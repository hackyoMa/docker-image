#!/bin/bash
set -euo pipefail

export NPM_CONFIG_CACHE="${HOME}/.npm/cache"
export NPM_CONFIG_PREFIX="${HOME}/.npm/prefix"
export PATH="${NPM_CONFIG_PREFIX}/bin:${PATH}"

user_name="${CONTAINER_USER_NAME}"
sudoers_file="/etc/sudoers.d/${user_name}_apt"

if [ ! -f "${sudoers_file}" ]; then
  echo "${user_name} ALL=(ALL) NOPASSWD: /usr/bin/apt, /usr/bin/apt-get" > "${sudoers_file}"
  chmod 440 "${sudoers_file}"
fi

exec "$@"
