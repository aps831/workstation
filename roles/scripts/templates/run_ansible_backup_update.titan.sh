#! /bin/bash
trap 'rm -rf "$TMPDIR"' EXIT

aws sso login --profile "andrew-p-spratley"
aws sso login --profile "spratleyap"

TMPDIR=$(mktemp -d)
cd "$TMPDIR"
git clone --depth=1 https://bitbucket.org/aps831/workstation.git

cd "workstation"
ansible-playbook --ask-become-pass playbooks/titan-backup.yml