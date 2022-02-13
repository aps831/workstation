#! /bin/bash
(
cat << EOF
nas_password: $(pass odin.local/andrew/password)
EOF
) | ansible-vault encrypt - > inventory/vaulted_vars/vault.yml
