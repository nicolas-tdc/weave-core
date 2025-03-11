#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

if [ -f "./default-app/helpers/utils/install-packages.sh" ]; then
    ./default-app/helpers/utils/install-packages.sh \
        git
fi
