# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "generic/fedora35"

  config.vm.define "f35-prettybox"
  config.vm.hostname = "f35-prettybox"

  config.vm.provider :libvirt do |l, override|
    l.driver = "kvm"
    l.cpus = 2
    l.memory = 4096
    l.disk_bus = "virtio"

    # l.memorybacking :access, :mode => "shared"
    override.vm.synced_folder "./", "/dotfiles", disabled: false#, type: "virtiofs"

    # Enable Hyper-V enlightments: https://blog.wikichoon.com/2014/07/enabling-hyper-v-enlightenments-with-kvm.html
    l.hyperv_feature :name => 'relaxed', :state => 'on'
    l.hyperv_feature :name => 'synic',   :state => 'on'
    l.hyperv_feature :name => 'vapic',   :state => 'on'
    l.hyperv_feature :name => 'vpindex', :state => 'on'
  end
end
