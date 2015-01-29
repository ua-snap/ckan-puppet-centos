class pre_firewall {
        Firewall {
                require => undef,
        }

        firewall {'000 accept all port 80 requests':
                proto => 'tcp',
                      action => 'accept',
                      chain => 'INPUT',
                      dport => ['80'],
                      table => 'filter',
        }
        firewall {'001 Accept all port 8080 requests':
                proto => 'tcp',
                      action => 'accept',
                      chain => 'INPUT',
                      dport => ['8080'],
                      table => 'filter',
        }
}

class post_firewall {
        firewall { '999 drop all':
                proto   => 'all',
                        action  => 'drop',
                        before  => undef,
        }
}


node 'ckan-dev' {
	Firewall {
		before => Class['post_firewall'],
		require => Class['pre_firewall'],
	}

	class { ['pre_firewall', 'post_firewall']: }
	
	group {"ckan":
		ensure => present,
	}

        file {"/home/vagrant":
		mode => 755,
	}

	user {"ckan":
		require => Group["ckan"],
		ensure => present,
		managehome => true,
		gid => "ckan",
		shell => "/bin/bash",
		home => "/usr/lib/ckan",
	}

	file {"/usr/lib/ckan/default/.bashrc":
		ensure => 'link',
		target => '/etc/bashrc',
	}

	package { "screen":
		ensure => "installed"
	}

	package { "vim-enhanced":
		ensure => "installed"
	}

	include ckan
}
