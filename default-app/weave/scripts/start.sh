#!/bin/bash

# Exit immediately if a command fails
set -e

# Source utilities helpers
if [ -f "./weave/helpers/utils.sh" ]; then
    source ./weave/helpers/utils.sh
else
    echo -e "\e[31mCannot find 'utils' file! Exiting...\e[0m"
    exit 1
fi

# Source services helpers
if [ -f "./weave/helpers/services.sh" ]; then
    source ./weave/helpers/services.sh
else
    echo -e "\e[31mCannot find 'services' file! Exiting...\e[0m"
    exit 1
fi

set_application_environment $1

echo -e "\e[33mTrying to start application '$APP_NAME'...\e[0m"

# Required packages installation
install_packages \
    docker \
    docker-compose

execute_services_specific_script $SERVICES_DIRECTORY "start.sh"
execute_services_specific_script $SERVICES_DIRECTORY "log-available-ports.sh"

echo -e "\e[32mApplication '$APP_NAME' started.\e[0m"
