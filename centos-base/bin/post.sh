#!/bin/bash -eux
# "sysprep" actions adapted from source at
# https://github.com/libguestfs/libguestfs/tree/master/sysprep
#
echo "Removing log files and stale data"
logfiles="
/root/anaconda-ks.cfg
/root/anaconda-post.log
/root/initial-setup-ks.cfg
/root/install.log
/root/install.log.syslog
/var/cache/fontconfig/*
/var/cache/gdm/*
/var/cache/man/*
/var/lib/AccountService/users/*
/var/lib/fprint/*
/var/lib/logrotate.status
/var/log/anaconda/*
/var/log/anaconda.syslog
/var/log/apache2/*_log-*
/var/log/apache2/*_log
/var/log/apt/*
/var/log/aptitude*
/var/log/audit/*
/var/log/BackupPC/LOG
/var/log/btmp*
/var/log/ceph/*.log
/var/log/chrony/*.log
/var/log/ConsoleKit/*
/var/log/cron*
/var/log/cups/*_log*
/var/log/debug*
/var/log/dmesg*
/var/log/exim4/*
/var/log/faillog*
/var/log/firewalld*
/var/log/gdm/*
/var/log/glusterfs/*glusterd.vol.log
/var/log/glusterfs/glusterfs.log
/var/log/grubby*
/var/log/httpd/*log
/var/log/installer/*
/var/log/jetty/jetty-console.log
/var/log/journal/*
/var/log/lastlog*
/var/log/libvirt/libvirtd.log
/var/log/libvirt/libxl/*.log
/var/log/libvirt/lxc/*.log
/var/log/libvirt/qemu/*.log
/var/log/libvirt/uml/*.log
/var/log/lightdm/*
/var/log/*.log*
/var/log/mail/*
/var/log/maillog*
/var/log/messages*
/var/log/ntp
/var/log/ntpstats/*
/var/log/ppp/connect-errors
/var/log/rhsm/*
/var/log/sa/*
/var/log/secure*
/var/log/setroubleshoot/*.log
/var/log/spooler*
/var/log/squid/*.log
/var/log/syslog*
/var/log/tallylog*
/var/log/tuned/tuned.log
/var/log/wtmp*
/var/log/xferlog*
/var/named/data/named.run
"
for lf in $logfiles; do
  sudo rm -v -rf $lf
done
# Remove these silently
sudo rm -rf /var/lib/rpm/__db.* /var/lib/yum/* /tmp/* /var/tmp/*

echo "Deleting /root/.ssh (config or keys)"
sudo rm -v -rf /root/.ssh

echo "Removing .bash_history"
sudo rm -v -rf /home/*/.bash_history
sudo rm -v -rf /root/.bash_history

echo "Removing DHCP leases data"
sudo rm -v -rf /var/lib/dhclient/*
sudo rm -v -rf /var/lib/dhcp/*
sudo rm -v -rf /var/lib/dhcpd/*

echo "Resetting machine-id"
sudo truncate --size=0 /etc/machine-id || :

echo "Removing SSH host keys"
sudo rm -rf /etc/ssh/*_host_*

# Explicitly sync disk
sync

