# Top-Most Makefile in /

# ? ––––––––––––––––––––––––––––––––––––––––––––– VARs

SHELL = /bin/bash

.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

CC := cargo

export

# ? ––––––––––––––––––––––––––––––––––––––––––––– Default

all: nightly
	$(MAKE) -C athena
	$(MAKE) -C kyrene

nightly:
	@ rustup override set nightly

format:
	-@ cargo fmt


shellcheck:
	@ echo -e '#\n## STARTING SHELLCHECK TEST\n#\n'
	@ shellcheck --version
	@ echo ''
	@ if find -iname "*.sh" -exec shellcheck -S style -Cauto -o all -e SC2154 -W 50 {} \; | grep .; then\
		echo -e "\nError" ;\
		exit 1 ;\
	else\
		echo -e '\nSuccess' ;\
	fi

# ? ––––––––––––––––––––––––––––––––––––––––––––– Release

.PHONY: release

release: nightly
	cargo build --release -p athena
	cargo build --release -p kyrene
	@ cp ./target/release/kyrene apollo
	@ chmod +x apollo

# ? ––––––––––––––––––––––––––––––––––––––––––––– Non-Release

.PHONY: clean

clean:
	-@ cargo clean

SUBDIRS = kyrene athena
.PHONY: nr $(SUBDIRS)

nr: $(SUBDIRS)
	./target/debug/kyrene

$(SUBDIRS):
	$(MAKE) -C $@

kyrene: athena

# ? ––––––––––––––––––––––––––––––––––––––––––––– Install

install: ./apollo
	-@ ./apollo

# ? ––––––––––––––––––––––––––––––––––––––––––––– Includes

include athena/Makefile
include hermes/Makefile
include kyrene/Makefile

# ? ––––––––––––––––––––––––––––––––––––––––––––– Notes

# A prepended "@" will result in not displaying the
# build rules. A prepended "-" will result in ignoring
# the exit code of a command. If no target is specified,
# the first one that is encountered will be build.
#
# GUIDES
# https://devhints.io/makefile
# https://tech.davis-hansson.com/p/make/
#
# https://www.gnu.org/software/make/manual/html_node/Recursion.html
# https://www.gnu.org/software/make/manual/html_node/Phony-Targets.html#Phony-Targets
