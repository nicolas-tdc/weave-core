#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

if [ -z "$2" ]; then
    echo -e "\e[31mToo many arguments. Exiting...\e[0m"
    echo "Usage: ./weave.sh {create|clone|update}"
    exit 1
fi

(
    # Execute from project root in a subshell
    cd "$(dirname "$0")"

    case "$1" in
    create) ./scripts/create-app.sh ;;
    clone) ./scripts/clone-app.sh ;;
    update) ./scripts/update.sh;;
    *)
        echo -e "\e[31mError: Invalid or missing argument. Exiting...\e[0m"
        echo "Usage: ./weave.sh {create|clone|update}"
        exit 1 
        ;;
    esac
)
