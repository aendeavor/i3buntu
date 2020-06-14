SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

BIN := kyrene
KPATH=kyrene
CC := cargo
ABORTMSG := "Encountered critical non-zero exit code. Aborting."

all: test

build: kyrene/Cargo.toml kyrene/src/main.rs
	cd $(KPATH)
	$(CC) build

doc:
	cd $(KPATH)
	$(CC) doc --open &

check:
	cd $(KPATH)
	$(CC) check

release: kyrene/Cargo.toml kyrene/src/main.rs
	@ cd $(KPATH)
	@ $(CC) build --release -q
	@ cp -f target/release/$(BIN) $(KPATH)

test: build
	./$(KPATH)/target/debug/$(BIN)

install: kyrene/kyrene
	@- sudo -E ./$(KPATH)/$(BIN) || printf "\n%s\n" $(ABORTMSG)

clean:
	cd kyrene
	cargo --clean

# NOTES
# A prepended "@" will result in not
# displaying what the build rules do.
# A prepended "-" will result in ig-
# noring the exit code of a command.
#
# GUIDES
# https://devhints.io/makefile
# https://tech.davis-hansson.com/p/make/
