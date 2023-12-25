#! /bin/bash
trap 'rm -rf "$TMPDIR"' EXIT

TMPDIR=$(mktemp -d)
cd "$TMPDIR"
git clone --depth=1 https://github.com/aps831/workstation.git

cd "workstation"

export DOPPLER_PROJECT=workstation
export DOPPLER_CONFIG=$(hostname)

doppler login --scope .
doppler run -- ansible-playbook --ask-become-pass playbooks/thor-backup.yml
doppler logout --scope .
