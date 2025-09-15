#!/bin/bash

if [ "$(id -u)" = "0" ]; then
  USER_ID=${PUID:-1000}
  GROUP_ID=${PGID:-1000}
  WORKDIR="${WORKDIR:-$(pwd)}"

  if ! getent group "${GROUP_ID}" >/dev/null; then
    GROUP_NAME="dynamic_group_${GROUP_ID}"
    groupadd -g "${GROUP_ID}" "${GROUP_NAME}"
  else
    GROUP_NAME=$(getent group "${GROUP_ID}" | cut -d: -f1)
  fi

  if ! USER_NAME=$(id -un "${USER_ID}" 2>/dev/null); then
    USER_NAME="dynamic_user_${USER_ID}"
    useradd -l -u "${USER_ID}" -g "${GROUP_ID}" "${USER_NAME}"
  fi

  if ! id -nG "${USER_NAME}" | grep -qw "${GROUP_NAME}"; then
    usermod -aG "${GROUP_NAME}" "${USER_NAME}"
  fi

  chmod -R a+rwX "${WORKDIR}"

  exec gosu "${USER_ID}:${GROUP_ID}" "$@"
else
  exec "$@"
fi
