# Contributing

—— Version 2, 28 October 2020

## General

This document provides the guide on how to develop in this repository. There are tools required for proper development. These include

- [`make`][make::wikipedia] via `sudo apt-get -y install make`
- [`python3`][python3::wikipedia] and `pip` via `sudo apt-get -y install python3 python3-pip`
- [`mkdocs`][mkdocs::main] and [`mkdocs-material`][mkdocs_material::main] via `pip3 install mkdocs mkdocs-material`
- [`cargo`][cargo::github] and [`rustup`][rustup::github] via [curl][rustup::installation]
- [`just`][just::github] via `cargo install just`

If you like, you can optionally include the following tools into your workflow:

- [`delta`][delta::github] via `cargo install delta`

[make::wikipedia]: https://en.wikipedia.org/wiki/Make_(software)
[python3::wikipedia]: https://en.wikipedia.org/wiki/Python_(programming_language)
[mkdocs::main]: https://www.mkdocs.org/
[mkdocs_material::main]: https://squidfunk.github.io/mkdocs-material/
[cargo::github]: https://github.com/rust-lang/cargo
[rustup::github]: https://github.com/rust-lang/rustup
[rustup::installation]: https://rustup.rs/
[just::github]: https://github.com/casey/just

[delta::github]: https://github.com/dandavison/delta

!!! important "Working with this Documentation"
    If you'd like to alter this documentation, edit the Markdown files located under `documentation/docs/`. The current state is served on <http://127.0.0.1:8080> with `just docs`. This documentation is packed in a _Docker_ container.

## Git

### General Information

Make sure to adhere to the [GitFlow Workflow][gitflow_worklow]. We use [Semantic Versioning][semantic_versioning]. Pushes to this repository are to be done via `ssh`, commits **must** be signed. We require a linear commit history on protected branches.

[gitflow_worklow]: https://www.atlassian.com/de/git/tutorials/comparing-workflows/gitflow-workflow
[semantic_versioning]: https://semver.org/

The following labels must exists to tag issues and merge requests

| Label             | Description                            | Look                                | Color   |
| :---:             | :---------:                            | :--:                                | :---:   |
| `core`            | concerning core components             | ![core][core]                       | #101010 |
| `uncore`          | concerning components outside the core | ![uncore][uncore]                   | #DDDDDD |
| `bug`             | related to a bug                       | ![bug][bug]                         | #FBB444 |
| `roadmap`         | outlines future plans                  | ![roadmap][roadmap]                 | #F28F3B |
| `conflict`        | related to a conflict of any nature    | ![conflict][conflict]               | #EE2E31 |
| `feature request` | introduces a new feature               | ![feature request][feature request] | #A30B37 |
| `wip`             | work in progress                       | ![wip][wip]                         | #2E2947 |
| `documentation`   | concerning the documentation           | ![documentation][documentation]     | #3C91E6 |
| `enhancement`     | enhances existing features             | ![enhancement][enhancement]         | #99C24D |
| `update`          | updates an existing feature            | ![update][update]                   | #297045 |
| `high priority`   | issue / merge of high priority         | ![priority1][high priority]         | #FF0000 |
| `medium priority` | issue / merge of medium priority       | ![priority2][medium priority]       | #FFFF00 |
| `low priority`    | issue / merge of low priority          | ![priority3][low priority]          | #81F445 |

[core]: https://img.shields.io/badge/core-101010
[uncore]: https://img.shields.io/badge/uncore-DDDDDD
[bug]: https://img.shields.io/badge/bug-FBB444
[roadmap]: https://img.shields.io/badge/roadmap-F28F3B
[conflict]: https://img.shields.io/badge/conflict-EE2E31
[feature request]: https://img.shields.io/badge/feature_request-A30B37
[wip]: https://img.shields.io/badge/wip-2E2947
[documentation]: https://img.shields.io/badge/documentation-3C91E6
[enhancement]: https://img.shields.io/badge/enhancement-99C24D
[update]: https://img.shields.io/badge/update-297045

[high priority]: https://img.shields.io/badge/high_priority-FF0000
[medium priority]: https://img.shields.io/badge/medium_priority-FFFF00
[low priority]: https://img.shields.io/badge/low_priority-81F445

Furthermore, issue and merge request templates are located under `#!bash ${REPOSITORY ROOT}/.gitlab/` and must be used when opening an issue or merge request.

