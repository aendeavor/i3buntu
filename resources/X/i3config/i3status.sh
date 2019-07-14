#!/bin/sh
# a helper script for the conky replacement for i3status
# taken for the i3 user guide

# change this directory to where you have cloned the repo
scripts="/home/$USER/.i3/i3status-conky"

# Send the header so that i3bar knows we want to use JSON:
echo '{"version":1}'

# Begin the endless array.
echo '['

# We send an empty first array of blocks to make the loop simpler:
echo '[],'

# Now send blocks with information forever:
exec conky -c "/home/jakob/.i3/conkystatus"
