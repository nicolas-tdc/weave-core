#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

if [ -f "./helpers/utils/install-packages.sh" ]; then
    ./helpers/utils/install-packages.sh \
        git \
        docker \
        docker-compose

fi
