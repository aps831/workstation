# Workstation Configuration
Configuration of workstations via Ansible

## Testing
To test the Ansible provisioning using Vagrant run `vagrant up`.  Playbooks have been created called `virtualbox.yml`, `thor.yml`, `titan.yml` and `md-desktop.yml`. `virtualbox.yml` is designed to run through all the roles to test them by creating a Linux Mint instance in Virtualbox.  However, the other playbooks can be tested by uncommenting the appropriate line in `Vagrantfile` and changing the `minikube_install` variable to `false`, `nas_mounting` to `present`, `firewall_state` to `disabled` and `jenkins_image_name` to `jenkins/jenkins:latest` in the appropriate playbook.

If the Vagrant machine, called ansible, is running then re-provisioning can be performed with `vagrant provision`.  Note that once Docker has been installed and the Vagrant machine has been restarted, the network interface `docker0` has no IP address.  The work-around to this is to restart Docker with `sudo systemctl restart docker`.

## Production

### Pre Tasks
If it is necessary to first move `/home` and `/var` onto a secondary hard disk, then ensure that the `-p` flag is used with `cp` to ensure that permissions are preserved.  Before the Ansible playbook is run, mounting of `/home` and `/var` from a secondary hard disk must be done manually.  Using a mount point of `/hdd` and user `andrew` execute:

```
sudo mkdir /hdd
sudo chown andrew:andrew /hdd
sudo chmod +rw /hdd
```

To identify the UUID of the disk that `/home` and `/var` are on run `lsblk -f`.  Back up `/etc/fstab` using `sudo cp /etc/fstab /etc/fstab.bak` then edit `/etc/fstab` as follows:

```
# /etc/fstab
UUID=$UUID    /hdd ext4 defaults 0 2
```
Reload fstab by running `sudo mount -a`.  Then create symbolic links for `/home` and `/var`:

```
cd /
sudo ln -s /hdd/var var
sudo ln -s /hdd/home home
```

Finally, in `/etc/apparmor.d/usr.sbin.cupsd` replace to `/var` with `/hdd/var`, and `,var` with `,hdd/var`.  Do not create a back up in this directory as it will be read in as though it were config.  To restart cups run `sudo systemctl restart cups.service`.

### Run
A bootstrapping script can be downloaded from `https://bitbucket.org/aps831/workstation`.  Execute the script `bootstrap.sh` and enter the appropriate playbook name: `thor.yml`, `titan.yml` or `md-desktop.yml`.  Alternativaly, a playbook can be run locally using `ansible-playbook --ask-become-pass provisioning/<name>.yml`

### Post Tasks
To complete the setup, icons on the panel need to be added manually and the self-signed certificate for Docker copied from `titan` to `thor`.  On `titan` the certificate can be found at `/usr/local/share/ca-certificates/titan.local.crt`.  On `thor` this must be copied to `/etc/docker/certs.d/titan.local:5000/ca.crt`.  

The printer may be installed automatically for a local install but may need to be done manually for a network install.  `hp-setup -i` can be run for a full install, or `hp-plugin -i` to install just the driver for the printer.  To share the printer, go to the start menu and then `Printers -> Servers -> Settings -> Publish Shared Printer`.
