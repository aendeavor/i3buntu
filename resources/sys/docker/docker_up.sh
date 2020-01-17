#!/usr/bin/env bash

# This script serves the purpose of
# creating and running a dedicated
# docker container.
#
# current version - 0.1.1 unstable

# ? Preconfig

## directory of this file - absolute & normalized
SCR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# initiate aliases and functions
. "${SCR}/../sh/.bash_aliases"

# ? Checks

if [[ -z $(which docker) ]]; then
    err "We could not locate docker on this system. Is it installed and in \$PATH?\n"
    exit 1
fi

# ? Actual script

cd $SCR

docker build -t i3buntu .

EC=$?
if (( $EC != 0 )); then
    err "The build process terminated with exit code $EC\n"
    exit 1
fi
unset EC

docker run -i -d -t i3buntu

EC=$?
if (( $EC != 0 )); then
    err "The run process terminated with exit code $EC.\n"
    exit 1
fi

succ 'You can now connect to the container with docker attach'
