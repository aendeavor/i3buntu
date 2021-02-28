SHELL = /bin/bash

.SHELLFLAGS = -eu -o pipefail -c

MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

SHELLCHECK_VERSION = 0.7.1
ECLINT_VERSION     = 2.3.3

export CDIR = $(shell pwd)

# -->                   -->                   --> INSTALLATION

install: ./i3buntu
	-@ ./i3buntu

# -->                   -->                   --> LINTING

lint: eclint shellcheck

shellcheck:
	@ ./scripts/lints/shellcheck.sh

eclint:
	@ ./scripts/lints/eclint.sh

install-linters:
	@ mkdir -p tools
	@ curl -ksSL \
		"https://github.com/koalaman/shellcheck/releases/download/v$(SHELLCHECK_VERSION)/shellcheck-v$(SHELLCHECK_VERSION).linux.x86_64.tar.xz" | tar -Jx shellcheck-v$(SHELLCHECK_VERSION)/shellcheck -O > tools/shellcheck
	@ curl -ksSL \
		"https://github.com/editorconfig-checker/editorconfig-checker/releases/download/$(ECLINT_VERSION)/ec-linux-amd64.tar.gz" | tar -zx bin/ec-linux-amd64 -O > tools/eclint
	@ chmod u+rx tools/shellcheck tools/eclint
