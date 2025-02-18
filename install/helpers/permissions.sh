#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# User info input for permissions
echo -e "Enter user info for permissions (default: '\$USER:\$USER'): \c"
read USER_INFO
DEFAULT_USER_INFO="$USER:$USER"
USER_INFO=${USER_INFO:-"$DEFAULT_USER_INFO"}
# Create and add to .env file
echo "export USER_INFO=\"$USER_INFO\"" >> .env
export USER_INFO

# Set permissions
echo -e "\e[33mSetting permissions...\e[0m"
chmod -R 755 "$APP_NAME"
chown -R "$USER_INFO" "$APP_NAME"
if [ -f ".env" ]; then
    chmod -R 755 .env
    chown -R "$USER_INFO" .env
fi

# Run app specific install script
cd "$APP_NAME"
if [ -f "./scripts/install.sh" ]; then
    echo -e "\e[33mRunning app specific install script...\e[0m"
    "./scripts/install.sh"
fi
