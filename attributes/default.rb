default[:solr][:version]   = "3.6.1"
default[:solr][:link]      = "http://mirror.netcologne.de/apache.org/lucene/solr/#{solr.version}/apache-solr-#{solr.version}.tgz"
default[:solr][:checksum]  = "1b4552ba95c8456d4fbd596e82028eaa0619b6942786e98e1c4c31258543c708" #sha265
default[:solr][:home]          = "/usr/share/solr"

default[:solr][:typo3][:plugin][:version] = "1.2.0"
default[:solr][:typo3][:plugin][:url] = "http://www.typo3-solr.com/fileadmin/files/solr/solr-typo3-plugin-#{node.solr.typo3.plugin.version}.jar"

default[:solr][:typo3][:repo] = "https://forge.typo3.org/projects/extension-solr/repository/revisions/master/raw/resources"

default[:solr][:cores] = ["t3o_live", "t3o_latest", "t3o_testing"]