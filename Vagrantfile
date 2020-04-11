# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.box_check_update = false

  config.vm.network "private_network", ip: "192.168.10.10"
  # config.vm.network "public_network"

  config.vm.synced_folder "./mnt/", "/vagrant/app", create: true
  
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = 2048
    vb.cpus = 2
  end

  config.vm.provision "shell", :path => "provision/main.sh" 

end
