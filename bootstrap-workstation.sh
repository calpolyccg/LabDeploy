#!/bin/sh
# This script bootstraps a workstation by creating an Ansible user.

bootstrap_workstation() {
  # wrap this script in a function, so that it doesn't fail due to network issues during curl

  set -e # fail on first error
  set -o xtrace # print executed commands

  if [ "$EUID" -ne 0 ]; then
    echo "Must be run as root."
    exit 1
  fi

  # This will undo the changes that this script makes.
  # rm -rf ~ansible && userdel ansible

  echo "Creating Ansible user..."
  useradd ansible -mr -G wheel -c "Ansible Admin"
  
  echo "Allowing ansible to use sudo without a password..."
  echo '%ansible ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/ansible-can-sudo-without-password

  echo "Installing Ansible's SSH key..."
  install -d 700 ~ansible/.ssh
  echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ94eDys1WjAJXC5FU/iZsDApHwRIqNmO2Ptuh/hOJGc ansible' >> ~ansible/.ssh/authorized_keys
  chmod 600 ~ansible/.ssh/authorized_keys
  chown -R ansible ~ansible/.ssh
}

bootstrap_workstation