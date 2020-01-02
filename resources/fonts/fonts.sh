#!/usr/bin/env bash

# This script serves as a wrapper for
# the installation of all fonts in the
# directory of this script.
# 
# current version - 0.2.0

# ? Preconfig

RED='\033[0;31m'    # RED
GRE='\033[1;32m'    # GREEN
YEL='\033[1;33m'    # YELLOW
BLU='\033[1;34m'    # BLUE
NC='\033[0m'        # NO COLOR

ERR="${RED}ERROR${NC}"
WAR="${YEL}WARNING${NC}"
SUC="${GRE}SUCCESS${NC}"
INF="${BLU}INFO${NC}"

# ? Preconfig finished
# ? Actual script begins

echo -e "${INF}FiraCode will be installed..."
./firacode.sh 
if (( $? == 0 )); then
    echo -e "${SUC}FiraCode successfully installed."
else
    echo -e "${ERR}FiraCode not successfully installed."
fi

echo -e "${INF}FontAwesome is next..."
./fontawesome.sh
if (( $? == 0 )); then
    echo -e "${SUC}FontAwesome successfully installed."
else
    echo -e "${ERR}FontAwesome not successfully installed."
fi

echo -e "${INF}Iosevka is next..."
./iosevkanerd.sh
if (( $? == 0 )); then
    echo -e "${SUC}Iosevka successfully installed."
else
    echo -e "${ERR}Iosevka not successfully installed."
fi

echo -e "${INF}Roboto Mono Nerd is next..."
./robotomononerd.sh
if (( $? == 0 )); then
    echo -e "${SUC}Roboto Mono Nerd successfully installed."
else
    echo -e "${ERR}Roboto Mono Nerd not successfully installed."
fi

echo -e "${INF}Fonts installed."

# ? Actual script finished
