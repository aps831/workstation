#! /bin/bash
(
cat << EOF
vault_nas_password: $(pass odin.local/andrew/password)
EOF
) | ansible-vault encrypt - > roles/nas/vars/vault.yml
