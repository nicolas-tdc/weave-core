#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo -e "\e[32mInstall application\e[0m"

# Setup local environment
if [ -f "./helpers/app/install-required.sh" ]; then
    echo -e "\e[33mSetting up local environment...\e[0m"
    source ./helpers/app/install-required.sh
fi

# Setup app environment
if [ -f "./helpers/app/read-env.sh" ]; then
    echo -e "\e[33mSetting up app environment...\e[0m"
    source ./helpers/app/read-env.sh
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
if [ -f "./helpers/git/merge-ignores.sh" ]; then
    echo -e "\e[33mMerging .gitignore files...\e[0m"
    ./helpers/git/merge-ignores.sh
fi

# Application versioning
if [ -f "./helpers/app/init-repo.sh" ]; then
    echo -e "\e[33mApplication versioning...\e[0m"
    ./helpers/app/init-repo.sh
fi

echo -e "\e[32mApplication initialized successfully!\e[0m"
