# manages services for ckan
# details: http://docs.ckan.org/en/ckan-2.0/install-from-package.html
class ckan::service {

if $osfamily == 'debian' {
  service { 'jetty':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
  service { 'apache2':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Service['jetty'],
  }
  service { 'nginx':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Service['apache2'],
  }
} 
else {
  service { 'httpd':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
}
