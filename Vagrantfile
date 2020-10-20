# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.box_check_update = false

  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.cpus = 1
    vb.memory = 1024
  end

  # Filesystem mount settings (Share folder)
  config.vm.synced_folder "./mnt", "/vagrant/mnt",
    mount_options: ["dmode=777, fmode=777"],
    create: true

  # Network settings
  config.vm.network "private_network", ip: "192.168.33.1"
  config.vm.network "forwarded_port", guest: 80, host: 8000

  # Provisioning
  config.vm.provision "shell", path: "provision/main.sh"
  config.vm.provision "shell", path: "deploy/main.sh"
end
