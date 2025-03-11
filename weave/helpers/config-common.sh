#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# usage : read_default "DYNAMIC_VAR" "default_value"
read_default() {
    if [ -z "$1" ]; then
        echo -e "\e[31mread_default: Error: No variable name provided.\e[0m"
        exit 1
    fi

    var_name="$1"

    # If default value is provided initially, store it in a persistent variable
    if [ -n "$2" ]; then
        eval "DEFAULT_${var_name}=\"$2\""
    fi

    # Retrieve the stored default value
    eval "default_value=\"\${DEFAULT_${var_name}}\""

    if [ -z "$default_value" ]; then
        echo -e "\e[31mread_default: No default value available.\e[0m"
        exit 1
    fi

    echo -e "\n"

    if [ "$SETUP_TYPE" == "default" ]; then
        # Automatically use the stored default value
        input_var="$default_value"
    else
        # Read input from user
        read -r input_var
        input_var=${input_var:-"$default_value"}
    fi

    # Dynamically assign the input value to the variable
    eval "$var_name=\"${input_var}\""
    # Update the persistent default value for the next use
    eval "DEFAULT_${var_name}=\"${input_var}\""
}

echo -e "\e[33mConfiguring application...\e[0m"

# Setup type input
while true; do
    echo -e "Setup type default|manual (default: 'default'): \c"
    read SETUP_TYPE
    SETUP_TYPE=${SETUP_TYPE:-default}
    # Check for valid environment input
    if [ $SETUP_TYPE == "default"  ] || [ $SETUP_TYPE == "manual" ]; then
        break;
    else
        echo -e "\e[31mInvalid input. Please choose a valid type: default|manual.\e[0m"
    fi
done

# Application repository input
GIT_SSH_REGEX="^git@[a-zA-Z0-9.-]+:[^/]+/.+\.git$"
while true; do
    echo -e "Enter your application's repository SSH URL: \c"
    read APP_REPOSITORY
    # Check for valid repository input
    if [[ "$APP_REPOSITORY" =~ $GIT_SSH_REGEX ]]; then
        break;
    else
        echo "Invalid SSH Git URL."
    fi
done
export APP_REPOSITORY

# Application name input
REPOSITORY_NAME=$(basename "$APP_REPOSITORY" .git)
echo -e "Enter application name (default: '$REPOSITORY_NAME'): \c"
read_default "APP_NAME" $REPOSITORY_NAME
export APP_NAME

# Application directory path input
while true; do
    echo -e "Enter path to desired application directory (default: '..'): \c"
    read -e "APP_PATH"
    APP_PATH=${APP_PATH:-".."}
    # Expand tilde (~) to full home directory path
    APP_PATH=$(eval echo "$APP_PATH")
    # Check for valid path input
    if [ -d "$APP_PATH" ]; then
        APP_PATH="${APP_PATH%/}"
        break;
    else
        echo -e "\e[31mInvalid path. Please choose a valid path.\e[0m"
    fi
done
export APP_PATH