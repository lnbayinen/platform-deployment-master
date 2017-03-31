#!/bin/bash
. kickstartStubs || exit 1

function generate_maprwh
{
	local installType=$1
	[ "$installType" ] || return 1 

	echo '# Kickstart file for a RSA Warehouse Powered by MapR Appliance
# $Revision: 2176 $'

	writeInstallType "$installType" sda1 || return 1
	writeStandardConfigs
	#writeFirewall 50020 50021 50015 111 2049 8140 5660 9997 9998 7220 7221 7222 9001 50030 5181 2888 3888 50060 60000 60010 60020 20000
	writeFirewall 2049 2888 3888 5181 5660 7220 7221 7222 8080 8443 9001 9997 9998 10000 50030 50060 60000 60010 60020
	
	echo 'reboot'

	echo '%include /tmp/nwpart.txt' 
	
	echo '%packages --nobase'
	
	cat maprpackagelist

	echo '-rsa-saw-server'

	echo '%include /tmp/nwpack.txt' 

	echo '%pre --log /tmp/pre.log' 
	
	cat hardware_check.sh
	
	echo "clrRaidCfg
doAllSeriesCheck < /dev/tty3 >/dev/tty3 2>/dev/tty3
check_upgrade
%end
%post --nochroot --log /tmp/post.log"

	cat post.sh
	
	echo 'runPostScript
%end'

	return 0
}

generate_maprwh "$@"
