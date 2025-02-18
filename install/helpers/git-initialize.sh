#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Input ssh private key path
echo -e "Enter your ssh public key path (default: '~/.ssh/id_rsa'): \c"
read SSH_PRIVATE_KEY_PATH
SSH_PRIVATE_KEY_PATH=${SSH_PRIVATE_KEY_PATH:-~/.ssh/id_rsa}

# Setup ssh agent
eval "$(ssh-agent -s)"
ssh-add "$SSH_PRIVATE_KEY_PATH"
SSH_PRIVATE_KEY_PATH=""

# Git configuration
echo -e "\e[33mConfiguring git...\e[0m"
git config --global init.defaultBranch "$MAIN_BRANCH"

# Clone repository
echo -e "\e[33mCloning repository...\e[0m"
git clone --single-branch --branch "$SK_BRANCH_NAME" "$SK_REPOSITORY" "$APP_NAME"

# Git remove app git cache
echo -e "\e[33mReinitializing git repository...\e[0m"
rm -rf "$APP_NAME/.git"

# Git link to project repository
echo -e "\e[33mLink to git app repository...\e[0m"
cd "$APP_NAME"
git init
git add .
git commit -m "Initial commit $APP_NAME"
git remote add origin "$APP_REPOSITORY"
git push -u origin "$MAIN_BRANCH"
git checkout -b "$BRANCH"
git push -u origin "$MAIN_BRANCH:$BRANCH"

pkill ssh-agent