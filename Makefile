SHELL = /bin/bash

.SHELLFLAGS := -eu -o pipefail -c

MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

# -->                   -->                   --> TESTS

lint: eclint shellcheck

eclint:
	@ ./tests/eclint.sh

shellcheck:
	@ ./tests/shellcheck.sh

# -->                   -->                   --> INSTALLATION

install: ./apollo
	-@ ./apollo
