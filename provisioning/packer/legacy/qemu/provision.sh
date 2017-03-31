#!/bin/bash
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

# remove uuid
sed -i '/UUID/d' /etc/sysconfig/network-scripts/ifcfg-e*
sed -i '/HWADDR/d' /etc/sysconfig/network-scripts/ifcfg-e*

# moved to kickstart
# install cloud-init and cloud-utils-growpart from extras repo
#yum -y install cloud-init cloud-utils-growpart

# Zero out the free space to save space in the final image:
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

# create inistalled rpm manifest and cat it for script parsing
echo '# installed rpm manifest' > /root/rpm.mnf
rpm -qa | sort >> /root/rpm.mnf
echo '# end rpm manifest' >> /root/rpm.mnf 
cat /root/rpm.mnf
