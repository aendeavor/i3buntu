#!/usr/bin/env bash

# This script servers testing purposes and
# is not being used in actual scripts. 

# ? Info section

# * &>>"$DIR" === >>"$DIR" 2>&1

# ? Preconfig

set -e

## directory of this file - absolute & normalized
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

. "${DIR}/../sys/sh/.bash_aliases"

# ? Actual script

# Insert something to test here
function run_test() {
	
}

# ! Main

function main() {
	warn 'This is a test!'
	inform "Starting test\n"
	run_test
	echo ''
	inform 'Finished test'
}

main "$@" || exit 1
