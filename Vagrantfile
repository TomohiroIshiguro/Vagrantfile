# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

  #----------------------------------------
  # Vagrant box
  #----------------------------------------
  config.vm.box = "centos/7"
  config.vm.box_url = "https://app.vagrantup.com/centos/boxes/7"


  #----------------------------------------
  # Network and Synced folder
  #----------------------------------------
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "private_network", ip: "192.168.33.84"
  config.vm.synced_folder "./", "/vagrant", create: true
  config.vm.synced_folder "./mnt", "/var/www", create: true


  #----------------------------------------
  # Specification of virtual machine
  #----------------------------------------
  config.vm.provider "virtualbox" do |vb|
    vb.cpus = 1
    vb.memory = 1024
  end


  #----------------------------------------
  # Provisioning
  #----------------------------------------
  config.vm.provision "shell", path: "./provision/main.sh"

end
