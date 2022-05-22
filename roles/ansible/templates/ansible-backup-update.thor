#! /bin/bash
trap 'rm -rf "$TMPDIR"' EXIT

aws sso login

TMPDIR=$(mktemp -d)
cd "$TMPDIR"
git clone --depth=1 https://github.com/aps831/workstation.git

cd "workstation"
ansible-playbook --ask-become-pass playbooks/thor-backup.yml
