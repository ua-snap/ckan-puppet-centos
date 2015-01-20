# manages services for ckan
# details: http://docs.ckan.org/en/ckan-2.0/install-from-package.html
class ckan::service {

  service { 'httpd':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

  service {'tomcat6':
  ensure => running,
    enable => true,
    hasstatus => true,
    hasrestart => true
}

}
