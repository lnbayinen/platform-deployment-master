#!/bin/bash
# set default console and keep old ethernet device names, i.e. /dev/ethx
cp /boot/grub2/grub.cfg /boot/grub2/grub2.cfg.bak
cat > /etc/default/grub <<EOF
GRUB_DEFAULT=0
GRUB_HIDDEN_TIMEOUT=0
GRUB_HIDDEN_TIMEOUT_QUIET=true
GRUB_TIMEOUT=1
GRUB_DISTRIBUTOR="$(sed 's, release .*$,,g' /etc/system-release)"
GRUB_DEFAULT=saved
GRUB_DISABLE_SUBMENU=true
GRUB_TERMINAL=serial
GRUB_SERIAL_COMMAND="serial --speed=115200 --unit=0 --word=8 --parity=no --stop=1"
GRUB_CMDLINE_LINUX_DEFAULT="console=tty0 console=ttyS0,115200n8 net.ifnames=0 biosdevname=0"
GRUB_TERMINAL_OUTPUT="console"
GRUB_DISABLE_RECOVERY="true"
EOF
grub2-mkconfig -o /boot/grub2/grub.cfg

# remove uuid and mac address from ethernet configuration
sed -i '/UUID/d' /etc/sysconfig/network-scripts/ifcfg-e*
sed -i '/HWADDR/d' /etc/sysconfig/network-scripts/ifcfg-e*

# install wget, cloud-init, cloud-utils-growpart and haveged from iso
mount -o loop /dev/sr0 /mnt
# create temporary yum conf file
YUMCFG='/tmp/.myyum.conf'
echo '[main]' > $YUMCFG
echo 'cachedir=/var/cache/yum' >> $YUMCFG
echo 'keepcache=0' >> $YUMCFG
echo 'debuglevel=2' >> $YUMCFG
echo 'logfile=/tmp/.myyum.log' >> $YUMCFG
echo 'distroverpkg=redhat-release' >> $YUMCFG
echo 'tolerant=1' >> $YUMCFG
echo 'exactarch=1' >> $YUMCFG
echo 'obsoletes=1' >> $YUMCFG
echo 'gpgcheck=1' >> $YUMCFG
echo 'plugins=1' >> $YUMCFG
echo 'metadata_expire=1h' >> $YUMCFG
echo '[myiso]' >> $YUMCFG
echo 'name=rsanw-11.0.0.0.0-base' >> $YUMCFG
echo 'baseurl=file:///mnt/' >> $YUMCFG
echo 'gpgcheck=0' >> $YUMCFG
echo 'enabled=1' >> $YUMCFG
yum -c /tmp/.myyum.conf --disablerepo=\* --enablerepo=myiso -y install wget cloud-init cloud-utils-growpart haveged
umount /mnt
yum clean all

# zero out and delete qcow2 /EMPTY to save space in the final image
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

# populate bootstrap repo
myrepo='http://asoc-platform.rsa.lab.emc.com/platform/el7/mainline/dev/bootstrap/11.0'
cd /opt/rsa/platform/bootstrap-repo
wget -r -np -nH --reject html --cut-dirs=6 ${myrepo}

# download GPG repo keys
repo_keys='http://asoc-platform.rsa.lab.emc.com/platform/el7/mainline/dev/bootstrap/keys'
cd /opt/rsa/platform/bootstrap-repo
wget -r -np -nH --reject html --cut-dirs=6 ${repo_keys}

# create installed rpm manifest and cat it for script parsing
echo '# installed rpm manifest' > /root/rpm.mnf
rpm -qa | sort >> /root/rpm.mnf
echo '# end rpm manifest' >> /root/rpm.mnf
echo
echo
cat /root/rpm.mnf
echo
echo
sleep 3
