#!/usr/bin/env bash

# ? Preconfig

## directory of this file - absolute & normalized
SCR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

RED='\033[0;31m'    # RED
GRE='\033[1;32m'    # GREEN
YEL='\033[1;33m'    # YELLOW
NC='\033[0m'        # NO COLOR

ERR="${RED}ERROR${NC}"
WAR="${YEL}WARNING${NC}"
SUC="${GRE}SUCCESS${NC}"

echo -e "${WAR}${SUC}"