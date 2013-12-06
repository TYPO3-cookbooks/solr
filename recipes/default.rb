#
# Cookbook Name:: solr
# Recipe:: default
#
# Copyright 2012, Steffen Gebert / TYPO3 Association
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

##############################
# Tomcat setup
##############################

include_recipe "tomcat"

# access protection
all_nodes = search(:node, "*:*")
ips = all_nodes.map{|n| n[:ipaddress]}

# replace the server.xml with the one from this cookbook
server_xml = resources("template[/etc/tomcat6/server.xml]")
server_xml.cookbook "solr"


# whitelist srv112 (integration) as long as #49481 is not fixed
ips << "217.29.36.51"
server_xml.variables({
  :ips => ips.sort
})

##############################
# SOLR deployment
##############################

ark "solr" do
  url      node.solr.link
  checksum node.solr.checksum
  version  node.solr.version
  mode     0777
end

#execute "all permissions" do
#  cmd "chmod -R 0777 /usr/local/solr"
#end

#link "#{node.tomcat.webapp_dir}/solr.war" do
#  to "/usr/local/solr/dist/apache-solr-#{node.solr.version}.war"
#end


#file "#{node.tomcat.webapp_dir}/solr.war" do
#  content IO.read("/usr/local/solr/dist/apache-solr-#{node.solr.version}.war")
#end

[
#  "#{node.tomcat.webapp_dir}/solr",
  "#{node.solr.home}/dist",
  "#{node.solr.home}/typo3cores",
  "#{node.solr.home}/typo3cores/conf",
  "#{node.solr.home}/typo3lib",
].each do |dir|
  directory dir do
    recursive true
    owner node.tomcat.user
    group node.tomcat.group
  end
end


languages = ['german', 'english']
languages.each do |lang|
  directory "#{node.solr.home}/typo3cores/conf/#{lang}" do
    owner node.tomcat.user
    group node.tomcat.group
  end

  [
    'protwords.txt',
    'schema.xml',
    'stopwords.txt',
    'synonyms.txt'
  ].each do |file|
    file_path = "typo3cores/conf/#{lang}/#{file}"
    remote_file "#{node.solr.home}/#{file_path}" do
      owner node.tomcat.user
      group node.tomcat.group
      checksum node.solr.checksum
      source "#{node.solr.typo3.repo}/solr/#{file_path}"
      action :create_if_missing
      notifies :restart, "service[tomcat]"
    end
  end
end

# TODO
#if [ $LANGUAGE = "german" ]
#wgetresource solr/typo3cores/conf/$LANGUAGE/german-common-nouns.txt

	
[
  'admin-extra.html',
  'currency.xml',
  'elevate.xml',
  'general_schema_fields.xml',
  'general_schema_types.xml',
#  'mapping-ISOLatin1Accent.txt',
  'solrconfig.xml'
].each do |file|
  file_path = "typo3cores/conf/#{file}"
  remote_file "#{node.solr.home}/#{file_path}" do
    owner node.tomcat.user
    group node.tomcat.group
    source "#{node.solr.typo3.repo}/solr/#{file_path}"
    action :create_if_missing
    notifies :restart, "service[tomcat]"
  end
end

remote_file "#{node.tomcat.config_dir}/server.xml" do
  owner node.tomcat.user
  group node.tomcat.group
  source "#{node.solr.typo3.repo}/tomcat/server.xml"
  action :create_if_missing
  notifies :restart, "service[tomcat]"
end

template "#{node.tomcat.context_dir}/solr.xml" do
  owner node.tomcat.user
  group node.tomcat.group
  source "context-solr.xml"
  notifies :restart, "service[tomcat]"
end

template "#{node.solr.home}/solr.xml" do
  owner node.tomcat.user
  group node.tomcat.group
  source "solr-cores.xml"
  notifies :restart, "service[tomcat]"
end


#################################
# Libs
#################################

libs = [
  'analysis-extras',
  'cell',
  'clustering',
  'dataimporthandler',
  'dataimporthandler-extras',
  'uima'
]

libs.each do |lib|
  lib_file = "#{lib}-#{node.solr.version}.jar"
  link "#{node.solr.home}/dist/#{lib_file}" do
    to "/usr/local/solr-#{node.solr.version}/dist/#{lib_file}"
    notifies :restart, "service[tomcat]"
  end
end

remote_file "#{node.solr.home}/typo3lib/solr-typo3-plugin-#{node.solr.typo3.plugin.version}.jar" do
  source node.solr.typo3.plugin.url
  owner node.tomcat.user
  group node.tomcat.group
  action :create_if_missing
  notifies :restart, "service[tomcat]"
end
