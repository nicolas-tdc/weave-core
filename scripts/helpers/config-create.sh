#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

configure_name() {
    # Application name
    default="app"
    # Application name input
    echo -e "\e[94mEnter application name (default: '$default'):\e[0m"
    read "APP_NAME"
    APP_NAME=${APP_NAME:-"$default"}

    export APP_NAME
}

configure_path() {
    # Application directory path
    while true; do
        # Application directory path input
        echo -e "\e[94mEnter path to desired application directory (default: '..'):\e[0m"
        read "APP_PATH"
        APP_PATH=${APP_PATH:-".."}

        # Check for valid path input
        if ! [ -d "$APP_PATH" ]; then
            echo -e "\e[31mInvalid path. Please choose a valid path.\e[0m"
            continue;
        fi

        # Expand tilde (~) to full home directory path
        APP_PATH=$(eval echo "$APP_PATH")

        export APP_PATH="${APP_PATH%/}"
        break;
    done
}

create_application_directory() {
    if ! [ -d "$APP_PATH/$APP_NAME" ]; then
        # Create application directory
        mkdir "$APP_PATH/$APP_NAME"
        echo -e "\e[33mCreating directory...\e[0m"
    else
        # Prompt user to overwrite existing directory
        while true; do
            echo -e "\e[31mDirectory already exists.\e[0m"
            echo -e "\e[94mDo you want to overwrite it? (yes/no): \c\e[0m"
            read overwrite
            if [ "$overwrite" == "yes" ]; then
                sudo rm -rf "$APP_PATH/$APP_NAME"
                mkdir "$APP_PATH/$APP_NAME"
                break;
            elif [ "$overwrite" == "no" ]; then
                echo -e "\e[31mExiting application initialization...\e[0m"
                exit 1
            else
                echo -e "\e[31mInvalid input.\e[0m"
            fi
        done
    fi
}

create_service_directory() {
    default="services"
    echo -e "\e[94mEnter your services' directory name (default: '$default'):\e[0m"
    # Input services directory
    read "SERVICES_DIRECTORY"
    SERVICES_DIRECTORY=${SERVICES_DIRECTORY:-"$default"}
       
    # Create services directory
    mkdir -p "$APP_PATH/$APP_NAME/$SERVICES_DIRECTORY"

    export SERVICES_DIRECTORY
}

configure_environment_file() {
    # Initial environment dist file
    app_env_file="$APP_PATH/$APP_NAME/.env.dist"

    # Initial application environment variables
    echo "# $APP_NAME global env variables" > $app_env_file
    echo "SERVICES_DIRECTORY=\"$SERVICES_DIRECTORY\"" >> $app_env_file
}