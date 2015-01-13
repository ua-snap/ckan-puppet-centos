# == Class ckan::install
#
# installs ckan
# details: http://docs.ckan.org/en/ckan-2.0/install-from-package.html
#
class ckan::install {

  include wget

  # Install Jetty
 # package { ['openjdk-6-jdk', 'solr-jetty']:
 #   ensure => present,
 # }

  # Install Postgres
  class { 'postgresql::server':
    pg_hba_conf_defaults => $ckan::pg_hba_conf_defaults,
    postgres_password => $ckan::postgres_pass,
    listen_addresses => '*',
  }

  # Install CKAN deps
  $ckan_libs = ['libcurl-devel','httpd', 'xml-common', 'git', 'libxslt', 'libxslt-devel',
                'libxml2', 'libxml2-devel', 'gcc', 'gcc-c++', 'make','postgresql-devel',
                'java-1.6.0-openjdk-devel', 'java-1.6.0-openjdk', 'tomcat6', 'xalan-j2', 'unzip',
                'policycoreutils-python','mod_wsgi','xml-commons-resolver','xml-commons-apis']
  package { $ckan_libs: ensure => present, }

# postgresql-devel

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
  #  'ckanext-spatial',
  #  'ckanext-harvest',
  ]
  ckan::pip_package { $pip_pkgs_local:
    require => Python::Virtualenv[$ckan_virtualenv],
    ensure  => present,
    owner   => 'ckan',
    local   => true,
  }

  #exec { 'a2enmod wsgi':
  #  command => '/usr/sbin/a2enmod wsgi',
  #  creates => '/etc/apache2/mods-enabled/wsgi.conf',
  #  require => Package['apache2', 'libapache2-mod-wsgi'],
  #}

  # Install CKAN either from APT repositories or from the specified file
  #if $ckan::is_ckan_from_repo == true {
  #  package { 'python-ckan':
  #    ensure  => latest,
  #    require => Package[$ckan_libs],
  #  }
  #} else {
  #  file { $ckan::ckan_package_dir:
  #    ensure => directory,
  #  }
  #  wget::fetch { 'ckan package':
  #    source      => $ckan::ckan_package_url,
  #    destination => "$ckan::ckan_package_dir/$ckan::ckan_package_filename",
  #    verbose     => false,
  #    require     => File[$ckan::ckan_package_dir],
  #  }
  #  package { 'python-ckan':
  #    ensure   => latest,
  #    provider => dpkg,
  #    source   => "$ckan::ckan_package_dir/$ckan::ckan_package_filename",
  #    require  => [Wget::Fetch["ckan package"], Package[$ckan_libs]],
  #  }
  #}

  # Install Node and NPM (which comes with Node)
  #include nodejs

  # less requires a compile of the css before changes take effect.
  #exec { 'Install Less and Nodewatch':
  #  command => '/usr/bin/npm install less nodewatch',
  #  cwd     => '/usr/lib/ckan/default/src/ckan',
  #  require => [Package['nodejs'], Package['python-ckan']],
  #  creates => '/usr/lib/ckan/default/src/ckan/bin/less',
  #}

  # Git is necessary for installing extensions
  #package { 'git-core':
  #  ensure => present,
  #}
}
