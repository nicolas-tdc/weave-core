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

# Source docker helpers
if [ -f "./weave/helpers/docker.sh" ]; then
    source ./weave/helpers/docker.sh
else
    echo -e "\e[31mCannot find 'docker' file! Exiting...\e[0m"
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

echo -e "\e[33mTrying to stop application '$APP_NAME' in '$APP_ENV' environment...\e[0m"

install_packages \
    docker \
    docker-compose

execute_services_specific_script $SERVICES_DIRECTORY "stop.sh"

remove_network "$APP_NAME-main-network"

echo -e "\e[32mApplication '$APP_NAME' stopped in '$APP_ENV' environment.\e[0m"
