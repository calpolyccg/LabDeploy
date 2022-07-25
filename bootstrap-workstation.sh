#!/bin/sh
# This script bootstraps a workstation by creating an Ansible user.

bootstrap_workstation() {
  set -e
  set -o xtrace

  if [ "$EUID" -ne 0 ]; then
    echo "Must be run as root."
    exit 1
  fi

  echo "Creating Ansible user..."
  useradd ansible -mr -G wheel -c "Ansible Admin"
  
  echo "Allowing ansible to use sudo without a password..."
  echo '%ansible ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/ansible-can-sudo-without-password

  echo "Installing Ansible's SSH key..."
  SSH_TMP=$(mktemp)
  echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ94eDys1WjAJXC5FU/iZsDApHwRIqNmO2Ptuh/hOJGc ansible' >> "$SSH_TMP"
  install -D $SSH_TMP ~ansible/.ssh/authorized_keys
}

bootstrap_workstation