## IDEs

The main IDE used for development is [_Visual Studio Code_][visual_studio_code]. For some tasks, [_NeoVim_][neovim] is used too.

### Extensions

#### Visual Studio Code

All VS Code extensions can be installed on the command line with:

``` BASH
EXTENSIONS=(
  "2gua.rainbow-brackets"
  "aaron-bond.better-comments"
  "azemoh.one-monokai"
  "bierner.markdown-preview-github-styles"
  "DavidAnson.vscode-markdownlint"
  "dustypomerleau.rust-syntax"
  "editorconfig.editorconfig"
  "esbenp.prettier-vscode"
  "mads-hartmann.bash-ide-vscode"
  "matklad.rust-analyzer"
  "ms-kubernetes-tools.vscode-kubernetes-tools"
  "ms-python.python"
  "ms-vscode-remote.remote-ssh"
  "ms-vscode-remote.remote-ssh-edit"
  "ms-vscode.cpptools"
  "PKief.material-icon-theme"
  "redhat.vscode-xml"
  "redhat.vscode-yaml"
  "shd101wyy.markdown-preview-enhanced"
  "streetsidesoftware.code-spell-checker"
  "streetsidesoftware.code-spell-checker-german"
  "timonwong.shellcheck"
  "VisualStudioExptTeam.vscodeintellicode"
  "yzhang.markdown-all-in-one"
  "zhuangtongfa.Material-theme"
)

for EXTENSION in ${EXTENSIONS[@]}
do
  code --install-extension "${EXTENSION}"
done

```

#### NeoVim

VimPlug should be enabled and contain the following plugins:

``` VIM
Plug 'scrooloose/nerdtree'     " File explorer
Plug 'itchyny/lightline.vim'   " Status line
Plug 'ctrlpvim/ctrlp.vim'      " Full path finder
Plug 'Raimondi/delimitMate'    " Automatic closing of parenthesis
Plug 'tpope/vim-markdown'      " Markdown language extension
Plug 'vim-syntastic/syntastic' " Syntax check
Plug 'rust-lang/rust.vim'      " Rust language support
Plug 'luochen1990/rainbow'     " Rainbow brackets
Plug 'Valloric/YouCompleteMe'  " Autocompletion
Plug 'morhetz/gruvbox'         " Themes
Plug 'ryanoasis/vim-devicons'  " Icon theme
```

[visual_studio_code]: https://code.visualstudio.com/
[neovim]: https://neovim.io/

## Coding Style

### General Styling Guidelines

When writing code, adhere to the style provided in this document and to what is already there, even if this is not your preferred style. When altering Markdown or other descriptive documents, look how it has been written and stay true to these design decisions.

Make sure your IDE uses the provided `.editorconfig`.

### Rust

Rust if formatted with `cargo fmt` (or `rustfmt`). These commands are properly invoked via `just fmt`. The style definition is found in `.rustfmt.toml`. Make sure to adjust your style to the already present style.

### YAML

When writing YAML, code is formatted with [Prettier][prettier]. [_Visual Studio Code_][visual_studio_code] has an extension for this formatter. YAML files in a directory are **sorted** by prepending them a number which indicates priority, much like configuration files / systemd - i.e. files with lower number will take priority and will be executed first.

### Bash

#### Overview

Almost all scripts are located under `#!bash scripts/`. Use Bash as the interpreter, i.e. `bash` and not `sh`, `ksh`, `zsh` or any other interpreter. Therefore, dependent on the context, the shebang is either `#!/bin/bash` or `#!/usr/bin/env bash`. It's **mandatory** to use Bash in version 5 and above. We use `shellcheck` in version `v0.7.1` to test scripts. This is done during CI/CD too to enforce the use of this tool. Make sure to use `just shellcheck` to check for errors are styling guides.

#### Initial Description

When writing a script, the first part of scripts is uniform. The following snippet is taken from the `#!bash init.sh` script. **Always** provide version, executor or sourcing script as well as the task. Afterwards, imports are handled. Thereafter, `#!bash set`'s are executed followed by the definition of the `#!bash SCRIPT` variable, a variable every script has (which enabled logging functionality). 

