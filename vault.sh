#! /bin/bash
(
cat << EOF
vault_nas_password: $(pass odin.local/andrew/password | base64)
vault_opendata_basic_auth_aps831: $(echo -n aps831@yahoo.co.uk:$(pass datafeeds.networkrail.co.uk/aps831@yahoo.co.uk/password) | base64 )
vault_opendata_basic_auth_operations_reports_831: $(echo -n operations.reports.831@gmail.com:$(pass datafeeds.networkrail.co.uk/operations.reports.831@gmail.com/password) | base64 )
EOF
) | ansible-vault encrypt - > inventory/vaulted_vars/vault.yml
