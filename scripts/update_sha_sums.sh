#! /bin/bash

: '
# ? version       v0.1.0 RC1 PRODUCTION STABLE
# ? executed by   just
# ? task          updates the SHA sums in INSTALL.md
'

# shellcheck source=./lib/errors.sh
. scripts/lib/errors.sh

export SCRIPT='SHA SUM ADJUSTMENT'

# -->                   -->                   --> START

(
  cd hermes

  sed -E -i \
    "s+SHA512\ \`.*\`+SHA512\ \`$(sha512sum init.sh)\`+g" \
    ../INSTALL.md
  
  sed -E -i \
    "s+SHA256\ \`.*\`+SHA256\ \`$(sha256sum init.sh)\`+g" \
    ../INSTALL.md
  
  sed -E -i \
    "s+SHA1\ \`.*\`+SHA1\ \`$(sha1sum init.sh)\`+g" \
    ../INSTALL.md

)
