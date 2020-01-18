#!/usr/bin/env bash

# This script servers testing purposes and
# is not being used in actual scripts. 

# ? Info section

# * &>>"$DIR" === >>"$DIR" 2>&1

# ? Preconfig

## directory of this file - absolute & normalized
SCR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

. "${SCR}/../sys/sh/.bash_aliases"

warn 'This is a test!'

succ "TEST"
inform "TEST"
err "TEST"
