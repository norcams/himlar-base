#!/bin/bash -eux

echo "Zero-filling swap and root disks"

swapuuid="$(sudo blkid -o value -l -s UUID -t TYPE=swap || true)"
if [ "x${swapuuid}" != "x" ]; then
    # Whiteout the swap partition to reduce box size"
    # Swap is disabled till reboot"
    swappart="$(sudo readlink -f /dev/disk/by-uuid/$swapuuid)"
    sudo swapoff "$swappart"
    sudo dd if=/dev/zero of="$swappart" bs=1M || echo "dd exit code $? suppressed"
    sudo mkswap -U "$swapuuid" "$swappart"
fi

sudo dd if=/dev/zero of=/EMPTY bs=1M || echo "dd exit code $? suppressed"
sudo rm -f /EMPTY
# Block until the empty file has been removed, otherwise, Packer
# will try to kill the box while the disk is still full and that's bad
sudo sync

