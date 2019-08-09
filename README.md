# Workstation Configuration
Configuration of workstations via Ansible 

## Testing
To test the Ansible provisioning using Vagrant run `vagrant up`.  Playbooks have been created called `virtualbox.yml`, `thor.yml`, `titan.yml` and `md-desktop.yml`. `virtualbox.yml` is designed to run through all the roles to test them by creating a Linux Mint instance in Virtualbox.  However, the other playbooks can be tested by uncommenting the appropriate line in `Vagrantfile` and changing the `minikube_install` variable to `false`, `nas_mounting` to `present`, `firewall_state` to `disabled` and `jenkins_image_name` to `jenkins/jenkins:latest` in the appropriate playbook.

If the Vagrant machine, called ansible, is running then re-provisioning can be performed with `vagrant provision`.  Note that once Docker has been installed and the Vagrant machine has been restarted, the network interface `docker0` has no IP address.  The work-around to this is to restart Docker with `sudo systemctl restart docker`.

## Production

### Pre Tasks
First move the `/home` and `/var` directories that are on the secondary hard drive to temporary directory names:

```
sudo mv /media/andrew/hdd/home /media/andrew/hdd/home_orig
sudo mv /media/andrew/hdd/var /media/andrew/hdd/var_orig
```

Now create a mount point for the secondary hard drive:

```
sudo mkdir /hdd
sudo chmod 0755 /hdd
```

Backup /etc/fstab:

```
sudo cp /etc/fstab /etc/fstab.bak
```

Edit `/etc/fstab` using `lsblk -f` to identify the UID of the secondary hard drive:

```
# /etc/fstab
UUID=$UUID    /hdd ext4 defaults 0 2
```

Mount the secondary hard drive and then move `/home` and `/var` to the secondary hard drive:

```
sudo mount -a
sudo cp -pr /home /hdd/home
sudo cp -pr /var /hdd/var
sudo mv /home /home_old
sudo mv /var /var_old
cd /
sudo ln -s /hdd/var var
sudo ln -s /hdd/home home
```

`/hdd/home_orig` and `/hdd/var_orig` can then be merged manually into `/hdd/home` and `/hdd/var`, taking care to not move all the dot files and to replace rather than merge.  Check lists of files are provided in `dot_file_checklist.txt` and `var_file_checklist.txt`.

Finally, in `/etc/apparmor.d/usr.sbin.cupsd` replace to `/var` with `/hdd/var`, and `,var` with `,hdd/var`.  Do not create a back up in this directory as it will be read in as though it were config.  To restart cups run `sudo systemctl restart cups.service`.

### Run
A bootstrapping script can be downloaded from `https://bitbucket.org/aps831/workstation`.  Execute the script `bootstrap.sh` and enter the appropriate playbook name: `thor.yml`, `titan.yml` or `md-desktop.yml`.  Alternativaly, a playbook can be run locally using `ansible-playbook --ask-become-pass provisioning/<name>.yml`

### Post Tasks
Both the Docker and Virtualbox roles involve setting group membership.  This will only take effect after logging out and back in.

To complete the setup, icons on the panel need to be added manually.

The self-signed certificate for Docker needs to be copied from `titan` to `thor`.  On `titan` the certificate can be found at `/usr/local/share/ca-certificates/titan.local.crt`.  On `thor` this must be copied to `/etc/docker/certs.d/titan.local:5000/ca.crt`.  

Timeshift will require manual configuration whilst Duply backups will need to be deleted and recreated.

The printer may be installed automatically for a local install but may need to be done manually for a network install.  `hp-setup -i` can be run for a full install, or `hp-plugin -i` to install just the driver for the printer.  To share the printer, go to the start menu and then `Printers -> Servers -> Settings -> Publish Shared Printer`.

### Specified Versions
The following roles have version numbers defined within the role:

* docker
* eclipse
* elm
* javascript
* minikube
* mysql
* vagrant
* vaultclient
* vaultserver
* virtualbox
