#!/bin/bash
set -euo pipefail

export NPM_CONFIG_CACHE="${HOME}/.npm/cache"
export NPM_CONFIG_PREFIX="${HOME}/.npm/prefix"

npm config set cache "${NPM_CONFIG_CACHE}"
npm config set prefix "${NPM_CONFIG_PREFIX}"

export PATH="${NPM_CONFIG_PREFIX}/bin:${PATH}"
