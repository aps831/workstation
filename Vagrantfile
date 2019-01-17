VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "mrlesmithjr/linuxmint19-desktop"
  config.ssh.insert_key = false

  config.vm.provider :virtualbox do |v|
    v.name = "ansible"
    v.memory = 8192
    v.cpus = 2
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--ioapic", "on"]
    v.gui = true
  end

  config.vm.hostname = "ansible"
  config.vm.network :private_network, ip: "192.168.33.23"

  # Set the name of the VM
  config.vm.define :ansible do |ansible|
  end

  # Ansible provisioner.
  config.vm.provision "ansible" do |ansible|
    ansible.compatibility_mode = "2.0"
#    ansible.playbook = "provisioning/virtualbox.yml"
#    ansible.playbook = "provisioning/thor.yml"
#    ansible.playbook = "provisioning/titan.yml"
    ansible.playbook = "provisioning/m-d-desktop.yml"
    ansible.inventory_path = "provisioning/inventory"
    ansible.become = true
  end

end
