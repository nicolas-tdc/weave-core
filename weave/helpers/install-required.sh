#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

if [ -f "./weave/default-app/weave/helpers/utils/install-packages.sh" ]; then
    ./weave/default-app/weave/helpers/utils/install-packages.sh \
        git
fi
