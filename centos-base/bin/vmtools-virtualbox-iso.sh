#!/bin/bash -eux

HOME_DIR="${HOME_DIR:-/home/packer}"

mkdir -p /tmp/vbox
VER="$(cat "${HOME_DIR}/.vbox_version")"
sudo mount -o loop "${HOME_DIR}/VBoxGuestAdditions_${VER}.iso" /tmp/vbox

sudo /tmp/vbox/VBoxLinuxAdditions.run || \
  echo "VBoxLinuxAdditions.run exited $? and is suppressed." \
       "For more read https://www.virtualbox.org/ticket/12479"

sudo umount /tmp/vbox
sudo rm -rf /tmp/vbox
sudo rm -rf /var/log/VBox*
sudo rm -f "${HOME_DIR}"/*.iso

