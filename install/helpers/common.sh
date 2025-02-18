#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Check if Docker is installed
if ! command -v docker >/dev/null 2>&1; then
    # Install docker
    echo -e "\e[33mInstalling docker..."
    apt install -y docker
fi

# Check if Docker Compose is installed
if ! command -v docker-compose >/dev/null 2>&1; then
    # Install docker
    echo -e "\e[33mInstalling docker compose..."
    apt install -y docker-compose
fi

# Check if user is in Docker group
if groups "$USER" | grep -q "\bdocker\b"; then
    # Add user to Docker group
    echo -e "\e[33mAdding user to Docker group...\e[0m"
    usermod -aG docker $USER
fi

# User info input for permissions
echo -e "Enter user info (default: '\$USER:\$USER'): \c"
read USER_INFO
DEFAULT_USER_INFO="$USER:$USER"
USER_INFO=${USER_INFO:-"$DEFAULT_USER_INFO"}
# Create and add to .env file
echo "export USER_INFO=\"$USER_INFO\"" >> .env
export USER_INFO

# Set permissions
echo -e "\e[33mSetting permissions for app, .env and .git...\e[0m"
chmod -R 755 "$APP_NAME"
chown -R "$USER_INFO" "$APP_NAME"
chmod -R 755 .env
chown -R "$USER_INFO" .env

# Run app specific install script
cd "$APP_NAME"
if [ -f "./scripts/install.sh" ]; then
    echo -e "\e[33mRunning app specific install script...\e[0m"
    "./scripts/install.sh"
fi
