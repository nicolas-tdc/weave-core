#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

configure_setup_type() {
    # Setup type selection
    echo -e "Choose a setup type:"
    echo -e "Default automatically sets up the application with default values."
    echo -e "Manual allows you to configure the application setup."
    select type in "default" "manual"; do
        if ! [ -n "$type" ]; then
            echo "\e[31mInvalid selection. Please try again.\e[31m"
            continue
        fi

        export SETUP_TYPE=$type
        echo -e "\e[32m$SETUP_TYPE setup selected.\e[0m"
        break
    done

    # Handle default and manual setup types
    if [ -f "./default-app/weave/helpers/utils.sh" ]; then
        source "./default-app/weave/helpers/utils.sh"
    else
    echo -e "\e[31mCannot find default application utilities file! Exiting...\e[0m"
        exit 1
    fi
}

configure_repository() {
    # Application repository
    git_shh_regex="^git@[a-zA-Z0-9.-]+:[^/]+/.+\.git$"
    while true; do
        # Application repository input
        echo -e "Enter your application's repository SSH URL: \c"
        read APP_REPOSITORY

        # Check for valid repository input
        if ! [[ "$APP_REPOSITORY" =~ $git_shh_regex ]]; then
            echo "Invalid SSH Git URL."
            continue;
        fi

        export APP_REPOSITORY
        echo -e "\e[32mApplication repository set to $APP_REPOSITORY.\e[0m"
        break;
    done
}

configure_name() {
    # Application name
    repository_name=$(basename "$APP_REPOSITORY" .git)
    # Application name input
    read_default \
        "APP_NAME" \
        $repository_name \
        "\e[33mEnter application name (default: '$repository_name'): \e[0m" \
    export APP_NAME
}

configure_path() {
    # Application directory path
    while true; do
        # Application directory path input
        echo -e "Enter path to desired application directory (default: '..'):"
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