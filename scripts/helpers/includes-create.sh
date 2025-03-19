#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo -e "\e[32mLaunching application initialization...\e[0m"

# Source common configuration helpers
if [ -f "./scripts/helpers/config-common.sh" ]; then
    source ./scripts/helpers/config-common.sh
else
    echo -e "\e[31mCannot find 'common' configuration file! Exiting...\e[0m"
    exit 1
fi

# Source initial configuration helpers
if [ -f "./scripts/helpers/config-initial.sh" ]; then
    source ./scripts/helpers/config-initial.sh
else
    echo -e "\e[31mCannot find 'initial' configuration file! Exiting...\e[0m"
    exit 1
fi

# Source utilities helpers
if [ -f "./scripts/helpers/utils.sh" ]; then
    source ./scripts/helpers/utils.sh
else
    echo -e "\e[31mCannot find 'utilities' file! Exiting...\e[0m"
    exit 1
fi

# Source application utilities helpers
if [ -f "./default-app/weave/helpers/utils.sh" ]; then
    source ./default-app/weave/helpers/utils.sh
else
    echo -e "\e[31mCannot find default application utilities file! Exiting...\e[0m"
    exit 1
fi

# Source application git helpers
if [ -f "./default-app/weave/helpers/git.sh" ]; then
    source ./default-app/weave/helpers/git.sh
else
    echo -e "\e[31mCannot find default application git file! Exiting...\e[0m"
    exit 1
fi

# Source application services helpers
if [ -f "./default-app/weave/helpers/services.sh" ]; then
    source ./default-app/weave/helpers/services.sh
else
    echo -e "\e[31mCannot find default application 'services' file! Exiting...\e[0m"
    exit 1
fi
