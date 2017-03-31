#!/bin/bash
. kickstartStubs || exit 1

function generate_tpappliance
{
	local installType=$1
	[ "$installType" ] || return 1 

	echo '# Kickstart file for a RSA Third Party HW Appliance
# $Revision: 2176 $'

	writeInstallType "$installType" sda1 || return 1
	writeStandardConfigs
	writeFirewall 8140
	
	echo -e 'zerombr\nreboot'
	
	echo '%include /tmp/nwpart.txt' 

	echo '%packages --nobase'

	echo '%include /tmp/nwpack.txt'	

	echo '%pre --log /tmp/pre.log'

	cat tphardware_check.sh
	
	echo 'get_cpunram
scan_blockdev
get_appsw
%end
%post --nochroot --log /tmp/post.log'

	cat tppost.sh
	
	echo 'runPostScript
%end'

	return 0
}

generate_tpappliance "$@"
