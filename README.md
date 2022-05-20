# Workstation Configuration

Configuration of workstations via Ansible.

## Playbooks

The following playbooks have been created:

-   `md-desktop.yml` - install dependencies for m-d;
-   `thor-backup.yml` - install backup dependencies for thor;
-   `thor-core.yml` - install core dependencies for thor;
-   `thor-restore.yaml` - install minimal dependencies in order to bootstrap a restore of thor;
-   `titan-backup.yml` - install backup dependencies for titan;
-   `titan-core.yml` - install core dependencies for titan;
-   `titan-restore.yaml` - install minimal dependencies in order to bootstrap a restore of titan;
-   `virtualbox.yml` - run through all the roles on a Linux Mint instance in Virtualbox.

## Vault

To update the vault with passwords stored in `pass` run `vault.sh`.

## Testing

To test the Ansible provisioning using Vagrant run `vagrant up`. The current image for Linux Mint has insufficient initial disk space. Before the Ansible provisioning is run the partition must be expanded to fill the additional disk space that is created as part of the virtual machine provisioning. The first step is to start the virtual machine but without the Ansible provisioning. This can be done by commenting out the appropriate section in the `Vagrantfile`. Then login to the virtual machine using the user and password `vagrant` and run:

```
sudo apt install cloud-guest-utils gparted
sudo growpart /dev/sda 2
sudo resize2fs /dev/sda5
```

If these commands do not work, then it may be possible to use `gparted` to increase the partition size.

If Ansible hangs and it is necessary to kill the process then the lock file for `dpkg` may remain. This can be removed using `sudo rm /var/lib/dpkg/lock`.

If the install of `pgadmin` fails, then update `ca-certificates` using the update manager.

If the Vagrant machine, called ansible, is running then re-provisioning can be performed with `vagrant provision`.

Once Docker has been installed and the Vagrant machine has been restarted, the network interface `docker0` has no IP address. The work-around to this is to restart Docker with `sudo systemctl restart docker`.

## Run Role

To run a single role:

```
ansible --ask-become --ask-vault-pass -m include_role -a name=<role_name> --extra-vars "<variable_name1>=<variable_value1> <variable_name2>=<variable_value2>" --extra-vars "@inventory/vaulted_vars/vault.yml" <host_name>
```

If the role does not use encrypted secrets then `--ask-vault-pass` and `--extra-vars "@inventory/vaulted_vars/vault.yml"` can be omitted.

If the role requires a number of parameters to be passed to it, then it may be easier to run the playbook but filter the roles using tags.

## Run Playbook

A playbook can be run locally using

```
ansible-playbook --ask-become-pass --ask-vault-pass --extra-vars "@inventory/vaulted_vars/vault.yml" playbooks/<name>.yml
```

If the playbook does not use encrypted secrets then `--ask-vault-pass` and `--extra-vars "@inventory/vaulted_vars/vault.yml"` can be omitted. The scripts `run-ansible-core-update.sh` and `run-ansible-backup-update.sh` can also be used. These pull the latest version of the playbooks from Bitbucket.

To run selected roles from a playbook, add tags to roles using the syntax: `tags: tagname` and append the `ansible-playbook` command with `--tags "tagname"`.

## Clean Install

A bootstrapping script `bootstrap.sh` can be downloaded by running `wget -q -O bootstrap.sh https://bitbucket.org/aps831/workstation/raw/master/bootstrap.sh && chmod +x bootstrap.sh`. This script will install the dependencies needed to run Ansible.

After migrating files and folders as per the instructions in [migration](MIGRATION.md), the restore, core and backup playbooks should be run. The `--ask-vault-pass` and `--extra-vars "@inventory/vaulted_vars/vault.yml"` should not be passed when running the restore playbook, as the vault password will not be accessible at the time of running. The following steps are then required:

-   logout and back in again to pick up group membership defined the Docker and Virtualbox roles;
-   configure Timeshift;
-   copy self-signed certificate from titan to thor (see below);
-   create a Samba user is a Samba share has been created for SyncMe Wireless app on Android (see below);
-   configure printers (see below).

### Certificate

The self-signed certificate for Docker needs to be copied from `titan` to `thor`. On `titan` the certificate can be found at `/usr/local/share/ca-certificates/titan.local.crt`. On `thor` this must be copied to `/etc/docker/certs.d/titan.local:5000/ca.crt`.

### Samba

To create a Samba user run `sudo smbpasswd -a <user_name>`.

### Printer

The printer may be installed automatically for a local install but may need to be done manually for a network install. `hp-setup -i` can be run for a full install, or `hp-plugin -i` to install just the driver for the printer. To share the printer, go to the start menu and then `Printers -> Servers -> Settings -> Publish Shared Printer`. Apparmor may still not play nicely with `/var` located on a different drive even with edits to `/etc/apparmor.d/usr.sbin.cupsd` listed in the migration instructions. A workaround is to install `apparmor-utils` with `sudo apt install apparmor-utils`, then run `sudo aa-complain cupsd`, install the printer and then run `sudo aa-enforce cupsd`. Details are on `https://wiki.ubuntu.com/DebuggingPrintingProblems`.

If running `hp-setup -i` or `hp-plugin -i` results in an problem downloading the plugin, then it can be done manually:

```
wget https://developers.hp.com/sites/default/files/hplip-3.20.11-plugin.run
hp-plugin -i -p .
```

### MEGA

mega.io file syncing is not installed automatically. The downloads are available from https://mega.io/desktop and the Chrome store. The following are required:

-   desktop app;
-   nemo integration;
-   Chrome extension.

## Specified Versions

The following roles have version numbers defined within the role:

-   ansible
-   aws
-   backup
-   chezmoi
-   ddlog
-   docker
-   duplicacy
-   eclipse
-   elm
-   git
-   github
-   gogs
-   haskell
-   intellij
-   javascript
-   jenkins
-   kubernetes
-   nexus
-   nvchecker
-   owaspzap
-   python
-   semgrep
-   terraform
-   vagrant
-   virtualbox
-   web

New versions are tracked using [newreleases.io](https://newreleases.io/) except for the following:

-   eclipse
-   golang
-   intellij
-   node
-   virtualbox

Version numbers are also defined centrally in `inventory/group_vars/all/vars.yaml`. These take precedence over the default values in the roles.

A check for new versions can be performed by running `new-version-check`.

## Temporary Changes

Currently Jenkins and Nexus are not in use and so the systemd tasks in `roles/jenkins/tasks/main.yaml` and `roles/nexus/tasks/main.yaml` are not enabled.
