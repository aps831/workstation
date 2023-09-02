VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "aps831/mint-cinnamon-21.2"
  config.vm.box_version = "1.0.0"
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.provider :libvirt do |v|
    v.forward_ssh_port = true
    v.graphics_type = "spice"
    v.memory = 8192
    v.nested = true
    v.cpu_mode = "host-model"
    v.random :model => 'random' # Passthrough /dev/random
  end

  config.vm.hostname = "vagrant"

  # Set the name of the VM
  config.vm.define :vagrant do |vagrant|
  end

  # Shell provisioner
  config.vm.provision "shell", path: "bootstrap.sh"
  config.vm.provision "shell", privileged: false, inline: "echo -n 'vagrant' | gnome-keyring-daemon --daemonize --components=ssh,secrets,pkcs11 --replace --unlock"

  # Ansible provisioner
  config.vm.provision "ansible" do |ansible|
    ansible.compatibility_mode = "2.0"
    ansible.playbook = "playbooks/vagrant.yml"
    ansible.inventory_path = "inventory/inventory"
  end

end
