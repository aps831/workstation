#! /bin/bash
# Check running as root
if ((EUID != 0)); then
  echo "You must be root when running this script" 1>&2
  exit 1
fi
apt-get install software-properties-common
apt-get update
apt-add-repository -y ppa:ansible/ansible
add-apt-repository -y ppa:git-core/ppa
apt-get update
apt-get install -y git
apt-get install -y ansible
apt-get install -y gnome-keyring
ansible-galaxy collection install community.general

# This has been removed from Ubuntu 24
mkdir -p /usr/local/bin
