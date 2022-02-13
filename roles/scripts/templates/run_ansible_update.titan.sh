#! /bin/bash
ansible-pull --ask-become-pass --ask-vault-pass --extra-vars "@inventory/vaulted_vars/vault.yml" -U https://bitbucket.org/aps831/workstation.git playbooks/titan-core.yml
