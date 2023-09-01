VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "vimalkvn/linuxmint-20.2"
  config.vm.box_version = "1.0"
  config.disksize.size = '50GB'
  config.ssh.insert_key = false

  config.vm.provider :virtualbox do |v|
    v.name = "vagrant"
    v.memory = 8192
    v.cpus = 2
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--ioapic", "on"]
    v.gui = true
  end

  config.vm.hostname = "vagrant"

  # Set the name of the VM
  config.vm.define :vagrant do |vagrant|
  end

  # Shell provisioner
  config.vm.provision "shell", path: "bootstrap.sh"

  # Ansible provisioner
  config.vm.provision "ansible" do |ansible|
    ansible.compatibility_mode = "2.0"
    ansible.playbook = "playbooks/vagrant.yml"
    ansible.inventory_path = "inventory/inventory"
  end

end
