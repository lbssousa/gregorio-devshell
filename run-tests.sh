#!/usr/bin/env bash
# Run the full gregorio-test suite against ../gregorio inside the devshell.
cd "$(dirname "$0")/../gregorio-test" || exit 1
exec nix develop ../gregorio-devshell --command bash -c \
  'export PATH="$PWD/../gregorio/src:$PATH"; ./gregorio-test.sh -C "$@"; echo __DONE__' _ "$@"
