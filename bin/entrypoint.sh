#!/bin/sh

. /usr/bin/setup_config.sh
. /usr/bin/manage_jackett.sh

ensure_env_var "ADMIN_PASSWORD"

setup_config

run_jackett

login_to_jackett

change_admin_password

subscribe_all_indexers

echo "All the configurations finished successfully."

wait
