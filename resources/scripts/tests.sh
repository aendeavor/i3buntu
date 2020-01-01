#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo "Hello, World!"

echo -e 'Installing Docker...' | ${WTL[@]}
$(readlink -m "${DIR}/../sys/docker/get_docker.sh") $DIR
