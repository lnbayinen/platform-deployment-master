#!/bin/bash
# set default terminal, keep old ethernet device names, i.e. /dev/ethx
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

# cloud deployment configurations not needed for vmware ova
# remove uuid
#sed -i '/UUID/d' /etc/sysconfig/network-scripts/ifcfg-e*
#sed -i '/HWADDR/d' /etc/sysconfig/network-scripts/ifcfg-e*

# moved to kickstart
# install cloud-init and cloud-utils-growpart from extras repo
#yum -y install cloud-init cloud-utils-growpart

# zero out and delete qcow2 /EMPTY, to save space in final image
#dd if=/dev/zero of=/EMPTY bs=1M
#rm -f /EMPTY
 
# reset ifcfg-eth0 to dhcp
myif=/etc/sysconfig/network-scripts/ifcfg-eth0
sed -r 's/^BOOTPROTO.*$/BOOTPROTO=dhcp/' < ${myif} > ${myif}.tmp
mv -f ${myif}.tmp ${myif}
sed -r 's/^IPADDR.*$/#IPADDR=/' < ${myif} > ${myif}.tmp
mv -f ${myif}.tmp ${myif}
sed -r 's/^GATEWAY.*$/#GATEWAY=/' < ${myif} > ${myif}.tmp
mv -f ${myif}.tmp ${myif}
sed -r 's/^PREFIX.*$/# ipv4 netmask in bits, e.g. 24\n#PREFIX=/' < ${myif} > ${myif}.tmp
mv -f ${myif}.tmp ${myif}
sed -r 's/^DNS.*$/#DNS1=\n#DNS2=/' < ${myif} > ${myif}.tmp
mv -f ${myif}.tmp ${myif}

## populate bootstrap-repo
#cd /opt/rsa/platform
#tar -xzf bootstrap-repo.tgz
#rm -f bootstrap-repo.tgz
#chown -R root:root bootstrap-repo
#cd

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
