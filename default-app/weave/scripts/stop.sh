#!/bin/bash

# Exit immediately if a command fails
set -e

# This script is used to stop the application and its services.

# Source services helpers
if [ -f "./weave/helpers/services.sh" ]; then
    source ./weave/helpers/services.sh
else
    echo -e "\e[31mCannot find 'services' file! Exiting...\e[0m"
    exit 1
fi

if [ -z "$1" ]; then
    # Execute the stop command on all services
    echo -e "\e[33mTrying to stop application '$APP_NAME'...\e[0m"
    execute_command_on_all_services $SERVICES_DIRECTORY "stop"
else
    # Execute the stop command on a specific service
    service_name=$1
    echo -e "\e[33mTrying to stop service '$service_name'...\e[0m"
    execute_command_on_specific_service $SERVICES_DIRECTORY "stop" $service_name
fi

echo -e "\e[32mApplication '$APP_NAME' stopped.\e[0m"
