#!/bin/bash
myinit=/etc/rc.d/rc.local
# reset default host name on first boot
myrand=${RANDOM}
sed -r "s/NWAPPLIANCE[[:digit:]]+/NWAPPLIANCE${myrand}/g" < /etc/hosts > /etc/hosts.tmp
mv -f /etc/hosts.tmp /etc/hosts
chmod 644 /etc/hosts
sed -r "s/NWAPPLIANCE[[:digit:]]+/NWAPPLIANCE${myrand}/" < /etc/sysconfig/network > /etc/sysconfig/network.tmp
mv -f /etc/sysconfig/network.tmp /etc/sysconfig/network
chmod 644 /etc/sysconfig/network
/sbin/sysctl kernel.hostname=NWAPPLIANCE${myrand}
# rekey nwlogcollector legacy message broker cert
/opt/netwitness/bin/NwEventBrokerRekey
# remove script invocation
sed -r 's/\/tmp\/setuplc.sh//' < ${myinit} > ${myinit}.tmp
mv -f ${myinit}.tmp ${myinit}
chmod 755 ${myinit}
rm -f /tmp/setuplc.sh
