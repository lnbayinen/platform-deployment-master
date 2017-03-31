#!/bin/bash
. kickstartStubs || exit 1

function generate_broker
{
	local installType=$1
	[ "$installType" ] || return 1 

	echo '# Kickstart file for a RSA Broker Appliance
# $Revision: 2176 $'

	writeInstallType "$installType" sda1 || return 1
	writeStandardConfigs
	#writeFirewall 50003 50103 56003 50006 50106 56006 8140
	writeFirewall 8140
	
	echo 'reboot'

	echo '%include /tmp/nwpart.txt' 
	
	echo '%packages --nobase'

	echo '@rsa-sa-core
@rsa-sa-broker'

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

generate_broker "$@"
