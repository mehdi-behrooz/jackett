#!/bin/sh

ensure_env_var() {
    if [ -z "$(printenv "$1")" ]; then
        echo "Missing required env variable: $1"
        exit 1
    fi
}

setup_config() {

    mkdir -p $XDG_CONFIG_HOME/Jackett/

    config=$XDG_CONFIG_HOME/Jackett/ServerConfig.json

    [ -e "$config" ] || jq -n '.' >$config

    key=$API_KEY

    if [ -z "$key" ]; then
        echo "Env variable API_KEY not found. Generating a random key..."
        key=$(tr -dc 'a-z0-9' < /dev/urandom | head -c 32)
    fi

    jq --arg key "$key" '.APIKey=$key' $config \
        | jq '.AdminPassword=null | .ListenPort=9117' \
        | sponge $config

}
