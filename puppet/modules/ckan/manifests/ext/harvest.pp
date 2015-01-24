#   https://github.com/ckan/ckanext-harvest
#
class ckan::ext::harvest {

  package { 'redis' :
    ensure => present,
  }

  ckan::ext { 'harvest':
    require => Package['redis']
  } ~> exec {'create database tables':
    command => "/bin/bash /usr/lib/ckan/default/bin/activate && paster --plugin=ckanext-harvest harvester initdb --config=/etc/ckan/default/production.ini",
    refreshonly => true
  }
}
