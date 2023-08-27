#! /bin/bash
sudo apt-get install software-properties-common
sudo apt-add-repository -y ppa:ansible/ansible
sudo add-apt-repository -y ppa:git-core/ppa
sudo apt-get update
sudo apt-get install -y git
sudo apt-get install -y ansible
ansible-galaxy collection install community.general
