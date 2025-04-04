#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# This script is used to to manage a weave application.

# Check for the correct number of arguments
if ! [ -z "$3" ]; then
    echo -e "\e[31mToo many arguments. Exiting...\e[0m"
    echo "\e[33mUsage: ./weave.sh <start|stop|update|add-services|backup-task|backup-enable|backup-disable>\e[0m"
    exit 1
fi

(
    # Exectue from application root
    cd "$(dirname "$0")"

    # Source utilities helpers
    if [ -f "./weave/helpers/utils.sh" ]; then
        source ./weave/helpers/utils.sh
    else
        echo -e "\e[31mCannot find 'utils' file! Exiting...\e[0m"
        exit 1
    fi

    # Defines APP_NAME
    set_application_environment

    # Execute the appropriate script based on command line argument
    # $2 is used to pass a service name to execute only that service's script
    case "$1" in
        start) ./weave/scripts/start.sh $2;;
        stop) ./weave/scripts/stop.sh $2;;
        update) ./weave/scripts/update.sh $2;;
        add-services) ./weave/scripts/add-services.sh;;
        backup-task) ./weave/scripts/backup-task.sh $2;;
        backup-enable) ./weave/scripts/backup-enable.sh;;
        backup-disable) ./weave/scripts/backup-disable.sh;;
    *)
        echo -e "\e[31mInvalid or missing argument. Exiting...\e[0m"
        echo "\e[33mUsage: ./weave.sh <start|stop|update|add-services|backup-task|backup-enable|backup-disable>\e[0m"
        exit 1
        ;;
    esac
)