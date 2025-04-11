#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# This script is used to manage a weave application's service.

(
    # Exectue from application root
    cd "$(dirname "$0")"

    # Source utilities helpers
    if [ -f "./scripts/helpers/environment.sh" ]; then
        source ./scripts/helpers/environment.sh
    else
        echo -e "\e[31mCannot find 'environment' helpers file. Exiting...\e[0m"
        exit 1
    fi

    # Defines SERVICE_NAME
    prepare_service

    # Options defaults
    local env_name="prod"

    # Parse arguments to extract options
    local service_script_args=()
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -d|-dev)
                # Set env_name
                env_name="dev"
                shift
                ;;
            -s|-staging)
                # Set env_name
                env_name="staging"
                shift
                ;;
            -*||--*)
                # Handle unknown options
                echo -e "\e[31m$SERVICE_NAME: Invalid option "$1". Exiting...\e[0m"
                log_service_usage
                exit 1
                ;;
            *)
                # Handle positional arguments
                service_script_args+=("$1")
                shift
                ;;
        esac
    done

    # Restore positional arguments
    set -- "${service_script_args[@]}"

    # Check if enough arguments are provided
    if [ "$#" -lt 1 ]; then
        echo -e "\e[31m$SERVICE_NAME: At least one argument is required. Exiting...\e[0m"
        log_service_usage
        exit 1
    fi

    # Aggregate relevant environment files
    prepare_environment_file "$env_name"

    # Execute the appropriate script based on command line argument
    local command_name="$1"
    shift
    case "$command_name" in
        r|run) ./scripts/commands/run.sh $env_name "$@";;
        k|kill) ./scripts/commands/kill.sh $env_name "$@";;
        bak|backup-task) ./scripts/commands/backup-task.sh $env_name "$@";;
        log|log-available-ports) ./scripts/commands/log-available-ports.sh $env_name "$@";;
        *)
            echo -e "\e[31m$SERVICE_NAME: Invalid argument. Exiting...\e[0m"
            log_service_usage
            exit 1
            ;;
    esac
)
