#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

create_application_directory() {
    if ! [ -d "$APP_PATH/$APP_NAME" ]; then
        # Create application directory
        mkdir "$APP_PATH/$APP_NAME"
        echo -e "\e[33mCreating directory...\e[0m"
    else
        # Prompt user to overwrite existing directory
        while true; do
            echo -e "\e[31mDirectory already exists.\e[0m"
            echo -e "\e[33mDo you want to overwrite it? (yes/no): \c\e[0m"
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

configure_service_directory() {
    # Input services directory
    read_default \
        "SERVICES_DIRECTORY" \
        "services" \
        echo -e "Enter your services' directory name (default: 'services'): \c"
    # Create services directory
    mkdir -p "$APP_PATH/$APP_NAME/$SERVICES_DIRECTORY"

    export SERVICES_DIRECTORY
}

configure_main_branch() {
    # Input prod main branch name
    read_default \
        "MAIN_BRANCH" \
        "main" \
        echo -e "Enter your main production branch name (default: 'main'): \c"
    
    export MAIN_BRANCH
}

configure_staging_branch() {
    # Input staging branch name
    read_default \
        "STAGING_BRANCH" \
        "staging" \
        echo -e "Enter your staging branch name (default: 'staging'): \c"

    export STAGING_BRANCH
}

configure_dev_branch() {
    # Input dev branch name
    read_default \
        "DEV_BRANCH" \
        "develop" \
        echo -e "Enter your development branch name (default: 'develop'): \c"

    export DEV_BRANCH
}

configure_environment_files() {
    # Environment files names
    dev_env_file="$APP_PATH/$APP_NAME/.env.dev"
    staging_env_file="$APP_PATH/$APP_NAME/.env.staging"
    prod_env_file="$APP_PATH/$APP_NAME/.env.prod"

    # App repository
    echo "APP_REPOSITORY=\"$APP_REPOSITORY\"" > $dev_env_file
    echo "APP_REPOSITORY=\"$APP_REPOSITORY\"" > $staging_env_file
    echo "APP_REPOSITORY=\"$APP_REPOSITORY\"" > $prod_env_file
    # Git branches
    echo "BRANCH=\"$MAIN_BRANCH\"" >> $prod_env_file
    echo "BRANCH=\"$STAGING_BRANCH\"" >> $staging_env_file
    echo "BRANCH=\"$DEV_BRANCH\"" >> $dev_env_file
    # Services directory
    echo "SERVICES_DIRECTORY=\"$SERVICES_DIRECTORY\"" >> $dev_env_file
    echo "SERVICES_DIRECTORY=\"$SERVICES_DIRECTORY\"" >> $staging_env_file
    echo "SERVICES_DIRECTORY=\"$SERVICES_DIRECTORY\"" >> $prod_env_file
}