``` BASH hl_lines="4 5 6"
#! /bin/bash

: '
# ? version       v0.1.0 RC1 ALPHA1 UNSTABLE
# ? executed by   just
# ? task          handles init jobs
'

# shellcheck source=./lib/errors.sh
. scripts/lib/errors.sh
# shellcheck source=./lib/logs.sh
. scripts/lib/logs.sh

SCRIPT='INIT'

# -->                   -->                   --> START
```

#### If Else Statements

``` BASH
# the default if-else-style using double-braces
# remember you do not need "" when using [[ ]]
if [[ <CONDITION> ]] && [[ -f $FILE ]]
then
  <CODE TO RUN>
# when using a command, omit the braces
# when comparing numbers, use -eq/-ne/-lt/-ge, not != or ==
elif ! <COMMAND> || [[ $VAR -ne <NUMBER> ]]
then
  <CODE TO TUN>
fi
```

#### Variables & Braces

Variables are always uppercase and consist of only alphanumeric symbols. Do not precede a variable an underline. We always use braces. If you forgot this and want to change it later, you can use [this link](https://regex101.com/r/ikzJpF/4), which points to <https://regex101.com>. The used regex is `\$([^{("\\'\/])([a-zA-Z0-9_]*)([^}\/ \t'"\n.\]:]*)`, where you should in practice be able to replace all variable occurrences without braces with occurrences with braces.

``` BASH
# good
local VAR="good"
local NEW_VAR="${VAR}"

# bad
var="bad"
```

#### Loops & Switch Statements

Like `#!bash if else`, loops look like this

``` BASH
for / while <LOOP CONDITION>
do
  <CODE TO RUN>
done
```

Make sure to be aware of the `#!bash while read -r VAR; do ...; done < <(INPUT)` construction. This is idiomatic Bash and mandatory.

``` BASH

# an overengineered solution to allow shellcheck -x to
# properly follow `source=<SOURCE FILE>` when sourcing
# files with `. <FILE>` in shell scripts.
while read -r FILE
do
  if ! (
    cd "$(realpath "$(dirname "$(readlink -f "${FILE}")")")"
    "${LINT[@]}" "$(basename -- "${FILE}")")
  then
    ERR=1
  fi
done < <(find . -type f -iname "*.sh")
```

For `#!bash case ${VAR} in` statements

``` BASH
case ${VAR} in
  'case1' ) __on_the_same_line ;;
  'case2' ) __stay_frosty      ;;
  'case3' )
    __now_there_is_more_to_do
    printf 'Multi lines are done this way'
    ;;
  
  'case 4' )
    __now_there_is_even_more_to_do
    printf "That's the way it is"
    ;;

esac
```

#### Functions

When using functions, they are used this way. Please use `#!bash function _main` to start the script as this provides a clear starting point.

``` BASH
function _<name_underscored_and_lowercase>
{
  <CODE TO RUN>

  # variables that can be local should be local
  local <LOCAL_VARIABLE_NAME>
}
```

#### Error Tracing

A construct to trace error in your scripts looks like this. Remember: Remove `#!bash set -x` in the end - this is for debugging purposes only.

``` BASH
set -euxEo pipefail
trap '__log_err ${FUNCNAME[0]:-"?"} ${_:-"?"} ${LINENO:-"?"} ${?:-"?"}' ERR

function __log_err
{
  local FUNC_NAME LINE EXIT_CODE
  FUNC_NAME="${1} / ${2}"
  LINE="${3}"
  EXIT_CODE="${4}"

  printf "\n––– \e[1m\e[31mUNCHECKED ERROR\e[0m\n%s\n%s\n%s\n%s\n\n" \
    "  – script    = ${SCRIPT,,}.sh" \
    "  – function  = ${FUNC_NAME}" \
    "  – line      = ${LINE}" \
    "  – exit code = ${EXIT_CODE}"

  <CODE TO RUN AFTERWARDS>
}
```

#### Arrays

Do not create arrays with non-robust methods. Use `#!bash read` or `#!bash mapfile`.

``` BASH
declare -a ARRAY
IFS='DELIMITER' ; read -r -a ARRAY < <(COMMAND INPUT)
unset IFS
```

#### Comments and Descriptiveness

Comments should be kept minimal and only describe non-obvious matters, i.e. not what the code does. Comments should start lowercase as most of them are not sentences. Make the code **self-descriptive** by using meaningful names! Make comments not longer than 75 columns, then wrap the line.

[prettier]: https://prettier.io/
