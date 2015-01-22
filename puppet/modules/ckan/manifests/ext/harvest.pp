#   https://github.com/ckan/ckanext-harvest
#
class ckan::ext::harvest {

  package { 'redis' :
    ensure => present,
  }

  ckan::ext { 'harvest':
    require => Package['redis']
  } ~> exec {'create database tables':
    command => "/bin/bash $ckan_package_dir/bin/activate && paster --plugin=ckanext-harvest harvester initdb --config=$ckan_default/production.ini",
    refreshonly => true
  }
}
