# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "generic/ubuntu2204"
  config.vm.provider "virtualbox" do |vb|
        vb.memory = "1516"
  end

  (1..3).each do |i|
    config.vm.define "nomad-#{i}" do |n|
      n.vm.provision "file", source: "config", destination: "/tmp/install"
      n.vm.provision "shell", path: "install.sh"
      n.vm.hostname = "nomad-#{i}"
      n.vm.network "public_network", ip: "192.168.100.#{i+100}", bridge: "en7: USB 10/100/1000 LAN"
    end
  end
end