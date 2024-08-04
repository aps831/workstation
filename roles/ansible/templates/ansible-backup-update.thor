#! /bin/bash
trap 'rm -rf "$TMPDIR"' EXIT

TMPDIR=$(mktemp -d)
cd "$TMPDIR"
git clone --depth=1 https://github.com/aps831/workstation.git

cd "workstation"

export DOPPLER_PROJECT=workstation
export DOPPLER_CONFIG=$(hostname)

echo "***A temporary PAT is require to access Doppler personal account***"
echo "***Open the browser manually to ensure that you authenticate with the correct account***"
echo "***Use 'ansible-temp' for the token name.  It should be deleted at the end of the update***"
doppler login --scope .
doppler run -- ansible-playbook --ask-become-pass playbooks/thor-backup.yml
doppler logout --scope .
