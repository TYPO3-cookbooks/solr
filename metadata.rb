name             "solr"
maintainer       "TYPO3 Association"
maintainer_email "steffen.gebert@typo3.org"
license          "MIT"
description      "Installs/Configures solr"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.2.9"

depends "tomcat", "~> 0.12.0"
depends "ark", "~> 0.4.0"
