#!/bin/sh

. /usr/bin/api.sh

run_jackett() {

    echo "Starting Jackett..."

    /app/Jackett/jackett --NoUpdates --NoRestart &

    until curl -s http://127.0.0.1:9117/ >/dev/null; do sleep 1; done

    echo "Jackett is up!"

}

login_to_jackett() {

    echo "Logging in to Jackett..."

    if api_login; then
        echo "Login Successful."
    else
        echo "Login failed."
        exit 1
    fi

}

change_admin_password() {

    echo "Changing admin password..."

    response=$(api_change_password "$ADMIN_PASSWORD")

    if [ "$response" = "204" ]; then
        echo "Admin password changed successfully".
    else
        echo "Error while changing password."
        echo "$response"
        exit 1
    fi

}

subscribe_all_indexers() {

    echo "Subscribing to indexers..."

    subscriptions=$(api_get_subscriptions)

    for indexer in $(echo $INDEXERS | tr ',;' ' '); do

        if echo "$subscriptions" | grep -qx "$indexer"; then
            echo "Indexer $indexer already subscribed."
            continue
        fi

        echo "Subscribing to indexer $indexer..."

        if ! config=$(api_get_indexer_config "$indexer"); then
            echo "Indexer $indexer not found."
            exit 1
        fi

        response=$(api_subscribe_indexer $indexer "$config")

        if [ "$response" = "204" ]; then
            echo "Indexer $indexer added successfully."
        else
            echo "Error while adding indexer $indexer:"
            echo "$response"
            exit 1
        fi

    done

}
