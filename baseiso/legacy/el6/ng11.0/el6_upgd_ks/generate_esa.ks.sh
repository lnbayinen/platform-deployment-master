#!/bin/bash
. kickstartStubs || exit 1

function generate_esa
{
	local installType=$1
	[ "$installType" ] || return 1 

	echo '# Kickstart file for a RSA Event Stream Analysis Appliance
# $Revision: 2176 $'

	writeInstallType "$installType" sda1 || return 1
	writeStandardConfigs
	#writeFirewall 50030 50035 50036 8140 514:udp 514:tcp
	writeFirewall 8140
	
	echo 'reboot'

	echo '%include /tmp/nwpart.txt' 
	
	echo '%packages --nobase'

	echo '@rsa-sa-core
@rsa-sa-esa-server'

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

generate_esa "$@"
