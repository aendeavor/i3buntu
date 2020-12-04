SHELL = /bin/bash

.SHELLFLAGS := -eu -o pipefail -c

MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

# -->                   -->                   --> INSTALLATION

install: ./i3buntu
	-@ ./i3buntu
