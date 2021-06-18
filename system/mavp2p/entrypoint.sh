#!/bin/sh
set -e

# If first argument has a leading '-' or if it's not a command
if [ "${1#-}" != "${1}" ] || [ -z "$(command -v "${1}")" ]; then
  set -- mavp2p "$@"
fi

exec "$@"