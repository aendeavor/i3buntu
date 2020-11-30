#! /bin/bash

: '
# ? version       v0.3.0 RC1 PRODUCTION STABLE
# ? executed by   just
# ? task          updates SHA sums in .env
'

# shellcheck source=./lib/errors.sh
. scripts/lib/errors.sh

trap 'unset FILE' EXIT

export SCRIPT='SHA SUM ADJUSTMENT'

# -->                   -->                   --> START

FILE="$(scripts/init.sh '--sha')"

sed -E -i "s+SHA1=.*+SHA1='$(sed '1q;d' <<< "${FILE}")'+g" .env
sed -E -i "s+SHA256=.*+SHA256='$(sed '2q;d' <<< "${FILE}")'+g" .env
sed -E -i "s+SHA512=.*+SHA512='$(sed '3q;d' <<< "${FILE}")'+g" .env
