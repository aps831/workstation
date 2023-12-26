#! /bin/bash
trap 'rm -rf "$TMPDIR"' EXIT

TMPDIR=$(mktemp -d)
cd "${TMPDIR}" || exit
git clone --depth=1 https://github.com/aps831/workstation.git

cd "workstation" || exit

DOPPLER_CONFIG=$(hostname)
export DOPPLER_PROJECT=workstation
export DOPPLER_CONFIG="${DOPPLER_CONFIG}"

doppler login --scope .
doppler run -- ansible-playbook --ask-become-pass playbooks/thor-core.yml
doppler logout --scope .
