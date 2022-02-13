#! /bin/bash
ansible-pull --ask-become-pass --ask-vault-pass -U https://bitbucket.org/aps831/workstation.git playbooks/titan-core.yml
