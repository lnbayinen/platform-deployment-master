#!/bin/bash
. kickstartStubs || exit 1
function generate_sabroker
{
	local installType=$1
	[ "$installType" ] || return 1
	
	echo '# Kickstart file for a RSA Security Analytics Server appliance
# $Revision: 3065 $'

	writeInstallType $installType sdb1 
	writeStandardConfigs
	#writeFirewall 50003 50006 50103 50106 56003 56006 80 443 8140 8443 60007 21 20 139 445 51024-51034:tcp 137:udp 138:udp 
	writeFirewall 8140
	
	echo 'reboot'

	echo '%include /tmp/nwpart.txt' 
			
	echo '%packages --nobase'

	echo '@rsa-sa-core
@rsa-sa-server
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

generate_sabroker "$@"
