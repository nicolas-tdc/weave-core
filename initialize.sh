#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo -e "\e[32mLaunching application initialization!\e[0m"

# Setup app environment
if [ -f "./helpers/app/read-environment.sh" ]; then
    echo -e "\e[33mSetting up app environment...\e[0m"
    source ./helpers/app/read-environment.sh
fi

# Run git auth script
if [ -f "./helpers/git/ssh-agent.sh" ]; then
    echo -e "\e[33mGit authentication...\e[0m"
    source ./helpers/git/ssh-agent.sh
fi

# Add services
if [ -f "./helpers/services/add.sh" ]; then
    echo -e "\e[33mAdding services...\e[0m"
    ./helpers/services/add.sh
fi

# Join .gitignore files
(
    if [ -f "./helpers/git/merge-ignores.sh" ]; then
        echo -e "\e[33mMerging .gitignore files...\e[0m"
        ./helpers/git/merge-ignores.sh
    fi
) &
# Copy application scripts
(
    if [ -f "./helpers/services/copy-scripts.sh" ]; then
        echo -e "\e[33mCopying scripts to service...\e[0m"
        ./helpers/utils/copy-directory-files.sh "./to-app/*" "./$APP_NAME"
    fi
) &

wait

# Application versioning
if [ -f "./helpers/app/initialize-repository.sh" ]; then
    echo -e "\e[33mInitializing git repository...\e[0m"
    ./helpers/app/initialize-repository.sh
fi

echo -e "\e[32mApplication initialized successfully!\e[0m"
