# Much of the configuration is better done here as a shell script, so we do that.
class ckan::solr {

  File['/tmp/install_solr.sh']
  ~> Exec['/tmp/install_solr.sh']
  ~> File['/etc/tomcat6/Catalina/localhost/solr.xml']
  ~> File['/usr/share/solr/solr.xml']
  ~> Service['tomcat6']

  file {'/tmp/install_solr.sh':
    ensure => 'file',
    path => '/tmp/install_solr.sh',
    owner => 'root',
    group => 'root',
    mode => '0744',
    source => 'puppet:///modules/ckan/install_solr.sh',
  }

  exec {'/tmp/install_solr.sh':
    command => '/bin/bash /tmp/install_solr.sh',
    refreshonly => true,
    notify => Service['tomcat6']
  }

  file {'/etc/tomcat6/Catalina/localhost/solr.xml':
    ensure => 'file',
    source => 'puppet:///modules/ckan/solr-tomcat.xml',
    notify => Service['tomcat6'],
  }

  file {'/usr/share/solr/solr.xml':
    ensure => 'file',
    source => 'puppet:///modules/ckan/solr.xml',
    notify => Service['tomcat6'],
  }
}
