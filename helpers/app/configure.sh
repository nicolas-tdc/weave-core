#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

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

# Application name input
echo -e "Enter application name (default: 'app'): \c"
read "APP_NAME"
APP_NAME=${APP_NAME:-"app"}

export APP_NAME

# Application directory path input
while true; do
    echo -e "Enter path for application directory (default: '../'): \c"
    read -e "APP_PATH"
    APP_PATH=${APP_PATH:-"../"}
    # Expand tilde (~) to full home directory path
    APP_PATH=$(eval echo "$APP_PATH")
    # Check for valid path input
    if [ -d "$APP_PATH" ]; then
        cd $APP_PATH
        break;
    else
        echo -e "\e[31mInvalid path. Please choose a valid path.\e[0m"
    fi
done

# Create app directory
echo -e "\e[33mCreating application directory...\e[0m"
mkdir -p $APP_NAME

DEV_ENV_FILE=".env.dev"
STAGING_ENV_FILE=".env.staging"
PROD_ENV_FILE=".env.prod"

echo "export APP_NAME=\"$APP_NAME\"" > $DEV_ENV_FILE
echo "export APP_NAME=\"$APP_NAME\"" > $STAGING_ENV_FILE
echo "export APP_NAME=\"$APP_NAME\"" > $PROD_ENV_FILE

GIT_SSH_REGEX="^git@[a-zA-Z0-9.-]+:[^/]+/.+\.git$"
# Application repostiory input
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
# Add to .env file
echo "export APP_REPOSITORY=\"$APP_REPOSITORY\"" >> $DEV_ENV_FILE
echo "export APP_REPOSITORY=\"$APP_REPOSITORY\"" >> $STAGING_ENV_FILE
echo "export APP_REPOSITORY=\"$APP_REPOSITORY\"" >> $PROD_ENV_FILE

export APP_REPOSITORY

# Input main branch name
echo -e "Enter your main branch name (default: 'main'): \c"
read_default "MAIN_BRANCH" "main"
# Add to .env file
echo "export BRANCH=\"$BRANCH\"" >> $STAGING_ENV_FILE
echo "export BRANCH=\"$BRANCH\"" >> $PROD_ENV_FILE

export MAIN_BRANCH

# Input dev branch name
echo -e "Enter your development branch name (default: 'devel'): \c"
read_default "DEV_BRANCH" "devel"
# Add to .env file
echo "export BRANCH=\"$DEV_BRANCH\"" >> $DEV_ENV_FILE

export DEV_BRANCH

# User info input for permissions
echo -e "Enter user info for permissions (default: '\$USER:\$USER'): \c"
read USER_INFO
read_default "USER_INFO" "$USER:$USER"
# Create and add to .env file
echo "export USER_INFO=\"$USER_INFO\"" >> $DEV_ENV_FILE
echo "export USER_INFO=\"$USER_INFO\"" >> $STAGING_ENV_FILE
echo "export USER_INFO=\"$USER_INFO\"" >> $PROD_ENV_FILE
export USER_INFO
