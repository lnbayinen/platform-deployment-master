#!/bin/bash
. kickstartStubs || exit 1
function generate_pack_hybrid
{
	local installType=$1
	[ "$installType" ] || return 1

	echo '# Kickstart file for a RSA Packet Hybrid Appliance
# $Revision: 3065 $'

	writeInstallType $installType sda1 
	writeStandardConfigs
	#writeFirewall 50004 50005 50006 50104 50105 50106 56004 56005 56006 8140
	writeFirewall 8140
	
	echo 'reboot'

	echo '%include /tmp/nwpart.txt'
	
	echo '%packages --nobase'
			
	echo '@rsa-sa-core
@rsa-sa-packet-hybrid
-@rsa-sa-warehouse-connector'

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

generate_pack_hybrid "$@"
