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

  # Add extensions
  class { 'ckan::ext::harvest':
    require => Exec['init_db']
  } ->
  class{ 'ckan::ext::spatial':
      require => Exec['init_db'],
  } ->
  # This is a sort of hinky way to do this, but we can't have the harvest/spatial extensions here during the initial buildout.
  # Would be better to learn to use Augeas to drop in the missing sections instead of rewriting the plugin list.
  file_line { 'enable plugins in config file':
    path => '/etc/ckan/default/production.ini',
    match => '^ckan\.plugins.*$',
    line => 'ckan.plugins = stats text_preview recline_preview datastore resource_proxy pdf_preview harvest csw_harvester spatial_metadata'
  } ->
  # Configures the harvester to run.
  file { '/etc/supervisord.conf':
    source => 'puppet:///modules/ckan/supervisord.conf'
  } -> cron { 'harvest':
    command => '/usr/lib/ckan/default/bin/paster --plugin=ckanext-harvest harvester run --config=/etc/ckan/default/production.ini',
    user => 'ckan',
    minute => '*/1',
  }

  #include ckan::ext::googleanalytics

}
