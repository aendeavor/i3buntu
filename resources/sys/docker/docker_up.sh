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
BLU='\033[1;34m'    # BLUE
NC='\033[0m'        # NO COLOR

ERR="${RED}ERROR${NC}\t"
WAR="${YEL}WARNING${NC}\t"
SUC="${GRE}SUCCESS${NC}\t"
INF="${BLU}INFO${NC}\t"

# ? Checks

if [[ ! $(docker -v) =~ ^Docker\ version\ [1-9.]* ]]; then
    echo -e "\n${ERR}We could not locate docker on this system. Is it installed and in \$PATH?\n"
    exit 1
fi

# ? Actual script

cd $SCR

docker build -t i3buntu .

EC=$?
if (( $EC != 0 )); then
    echo -e "\n${ERR}The build process terminated with exit code $EC.\n"
    exit 1
fi
unset EC

docker run -i -d -t i3buntu

EC=$?
if (( $EC != 0 )); then
    echo -e "\n${ERR}tThe run process terminated with exit code $EC.\n"
    exit 1
fi

echo -e "\n${SUC}You can now connect to the container with docker attach."
