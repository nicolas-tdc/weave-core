#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# This script is used to to manage a weave application from its root directory.

(
    # Exectue from application root
    cd "$(dirname "$0")"

    # Source application environment helpers
    if [ -f "./weave-core/helpers/environment.sh" ]; then
        source ./weave-core/helpers/environment.sh
    else
        echo -e "\e[31mCannot find application environment helpers file. Exiting...\e[0m"
        exit 1
    fi

    # Defines APP_NAME, SERVICES_DIRECTORY, BACKUP_DIRECTORY
    prepare_application

    # Options defaults
    local env_name="prod"
    local service_name=""

    # Parse arguments to extract options
    local app_script_args=()
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --s=*|--service=*)
                # Extract the value of the --service argument
                service_name="${1#*=}"
                shift
                ;;
            -d|-dev)
                env_name="dev"
                # Leave dev argument for service script
                app_script_args+=("$1")
                shift
                ;;
            -s|-staging)
                env_name="staging"
                # Leave staging argument for service script
                app_script_args+=("$1")
                shift
                ;;
            -*|--*)
                # Handle unknown options
                echo -e "\e[31mInvalid option "$1". Exiting...\e[0m"
                log_app_usage
                exit 1
                ;;
            *)
                # Handle positional arguments
                app_script_args+=("$1")
                shift
                ;;
        esac
    done

    # Restore positional arguments
    set -- "${app_script_args[@]}"

    # Check if enough arguments are provided
    if [ "$#" -lt 1 ]; then
        echo -e "\e[31mAt least one argument is required. Exiting...\e[0m"
        log_app_usage
        exit 1
    fi

    # Aggregate relevant environment files
    prepare_environment_file "$env_name"

    # Execute the appropriate script based on command line argument
    local command_name="$1"
    shift
    case "$command_name" in
        r|run) ./weave-core/commands/run.sh $service_name "$@";;
        k|kill) ./weave-core/commands/kill.sh $service_name "$@";;
        add|add-service) ./weave-core/commands/add-service.sh;;
        bak|backup-task) ./weave-core/commands/backup-task.sh $service_name "$@";;
        bak-on|backup-enable) ./weave-core/commands/backup-enable.sh;;
        bak-off|backup-disable) ./weave-core/commands/backup-disable.sh;;
        *)
            echo -e "\e[31mInvalid argument. Exiting...\e[0m"
            log_app_usage
            exit 1
            ;;
    esac
)
