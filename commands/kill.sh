#!/bin/bash

# Exit immediately if a command fails
set -e

# This script is used to stop the application and its services.

# Source services helpers
if [ -f "./weave-core/helpers/services.sh" ]; then
    source ./weave-core/helpers/services.sh
else
    echo -e "\e[31mCannot find 'services' helpers file. Exiting...\e[0m"
    exit 1
fi

# Extract service name from command line arguments
service_name=$1
shift

if [ -z "$service_name" ]; then
    # Execute the kill command on all services
    echo -e "\e[33mTrying to stop application '$APP_NAME'...\e[0m"

    execute_command_on_all_services \
        $SERVICES_DIRECTORY \
        "kill" \
        "$@"

    echo -e "\e[33mApplication '$APP_NAME' stopped successfully.\e[0m"
else
    # Execute the kill command on a specific service
    echo -e "\e[33mTrying to stop service '$service_name'...\e[0m"

    execute_command_on_specific_service \
        $SERVICES_DIRECTORY \
        "kill" \
        $service_name \
        "$@"

    echo -e "\e[33mService '$service_name' stopped successfully...\e[0m"
fi
