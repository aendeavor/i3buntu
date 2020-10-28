SHELL = /bin/bash

.SHELLFLAGS := -eu -o pipefail -c

MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

# -->                   -->                   --> BUILD

release: Cargo.toml
	@ ./make.sh --build

hpublish: hrelease
	@ ./make.sh --publish
