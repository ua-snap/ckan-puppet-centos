# == Class ckan::install
#
# installs ckan
# details: http://docs.ckan.org/en/ckan-2.0/install-from-package.html
#
class ckan::install {

  include wget

  # Install Postgresql and development packages
  package {'postgresql-devel':
	ensure => present,
  }

  # Install Postgres
  class { 'postgresql::server':
    pg_hba_conf_defaults => $ckan::pg_hba_conf_defaults,
    postgres_password => $ckan::postgres_pass,
    listen_addresses => '*',
  }

  # Install CKAN dependencies
  $ckan_libs = ['libcurl-devel','httpd', 'xml-common', 'git', 'libxslt', 'libxslt-devel',
                'libxml2', 'libxml2-devel', 'gcc', 'gcc-c++', 'make','redis',
                'java-1.7.0-openjdk-devel', 'java-1.7.0-openjdk', 'tomcat6', 'xalan-j2', 'unzip',
                'policycoreutils-python','mod_wsgi','xml-commons-resolver','xml-commons-apis']
  package { $ckan_libs: ensure => present, }

  class { 'python':
    version    => 'system',
    dev        => true,
    virtualenv => true,
    pip        => true,
  }

  $python_requirements = [
    'python-psycopg2',
    'python-paste-script',
  ]
  package { $python_requirements:
    ensure => installed,
    before => Python::VirtualEnv[$ckan_virtualenv],
  }
  python::virtualenv { $ckan_virtualenv:
    ensure => present,
    version => 'system',
    owner => 'ckan',
    group => 'ckan',
  }

  # Pip install everything
  $pip_pkgs_remote = [
    'git+https://github.com/ckan/ckan.git@ckan-2.2.1#egg=ckan',
    'git+https://github.com/okfn/ckanext-harvest.git@stable#egg=ckanext-harvest'
  ]
  ckan::pip_package { $pip_pkgs_remote:
    require => Python::Virtualenv[$ckan_virtualenv],
    ensure     => present,
    owner      => 'ckan',
    local      => false,
  }
  $pip_pkgs_local = [
    "${ckan_virtualenv}/src/ckan/requirements.txt",
  ]
  ckan::pip_package { $pip_pkgs_local:
    require => Python::Virtualenv[$ckan_virtualenv],
    ensure  => present,
    owner   => 'ckan',
    local   => true,
  }

  # Install Apache Solr
  file {'/usr/share/solr':
	ensure => directory,
  }

  Exec['download_solr'] 
-> Exec['untar-solr']
-> File['/data']
-> File['/data/solr']
-> File['/data/solr/solr.war']

exec { 'download_solr':
command => "/usr/bin/wget -q $ckan::apache_solr_url -O /tmp/$ckan::apache_solr_tarball",
creates => "/tmp/$ckan::apache_solr_tarball",
timeout => 1200,
}

exec { 'untar-solr':
command => "/bin/tar zxf /tmp/$ckan::apache_solr_tarball",
cwd => '/usr/share/solr',
refreshonly => true,
}

file { '/data':
ensure=>directory,
}

file{ '/data/solr':
ensure => directory,
  owner => 'tomcat',
  source => '/usr/share/solr/apache-solr-1.4.1/example/solr/',
  recurse => true,
}

file {'/data/solr/solr.war':
ensure => file,
  after => File['/data/solr'],
source => '/usr/share/solr/apache-solr-1.4.1/dist/apache-solr-1.4.1.war ',
owner => 'tomcat',
}

}
