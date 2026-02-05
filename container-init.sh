#!/bin/bash
set -euo pipefail

create_group_if_needed() {
  local group_id="${1}"
  local group_info=$(getent group "${group_id}" || true)

  if [ -z "${group_info}" ]; then
    local group_name="dynamic_group_${group_id}"
    groupadd -g "${group_id}" "${group_name}"
    echo "${group_name}"
  else
    echo "${group_info%%:*}"
  fi
}

create_user_if_needed() {
  local group_id="${1}"
  local user_id="${2}"
  local user_info=$(getent passwd "${user_id}" || true)

  if [ -z "${user_info}" ]; then
    local user_name="dynamic_user_${user_id}"
    useradd -m -u "${user_id}" -g "${group_id}" "${user_name}"
    echo "${user_name}"
  else
    echo "${user_info%%:*}"
  fi
}

get_home_dir() {
  local user_id="${1}"
  local user_name="${2}"
  local user_info=$(getent passwd "${user_id}" || true)
  local home_dir=$(echo "${user_info}" | cut -d: -f6)
  echo "${home_dir:-/home/${user_name}}"
}

main() {
  local cmd

  if [ "$(id -u)" -eq 0 ]; then
    local group_id="${PGID:-9999}"
    local user_id="${PUID:-9999}"

    local group_name=$(create_group_if_needed "${group_id}")
    local user_name=$(create_user_if_needed "${group_id}" "${user_id}")
    export HOME=$(get_home_dir "${user_id}" "${user_name}")

    if ! id -nG "${user_name}" | grep -qw "${group_name}"; then
      usermod -aG "${group_name}" "${user_name}"
    fi

    cmd=(gosu "${user_name}" "$@")
  else
    export HOME=$(get_home_dir "$(id -u)" "$(whoami)")
    cmd=("$@")
  fi

  if [ -n "${SUB_CONTAINER_INIT:-}" ] && [ -x "${SUB_CONTAINER_INIT}" ]; then
    exec "${SUB_CONTAINER_INIT}" "${cmd[@]}"
  else
    exec "${cmd[@]}"
  fi
}

main "$@"
