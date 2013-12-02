default[:solr][:version]   = "3.6.2"
default[:solr][:link]      = "http://archive.apache.org/dist/lucene/solr/#{solr.version}/apache-solr-#{solr.version}.tgz"
default[:solr][:checksum]  = "537426dcbdd0dc82dd5bf16b48b6bcaf87cb4049c1245eea8dcb79eeaf3e7ac6" #sha265
default[:solr][:home]          = "/usr/share/solr"

default[:solr][:typo3][:plugin][:version] = "1.2.0"
default[:solr][:typo3][:plugin][:url] = "http://www.typo3-solr.com/fileadmin/files/solr/solr-typo3-plugin-#{node.solr.typo3.plugin.version}.jar"

default[:solr][:typo3][:repo] = "https://forge.typo3.org/projects/extension-solr/repository/revisions/master/raw/resources"

default[:solr][:cores] = ["t3o_live", "t3o_latest", "t3o_testing"]