#!/bin/bash
. kickstartStubs || exit 1
function generate_logs_hybrid
{
	local installType=$1
	[ "$installType" ] || return 1

	echo '# Kickstart file for a RSA Logs Hybrid Appliance
# $Revision: 3065 $'

	writeInstallType $installType sda1 
	writeStandardConfigs
	#writeFirewall 5671 50001 50002 50005 50006 50101 50102 50105 50106 56002 56005 56006 514:udp 162:udp 514:tcp 8140 21:tcp 9995:udp 6343:udp 4739:udp 2055:udp 
	writeFirewall 8140
	
	echo 'reboot'

	echo '%include /tmp/nwpart.txt'
	
	echo '%packages --nobase'
			
	echo '@rsa-sa-core
@rsa-sa-log-hybrid
-@rsa-sa-remote-logcollector
-@rsa-sa-warehouse-connector'

	echo '%include /tmp/nwpack.txt'
	
	echo '%pre --erroronfail --log=/tmp/pre.log'
	
	cat hardware_check.sh
	
	echo "clrRaidCfg
doAllSeriesCheck < /dev/tty3 >/dev/tty3 2>/dev/tty3
check_upgrade
%end
%post --nochroot --log=/tmp/post.log"

	cat post.sh

	echo 'runPostScript
%end'

	return 0 
}

generate_logs_hybrid "$@"
