# ckan-puppet-centos

A Vagrant installation of CKAN using Puppet targeting CentOS 6.6.  Heavily derived from [Michael Speth's CKAN repository](https://github.com/Conzar/ckan-puppet).

# How to run

First, clone this repo, then `vagrant up` inside the cloned repository directory.  The provisioning process is lengthy and, depending on the speed of your internet connection, may take longer than 20 minutes.  Get coffee!  When it's done, a few post-install steps need to happen:

 1. Log into the VM: `vagrant ssh`
 1. Become root: `sudo su -`
 1. Activate the Python virtualenv so we can use the admin tools for CKAN: `source /usr/lib/ckan/default/bin/activate`
 1. Create an admin user: `paster --plugin=ckan sysadmin add admin -c /etc/ckan/default/production.ini`
 1. Restart web server: `service httpd restart`
 1. Stop and start the `supervisord` process, which manages the harvester, to ensure that it has the right configuration (doing a restart on the service doesn't do what we expect here, need to explicitly stop and start): `service supervisord stop; service supervisord start`
 1. Done!  `exit` and `exit` and `exit`.

Once that's done, you can launch CKAN by following directions [here](https://github.com/ua-snap/data-distribution) if using the system in development mode (default for this repo).

If serving via Apache, you can use these URLs to access CKAN and its resources:

 * CKAN: [http://localhost:8080](http://localhost:8080)
 * CKAN Harvester: [http://localhost:8080/harvest](http://localhost:8080/harvest)
 * Solr admin for CKAN schema: [http://localhost:8081/solr/ckan-schema/admin/](http://localhost:8081/solr/ckan-schema/admin/)

If you get an HTTP 500 error when trying to load CKAN this way, then the system is in debug mode and must be launched via Paster.