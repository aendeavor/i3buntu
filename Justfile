set shell := [ "bash", "-eu", "-o", "pipefail", "-c" ]

export CDIR    := `realpath -e -L .`
CC             := 'cargo'

# -->                   -->                   --> DEFAULT

DEFAULT: build

builda: nightly build_library build_app

build_library:
  {{CC}} build -p library

build_app:
  {{CC}} build -p app

build package='app':
  {{CC}} build -p {{package}}

# -->                   -->                   --> CODE

nightly:
  @ rustup override set nightly

alias fmt := format
format:
	@ {{CC}} fmt

clean:
	-@ {{CC}} clean

release: nightly
  {{CC}} build --release -p library
  {{CC}} build --release -p app
  @ cp ./target/release/app i3buntu
  @ chmod +x i3buntu

# -->                   -->                   --> MISC

update_sha:
  @ scripts/update_sha_sums.sh

# -->                   -->                   --> TESTS

lint:
  @ make lint

shellcheck:
  @ make shellcheck

eclint:
  @ make eclint
