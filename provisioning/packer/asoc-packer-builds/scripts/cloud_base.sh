#!/bin/bash
rm -f /etc/yum.repos.d/*
cat <<EOF >> /etc/yum.repos.d/t2centos.repo
[t2centos]
enabled = 1
baseurl = http://mirror.rsa.lab.emc.com/centos/7/os/x86_64/
gpgcheck = 0
name = Tier 2 CentOS
EOF

cat <<EOF >> /etc/yum.repos.d/t2centos_extras.repo
[t2centos_extras]
enabled = 1
baseurl = http://mirror.rsa.lab.emc.com/centos/7/extras/x86_64/
gpgcheck = 0
name = Tier 2 Extras
EOF

cat <<EOF >> /etc/yum.repos.d/t2epel.repo
[t2epel]
enabled = 1
baseurl = http://mirror.rsa.lab.emc.com/EPEL/7/x86_64/
gpgcheck = 0
name = Tier 2 EPEL
EOF

cat <<EOF >> /etc/yum.repos.d/t2centos_updates.repo
[t2centos_updates]
enabled = 1
baseurl = http://mirror.rsa.lab.emc.com/centos/7/updates/x86_64/
gpgcheck = 0
name = Tier 2 Updates
EOF


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

# cloud-init stuff
yum -y install cloud-utils cloud-init haveged


# configure cloud init 'cloud-user' as sudo
# this is not configured via default cloudinit config
cat > /etc/cloud/cloud.cfg.d/02_user.cfg <<EOF
system_info:
  default_user:
    name: centos
    lock_passwd: true
    gecos: Default user
    groups: [wheel, adm]
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    shell: /bin/bash
EOF


# Remove wireless firmware drivers 
rpm -qa  |grep "^i.*-firmware" | xargs rpm -e

# Cleanup yum caches
yum -y clean all

# remove uuid
sed -i '/UUID/d' /etc/sysconfig/network-scripts/ifcfg-e*
sed -i '/HWADDR/d' /etc/sysconfig/network-scripts/ifcfg-e*


# Zero out the free space to save space in the final image:
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY
