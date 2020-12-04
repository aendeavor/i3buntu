#! /bin/bash

: '
# ? version       v0.1.0 RC1 PRODUCTION STABLE
# ? executed by   manually
# ? task          installs linting dependencies
'

# shellcheck source=./lib/errors.sh
. scripts/lib/errors.sh
# shellcheck source=./lib/logs.sh
. scripts/lib/logs.sh

export SCRIPT='DEPENDENCIES INSTALLER'

trap 'unset ECLINT_VERSION SHELLCHECK_VERSION' EXIT

# -->                   -->                   --> START

ECLINT_VERSION='2.2.0'
SHELLCHECK_VERSION='0.7.0-2build2'

sudo apt-get -qq --fix-missing update
sudo apt-get -qq -y --no-install-recommends install shellcheck=${SHELLCHECK_VERSION} wget

cd /tmp
wget -qq --no-check-certificate "https://github.com/editorconfig-checker/editorconfig-checker/releases/download/${ECLINT_VERSION}/ec-linux-amd64.tar.gz"
tar xf ec-linux-amd64.tar.gz && chmod +x bin/ec-linux-amd64 && sudo mv bin/ec-linux-amd64 /usr/bin/eclint
