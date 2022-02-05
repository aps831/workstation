#! /bin/bash
(
cat << EOF
vault_nas_password: $(pass odin.local/andrew/password)
EOF
) | ansible-vault encrypt - > inventory/group_vars/workstations/vault.yml
