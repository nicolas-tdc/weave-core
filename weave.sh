#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# This script is used to create a Weave project or update Weave framework.
# It takes one argument: the action to perform (create or update).
# Usage: ./weave.sh {create|update}

# Check for the correct number of arguments
if ! [ -z "$2" ]; then
    echo -e "\e[31mToo many arguments. Exiting...\e[0m"
    echo -e "\e[33mUsage: ./weave.sh <create|update>\e[0m"
    exit 1
fi

(
    # Execute from project root in a subshell
    cd "$(dirname "$0")"

    # Execute the appropriate script based on command line argument
    case "$1" in
        create) ./scripts/create-app.sh ;;
        update) ./scripts/update.sh;;
    *)
        echo -e "\e[31mError: Invalid or missing argument. Exiting...\e[0m"
        echo -e "\e[33mUsage: ./weave.sh <create|update>\e[0m"
        exit 1 
        ;;
    esac
)
