class ckan::postinstall {
  
  exec { 'init_db':
	command => '/usr/lib/ckan/default/bin/paster db init -c /etc/ckan/default/production.ini',
	cwd => '/usr/lib/ckan/default/src/ckan',
	user => 'ckan',
  }

  file { '/etc/ckan/default/who.ini':
     ensure => 'link',
     target => '/usr/lib/ckan/default/src/ckan/who.ini',
  }
}
