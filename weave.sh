#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# This script is used to to manage a weave application from its root directory.

(
    # Exectue from application root
    cd "$(dirname "$0")"

    # Source arguments parser
    if [ -f "./weave-core/helpers/arguments-parser.sh" ]; then
        source ./weave-core/helpers/arguments-parser.sh
    else
        echo -e "\e[31mCannot find arguments parser file. Exiting...\e[0m"
        exit 1
    fi

    # Source application environment helpers
    if [ -f "./weave-core/helpers/environment.sh" ]; then
        source ./weave-core/helpers/environment.sh
    else
        echo -e "\e[31mCannot find application environment helpers file. Exiting...\e[0m"
        exit 1
    fi

    # Source services helpers
    if [ -f "./weave-core/helpers/services.sh" ]; then
        source ./weave-core/helpers/services.sh
    else
        echo -e "\e[31mCannot find 'services' helper file. Exiting...\e[0m"
        exit 1
    fi

    # Defines APP_NAME, SERVICES_DIRECTORY, BACKUP_DIRECTORY
    prepare_application

    # Check if enough arguments are provided
    if [ "$#" -lt 1 ]; then
        echo -e "\e[31mAt least one argument is required. Exiting...\e[0m"
        log_app_usage
        exit 1
    fi

    # Parse arguments to extract options
    read env_name service_name <<< $(parse_command_arguments "$@")

    # Aggregate relevant environment files
    prepare_environment_files "$env_name"

    # Execute the appropriate script based on command line argument
    command_name="$1"
    shift
    case "$command_name" in
        run|kill|backup)
            if [ "$service_name" == "" ]; then
                echo -e "\e[33mTrying to execute '$command_name' on application '$APP_NAME'...\e[0m"

                execute_command_on_all_services \
                    $SERVICES_DIRECTORY \
                    $command_name \
                    $@
            else
                echo -e "\e[33mTrying to start service '$service_name'...\e[0m"

                execute_command_on_specific_service \
                    $SERVICES_DIRECTORY \
                    $command_name \
                    $service_name \
                    $@
            fi
            ;;
        add-service) ./weave-core/commands/add-service.sh;;
        backup-enable) ./weave-core/commands/backup-enable.sh;;
        backup-disable) ./weave-core/commands/backup-disable.sh;;
        *)
            echo -e "\e[31mInvalid argument. Exiting...\e[0m"
            log_app_usage
            exit 1
            ;;
    esac
)
