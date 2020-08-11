# Top-Most Makefile in /

# ? ––––––––––––––––––––––––––––––––––––––––––––– VARs

SHELL = /bin/bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

CC := cargo

export

# ? ––––––––––––––––––––––––––––––––––––––––––––– Default

all:
	$(MAKE) -C athena
	$(MAKE) -C kyrene

# ? ––––––––––––––––––––––––––––––––––––––––––––– Release

.PHONY: release

release:
	rustup override set nightly
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
