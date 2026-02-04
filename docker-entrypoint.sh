#!/bin/bash

if [ "$(id -u)" = "0" ]; then
  GROUP_ID=${PGID:-9999}
  USER_ID=${PUID:-9999}

  GROUP_INFO=$(getent group "${GROUP_ID}" || true)
  if [ -z "${GROUP_INFO}" ]; then
    GROUP_NAME="dynamic_group_${GROUP_ID}"
    groupadd -g "${GROUP_ID}" "${GROUP_NAME}"
  else
    GROUP_NAME="${GROUP_INFO%%:*}"
  fi

  USER_INFO=$(getent passwd "${USER_ID}" || true)
  if [ -z "${USER_INFO}" ]; then
    USER_NAME="dynamic_user_${USER_ID}"
    useradd -m -u "${USER_ID}" -g "${GROUP_ID}" "${USER_NAME}"
  else
    USER_NAME="${USER_INFO%%:*}"
  fi

  if ! id -nG "${USER_NAME}" | grep -qw "${GROUP_NAME}"; then
    usermod -aG "${GROUP_NAME}" "${USER_NAME}"
  fi

  exec gosu "${USER_NAME}" "$@"
else
  USER_HOME="/home/$(whoami)"
  if [ ! -d "${USER_HOME}" ]; then
    mkdir -p "${USER_HOME}"
  fi
  export HOME="${USER_HOME}"
  exec "$@"
fi
