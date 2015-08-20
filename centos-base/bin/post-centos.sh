#!/bin/bash -eux

# Remove firewalld; it is required to be present for install/image building.
echo "Removing firewalld."
sudo yum -C -y remove --setopt="clean_requirements_on_remove=1" firewalld

echo "Remove development and kernel source packages."
sudo yum -C -y remove --setopt="clean_requirements_on_remove=1" gcc kernel-devel kernel-headers make perl
sudo yum -y clean all

# Clean up network interface persistence
# For cloud images, 'eth0' _is_ the predictable device name, since
# we don't want to be tied to specific virtual (!) hardware
echo "Disable presistent network interfaces"
sudo rm -f /etc/udev/rules.d/70*
#sudo ln -s /dev/null /etc/udev/rules.d/80-net-name-slot.rules
# Remove HWADDR and UUID from already configured devices
for ndev in $(ls -1 /etc/sysconfig/network-scripts/ifcfg-*); do
  if [ "$(basename $ndev)" != "ifcfg-lo" ]; then
    sudo sed -i '/^HWADDR/d' "$ndev"
    sudo sed -i '/^UUID/d' "$ndev"
  fi
done

sync

