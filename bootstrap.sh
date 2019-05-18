#! /bin/bash

# Install Software Properties Common
sudo apt-get install software-properties-common

# Install Git and Ansible
sudo apt-add-repository -y ppa:ansible/ansible
sudo add-apt-repository -y ppa:git-core/ppa
sudo apt-get update
sudo apt-get install -y git
sudo apt-get install -y ansible

echo "******************************************"
echo "******************************************"
echo "Enter playbook name including '.yml' extension:"
read PLAYBOOK

# Run ansible-pull
ansible-pull --ask-become-pass -U https://aps831@bitbucket.org/aps831/workstation.git provisioning/"$PLAYBOOK"
