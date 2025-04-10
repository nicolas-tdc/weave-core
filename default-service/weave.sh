#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# This script is used to manage a weave application's service.

(
    # Exectue from application root
    cd "$(dirname "$0")"

    command_name=$1

    # Get other arguments to be passed to the service command
    shift 1
    service_command_args=("$@")

    # Source utilities helpers
    if [ -f "./scripts/helpers/environment.sh" ]; then
        source ./scripts/helpers/environment.sh
    else
        echo -e "\e[31mCannot find 'environment' file. Exiting...\e[0m"
        exit 1
    fi

    # Defines SERVICE_NAME
    set_service_environment

    # Execute the appropriate script based on command line argument
    # service_command_args passed to the service command
    case "$command_name" in
        start) ./scripts/commands/start.sh ${service_command_args[@]};;
        stop) ./scripts/commands/stop.sh ${service_command_args[@]};;
        update) ./scripts/commands/update.sh ${service_command_args[@]};;
        bak|backup-task) ./scripts/commands/backup-task.sh ${service_command_args[@]};;
        log|log-available-ports) ./scripts/commands/log-available-ports.sh ${service_command_args[@]};;
    *)
        echo -e "\e[31mInvalid or missing argument. Exiting...\e[0m"
        echo "\e[33mUsage: ./weave.sh <start|stop|update|backup-task|log>\e[0m"
        exit 1
        ;;
    esac
)