#! /bin/bash

: '
# ? version       v0.2.0 RC1 BETA1 UNSTABLE
# ? executed by   just
# ? task          updates all SHA sums in .env
'

# shellcheck source=./lib/errors.sh
. scripts/lib/errors.sh

trap 'unset GREP_CMD SHA1SUM SHA256SUM SHA512SUM' EXIT

export SCRIPT='SHA SUM ADJUSTMENT'

# -->                   -->                   --> START

GREP_CMD=(grep -a -m 1 -h -o -E "[0-9a-zA-Z]+")

SHA1SUM="$(sha1sum scripts/init.sh | "${GREP_CMD[@]}" | head -1)"
SHA256SUM="$(sha256sum scripts/init.sh | "${GREP_CMD[@]}" | head -1)"
SHA512SUM="$(sha512sum scripts/init.sh | "${GREP_CMD[@]}" | head -1)"

sed -E -i "s+SHA1=.*+SHA1=${SHA1SUM}+g" .env
sed -E -i "s/SHA256=.*/SHA256=${SHA256SUM}/g" .env
sed -E -i "s+SHA512=.*+SHA512=${SHA512SUM}+g" .env
