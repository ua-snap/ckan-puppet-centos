class ckan::snap_postinstall {

  # Copy the main.css file to main.debug.css to allow for site to be in debug mode
  file { '/usr/lib/ckan/default/src/ckan/ckan/public/base/css/main.debug.css':
    ensure => present,
    source => '/usr/lib/ckan/default/src/ckan/ckan/public/base/css/main.css',
  }

  # Git clone and install the SNAP harvester extension
  vcsrepo { '/usr/lib/ckan/default/src/ckanext-snap_harvester':
    ensure => present,
    provider => git,
    source => 'git://github.com/ua-snap/ckanext-snap_harvester.git',
    notify => Exec['install SNAP harvester'],
  } 

  exec { 'install SNAP harvester':
    cwd => "/usr/lib/ckan/default/src/ckanext-snap_harvester/",
    command => "source /usr/lib/ckan/default/bin/activate; /usr/lib/ckan/default/bin/python setup.py develop;",
    provider => 'shell',
  } 

  # Git clone and install the SNAP theme for CKAN 
  vcsrepo { '/usr/lib/ckan/default/src/ckanext-snap_theme':
    ensure => present,
    provider => git,
    source => 'git://github.com/ua-snap/ckanext-snap_theme.git',
    notify => Exec['install SNAP theme']
  }

  exec { 'install SNAP theme':
    cwd => "/usr/lib/ckan/default/src/ckanext-snap_theme/",
    command => "source /usr/lib/ckan/default/bin/activate; /usr/lib/ckan/default/bin/python /usr/lib/ckan/default/src/ckanext-snap_theme/setup.py develop;",
    provider => 'shell',
  }

  # Set the license file in the CKAN configuration file
  file_line { 'change default license':
    path => '/etc/ckan/default/production.ini',
    match => 'licenses_group_url.*$',
    line => 'licenses_group_url = file:///usr/lib/ckan/default/src/ckanext-snap_harvester/ckanext/snap_harvester/licenses.json'
  }

}
