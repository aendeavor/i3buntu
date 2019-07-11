#!/bin/bash

# ! 1.1 HANDLES REMOVAL OF PACKAGES

# ? Preconfig
##############################################################################################

ece=( sudo echo -e )

iFlags=(--yes --assume-yes --allow-unauthenticated --allow-downgrades --allow-remove-essential --allow-change-held-packages)
apti=( sudo apt-get install ${iFlags[@]})

##############################################################################################

${ece[@]} "Start by removing packages..."
sudo apt-get remove ${iFlags[@]}) plymouth
${ece[@]} "\n"
