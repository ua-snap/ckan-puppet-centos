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
  #class { 'postgresql::server':
  #  pg_hba_conf_defaults => $ckan::pg_hba_conf_defaults,
  #  postgres_password => $ckan::postgres_pass,
  #  listen_addresses => '*',
  #}

  # Install CKAN deps
  $ckan_libs = ['httpd', 'xml-common', 'git', 'libxslt', 'libxslt-devel',
                'libxml2', 'libxml2-devel', 'gcc', 'gcc-c++', 'make',
                'java-1.6.0-openjdk-devel', 'java-1.6.0-openjdk', 'tomcat6', 'xalan-j2', 'unzip',
                'policycoreutils-python','mod_wsgi','xml-commons-resolver','xml-commons-apis']
  package { $ckan_libs: ensure => present, }


  class { 'python':
    version    => 'system',
    dev        => true,
    virtualenv => true,
    pip        => true,
  }

  $python_requirements = [
    'libpq-dev',
    'python-psycopg2',
    'python-pastescript',
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
    'Babel==0.9.6',
    'Beaker==1.6.3',
    'ConcurrentLogHandler==0.8.4',
    'Flask==0.8',
    'FormAlchemy==1.4.2',
    'FormEncode==1.2.4',
    'Genshi==0.6',
    'GeoAlchemy==0.7.2',
    'Jinja2==2.7',
    'Mako==0.8.1',
    'MarkupSafe==0.15',
    'OWSLib==0.8.2',
    'Pairtree==0.7.1-T',
    'Paste==1.7.5.1',
    'PasteDeploy==1.5.0',
    'PasteScript==1.7.5',
    'Pygments==1.6',
    'Pylons==0.9.7',
    'PyMollom==0.1',
    'Routes==1.13',
    'SQLAlchemy==0.7.8',
    'Shapely==1.2.17',
    'Tempita==0.5.1',
    'WebError==0.10.3',
    'WebHelpers==1.3',
    'WebOb==1.0.8',
    'WebTest==1.4.3',
    'Werkzeug==0.8.3',
    'amqplib==1.0.2',
    'anyjson==0.3.3',
    'apachemiddleware==0.1.1',
    'autoneg==0.5',
    'carrot==0.10.1',
    'celery==2.4.2',
    'chardet==2.1.1',
    'ckanclient==0.10',
    'datautil==0.4',
    'decorator==3.3.2',
    'fanstatic==0.12',
    'flup==1.0.2',
    'gdata==2.0.17',
    'google-api-python-client==1.1',
    'httplib2==0.8',
    'json-table-schema==0.1',
    'kombu==2.1.3',
    'kombu-sqlalchemy==1.1.0',
    'lxml==3.3.5',
    'messytables==0.10.0',
    'nose==1.3.0',
    'ofs==0.4.1',
    'openpyxl==1.5.7',
    'psycopg2==2.4.5',
    'pylibmc',
    'python-dateutil==1.5',
    'python-gflags==2.0',
    'python-magic==0.4.3',
    'python-openid==2.2.5',
    'pytz==2012j',
    'pyparsing==2.0.2',
    'pika==0.9.13',
    'pyutilib.component.core==4.6',
    'repoze.who==1.0.19',
    'repoze.who-friendlyform==1.0.8',
    'repoze.who.plugins.openid==0.5.3',
    'requests==1.1',
    'simplejson==2.6.2',
    'solrpy==0.9.5',
    'sqlalchemy-migrate==0.7.2',
    'vdm==0.11',
    'xlrd==0.9.2',
    'zope.interface==4.0.1',
    # from dev-requirements.txt
    'pep8==1.4.6',
  ]
  ckan::pip_package { $pip_pkgs_remote:
    require => Python::Virtualenv[$ckan_virtualenv],
    ensure     => present,
    owner      => 'ckan',
    local      => false,
  }
  $pip_pkgs_local = [
    'ckan',
    'ckanext-spatial',
    'ckanext-harvest',
  ]
  ckan::pip_package { $pip_pkgs_local:
    require => Python::Virtualenv[$ckan_virtualenv],
    ensure  => present,
    owner   => 'ckan',
    local   => true,
  }

# 'nginx', 'libpq5','python-pastescript']

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
