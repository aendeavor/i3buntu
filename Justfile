set shell := [ "bash", "-eu", "-o", "pipefail", "-c" ]

export CDIR    := `realpath -e -L .`
CC             := 'cargo'

# -->                   -->                   --> DEFAULT

DEFAULT: build

build_library:
	{{CC}} build -p library

build_app:
	{{CC}} build -p app

build package='app':
	{{CC}} build -p {{package}}

# -->                   -->                   --> CODE

nightly:
	@ rustup override set nightly-2020-11-09

alias fmt := format
format:
	@ {{CC}} fmt

clean:
	-@ {{CC}} clean

release: nightly build_library build_app
	@ cp ./target/release/app i3buntu
	@ chmod +x i3buntu

alias ci := test
test: nightly
	cargo clippy --all-targets --all-features -- -D warnings
	cargo fmt -- --check
	cargo test

# -->                   -->                   --> MISC

update_sha:
	@ scripts/update_sha_sums.sh

# -->                   -->                   --> TESTS

lint: eclint shellcheck

shellcheck:
	@ ./scripts/lints/shellcheck.sh

eclint:
	@ ./scripts/lints/eclint.sh
