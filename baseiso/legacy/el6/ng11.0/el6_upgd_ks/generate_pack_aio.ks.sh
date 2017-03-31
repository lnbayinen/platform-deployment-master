#!/bin/bash
. kickstartStubs || exit 1

function generate_pack_aio
{
	local installType=$1
	[ "$installType" ] || return 1 

	echo '# Kickstart file for a RSA Packet AIO Appliance
# $Revision: 2176 $'

	writeInstallType "$installType" sda1 || return 1
	writeStandardConfigs
	#writeFirewall 50003 50004 50005 50006 50103 50104 50105 50106 56003 56004 56005 56006 80 443 8140 8443 60007 21 20 139 445 51024-51034:tcp 137:udp 138:udp
	writeFirewall 8140
	
	echo 'reboot'

	echo '%include /tmp/nwpart.txt' 
	
	echo '%packages --nobase'

	echo '@rsa-sa-core 
@rsa-sa-packet-aio
@rsa-sa-malware-analysis-colocated'

	echo '%include /tmp/nwpack.txt' 
	
	echo 'user --name=rsasoc --homedir=/home/rsasoc --shell=/bin/bash --password=rs@_.s0c'
	
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

generate_pack_aio "$@"
