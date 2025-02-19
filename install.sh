#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo -e "\e[32mInstall application\e[0m"

if [ -f "./helpers/local-setup.sh" ]; then
    echo -e "\e[33mSetting up local environment...\e[0m"
    source ./helpers/local-setup.sh
fi

if [ -f "./helpers/app-setup.sh" ]; then
    echo -e "\e[33mSetting up app environment...\e[0m"
    source ./helpers/app-setup.sh
fi

if [ $APP_ENV == "dev" ]; then
    if [ -f "./install/dev.sh" ]; then
        echo -e "\e[33mSetting up development environment...\e[0m"
        ./install/dev.sh
    fi
elif [ $APP_ENV == "prod" ]; then
    if [ -f "./install/prod.sh" ]; then
        echo -e "\e[33mSetting up production environment...\e[0m"
        ./install/prod.sh
    fi
fi

# Set permissions
if [ -f "./helpers/set-permissions.sh" ]; then
    echo -e "\e[33mSetting up permissions...\e[0m"
    ./helpers/set-permissions.sh $APP_NAME
fi

# Run app specific install script
cd "$APP_NAME"
if [ -f "./scripts/install.sh" ]; then
    echo -e "\e[33mRunning app specific install script...\e[0m"
    "./scripts/install.sh"
fi
