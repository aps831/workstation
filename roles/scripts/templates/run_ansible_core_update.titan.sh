#! /bin/bash
trap 'rm -rf "$TMPDIR"' EXIT
TMPDIR=$(mktemp -d)
cd "$TMPDIR"
git clone --depth=1 https://bitbucket.org/aps831/workstation.git
cd "workstation"
ansible-playbook --ask-become-pass --ask-vault-pass --extra-vars "@inventory/vaulted_vars/vault.yml" playbooks/titan-core.yml