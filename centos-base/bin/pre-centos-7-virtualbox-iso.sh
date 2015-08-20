#!/bin/bash -eux

echo "Slow DNS fix"
echo "Ref https://access.redhat.com/site/solutions/58625 (subscription required)"
sudo sed -i  -e '$ a\ RES_OPTIONS=\"single-request-reopen\"' /etc/sysconfig/network

# Another bug that breaks resolv.conf when we apply the above fix
# * https://bugzilla.redhat.com/show_bug.cgi?id=1212883
# * https://git.fedorahosted.org/cgit/initscripts.git/patch/?id=39de27f81ed861da917155a0552bbf494b33e5ad
sudo patch -p1 -f -b -d /etc < "/tmp/${PROJECT_NAME}/files/network-functions.patch" || :

sudo service network restart

