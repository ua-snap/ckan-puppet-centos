# Much of the configuration is better done here as a shell script, so we do that.
class ckan::solr {

  File['/tmp/install_solr.sh']
  ~> Exec['/tmp/install_solr.sh']
  ~> File['/etc/tomcat6/Catalina/localhost/solr.xml']
  ~> File['/data/solr/cores/ckan_default/conf/solrconfig.xml']

  file {'/tmp/install_solr.sh':
    ensure => file,
      mode => 'ugo+x',
      source => 'puppet:///modules/ckan/install_solr.sh',
  }

  exec {'/tmp/install_solr.sh':
    command => '/bin/bash /tmp/install_solr.sh'
  }

  file {'/etc/tomcat6/Catalina/localhost/solr.xml':
  ensure => file,
    source => 'puppet:///modules/ckan/solr-tomcat.xml',
    ## TODO set this to readonly so we aren't tempted to edit it manually on the server.
  }

  file {'/data/solr/cores/ckan_default/conf/solrconfig.xml':
  ensure => file,
    source => 'puppet:///modules/ckan/solrconfig.xml',
  }
}