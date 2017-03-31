#!/bin/bash
. kickstartStubs || exit 1

function generate_logs_aio
{
	local installType=$1
	[ "$installType" ] || return 1 

	echo '# Kickstart file for a RSA Logs AIO Appliance
# $Revision: 2176 $'

	writeInstallType "$installType" sda1 || return 1
	writeStandardConfigs
	#writeFirewall 5671 50001 50002 50003 50005 50006 50101 50102 50103 50105 50106 56002 56003 56005 56006 514:udp 514:tcp 162:udp 80 443 8140 8443 60007 21 20 139 445 51024-51034:tcp 137:udp 138:udp 9995:udp 6343:udp 4739:udp 2055:udp
	writeFirewall 8140
	
	echo 'reboot'

	echo '%include /tmp/nwpart.txt' 
	
	echo '%packages --nobase'
	
	echo '@rsa-sa-core
@rsa-sa-log-aio
-@rsa-sa-remote-logcollector
@rsa-sa-malware-analysis-colocated'

	echo '%include /tmp/nwpack.txt' 

	echo 'user --name=rsasoc --homedir=/home/rsasoc --shell=/bin/bash --password=rs@_.s0c'
	
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

generate_logs_aio "$@"
