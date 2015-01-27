# == Class ckan::install
#
# installs ckan
# details: http://docs.ckan.org/en/ckan-2.0/install-from-package.html
#
class ckan::install {

  # Install Postgres at version 9.3
  class {'postgresql::globals':
    manage_package_repo => true,
    version => '9.3',
  } -> class { 'postgresql::server':
    pg_hba_conf_defaults => $ckan::pg_hba_conf_defaults,
    postgres_password => $ckan::postgres_pass,
    listen_addresses => '*',
  } -> class { 'postgresql::lib::devel':
    package_name => 'postgresql93-devel', # Need this prior to doing a pip install of psycopg2
  }

  # Install CKAN dependencies
  $ckan_libs = ['libcurl-devel','httpd', 'xml-common', 'git', 'libxslt', 'libxslt-devel',
                'libxml2', 'libxml2-devel', 'gcc', 'gcc-c++', 'make', 'supervisor', 'redis',
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
    'python-paste-script',
  ]
  package { $python_requirements:
    ensure => installed,
    before => Python::VirtualEnv[$ckan_virtualenv],
    require => Class['postgresql::lib::devel']
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
    notify => Class['ckan::solr']
  }

  include ckan::solr

}
