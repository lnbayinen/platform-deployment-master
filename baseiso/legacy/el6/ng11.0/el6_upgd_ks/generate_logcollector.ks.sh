#!/bin/bash
. kickstartStubs || exit 1

function generate_logcollector
{
	local installType=$1
	[ "$installType" ] || return 1 

	echo '# Kickstart file for a RSA Remote Log Collector Appliance
# $Revision: 2176 $'

	writeInstallType "$installType" sda1 || return 1
	writeStandardConfigs
	#writeFirewall 5671 50001 50006 50106 56006 50101 514:udp 514:tcp 162:udp 8140 21:tcp 9995:udp 6343:udp 4739:udp 2055:udp
	writeFirewall 8140
	
	echo 'reboot'

	echo '%include /tmp/nwpart.txt' 
	
	echo '%packages --nobase'
	
	echo '@rsa-sa-core
-@rsa-sa-remote-logcollector'

	echo '%include /tmp/nwpack.txt' 

	echo '%pre --erroronfail --log /tmp/pre.log' 
	
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

generate_logcollector "$@"
