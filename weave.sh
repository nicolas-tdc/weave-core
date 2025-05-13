#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# This script is used to to manage a weave application from its root directory.

(
    # Exectue from application root
    cd "$(dirname "$0")"

    WEAVE_CONFIGURATIONS_FILE="weave.conf"

    # Source configurations
    if [ -f "./weave-core/helpers/configurations.sh" ]; then
        source ./weave-core/helpers/configurations.sh
    else
        echo -e "\e[31mCannot find configurations file. Exiting...\e[0m"
        exit 1
    fi

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

    # Source logs helpers
    if [ -f "./weave-core/helpers/logs.sh" ]; then
        source ./weave-core/helpers/logs.sh
    else
        echo -e "\e[31mCannot find logs helper file. Exiting...\e[0m"
        exit 1
    fi

    # Source utilities helpers
    if [ -f "./weave-core/helpers/utils.sh" ]; then
        source ./weave-core/helpers/utils.sh
    else
        echo -e "\e[31mCannot find 'utils' helper file. Exiting...\e[0m"
        exit 1
    fi

    # Source docker helpers
    if [ -f "./weave-core/helpers/docker.sh" ]; then
        source ./weave-core/helpers/docker.sh
    else
        echo -e "\e[31mCannot find 'docker' helper file. Exiting...\e[0m"
        exit 1
    fi

    # Source services helpers
    if [ -f "./weave-core/helpers/services/execute.sh" ]; then
        source ./weave-core/helpers/services/execute.sh
    else
        echo -e "\e[31mCannot find services execute helper file. Exiting...\e[0m"
        exit 1
    fi

    # Check if enough arguments are provided
    if [ "$#" -lt 1 ]; then
        echo -e "\e[31mAt least one argument is required. Exiting...\e[0m"
        log_app_usage
        exit 1
    fi

    # Get application name and services directory
    get_application_name
    get_services_directory

    # Parse arguments to extract environment and service name
    parse_command_arguments "$@"

    # Aggregate relevant environment files
    prepare_environment_files "$ENV_NAME"

    # Execute the appropriate script based on command line argument
    command_name="$1"
    shift
    case "$command_name" in
        run|kill) execute_command $command_name;;
        backup) source ./weave-core/commands/backup.sh;;
        add-service) source ./weave-core/commands/service-add.sh;;
        rm-service) source ./weave-core/commands/service-remove.sh;;
        backup-enable) source ./weave-core/commands/backup-enable.sh;;
        backup-disable) source ./weave-core/commands/backup-disable.sh;;
        *)
            echo -e "\e[31m$APP_NAME: Invalid argument. Exiting...\e[0m"
            log_app_usage
            exit 1
            ;;
    esac
)
