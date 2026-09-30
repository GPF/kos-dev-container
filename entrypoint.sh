#!/bin/bash
set -e

if [[ ! -f /opt/toolchains/dc/kos/environ.sh ]]; then
    echo "KOS source tree is missing. Mount or clone it at /opt/toolchains/dc/kos." >&2
    exit 1
fi

if [[ ! -f /opt/toolchains/dc/kos-ports/config.mk ]]; then
    echo "kos-ports source tree is missing. Mount or clone it at /opt/toolchains/dc/kos-ports." >&2
    exit 1
fi

source /opt/toolchains/dc/kos/environ.sh
exec "$@"
