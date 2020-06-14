SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

CC := cargo build
ABORTMSG := "Encountered critical non-zero exit code. Aborting."

all: build

build: Cargo.toml src/main.rs
	$(CC)

run: build
	cargo run

release: Cargo.toml src/main.rs
	@- ./make.sh --build || printf "\n%s\n" $(ABORTMSG)

publish: release
	@- ./make.sh --publish || printf "\n%s\n" $(ABORTMSG)

clean:
	cargo --clean
