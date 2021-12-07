# Workstation Configuration

Configuration of workstations via Ansible.

## Playbooks

The following playbooks have been created:

* `md-desktop.yml` - install dependencies for m-d;
* `thor-backup.yml` - install backup dependencies for thor;
* `thor-core.yml` - install core dependencies for thor;
* `thor-restore.yaml` -  install minimal dependencies in order to bootstrap a restore of thor;
* `titan-backup.yml` - install backup dependencies for titan;
* `titan-core.yml` - install core dependencies for titan;
* `titan-restore.yaml` -  install minimal dependencies in order to bootstrap a restore of titan;
* `virtualbox.yml` - run through all the roles on a Linux Mint instance in Virtualbox.

## Testing

To test the Ansible provisioning using Vagrant run `vagrant up`.  If the Vagrant machine, called ansible, is running then re-provisioning can be performed with `vagrant provision`.  The password to the vagrant machine is `vagrant`.  Once Docker has been installed and the Vagrant machine has been restarted, the network interface `docker0` has no IP address.  The work-around to this is to restart Docker with `sudo systemctl restart docker`.

## Run Role
To run a single role:

```
ansible --ask-become <host_name> -m include_role -a name=<role_name> --extra-vars "<variable_name1>=<variable_value1> <variable_name2>=<variable_value2>"
```

## Run Playbook

A playbook can be run locally using `ansible-playbook --ask-become-pass playbooks/<name>.yml`  A bootstrapping script can be downloaded from `https://bitbucket.org/aps831/workstation`.  Running the script `bootstrap.sh` will install dependencies and then prompt for a playbook name to run.  

## Clean Install

After migrating files and folders as per the instructions in [migration](MIGRATION.md), the core and backup playbooks should be run.  The following steps are then required:

* logout and back in again to pick up group membership defined the Docker and Virtualbox roles;
* manually add icons on the panel;
* configure Timeshift;
* copy self-signed certificate from titan to thor (see below);
* create a Samba user is a Samba share has been created for SyncMe Wireless app on Android (see below);
* configure printers (see below).

### Certificate

The self-signed certificate for Docker needs to be copied from `titan` to `thor`.  On `titan` the certificate can be found at `/usr/local/share/ca-certificates/titan.local.crt`.  On `thor` this must be copied to `/etc/docker/certs.d/titan.local:5000/ca.crt`.  

### Samba

To create a Samba user run `sudo smbpasswd -a <user_name>`.

### Printer

The printer may be installed automatically for a local install but may need to be done manually for a network install.  `hp-setup -i` can be run for a full install, or `hp-plugin -i` to install just the driver for the printer.  To share the printer, go to the start menu and then `Printers -> Servers -> Settings -> Publish Shared Printer`.  Apparmor may still not play nicely with `/var` located on a different drive even with edits to `/etc/apparmor.d/usr.sbin.cupsd` listed in the migration instructions.  A workaround is to install apparmor-utils with `sudo apt install apparmor-utils`, then run `sudo aa-complain cupsd`, install the printer and then run `sudo aa-enforce cupsd`.  Details are on `https://wiki.ubuntu.com/DebuggingPrintingProblems`.

If running `hp-setup -i` or `hp-plugin -i` results in an problem downloading the plugin, then it can be done manually:
```
wget https://developers.hp.com/sites/default/files/hplip-3.20.11-plugin.run
hp-plugin -i -p .
```

## Specified Versions
The following roles have version numbers defined within the role:

* aws
* docker
* duplicacy
* eclipse
* elm
* golang
* gogs
* javascript
* kubernetes
* mysql
* nexus
* owaspzap
* stoplight
* terraform
* vagrant
* vaultclient
* vaultserver
* virtualbox
