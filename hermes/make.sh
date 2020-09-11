#!/bin/bash

# Called by CMAKE (Makefile) and CMAKE only.

# Builds Docker-container which provides the init script.
# Realized via ekidd/rust-musl-builder, which builds the
# binary and links statically against system libraries.

# https://github.com/emk/rust-musl-builder

function log()
{
  case $1 in
    1) # PHASE
      printf '%s PHASE {\n' "$2"
      ;;
    2) # STAGE
      printf '  (%s/%s) : %s\n' "$2" "$3" "$4"
      ;;
    3) # MSG SUCCESS
      printf '    \e[32m->\e[0m %s\n' "$2"
      ;;
    4) # MSG FAILURE
      printf '    \e[31m->\e[0m %s\n' "$2"
      ;;
    5) # PHASE SUCCESS
      printf '} \e[32m✓\e[0m\n'
      ;;
  esac
}

function check()
{
  true >.log
  if ! command -v docker &>/dev/null
  then
    printf 'Docker not in PATH or not installed.'
    exit 10
  fi

  if ! command -v cargo &>/dev/null
  then
    printf 'Cargo not in PATH or not installed.'
    exit 10
  fi
}

function build()
{
  local _tag=':nightly-2020-08-26'
  local rust_musl_builder
  rust_musl_builder="docker run --rm -it -v $(pwd):/home/rust/src ekidd/rust-musl-builder${_tag}"

  log 1 'BUILD'
  log 2 1 2 'RUST'
  log 3 "Using rust-musl-builder${_tag}"
  if ! $rust_musl_builder cargo build --release -q --color never &>.log
  then
    log 4 'Could not compile sources. Check logfile.'
    exit 100
  fi

  log 2 2 2 'DOCKER'
  if ! docker build -t andevour/hermes . >/dev/null 2>.log
  then
    log 4 'Could not build Docker image. Check logfile.'
    exit 101
  fi
  log 3 'Building tag is andevour/hermes'
  log 5
}

function publish()
{
  log 1 'PUBLISH'
  log 2 1 4 'LOGIN'
  printf '    \e[32m->\e[0m Password: '
  if ! docker login -u andevour >/dev/null 2>.log
  then
    printf '\e[31m✕\e[0m\n'
    log 4 'Login unsuccessful'
    exit 200
  fi
  printf '\e[32m✓\e[0m\n'

  log 2 2 4 'TAGGING'
  docker tag andevour/hermes andevour/hermes:latest &>/dev/null
  log 3 'Version tag is ":latest"'

  log 2 3 4 'PUSHING'
  if ! docker push andevour/hermes:latest >/dev/null 2>.log
  then
    log 4 'Push unsuccessful. Check logfile.'
    exit 201
  fi

  docker logout &>/dev/null
  log 2 4 4 'LOGOUT'
  log 5
}

function main()
{
  cd hermes || return 1

  case $1 in
    '--build')
      check
      build
      ;;
    '--publish') publish ;;
  esac
}

main "$@" || exit ${?}
