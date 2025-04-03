#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

(
    # Exectue from application root
    cd "$(dirname "$0")"

    command_name=$1

    shift 1
    
    service_command_args=("$@")

    case "$command_name" in
        start) ./weave/scripts/start.sh ${service_command_args[@]};;
        stop) ./weave/scripts/stop.sh ${service_command_args[@]};;
        update) ./weave/scripts/update.sh ${service_command_args[@]};;
        backup-task) ./weave/scripts/backup-task.sh ${service_command_args[@]};;
        log) ./weave/scripts/log-available-ports.sh ${service_command_args[@]};;
    *)
        echo "Usage: ./weave.sh {start|stop|update|backup-task|log}"
        exit 1
        ;;
    esac
)