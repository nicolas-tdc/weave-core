#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Check application and services default files directories exist
check_default_files() {
    ls -al
    if ! [ -d "./default-app" ]; then
        echo -e "\e[31mCannot find default application files! Exiting...\e[0m"
        exit 1
    fi

    if ! [ -d "./default-service" ]; then
        echo -e "\e[31mCannot find default service files! Exiting...\e[0m"
        exit 1
    fi
}

# Copy default files
copy_default_files() {
    if [ -d "$APP_PATH/$APP_NAME" ]; then
        echo -e "\e[33mCopying default files...\e[0m"
        sudo cp -r ./default-app/* "$APP_PATH/$APP_NAME"
        sudo cp -r ./default-service "$APP_PATH/$APP_NAME/weave"
    fi
}