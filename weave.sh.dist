#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# This script is used to to manage a weave application from its root directory.

# Check for the correct number of arguments
if ! [ -z "$3" ]; then
    echo -e "\e[31mToo many arguments. Exiting...\e[0m"
    echo "\e[33mUsage: ./weave.sh <start|stop|update|add-service|backup-task|backup-enable|backup-disable>\e[0m"
    exit 1
fi

(
    # Exectue from application root
    cd "$(dirname "$0")"

    # Source environment helpers
    if [ -f "./weave-core/helpers/environment.sh" ]; then
        source ./weave-core/helpers/environment.sh
    else
        echo -e "\e[31mCannot find 'environment' file. Exiting...\e[0m"
        exit 1
    fi

    # Defines APP_NAME, SERVICES_DIRECTORY
    set_application_environment

    # Execute the appropriate script based on command line argument
    # $2 is used to pass a service name to execute only that service's script
    case "$1" in
        start) ./weave-core/commands/start.sh $2;;
        stop) ./weave-core/commands/stop.sh $2;;
        update|update-weave) ./weave-core/commands/update.sh $2;;
        add|add-service) ./weave-core/commands/add-service.sh;;
        bak|backup-task) ./weave-core/commands/backup-task.sh $2;;
        bak-on|backup-enable) ./weave-core/commands/backup-enable.sh;;
        bak-off|backup-disable) ./weave-core/commands/backup-disable.sh;;
    *)
        echo -e "\e[31mInvalid or missing argument. Exiting...\e[0m"
        echo "\e[33mUsage: ./weave.sh <start|stop|update|add|bak|bak-on|bak-off>\e[0m"
        exit 1
        ;;
    esac
)