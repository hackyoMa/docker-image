#!/bin/bash
set -euo pipefail

export NPM_CONFIG_CACHE="${HOME}/.npm/cache"
export NPM_CONFIG_PREFIX="${HOME}/.npm/prefix"
export PATH="${NPM_CONFIG_PREFIX}/bin:${PATH}"

exec "$@"
