node 'ckan-dev' {
	group {"ckan":
		ensure => present,
	}

	#file {"/usr/lib/ckan":
	#	require => [ User["ckan"], Group["ckan"] ],
	#	ensure => directory,
	#	owner => "ckan",
	#	group => "ckan",
	#}

	user {"ckan":
		require => Group["ckan"],
		ensure => present,
		managehome => true,
		gid => "ckan",
		shell => "/bin/bash",
		home => "/usr/lib/ckan",
	}

	file {"/usr/lib/ckan/.bashrc":
		ensure => 'link',
		target => '/etc/bashrc',
	}

	package { "screen":
		ensure => "installed"
	}

	package { "vim":
		ensure => "installed"
	}

	include ckan
}
