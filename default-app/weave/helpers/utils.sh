#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# This function installs apt packages listed as function arguments
# usage :
# install_packages <first-package> <second-package> ...
install_packages() {
    # Define required packages
    packages=("$@")

    # Check if a package is installed
    is_installed() {
        dpkg -l | grep -q "^ii  $1 "
    }

    # Check for missing packages
    needs_update=false
    for pkg in "${packages[@]}"; do
        if ! is_installed "$pkg"; then
            needs_update=true
            break;
        fi
    done

    # If at least one package is missing, update and install
    if [ "$needs_update" = true ]; then
        echo -e "\e[33mInstalling missing packages...\e[0m"
        sudo apt update
        for pkg in "${packages[@]}"; do
            if ! is_installed "$pkg"; then
                echo -e "\e[33mInstalling $pkg...\e[0m"
                sudo apt install -y "$pkg"
            fi
        done
        sudo apt autoremove
    else
        echo -e "\e[32mAll packages are already installed.\e[0m"
    fi
}

# @todo: check if used in app, else move to weave helpers utils file
# This function automatically sets provided variable name
# to the default value if setup type is default.
# usage :
# read_default <var_name> <default value> <(optional)Prompt message...>
read_default() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo -e "\e[31mread_default() - Error: First and second argument are required.\e[0m"
        echo -e "\e[31musage: read_default <var_name> <default value> <(optional)Prompt message...>\e[0m"
        exit 1
    fi

    var_name="$1"

    # If default value is provided initially, store it in a persistent variable
    if [ -n "$2" ]; then
        eval "DEFAULT_${var_name}=\"$2\""
    fi

    # Display prompt message if setup type is manual
    if ! [ -z "$3" ] && [ "$SETUP_TYPE" == "manual" ]; then
        echo -e "$3"
    fi

    # Retrieve the stored default value
    eval "default_value=\"\${DEFAULT_${var_name}}\""

    if [ -z "$default_value" ]; then
        echo -e "\e[31mread_default: No default value available.\e[0m"
        exit 1
    fi

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
    
    
    # Display success message
    echo -e "\e[32m$var_name set to $input_var\e[0m"
}

set_application_environment() {
    # Application environment input defaults to dev
    if [ -z "$1" ]; then
        export APP_ENV="dev"
    else
        export APP_ENV=$1
    fi

    # Check for environment input validity
    if ! [[ "$APP_ENV" == "dev" || "$APP_ENV" == "staging" || "$APP_ENV" == "prod" ]]; then
        echo -e "\e[31mError: Invalid environment provided as first argument!\e[0m"
        echo -e "\e[31mAvailable: dev|staging|prod.\e[0m"
        exit 1
    fi

    # Check if the deploy-sk .env file exists
    if ! [ -f "./.env.$APP_ENV" ]; then
        echo -e "\e[31mError: .env.$APP_ENV file not found in the app directory.\e[0m"
        exit 1
    fi

    # Get development environment variables
    echo -e "\e[33mSet $APP_ENV environment variables...\e[0m"
    sudo cp ".env.$APP_ENV" ".env"
    source .env

    # Get app name from directory name
    export APP_NAME=$(basename "$PWD") > /dev/null 2>&1
}