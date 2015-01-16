
class solr(
  $apache_solr_tarball = 'solr-1.4.1.tgz',
  $apache_solr_url = 'https://archive.apache.org/dist/lucene/solr/1.4.1/apache-solr-1.4.1.tgz',
  ) {
  file {'/etc/solr':
  ensure => directory
  }

  file {'/etc/solr/conf':
  ensure => directory
  }

  file {'/etc/solr/conf/schema.xml':
    ensure  => link,
    target  => "$ckan_src/ckan/config/solr/schema-2.0.xml",
  }


 Exec['download-solr']
    -> File['/usr/share/solr']
    ~> Exec['untar-solr']
    -> File['/data']
    -> File['/data/solr']
    ~> Exec['make-solr-dir']
    ~> Exec['copy-solr']
    ~> File['/etc/tomcat6/Catalina/localhost/solr.xml']

  file {'/etc/tomcat6/Catalina/localhost/solr.xml':
  ensure => file,
    source => 'puppet:///modules/ckan/solr.xml',
    ## TODO set this to readonly so we aren't tempted to edit it manually on the server.
  }

  exec { 'download-solr':
    command => "/usr/bin/wget -q https://archive.apache.org/dist/lucene/solr/1.4.1/apache-solr-1.4.1.tgz -O /tmp/solr-1.4.1.tgz",
    creates => "/tmp/solr-1.4.1.tgz",
    timeout => 1200,
  }

  exec { 'untar-solr':
    command       => "/bin/tar zxf /tmp/solr-1.4.1.tgz",
    cwd           => '/usr/share/solr',
    refreshonly   => true,
  }

  file { '/usr/share/solr': ensure        =>  'directory' }
  file { '/data':           ensure        =>  'directory' }
  file { '/data/solr':      ensure        =>  'directory' }

  exec { 'make-solr-dir':
    command       => '/bin/mkdir -p /usr/share/solr/apache-solr-1.4.1/example/solr/',
    refreshonly   => true
  }

  exec {'copy-solr':
    refreshonly   => true,
    command       => '/bin/cp /usr/share/solr/apache-solr-1.4.1/dist/apache-solr-1.4.1.war /data/solr/solr.war',
  }
}