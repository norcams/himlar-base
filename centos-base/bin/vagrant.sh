#!/bin/bash -eux

vagrant_user() {
  local HOME_DIR="${HOME_DIR:-/home/vagrant}"
  if [[ ! -d "${HOME_DIR}" ]]; then
    sudo groupadd vagrant
    sudo useradd vagrant -g vagrant
    echo "vagrant" | sudo passwd --stdin vagrant
  fi
}

vagrant_public_key() {
  local PUBKEY="/tmp/${PROJECT_NAME}/files/vagrant.pub"
  local HOME_DIR="${HOME_DIR:-/home/vagrant}"
  if [[ -s "${PUBKEY}" ]]; then
    sudo mkdir -p "${HOME_DIR}/.ssh"
    sudo cp -f "${PUBKEY}" "${HOME_DIR}/.ssh/authorized_keys"
  else
    echo "Cannot find ${PROJECT_NAME}/files/vagrant.pub"
    exit 1
  fi
  sudo chown -R vagrant $HOME_DIR/.ssh
  sudo chmod -R go-rwsx $HOME_DIR/.ssh
}

setup_sudo() {
  cat <<EOF | sudo tee /etc/sudoers.d/vagrant
Defaults:vagrant !requiretty
Defaults:vagrant env_keep += "SSH_AUTH_SOCK"
vagrant ALL=(ALL) NOPASSWD: ALL
EOF
  sudo chmod 0440 /etc/sudoers.d/vagrant
}


echo "Adding vagrant user..."
vagrant_user
echo "Copying vagrant.pub..."
vagrant_public_key
echo "Enabling sudo for vagrant user..."
setup_sudo

