#!/bin/bash
. kickstartStubs || exit 1
function generate_mpbrok
{
	local installType=$1
	[ "$installType" ] || return 1

	echo '# Kickstart file for a RSA Malware Protection Enterprise Appliance
# $Revision: 3065 $'

	writeInstallType $installType sda1 
	writeStandardConfigs
	#writeFirewall 50003 50006 50103 50106 56003 56006 8443 60007 21 20 139 445 51024-51073:tcp 137:udp 138:udp 8140 
	writeFirewall 8140
	
	echo 'reboot'

	echo '%include /tmp/nwpart.txt'

	echo '%packages --nobase'

	echo '@rsa-sa-core
@rsa-sa-malware-analysis'

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

generate_mpbrok "$@"
