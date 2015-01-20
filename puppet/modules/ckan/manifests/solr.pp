
class ckan::solr (
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
    -> File['/data/solr/conf']
    ~> Exec['make-solr-dir']
    ~> Exec['copy-solr-war']
    ~> Exec['copy-solr-config']
    ~> File['/etc/tomcat6/Catalina/localhost/solr.xml']
    ~> Exec['simlink-solr-schema']

## todo
# sudo cp /usr/share/solr/apache-solr-1.4.1/example/solr/conf/synonyms.txt /data/solr/conf/
# sudo cp /usr/lib/ckan/default/src/ckan/ckan/config/solr/schema.xml /data/solr/conf/schema.xml
# the schema.xml should be symlinked but needs correct permissions or Solr wont' find it.
# sudo cp /usr/share/solr/apache-solr-1.4.1/example/solr/conf/protwords.txt /data/solr/conf/

## another approach
# tar --strip 2 -zxf /tmp/solr-1.4.1.tgz --wildcards "apache-solr-*/dist/apache-solr-*.war" -O > /data/solr/solr.war
# tar -C /data/solr --strip 3 -zxf /tmp/solr-1.4.1.tgz --wildcards "apache-solr-*/example/solr/"

  exec { 'simlink-solr-schema':
    command => '/bin/ln -s /usr/lib/ckan/default/src/ckan/ckan/config/solr/schema.xml /data/solr/conf/schema.xml',
    refreshonly => true,
  }

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
  file { '/data/solr/conf':      ensure        =>  'directory' }

  exec { 'make-solr-dir':
    command       => '/bin/mkdir -p /usr/share/solr/apache-solr-1.4.1/example/solr/',
    refreshonly   => true
  }

  exec {'copy-solr-war':
    refreshonly   => true,
    command       => '/bin/cp /usr/share/solr/apache-solr-1.4.1/dist/apache-solr-1.4.1.war /data/solr/solr.war',
  }
  exec {'copy-solr-config':
    refreshonly   => true,
    command       => '/bin/cp /usr/share/solr/apache-solr-1.4.1/example/solr/conf/solrconfig.xml /data/solr/conf/solrconfig.xml',
  }
}