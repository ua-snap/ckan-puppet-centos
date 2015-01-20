# configuration supporting ckan
# details: http://docs.ckan.org/en/ckan-2.0/install-from-package.html
class ckan::config (
  $site_url,
  $site_title,
  $site_description,
  $site_intro,
  $site_about,
  $site_logo,
  $plugins,
){

  # == variables ==
  # the configuration directories
  $ckan_etc       = '/etc/ckan'
  $ckan_default   = "$ckan_etc/default"
  $ckan_src       = '/usr/lib/ckan/default/src/ckan'
  # the default image directory
  $ckan_img_dir   = "$ckan_src/ckan/public/base/images"
  $ckan_css_dir   = "$ckan_src/ckan/public/base/css"
  $ckan_storage_path = '/usr/lib/ckan/storage'
  $license_file   = 'license.json'
  $backup_dir = '/backup'

  # CKAN configuration
  file { [$ckan_etc, $ckan_default]:
    ensure  => directory,
  }

  concat { "$ckan_default/production.ini":
     owner => root,
     group => root,
     mode  => '0644',
  }
  concat::fragment { "config_head":
    target  => "$ckan_default/production.ini",
    content => template('ckan/production_head.ini.erb'),
    order   => 01,
  }
  concat::fragment { "config_tail":
    target  => "$ckan_default/production.ini",
    content => template('ckan/production_tail.ini.erb'),
    order   => 99,
  }

  # add the logo but its set via the web ui and also set via production.ini
  # however, I'm not certain that the production.ini has any effect...
  if $site_logo != '' {
    file {"$ckan_img_dir/site_logo.png":
      ensure  => file,
      source  => $site_logo,
      require => File["$ckan_default/production.ini"],
    }
  }

  # Configure Apache
  file { 'ckan_default.conf':
    path => '/etc/httpd/conf.d/ckan_default.conf',
    ensure => file,
    require => Package['httpd'],
    content => template("ckan/ckan_default.conf.erb"),
  }

  # Configure Apache / WSGI gateway
  file { 'apache.wsgi':
    path => '/etc/ckan/default/apache.wsgi',
    source => 'puppet:///modules/ckan/apache.wsgi',
    ensure => file,
  }

  #$ckan_data_dir = ['/var/lib/ckan',$ckan_storage_path]
  #file {$ckan_data_dir:
  file {$ckan_storage_path:
   ensure => directory,
   owner  => ckan,
   group  => ckan,
   mode   => '0755',
  }

  # download the license file if it exists
  #if $ckan::license != '' {
    # add a license
  #  file { "$ckan_default/$license_file":
  #    ensure => file,
  #    source => $ckan::license,
  #  }
  #}

  #if $ckan::custom_imgs != '' {
    # manage the default image directory
  #  ckan::custom_images { $ckan::custom_imgs: }
  #}

  # download custom css if specified
  #if $ckan::custom_css != 'main.css' {
  #  file {"$ckan_css_dir/custom.css":
  #    ensure => file,
  #    source => $ckan::custom_css,
  #  }
  #}

  # backup configuration
  #file { $backup_dir:
  #  ensure => directory,
  #  owner  => backup,
  #  group  => backup,
  #  mode   => '0755',
  #}
  #file { '/usr/local/bin/ckan_backup.bash':
  #  ensure  => file,
  #  source  => 'puppet:///modules/ckan/ckan_backup.bash',
  #  mode    => '0755',
  #  require => File[$backup_dir],
  #}
  #cron {'ckan_backup':
  #  command => '/usr/local/bin/ckan_backup.bash',
  #  user    => backup,
  #  minute  => '0',
  #  hour    => '5',
  #  weekday => '7',
  #}
}
