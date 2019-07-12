#!/bin/bash

# ! 1.1 HANDLES REMOVAL OF PACKAGES

# ? Preconfig
##############################################################################################

ece=( sudo echo -e )

iFlags=(--yes --assume-yes --allow-unauthenticated --allow-downgrades --allow-remove-essential --allow-change-held-packages)
aptr=( sudo apt-get remove ${iFlags[@]})

##############################################################################################

${ece[@]} "Now removing unneccessary packages..."
${aptr[@]} ${iFlags[@]} plymouth
${ece[@]} "\n"
