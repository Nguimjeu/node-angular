#!/bin/bash

#set -xe;

USER_ID=$(id -u)
GROUP_ID=$(id -g)
USERNAME=$(id -un)
#GROUP_NAME=$(id -gn);
GROUP_NAME="todaloo"
var=""

#echo "uid=${USER_ID}(${USERNAME}) gid=${GROUP_ID}($GROUP_NAME)"

if [[ -z ${var+x} || -z "${var}" ]]; then
  echo "var is unset"
else
  echo "var is set to '$var'"
fi
# Create group if on only if group identified by GID not occupied.
existing_group=$(getent group "${GROUP_ID}" | cut -d: -f1)
if [[ -n "${existing_group}" ]]; then
  echo "The group with GID ${GROUP_ID} already exists. Skipping group creation."
  GROUP_NAME=$existing_group
  echo "$GROUP_NAME"
else
  echo /usr/sbin/groupadd --gid "${GROUP_ID}" "${GROUP_NAME}" --force
fi
# Create user if on only if user identified by UID not occupied.
existing_user=$(getent passwd "${USER_ID}" | cut -d: -f1)
if [[ -n "${existing_user}" ]]; then
  echo "The user with UID ${USER_ID} already exists. Skipping user creation."
  USERNAME=$existing_user
  echo "$USERNAME"
else
  echo /usr/sbin/useradd --create-home --shell /bin/bash --gid "${GROUP_ID}" --uid "${USER_ID}" "${USERNAME}"
fi

echo "${USERNAME} ALL=(root) NOPASSWD:ALL" >/etc/sudoers.d/"${USERNAME}"
#echo chmod 0440 /etc/sudoers.d/"${USERNAME}"
