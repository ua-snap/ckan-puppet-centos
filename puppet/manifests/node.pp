node 'ckan-dev' {
	group {"ckan":
		ensure => present,
	}

	#file {"/usr/lib/ckan/default":
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
		home => "/usr/lib/ckan/default",
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
