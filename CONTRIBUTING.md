# Contributing

—— Version 1, 10 September 2020

1. [Ground Rules](#ground-rules)
   1. [Issues](#issues)
   2. [Pull Request Process](#pull-request-process)
2. [Git Flow](#git-flow)
3. [Coding Style](#coding-style)
   1. [General Style Guidelines](#general-styling-guidelines)
   2. [YAML](#yaml)
   3. [Bash](#bash)

## Ground Rules

### Issues

If there are **problems** or **enhancements** which require work for a prolonged period of time and collaboration with others, open an issue. Use one of the given templates appropriate to your specific case. This template will provide the structure necessary to ensure the needed information is provided.

### Pull Request Process

Before opening a Pull Request, make sure to have opened an issue which describes the matter beforehand. This is important for reviewers. Make sure to add the changes to [CHANGELOG](./CHANGELOG.md).

Increase the version numbers in all changed files and in [README.md](./README.md) to the new version that this Pull Request would represent. The versioning scheme we use is [SemVer][semver].

Pull Requests are given a concise name and follow this template:

``` MARKDOWN
# {TITLE}

## Type & Purpose

{Type: Enhancement / Fix}
{Describe the purpose of the Pull Request}

## Issued Fixed

{List the issues that are being fixed by this Pull Request}

## Changes

{List all changes}
```

## Git Flow

We use the default [Git-Flow Workflow][git_flow].

``` TXT
RELEASE                                 [v0.2.0] ...
                                            |
MASTER      [v0.1.0]---+ ...         - ...  |
                       |             |      |
DEVELOPMENT            ----+---+ ... |------|--- ...
                           |   |     |      |
FEATURE                    |   ------~      |
                           |                |
FEATURE                    -----------------~
                                 [v0.1.1]
```

## Coding Style

### General Styling Guidelines

When writing code, adhere to the style provided in this document and to what is already there, even if this is not your preferred style. When altering Markdown or other descriptive documents, look how it has been written and stay true to these design decisions.

Make sure your IDE uses the provided `.editorconfig`.

### YAML

When writing YAML, we format the code with the [Prettier][prettier]. Visual Studio Code has an extension for this formatter.

### Bash

#### Bash Overview

Use `bash` as the interpreter, not `sh`, `ksh`, `zsh` or any other interpreter. Therefore, dependent on the context, the shebang is either `#!/bin/bash` or `#!/usr/bin/env bash`.

We use [semantic versioning](https://semver.org/) - so do you.

We use `shellcheck` in version `v0.7.1` to test scripts. This is done during CI/CD too to enforce the use of this tool. Make sure to use `make shellcheck` to check for errors are styling guides.

#### Initial Description

When writing a script, provide the version and the script's task like so:

``` BASH
#!/usr/bin/env bash

# version  0.1.0
#
# <TASK DESCRIPTION> -> cut this off
# to make it not longer than approx.
# 60 cols.
```

#### If-Else-Statements

``` BASH
# the default if-else-style
# using double-braces
if [[ <CONDITION1> ]]
then
  <CODE TO RUN>
# or when using a command,
# omit the braces
elif ! <COMMAND>
  <CODE TO TUN>
else
  <CODE TO RUN>
fi

# remember you do not need ""
# when using [[ ]]
if [[ -f $FILE ]] # is fine
then
  <CODE TO RUN>
fi

# when comparing numbers, use
# -eq/-ne/-lt/-ge, not != or ==
if [[ $VAR -ne <NUMBER> ]]
then
  <CODE TO RUN>
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

#### Loops

Like `if-else`, loops look like this

``` BASH
for / while <LOOP CONDITION>
do
  <CODE TO RUN>
done

while read -r
do
  <CODE TO EXECUTE>
done < INPUT
```

#### Functions

It's always nice to see the use of functions. Not only as it's more C-style, but it also provides a clear structure. If scripts are small, this is unnecessary, but if they become larger, please consider using functions. When doing so, provide `function _main()`. When using functions, they are **always** at the top of the script!

``` BASH
function _<name_underscored_and_lowercase>()
{
  <CODE TO RUN>

  # variables that can be local should be local
  local _<LOCAL_VARIABLE_NAME>
}
```

#### Error Tracing

A construct to trace error in your scripts looks like this: Please use it like this (copy-paste) to make errors streamlined. Remember: Remove `set -x` in the end. This of debugging purposes only.

``` BASH
set -euxEo pipefail
trap '_report_err $_ $LINENO $?' ERR

function _report_err()
{
  echo "ERROR occurred :: source (hint) $1 ; line $2 ; exit code $3 ;;" >&2
  
  <CODE TO RUN AFTERWARDS>
}
```

#### Comments and Descriptiveness

Comments should be kept minimal and only describe non-obvious matters, i.e. not what the code does. Comments should start lowercase as most of them are not sentences. Make the code **self-descriptive** by using meaningful names! Make comments not longer than approximately 60 columns, then wrap the line.

A positive example:

``` BASH
# writes result to stdout
function _add_one()
{
  echo $(( $1 + 1 ))
}
```

A negative example:

``` BASH
# adds one to the first argument
# and print it to stdout
function _add_one()
{
  # save the first variable
  local FIRST=$1

  # add one here
  local RESULT=$(( _FIRST + 1 ))

  # print it to stdout
  echo "$_RESULT"
}
```

#### Arrays

Do not create arrays with non-robust methods. Use `mapfile` or (preferably) `read`.

``` BASH
declare -a ARRAY
IFS='DELIMITER' ; read -r -a ARRAY < <(COMMAND INPUT)
unset IFS
```

[//]: # (Links)

[git_flow]: https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow
[prettier]: https://prettier.io/
