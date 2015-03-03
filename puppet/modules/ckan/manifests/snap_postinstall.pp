class ckan::snap_postinstall {

  # SNAP Harvester install
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

  # SNAP theme install
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

}
