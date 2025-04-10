#!/bin/bash

# Exit immediately if a command fails
set -e

# This script is used to start the application and its services.

# Source services helpers
if [ -f "./weave-core/helpers/services.sh" ]; then
    source ./weave-core/helpers/services.sh
else
    echo -e "\e[31mCannot find 'services' helper file. Exiting...\e[0m"
    exit 1
fi

# Extract service name from command line arguments
service_name=$1
shift

if [ -z "$service_name" ]; then
    # Execute the run command on all services
    echo -e "\e[33mTrying to start application '$APP_NAME'...\e[0m"

    execute_command_on_all_services \
        $SERVICES_DIRECTORY \
        "run" \
        "$@"

    execute_command_on_all_services \
        $SERVICES_DIRECTORY \
        "log" \
        "$@"

    echo -e "\e[33mApplication '$APP_NAME' started successfully.\e[0m"
else
    # Execute the run command on a specific service
    echo -e "\e[33mTrying to start service '$service_name'...\e[0m"

    execute_command_on_specific_service \
        $SERVICES_DIRECTORY \
        "run" \
        $service_name \
        "$@"

    execute_command_on_specific_service\
        $SERVICES_DIRECTORY \
        "log" \
        $service_name \
        "$@"

    echo -e "\e[33mService '$service_name' started successfully...\e[0m"
fi
