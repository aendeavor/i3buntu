#!/usr/bin/env bash

# This script serves the purpose of
# creating and running a dedicated
# docker container.
#
# current version - 0.0.1

# ? Preconfig

## directory of this file - absolute & normalized
SCR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

RED='\033[0;31m'    # RED
GRE='\033[1;32m'    # GREEN
YEL='\033[1;33m'    # YELLOW
NC='\033[0m'        # NO COLOR

# ? Checks

if [[ ! $(docker -v) =~ ^Docker\ version\ [1-9.]* ]]; then
    echo -e "${RED}ERROR${NC}\tDocker seems to be not installed on this system."
    exit 1
fi

# ? Actual script

cd $(readlink -m "${SCR}/../../")

docker build -t i3buntu .

EC=$?
if (( $EC != 0 )); then
    echo -e "${RED}ERROR${NC}\tThe build process terminated with exit code $EC."
fi
unset EC

docker run -i -d -t i3buntu

EC=$?
if (( $EC != 0 )); then
    echo -e "${RED}ERROR${NC}\tThe run process terminated with exit code $EC."
fi

echo -e "${GRE}SUCCESS${NC}\tYou can now connect to the container with\n --->\tdocker attach i3buntu"
