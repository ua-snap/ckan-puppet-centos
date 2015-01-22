# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "puppetlabs/centos-6.5-64-puppet"
  config.vm.hostname = "ckan-dev"
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "forwarded_port", guest: 8080, host: 8081

   config.vm.provider "virtualbox" do |vb|
     vb.customize ["modifyvm", :id, "--memory", "4096"]
   end

  config.vm.provision :shell do |shell|
             shell.inline = "if [ ! -e /etc/yum.repos.d/epel.repo ]; then wget http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm;
                             rpm -ivh epel-release-6-8.noarch.rpm; fi;
			     puppet module install puppetlabs-stdlib;
                             puppet module install maestrodev-wget;
                             puppet module install puppetlabs-concat;
                             puppet module install puppetlabs/postgresql;
			     puppet module install puppetlabs-firewall;
			     puppet module install puppetlabs-apache;
			     puppet module install stankevich/python"
  end

  config.vm.provision "puppet" do |puppet|
     puppet.module_path = "puppet/modules"
     puppet.manifests_path = "puppet/manifests"
     puppet.manifest_file  = "node.pp"
     puppet.options = "--verbose --debug"
  end

end
