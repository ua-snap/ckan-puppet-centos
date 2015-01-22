class my_fw::pre {
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

class my_fw::post {
	firewall { '999 drop all':
		proto   => 'all',
			action  => 'drop',
			before  => undef,
	}
}
