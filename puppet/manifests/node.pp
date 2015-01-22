node 'ckan-dev' {
	# Import Firewall configuration for port 80 and port 8080 access
	import 'fw_config.pp'

	Firewall {
		before => Class['my_fw::post'],
		require => Class['my_fw::pre'],
	}

	class { ['my_fw::pre', 'my_fw::post']: }
	class { 'firewall' : }

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
