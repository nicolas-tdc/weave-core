#!/bin/bash

# Exit immediately if a command fails
set -e

# Source common configuration helpers
if [ -f "./weave/helpers/utils.sh" ]; then
    source ./weave/helpers/utils.sh
else
    echo -e "\e[31m$SERVICE_NAME|$APP_ENV: Cannot find 'utils' file! Exiting...\e[0m"
    exit 1
fi

set_service_environment $1

# Add backup task here
echo -e "\e[33m$SERVICE_NAME|$APP_ENV: No backup task.\e[0m"