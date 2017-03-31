#!/bin/bash

function installCloudTools {
	# enable centos base,updates and extras repos for cloud-init install
	/bin/cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
	declare -a repolist
	let count=0
	while read line
	do
		repolist[$count]="${line}"
		let count=$count+1
	done < /etc/yum.repos.d/CentOS-Base.repo
	/bin/rm -f /etc/yum.repos.d/CentOS-Base.repo
	inblock=
	let count=0
	for item in "${repolist[@]}"
	do
		if [[ `echo "${item}" | grep '\[base\]'` ]] || [[ `echo "${item}" | grep '\[updates\]'` ]] || [[ `echo "${item}" | grep '\[extras\]'` ]]; then
			inblock=1
		fi
		if [ $inblock ] && [[ `echo "${item}" | grep 'enabled'` ]]; then
			echo 'enabled=1' >> /etc/yum.repos.d/CentOS-Base.repo
			unset inblock
		else
			echo "${item}" >> /etc/yum.repos.d/CentOS-Base.repo 
		fi
	done
	/bin/chmod 644 /etc/yum.repos.d/CentOS-Base.repo
	/usr/bin/yum clean all
	/usr/bin/yum makecache
	/usr/bin/yum -y install cloud-init
	/bin/mv -f /etc/yum.repos.d/CentOS-Base.repo.bak /etc/yum.repos.d/CentOS-Base.repo
	/usr/bin/yum clean all
	/usr/bin/yum makecache
}

# remove qemu "SLIRP" network configuration
/bin/mv -f /etc/sysconfig/network-scripts/bakifcfg-eth0 /etc/sysconfig/network-scripts/ifcfg-eth0
# re-generate net device naming on reboot
/bin/rm -f /etc/udev/rules.d/70-persistent-net.rules
# add serial console redirection for openstack logging
/bin/cp /boot/grub/grub.conf /boot/grub/grub.conf.bak
/bin/sed -r 's/(^[[:space:]]*kernel[[:space:]]+.*$)/\1 console=tty0 console=ttyS0,115200/' < /boot/grub/grub.conf > /boot/grub/grub.conf.tmp
/bin/mv -f /boot/grub/grub.conf.tmp /boot/grub/grub.conf
/bin/chmod 600 /boot/grub/grub.conf
