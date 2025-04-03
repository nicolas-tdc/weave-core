#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# This script is used to manage a Weave application's service.

(
    # Exectue from application root
    cd "$(dirname "$0")"

    command_name=$1

    # Get other arguments to be passed to the service command
    shift 1
    service_command_args=("$@")

    # Source utilities helpers
    if [ -f "./weave/helpers/utils.sh" ]; then
        source ./weave/helpers/utils.sh
    else
        echo -e "\e[31mCannot find 'utils' file! Exiting...\e[0m"
        exit 1
    fi

    # Defines SERVICE_NAME
    set_service_environment

    # Execute the appropriate script based on command line argument
    # service_command_args passed to the service command
    case "$command_name" in
        start) ./weave/scripts/start.sh ${service_command_args[@]};;
        stop) ./weave/scripts/stop.sh ${service_command_args[@]};;
        update) ./weave/scripts/update.sh ${service_command_args[@]};;
        backup-task) ./weave/scripts/backup-task.sh ${service_command_args[@]};;
        log) ./weave/scripts/log-available-ports.sh ${service_command_args[@]};;
    *)
        echo "\e[33mUsage: ./weave.sh <start|stop|update|backup-task|log>\e[0m"
        exit 1
        ;;
    esac
)