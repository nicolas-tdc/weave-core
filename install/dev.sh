#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Input  branch name
echo -e "Enter your development branch name (default: 'devel'): \c"
read BRANCH
BRANCH=${BRANCH:-devel}
# Add to .env file
echo "export BRANCH=\"$BRANCH\"" >> .env

# Run git clone script
if [ -f "./helpers/git-clone.sh" ]; then
    echo -e "\e[33mGit cloning for project clone...\e[0m"
    ./helpers/git-clone.sh $APP_NAME $BRANCH
fi
