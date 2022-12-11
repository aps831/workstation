#! /bin/bash
set -e
vault_nas_password="$(pass odin.local/andrew/password)"
vault_nas_password_b64="$(echo "${vault_nas_password}" | base64)"
vault_opendata_password_aps831="$(pass datafeeds.networkrail.co.uk/aps831@yahoo.co.uk/password)"
vault_opendata_password_aps831_b64=$(echo "${vault_opendata_password_aps831}" | base64)
vault_opendata_password_operations_reports_831="$(pass datafeeds.networkrail.co.uk/operations.reports.831@gmail.com/password)"
vault_opendata_password_operations_reports_831_b64=$(echo "${vault_opendata_password_operations_reports_831}" | base64)
temp_file=$(mktemp)
cat <<EOF >"${temp_file}"
vault_nas_password: "${vault_nas_password_b64}"
vault_opendata_password_aps831: "${vault_opendata_password_aps831_b64}"
vault_opendata_password_operations_reports_831: "${vault_opendata_password_operations_reports_831_b64}"
EOF
ansible-vault encrypt <"${temp_file}" >inventory/vaulted_vars/vault.yml
