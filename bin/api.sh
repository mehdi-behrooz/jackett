#! /bin/sh

URL="http://127.0.0.1:9117"
UI="$URL/UI/Dashboard/"
API_ENDPOINT="$URL/api/v2.0"
cookie=/home/jackett/cookie.txt

api_login() {
    curl --silent \
        --show-error \
        --header 'Content-Type: application/x-www-form-urlencoded' \
        --data "password=$1" \
        --cookie-jar $cookie \
        $UI
    grep -q 'Jackett' $cookie
}

api_change_password() {
    curl --silent \
        --show-error \
        --header 'Content-Type: application/json' \
        --header 'Accept: application/json, */*' \
        --cookie $cookie \
        --data-raw "'$1'" \
        --write-out "%{http_code}" \
        "$API_ENDPOINT/server/adminpassword"
}

api_get_indexer_config() {
    curl --silent \
        --fail \
        --request GET \
        --header 'Content-Type: application/json' \
        --header 'Accept: application/json, */*' \
        --cookie $cookie \
        "$API_ENDPOINT/indexers/$1/config"
}

api_subscribe_indexer() {
    curl --silent \
        --show-error \
        --request POST \
        --header 'Content-Type: application/json' \
        --header 'Accept: application/json, */*' \
        --cookie $cookie \
        --data-raw "$2" \
        --write-out "%{http_code}" \
        "$API_ENDPOINT/indexers/$1/config"
}

api_get_subscriptions() {
    curl --silent \
        --show-error \
        --request GET \
        --header 'Content-Type: application/json' \
        --header 'Accept: application/json, */*' \
        --cookie $cookie \
        "$API_ENDPOINT/indexers?configured=true" \
        | jq -r '.[].id'
}
