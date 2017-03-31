#!/bin/bash
. kickstartStubs || exit 1

function generate_appliance
{
	local installType=$1
	[ "$installType" ] || exit 1
	
	echo '# Kickstart file for a RSA Netwitness Generic Appliance
# $Revision$'

	writeInstallType "$installType" sda1 || return 1
	writeStandardConfigs
	#writeFirewall 50004 50104 56004 50006 50106 56006 8140
	writeFirewall
	
	echo -e '# --prodnet--\nnetwork --bootproto=dhcp --device=eno1\n# --prodnetend--\n#network'

	echo 'reboot'

	echo '%packages --nocore'

	echo -e '@Core --nodefaults\n-@Base\n%end'

	echo -e '%pre --log=/tmp/pre.log --interpreter=/usr/bin/bash\n# --pre--'

	cat hardware_check.sh
	
	echo "clrRaidCfg
doAllSeriesCheck
#check_upgrade
make_install_parts
# --preend--
%end
%post --interpreter=/usr/bin/bash --nochroot --log=/tmp/post.log
# --post--"

	cat post.sh
	
	echo 'runPostScript
# --postend--
%end'

	return 0
}

generate_appliance "$@"
