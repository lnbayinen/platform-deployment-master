#!/bin/bash
. kickstartStubs || exit 1

function generate_vappliance
{
	local installType=$1
	[ "$installType" ] || return 1 

	echo '# Kickstart file for a NetWitness Virtual Appliance
# $Revision: 2176 $'

	writeInstallType "$installType" sda1 || return 1
	writeStandardConfigs 'America/New_York' 'mbr'
	echo '%include /tmp/fwrules.txt'
	
	if [ "$installType" = 'usb' ]; then
		#echo 'clearpart --drives=sdb --all --initlabel'
		writeBootRaid sdb
		echo 'part pv.0 --size=1 --grow --ondisk=sdb'
	else
		#echo 'clearpart --drives=sda --all --initlabel' 
		writeBootRaid sda 
		echo 'part pv.0 --size=1 --grow --ondisk=sda' 
	fi 

	echo 'volgroup VolGroup00 pv.0
logvol swap --vgname=VolGroup00 --size=2048 --fstype=swap --name=swap'

	echo 'reboot'

	echo '%include /tmp/nwpart.txt'
	
	echo '%include /tmp/swpacks.txt' 

	echo '%pre --log /tmp/pre.log' 
	
	cat preinstall.sh
	
	if [ "$installType" = 'usb' ]; then
		echo '
mk_disk_labels sdb'
	else
		echo '
mk_disk_labels sda'
	fi

	echo 'getSAapps 
getHDDsize
%end
%post --nochroot --log /tmp/post.log'

	cat post.sh
	
	echo 'virtualPostScript 
%end'

	return 0
}

generate_vappliance "$@"
