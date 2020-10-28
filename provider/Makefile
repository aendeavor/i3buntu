SHELL = /bin/bash

.SHELLFLAGS := -eu -o pipefail -c

MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

# -->                   -->                   --> BUILD

release: Cargo.toml
	@ ./make.sh --build

publish: release
	@ ./make.sh --publish
