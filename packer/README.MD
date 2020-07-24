packer build \
-var SUBNET_ID="subnet-0f929b8fbd4a86d64" \
-var ROOT_PASS=vault.root_pass \
-var DB_USER_NAME=vault.username \
-var DB_USER_PASS=vault.db_user_pass\
packer.json 