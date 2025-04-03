#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

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

    set_application_environment

    case "$1" in
    start) ./weave/scripts/start.sh $2;;
    stop) ./weave/scripts/stop.sh $2;;
    update) ./weave/scripts/update.sh $2;;
    add-services) ./weave/scripts/add-services.sh;;
    backup-task) ./weave/scripts/backup-task.sh $2;;
    backup-enable) ./weave/scripts/backup-enable.sh;;
    backup-disable) ./weave/scripts/backup-disable.sh;;
    *)
        echo "Usage: ./weave.sh {start|stop|update|add-services|backup-task|backup-enable|backup-disable}"
        exit 1
        ;;
    esac
)