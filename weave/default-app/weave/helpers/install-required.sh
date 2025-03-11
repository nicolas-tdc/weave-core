#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

if [ -f "./weave/helpers/utils/install-packages.sh" ]; then
    ./weave/helpers/utils/install-packages.sh \
        git \
        docker \
        docker-compose

fi
