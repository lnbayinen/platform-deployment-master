# ^^^^^^^^^^^^^^^^^^^^^^ global constants ^^^^^^^^^^^^^^^^^^^^^^^^^

raid_models_list=( "PERC H700" "PERC H710P" "SRCSAS144E" "MegaRAID 8888ELP" "MR9260DE-8i" "MR9260-8i" "MR9260-4i" "AOC-USAS2LP-H8iR" "Internal Dual SD" )

# list of common packages to install in %post
commpack=( "nwsupport-script" )

# ^^^^^^^^^^^^^^^^^^^^^ global variables ^^^^^^^^^^^^^^^^^^^^^^^^^

vgfreemib=

openstack=

vmware=

if [ -s /tmp/nwcloud.txt ] && [[ `cat /tmp/nwcloud.txt | grep -i 'OpenStack'` ]]; then
	echo 'openstack=true' | tee -a /tmp/post.log
	openstack='true'
fi

if [ -s /tmp/nwcloud.txt ] && [[ `cat /tmp/nwcloud.txt | grep -i 'VMware'` ]]; then
	echo 'vmware=true' | tee -a /tmp/post.log
	vmware='true'
fi

# ^^^^^^^^^^^^^^^^^^^^^^ %post func defs ^^^^^^^^^^^^^^^^^^^^^^^^^^

function set_logrotate_param
{
    # have logrotate run hourly for nextgen
    if ! [ -z $1 ]; then
        local LOGJOB='/mnt/sysimage/etc/cron.daily/logrotate'
        mv -f $LOGJOB /mnt/sysimage/etc/cron.hourly/
    fi
    local LOGCFG='/mnt/sysimage/etc/logrotate.conf'
    mv "$LOGCFG" "$LOGCFG.bkup$RANDOM" 
    echo '# RSA configuration, please do not edit' > $LOGCFG
    echo '' >> $LOGCFG
    echo '# see "man logrotate" for details' >> $LOGCFG
    echo '# rotate log files weekly' >> $LOGCFG
    echo 'weekly' >> $LOGCFG
    echo '' >> $LOGCFG
    echo '# keep 12 compressed backlogs' >> $LOGCFG
    echo 'rotate 12' >> $LOGCFG
    echo '' >> $LOGCFG
    echo '# create new (empty) log files after rotating old ones' >> $LOGCFG
    echo 'create' >> $LOGCFG
    echo '' >> $LOGCFG
    echo '# no greater than 250 mb' >> $LOGCFG
    echo 'size=250M' >> $LOGCFG 
    echo '' >> $LOGCFG
    echo '# use date as a suffix of the rotated file' >> $LOGCFG
    echo 'dateext' >> $LOGCFG
    echo '' >> $LOGCFG
    echo '# uncomment this if you want your log files compressed' >> $LOGCFG
    echo 'compress' >> $LOGCFG
    echo '' >> $LOGCFG
    echo '# RPM packages drop log rotation information into this directory' >> $LOGCFG
    echo 'include /etc/logrotate.d' >> $LOGCFG
    echo '' >> $LOGCFG
    echo '# no packages own wtmp and btmp -- we will rotate them here' >> $LOGCFG
    echo '/var/log/wtmp {' >> $LOGCFG
    echo '    monthly' >> $LOGCFG
    echo '    minsize 1M' >> $LOGCFG
    echo '    create 0664 root utmp' >> $LOGCFG 
    echo '    rotate 1' >> $LOGCFG
    echo '}' >> $LOGCFG
    echo '' >> $LOGCFG
    echo '/var/log/btmp {' >> $LOGCFG
    echo '    missingok' >> $LOGCFG   
    echo '    monthly' >> $LOGCFG
    echo '    create 0600 root utmp' >> $LOGCFG 
    echo '    rotate 1' >> $LOGCFG
    echo '}' >> $LOGCFG
    echo '' >> $LOGCFG
    echo '# system-specific logs may be also be configured here.' >> $LOGCFG
    echo '' >> $LOGCFG
    # add any SA/rsaMalwareDevice jetty logging directories 
    local UAXLOG='/mnt/sysimage/var/lib/netwitness/uax/logs'
    local SPECLOG='/mnt/sysimage/var/lib/rsamalware/jetty/logs'
    local COLOLOG='/mnt/sysimage/var/lib/netwitness/rsamalware/jetty/logs'
    if [ -d $UAXLOG ]; then
        echo '/var/lib/netwitness/uax/logs/*.log {' >> $LOGCFG
        echo 'rotate 16' >> $LOGCFG
	echo 'size=262144000' >> $LOGCFG 
	echo '}' >> $LOGCFG
	echo '' >> $LOGCFG
 
    fi
    if ! [ -h /mnt/sysimage/var/lib/rsamalware ] &&  [ -d $SPECLOG ]; then
 	echo '/var/lib/rsamalware/jetty/logs/*.log {' >> $LOGCFG
	echo 'rotate 16' >> $LOGCFG
	echo 'size=262144000' >> $LOGCFG
	echo '}' >> $LOGCFG
	echo '' >> $LOGCFG   
    fi 
    if [ -d $COLOLOG ]; then
 	echo '/var/lib/netwitness/rsamalware/jetty/logs/*.log {' >> $LOGCFG
	echo 'rotate 16' >> $LOGCFG
	echo 'size=262144000' >> $LOGCFG
	echo '}' >> $LOGCFG
	echo '' >> $LOGCFG   
    fi
}    

function make_device_map_sda
{
	echo "(hd0) /dev/sda
(hd1) /dev/sdb" > /mnt/sysimage/boot/grub/device.map
}

function make_device_map_sdb
{
	echo "(hd0) /dev/sdb
(hd1) /dev/sdc" > /mnt/sysimage/boot/grub/device.map
}

function make_device_map_esa
{
	echo "(hd0) /dev/sdb
(hd1) /dev/sda" > /mnt/sysimage/boot/grub/device.map
}

function make_device_map_sdc
{
	echo "(hd0) /dev/sdc
(hd1) /dev/sdd" > /mnt/sysimage/boot/grub/device.map
}

function make_device_map_sdd
{
	echo "(hd0) /dev/sdd
(hd1) /dev/sde" > /mnt/sysimage/boot/grub/device.map
}

function make_device_map_dell_2400
{
	echo "(hd0) /dev/sdc
(hd1) /dev/sda
(hd2) /dev/sdb" > /mnt/sysimage/boot/grub/device.map
}

function make_device_map_dell_200
{
	echo "(hd0) /dev/sda" > /mnt/sysimage/boot/grub/device.map
}

function get_kernel_filename
{
	local kernel
	local KERNEL
	for kernel in $(ls /mnt/sysimage/boot/vmlinuz*)
	do
		KERNEL=$(basename $kernel)
	done

	echo $KERNEL
}

function get_initrd_filename
{
	local initrd
	local INITRD
	for initrd in $(ls /mnt/sysimage/boot/initramfs*)
	do
		INITRD=$(basename $initrd)
	done

	echo $INITRD
}

function get_newest_modules_dir
{
	local moduledir
	local VER
	for moduledir in $(ls /mnt/sysimage/lib/modules)
	do
		VER=$moduledir
	done
	echo $VER
}

# don't think its broken anymore but, like this better than the CentOS splash 
#
# Fix for broken GRUB installation in Fedora 9 installer
function install_grub
{
	echo " configuring grub, 'GRand Unified Bootloader'" > /dev/tty1
	echo ' ignore any non existent device errors, e.g. floppy drives' > /dev/tty1
	cp /mnt/sysimage/usr/share/grub/x86_64-redhat/* /mnt/sysimage/boot/grub
	local KERNEL=$(get_kernel_filename)
	local INITRD=$(get_initrd_filename)

	echo "password --md5 \$1\$K7uqK\$bUbRkTIRK5zem3tYXF7ai0
default 0
timeout 5
title Boot
	root (hd0,0)
	kernel /$KERNEL root=/dev/VolGroup00/root ro nodmraid quiet
	initrd /$INITRD
title Boot Backup Drive
	root (hd1,0)
	kernel /$KERNEL root=/dev/VolGroup00/root ro nodmraid quiet
	initrd /$INITRD
" > /mnt/sysimage/boot/grub/grub.conf

	echo 'detecting grub boot device(s)' | tee -a /tmp/post.log > /dev/tty3
	local grubroot=`echo 'find /grub/stage1' | grub --batch | grep '\(hd[0-9],[0-9]\)' | tr '\n' ' ' | awk '{print $1}'`
	local grubroot2=`echo 'find /grub/stage1' | grub --batch | grep '\(hd[0-9],[0-9]\)' | tr '\n' ' ' | awk '{print $2}'`
	echo "grubroot = $grubroot, grubroot2 = $grubroot2 " | tee -a /tmp/post.log > /dev/tty3
	local rparen=')'
	local grubdisk=${grubroot%%,*}
	grubdisk="$grubdisk$rparen"
	local grubdisk2=${grubroot2%%,*}
	grubdisk2="$grubdisk2$rparen"
	echo "grubdisk = $grubdisk, grubdisk2 = $grubdisk2" | tee -a /tmp/post.log > /dev/tty3
	echo "root $grubroot 
	setup $grubdisk
	root $grubroot2 
	setup $grubdisk2" | grub --batch
	# add link to grub.conf in /etc for /sbin/new-kernel-pkg script
	chroot /mnt/sysimage /bin/ln -s -t /etc /boot/grub/grub.conf 
}

# this is now required for systems that don't have SW mirrored system drives 
#
# so back in the day we didn't mirror the root filesystem on our boxes.  If that's the
# case we're going to install our bootloader only on one drive.
function install_grub_on_first_drive_only
{
	echo " configuring grub, 'GRand Unified Bootloader'" > /dev/tty1 
	echo ' ignore any non existent device errors, e.g. floppy drives' > /dev/tty1
	cp /mnt/sysimage/usr/share/grub/x86_64-redhat/* /mnt/sysimage/boot/grub

	local KERNEL=$(get_kernel_filename)
	local INITRD=$(get_initrd_filename)
	local installdisk=`cat /tmp/partdisk.txt`
	local partable=`parted -s /dev/${installdisk} print | grep -i -E 'Partition[[:space:]]+Table:'`
	if [[ `echo "$partable" | grep -i 'gpt'` ]]; then
		echo "password --md5 \$1\$K7uqK\$bUbRkTIRK5zem3tYXF7ai0
default 0
timeout 5
title Boot
root (hd0,1)
kernel /$KERNEL root=/dev/VolGroup00/root ro nodmraid quiet
initrd /$INITRD" > /mnt/sysimage/boot/grub/grub.conf
		echo "password --md5 \$1\$K7uqK\$bUbRkTIRK5zem3tYXF7ai0
default 0
timeout 5
title Boot
root (hd0,1)
kernel /$KERNEL root=/dev/VolGroup00/root ro nodmraid quiet
initrd /$INITRD" > /mnt/sysimage/boot/efi/EFI/redhat/grub.conf
	else
		echo "password --md5 \$1\$K7uqK\$bUbRkTIRK5zem3tYXF7ai0
default 0
timeout 5
title Boot
root (hd0,0)
kernel /$KERNEL root=/dev/VolGroup00/root ro nodmraid quiet
initrd /$INITRD" > /mnt/sysimage/boot/grub/grub.conf
	fi
		
	echo 'detecting grub boot device(s)' | tee -a /tmp/post.log > /dev/tty3
	local grubroot=`echo 'find /grub/stage1' | grub --batch | grep '\(hd[0-9],[0-9]\)' | awk '{print $1}'`
	echo "grubroot = $grubroot" | tee -a /tmp/post.log > /dev/tty3
	local rparen=')'
	local grubdisk=${grubroot%%,*}
	grubdisk="$grubdisk$rparen"
	echo "grubdisk = $grubdisk" | tee -a /tmp/post.log > /dev/tty3
	echo "root $grubroot 
	setup $grubdisk
	" | grub --batch
	# add link to grub.conf in /etc for /sbin/new-kernel-pkg script
	chroot /mnt/sysimage /bin/ln -s -t /etc /boot/grub/grub.conf
}


# $1 = root prefix
function randomizeHostname
{
	local PREFIX=$1

	local hostnumber=`python -c 'import random; random.SystemRandom(); print random.randint(1,32768)'`

        local hostname=NWAPPLIANCE${hostnumber}
	
	echo "Setting hostname to $hostname"
	
	echo "NETWORKING=yes
HOSTNAME=${hostname}
IPV6_DEFAULTGW=
" > $PREFIX/etc/sysconfig/network
	
	if ! [[ `grep 'config_maprwh' /tmp/nwpost.txt` ]]; then
		echo "# Created by NetWitness Installer on $(date)
127.0.0.1 ${hostname} localhost localhost.localdomain localhost4 localhost4.localdomain4
::1 ${hostname} localhost localhost.localdomain localhost6 localhost6.localdomain6 
" > $PREFIX/etc/hosts
	else
		echo "# Created by NetWitness Installer on $(date)
127.0.0.1 localhost localhost.localdomain localhost4 localhost4.localdomain4 ${hostname}
::1 localhost localhost.localdomain localhost6 localhost6.localdomain6 ${hostname}
" > $PREFIX/etc/hosts
	fi
}

function set_dell_ethernet_devices { 
	local my_board=`dmidecode -t 2 | grep -i 'Product Name:' | awk '{print $3}'`
	local my_system=`dmidecode -t 1 | grep -i 'Product Name:' | awk '{print $4}'`
	if [[ `rpm -q nwdecoder | grep -E 'nwdecoder-[0-9]+\.[0-9]+\.[0-9]+'` ]] && ! [[ `rpm -q nwconcentrator | grep -E 'nwconcentrator-[0-9]+\.[0-9]+\.[0-9]+'` ]]; then
		local appliance_type='Decoder'
	fi 

	local curdir=`pwd`
	cd /mnt/sysimage/etc/sysconfig/network-scripts
	local netdev=( `ls -A ifcfg-[ep]*` )
	local item
	for item in ${netdev[@]}
	do
		sed 's/NM_CONTROLLED="yes"/NM_CONTROLLED="no"/' < $item > $item.tmp
		mv -f $item.tmp $item	
	done
	cd $curdir
	
	# warn if missing additional ethernet device on Dell 2400, SuperMicro 2400n Decoders and Spectrum w/Decoder models
	if [[ "$my_board" = 'X8DTN+-F' || "$my_board" = '00HDP0' || "$my_board" = "0DPRKF" ]] || [[ "$my_system" = 'R510' ]] && [[ `echo "$appliance_type" | grep -i 'Decoder'` ]]; then
    		let num_devices=$num_devices
		if [ $num_devices -le 2 ]; then 
			echo " Only 2 Ethernet devices found on a 2U Decoder Appliance" >> /dev/tty1
			echo "Only 2 Ethernet devices found on a 2U Decoder Appliance" >> /tmp/post.log 
			echo " Possible missing or unconfigured device, please check system configuration" >> /dev/tty1 
			sleep 10
    		fi
	fi 
}

# fix ethernet device ordering on older hardware, i.e. pre nehalem
function set_ethernet_devices { 
	local my_board=`dmidecode -t 2 | grep -i 'Product Name:' | awk '{print $3}'`
	
	# udev doesn't get the net device order right on the intel mckay creek and S2 supermicro appliances
	if [[ `echo $my_board | grep 'S5000PS'` ]] || [[ `echo $my_board | grep 'X7DWN+' ` ]]; then 
		local num_devices=`lspci | grep -c -i 'ethernet controller'`
		UDEVRULE='/mnt/sysimage/etc/udev/rules.d/70-persistent-net.rules'
		cp $UDEVRULE $UDEVRULE.el6.oem
		# pci-express NIC: Intel 4 port copper ethernet
		if [[ "$num_devices" = '6' ]]; then
			cd /mnt/sysimage/etc/sysconfig/network-scripts 
    			sed 's/ONBOOT="no"/ONBOOT="yes"/' < ifcfg-eth4 > ifcfg-ethA
    			mv -f ifcfg-ethA ifcfg-eth4	
   			sed 's/DEVICE="eth4"/DEVICE="eth0"/' < ifcfg-eth4 > ifcfg-ethA 
    			mv -f ifcfg-ethA ifcfg-eth4
			sed 's/NM_CONTROLLED="yes"/NM_CONTROLLED="no"/' < ifcfg-eth4 > ifcfg-ethA		
			echo 'BOOTPROTO="static"' >> ifcfg-ethA
			echo 'IPADDR="192.168.1.1"' >> ifcfg-ethA 
			echo 'NETMASK="255.255.255.0"' >> ifcfg-ethA
			echo 'GATEWAY="192.168.1.254"' >> ifcfg-ethA 
			sed 's/DEVICE="eth5"/DEVICE="eth1"/' < ifcfg-eth5 > ifcfg-ethB
			mv -f ifcfg-ethB ifcfg-eth5
			sed 's/NM_CONTROLLED="yes"/NM_CONTROLLED="no"/' < ifcfg-eth5 > ifcfg-ethB
			sed 's/DEVICE="eth0"/DEVICE="eth2"/' < ifcfg-eth0 > ifcfg-ethC
			mv -f ifcfg-ethC ifcfg-eth0 
			sed 's/NM_CONTROLLED="yes"/NM_CONTROLLED="no"/' < ifcfg-eth0 > ifcfg-ethC		
			sed 's/DEVICE="eth1"/DEVICE="eth3"/' < ifcfg-eth1 > ifcfg-ethD
			mv -f ifcfg-ethD ifcfg-eth1
			sed 's/NM_CONTROLLED="yes"/NM_CONTROLLED="no"/' < ifcfg-eth1 > ifcfg-ethD 
			sed 's/DEVICE="eth2"/DEVICE="eth4"/' < ifcfg-eth2 > ifcfg-ethE
			mv -f ifcfg-ethE ifcfg-eth2
			sed 's/NM_CONTROLLED="yes"/NM_CONTROLLED="no"/' < ifcfg-eth2 > ifcfg-ethE 
			sed 's/DEVICE="eth3"/DEVICE="eth5"/' < ifcfg-eth3 > ifcfg-ethF
			mv -f ifcfg-ethF ifcfg-eth3
			sed 's/NM_CONTROLLED="yes"/NM_CONTROLLED="no"/' < ifcfg-eth3 > ifcfg-ethF		
			mv -f ifcfg-ethA ifcfg-eth0 
			mv -f ifcfg-ethB ifcfg-eth1 
			mv -f ifcfg-ethC ifcfg-eth2 
			mv -f ifcfg-ethD ifcfg-eth3 
			mv -f ifcfg-ethE ifcfg-eth4 
			mv -f ifcfg-ethF ifcfg-eth5 
			sed 's/NAME="eth0"/NAME="ethC"/' < $UDEVRULE > $UDEVRULE.tmp
			mv -f $UDEVRULE.tmp $UDEVRULE
			sed 's/NAME="eth1"/NAME="ethD"/' < $UDEVRULE > $UDEVRULE.tmp
			mv -f $UDEVRULE.tmp $UDEVRULE 
			sed 's/NAME="eth2"/NAME="ethE"/' < $UDEVRULE > $UDEVRULE.tmp
			mv -f $UDEVRULE.tmp $UDEVRULE 
			sed 's/NAME="eth3"/NAME="ethF"/' < $UDEVRULE > $UDEVRULE.tmp
			mv -f $UDEVRULE.tmp $UDEVRULE 
			sed 's/NAME="eth4"/NAME="eth0"/' < $UDEVRULE > $UDEVRULE.tmp
			mv -f $UDEVRULE.tmp $UDEVRULE 
			sed 's/NAME="eth5"/NAME="eth1"/' < $UDEVRULE > $UDEVRULE.tmp
			mv -f $UDEVRULE.tmp $UDEVRULE 
			sed 's/NAME="ethC"/NAME="eth2"/' < $UDEVRULE > $UDEVRULE.tmp
			mv -f $UDEVRULE.tmp $UDEVRULE 
			sed 's/NAME="ethD"/NAME="eth3"/' < $UDEVRULE > $UDEVRULE.tmp
			mv -f $UDEVRULE.tmp $UDEVRULE 
			sed 's/NAME="ethE"/NAME="eth4"/' < $UDEVRULE > $UDEVRULE.tmp
			mv -f $UDEVRULE.tmp $UDEVRULE 
			sed 's/NAME="ethF"/NAME="eth5/' < $UDEVRULE > $UDEVRULE.tmp
			mv -f $UDEVRULE.tmp $UDEVRULE 
			# pci-express NIC: Intel 2 port fiber channel ethernet
		elif [[ "$num_devices" = '4' ]]; then
			cd /mnt/sysimage/etc/sysconfig/network-scripts
			sed 's/ONBOOT="no"/ONBOOT="yes"/' < ifcfg-eth2 > ifcfg-ethA
			mv -f ifcfg-ethA ifcfg-eth2
			sed 's/DEVICE="eth2"/DEVICE="eth0"/' < ifcfg-eth2 > ifcfg-ethA
			mv -f ifcfg-ethA ifcfg-eth2
			sed 's/NM_CONTROLLED="yes"/NM_CONTROLLED="no"/' < ifcfg-eth2 > ifcfg-ethA
			echo 'BOOTPROTO="static"' >> ifcfg-ethA
			echo 'IPADDR="192.168.1.1"' >> ifcfg-ethA
			echo 'NETMASK="255.255.255.0"' >> ifcfg-ethA
			echo 'GATEWAY="192.168.1.254"' >> ifcfg-ethA
			sed 's/DEVICE="eth3"/DEVICE="eth1"/' < ifcfg-eth3 > ifcfg-ethB
			mv -f ifcfg-ethB ifcfg-eth3
			sed 's/NM_CONTROLLED="yes"/NM_CONTROLLED="no"/' < ifcfg-eth3 > ifcfg-ethB
			sed 's/DEVICE="eth0"/DEVICE="eth2"/' < ifcfg-eth0 > ifcfg-ethC
			mv -f ifcfg-ethC ifcfg-eth0
			sed 's/NM_CONTROLLED="yes"/NM_CONTROLLED="no"/' < ifcfg-eth0 > ifcfg-ethC
			sed 's/DEVICE="eth1"/DEVICE="eth3"/' < ifcfg-eth1 > ifcfg-ethD
			mv -f ifcfg-ethD ifcfg-eth1
			sed 's/NM_CONTROLLED="yes"/NM_CONTROLLED="no"/' < ifcfg-eth1 > ifcfg-ethD
			mv -f ifcfg-ethA ifcfg-eth0
			mv -f ifcfg-ethB ifcfg-eth1
			mv -f ifcfg-ethC ifcfg-eth2
			mv -f ifcfg-ethD ifcfg-eth3
			sed 's/NAME="eth0"/NAME="ethC"/' < $UDEVRULE > $UDEVRULE.tmp
			mv -f $UDEVRULE.tmp $UDEVRULE
			sed 's/NAME="eth1"/NAME="ethD"/' < $UDEVRULE > $UDEVRULE.tmp
			mv -f $UDEVRULE.tmp $UDEVRULE 
			sed 's/NAME="eth2"/NAME="eth0"/' < $UDEVRULE > $UDEVRULE.tmp
			mv -f $UDEVRULE.tmp $UDEVRULE 
			sed 's/NAME="eth3"/NAME="eth1"/' < $UDEVRULE > $UDEVRULE.tmp
			mv -f $UDEVRULE.tmp $UDEVRULE
			sed 's/NAME="ethC"/NAME="eth2"/' < $UDEVRULE > $UDEVRULE.tmp
			mv -f $UDEVRULE.tmp $UDEVRULE 
			sed 's/NAME="ethD"/NAME="eth3"/' < $UDEVRULE > $UDEVRULE.tmp
			mv -f $UDEVRULE.tmp $UDEVRULE
		# all other appliances with two planar ethernet ports 
		elif [[ "$num_devices" = '2' ]]; then
			cd /mnt/sysimage/etc/sysconfig/network-scripts 
			sed 's/ONBOOT="no"/ONBOOT="yes"/' < ifcfg-eth0 > ifcfg-ethA
			mv -f ifcfg-ethA ifcfg-eth0		
			sed 's/NM_CONTROLLED="yes"/NM_CONTROLLED="no"/' < ifcfg-eth0 > ifcfg-ethA
			mv -f ifcfg-ethA ifcfg-eth0	
			echo 'BOOTPROTO="static"' >> ifcfg-eth0
			echo 'IPADDR="192.168.1.1"' >> ifcfg-eth0
			echo 'NETMASK="255.255.255.0"' >> ifcfg-eth0
			echo 'GATEWAY="192.168.1.254"' >> ifcfg-eth0
		fi
	fi	
}

function genSNMPconf {
# set snmpd log verbosity level to LOG_WARNING
echo 'OPTIONS="-Ls4d -Lf /dev/null -p /var/run/snmpd.pid -a"' >> /mnt/sysimage/etc/sysconfig/snmpd.options
mv /mnt/sysimage/etc/snmp/snmpd.conf /mnt/sysimage/etc/snmp/snmpd.conf.el5.oem
local CONF='/mnt/sysimage/etc/snmp/snmpd.conf' 
echo '#--------------------------------------------------------------------------------------------' > $CONF
echo '# sample netwitness snmpd.conf file' >> $CONF
echo '#' >> $CONF
echo '# the snmpd daemon is disabled by default, start command: /sbin/service snmpd start' >> $CONF
echo '# to enable snmpd startup on boot: chkconfig snmpd on' >> $CONF 
echo '#' >> $CONF
echo '# for more configuration information see "man 5 snmpd.conf" or visit http://www.net-snmp.org' >> $CONF
echo '# the OEM packaged snmpd.conf file has some good examples: /etc/snmpd/snmpd.el5.oem' >> $CONF
echo '#' >> $CONF
echo '# please be aware that there are some security implications associated with SNMP' >> $CONF
echo '# versions 1 & 2c send authentication strings in clear text, version 3 does have support' >> $CONF
echo '# for encrypted communications but, is not fully implemented for all devices' >> $CONF
echo '# please see http://www.cert.org/tech_tips/snmp_faq.html' >> $CONF
echo '#--------------------------------------------------------------------------------------------' >> $CONF
echo '#' >> $CONF
echo '# agent listening address definition, usage:' >> $CONF
echo '# agentaddress [<transport-specifier>:]<transport-address>[,...]' >> $CONF
echo '# by default snmpd listens on all IPv4 interfaces for UDP:161 traffic' >> $CONF
echo "# specify your listening interface's IPv4 hostname or address here, typically eth0" >> $CONF
echo '# see the "LISTENING ADDRESSES" section in "man snmpd" for detailed configuration options' >> $CONF
echo '#agentaddress 192.168.1.1' >> $CONF
echo '#' >> $CONF
echo '# enable agentx protocol for netwitness appliance service, requires opening udp port 161 in firewall configuration' >> $CONF
echo '#master	agentx' >> $CONF
echo '#' >> $CONF
echo '# add your system location by editing undisclosed, enclose multi word strings with quotes' >> $CONF
echo 'syslocation undisclosed' >> $CONF
echo '#' >> $CONF
echo '# add your system contact by editing undisclosed, enclose multi word strings with quotes' >> $CONF
echo 'syscontact undisclosed' >> $CONF
echo '#' >> $CONF
echo '# SNMPv1/SNMPv2c read-only community definition, usage:' >> $CONF
echo '# rocommunity community_name [restricted hostname | IP address  | network/bits ] [allowed oid]' >> $CONF
echo '# default behavior is to allow connections from any host to all oid' >> $CONF 
echo 'rocommunity netwitness' >> $CONF
echo '#' >> $CONF
echo '# SNMPv3 user definition, useage:' >> $CONF
echo '# createUser [-e ENGINEID] username (MD5|SHA) authpassphrase [DES|AES] [privpassphrase]' >> $CONF
echo '# required for sending traps' >> $CONF
echo '#createUser trapper SHA p955w0rd' >> $CONF
echo '#' >> $CONF
echo '# simple read-only access control definition, usage:' >> $CONF
echo '# rouser USER [noauth|auth|priv [OID | -V VIEW [CONTEXT]]]' >> $CONF
echo '# required for sending traps' >> $CONF
echo '#rouser trapper auth' >> $CONF
echo '#' >> $CONF 
echo '# process monitoring definitions, usage:' >> $CONF
echo '# proc process_name maximum_running minimum_running' >> $CONF
echo 'proc  nwappliance 1 1' >> $CONF

# determine appliance type
if [[ `rpm -q nwlogdecoder | grep -E 'nwlogdecoder-[0-9]+\.[0-9]+\.[0-9]+'` ]]; then
     appliance_type='Panorama'
elif [[ `rpm -q nwbroker | grep -E 'nwbroker-[0-9]+\.[0-9]+\.[0-9]+'` && ! `rpm -q nwspectrum-server | grep -E 'nwspectrum-server-[0-9]+\.[0-9]+\.[0-9]+'` ]]; then
     appliance_type='Broker'
elif [[ `rpm -q nwconcentrator | grep -E 'nwconcentrator-[0-9]+\.[0-9]+\.[0-9]+'` && ! `rpm -q nwdecoder | grep -E 'nwdecoder-[0-9]+\.[0-9]+\.[0-9]+'` ]]; then
    appliance_type='Concentrator'
elif [[ `rpm -q nwdecoder | grep -E 'nwdecoder-[0-9]+\.[0-9]+\.[0-9]+'` && ! `rpm -q nwconcentrator | grep -E 'nwconcentrator-[0-9]+\.[0-9]+\.[0-9]+'` && ! `rpm -q nwspectrum-server | grep -E 'nwspectrum-server-[0-9]+\.[0-9]+\.[0-9]+'` ]]; then
    appliance_type='Decoder'
elif [[ `rpm -q nwdecoder | grep -E 'nwdecoder-[0-9]+\.[0-9]+\.[0-9]+'` && `rpm -q nwconcentrator | grep -E 'nwconcentrator-[0-9]+\.[0-9]+\.[0-9]+'` ]]; then
    appliance_type='Hybrid' 
elif [[ `rpm -q nwbroker | grep -E 'nwbroker-[0-9]+\.[0-9]+\.[0-9]+'` && `rpm -q nwspectrum-server | grep -E 'nwspectrum-server-[0-9]+\.[0-9]+\.[0-9]+'` ]]; then
     appliance_type='SpecBroker'
elif [[ `rpm -q nwdecoder | grep -E 'nwdecoder-[0-9]+\.[0-9]+\.[0-9]+'` && `rpm -q nwspectrum-server | grep -E 'nwspectrum-server-[0-9]+\.[0-9]+\.[0-9]+'` ]]; then
     appliance_type='SpecDecoder'
fi

# set up process monitoring config
if [[ "$appliance_type" = 'Concentrator' ]]; then
    echo "proc nwconcentrator 1 1" >> $CONF	
elif [[ "$appliance_type" = 'Decoder' ]]; then
    echo 'proc nwdecoder 1 1' >> $CONF
elif [[ "$appliance_type" = 'Hybrid' ]]; then
    echo 'proc nwconcentrator 1 1' >> $CONF
    echo 'proc nwdecoder 1 1' >> $CONF
elif [[ "$appliance_type" = 'Panorama' ]]; then
    echo 'proc nwlogdecoder 1 1' >> $CONF 
elif [[ "$appliance_type" = 'Broker' ]]; then
    echo 'proc nwbroker 1 1' >> $CONF
elif [[ "$appliance_type" = 'SpecBroker' ]]; then
    echo 'proc nwbroker 1 1' >> $CONF 
    echo 'proc postmaster' >> $CONF
    echo 'proc java 1 1' >> $CONF
elif [[ "$appliance_type" = 'SpecDecoder' ]]; then
    echo 'proc nwdecoder 1 1' >> $CONF
    echo 'proc postmaster' >> $CONF
    echo 'proc java 1 1' >> $CONF
fi    
echo '#' >> $CONF

# set up disk monitoring config
echo '# disk space monitoring definition, usage:' >> $CONF
echo '# disk mount_point minimum_kb | minimum_percentage%' >> $CONF
echo 'disk / 10%' >> $CONF
echo 'disk /tmp 10%' >> $CONF
echo 'disk /var 10%' >> $CONF
echo 'disk /var/netwitness 10%' >> $CONF
if [[ "$appliance_type" = 'Concentrator' ]]; then
    echo 'disk /var/netwitness/concentrator 10%' >> $CONF
    echo 'disk /var/netwitness/concentrator/index 10%' >> $CONF
    echo 'disk /var/netwitness/concentrator/metadb 5%' >> $CONF
    echo 'disk /var/netwitness/concentrator/sessiondb 5%' >> $CONF
elif [[ "$appliance_type" = 'Decoder' ]]; then
    echo 'disk /var/netwitness/decoder 10%' >> $CONF
    echo 'disk /var/netwitness/decoder/index 5%' >> $CONF 
    echo 'disk /var/netwitness/decoder/metadb 5%' >> $CONF
    echo 'disk /var/netwitness/decoder/sessiondb 5%' >> $CONF
    echo 'disk /var/netwitness/decoder/packetdb 5%' >> $CONF 
elif [[ "$appliance_type" = 'Hybrid' ]]; then
    echo 'disk /var/netwitness/concentrator 10%' >> $CONF
    echo 'disk /var/netwitness/concentrator/index 10%' >> $CONF
    echo 'disk /var/netwitness/concentrator/metadb 5%' >> $CONF
    echo 'disk /var/netwitness/concentrator/sessiondb 5%' >> $CONF
    echo 'disk /var/netwitness/decoder 10%' >> $CONF  
    echo 'disk /var/netwitness/decoder/metadb 5%' >> $CONF
    echo 'disk /var/netwitness/decoder/sessiondb 5%' >> $CONF
    echo 'disk /var/netwitness/decoder/packetdb 5%' >> $CONF 
elif [[ "$appliance_type" = 'Broker' ]]; then
    echo 'disk /var/netwitness/broker 10%' >> $CONF
elif [[ "$appliance_type" = 'Panorama' ]]; then
    echo 'disk /var/netwitness/logdecoder 10%' >> $CONF
    echo 'disk /var/netwitness/logdecoder/index 5%' >> $CONF 
    echo 'disk /var/netwitness/logdecoder/metadb 5%' >> $CONF
    echo 'disk /var/netwitness/logdecoder/sessiondb 5%' >> $CONF
    echo 'disk /var/netwitness/logdecoder/packetdb 5%' >> $CONF 
elif [[ "$appliance_type" = 'SpecBroker' ]]; then
    echo 'disk /var/netwitness/broker 10%' >> $CONF
    echo 'disk /var/lib/netwitness 10%' >> $CONF
    echo 'disk /var/lib/database 10%' >> $CONF
elif [[ "$appliance_type" = 'SpecDecoder' ]]; then
    echo 'disk /var/netwitness/decoder 10%' >> $CONF
    echo 'disk /var/netwitness/decoder/index 5%' >> $CONF 
    echo 'disk /var/netwitness/decoder/metadb 5%' >> $CONF
    echo 'disk /var/netwitness/decoder/sessiondb 5%' >> $CONF
    echo 'disk /var/netwitness/decoder/packetdb 5%' >> $CONF
    echo 'disk /var/lib/netwitness 10%' >> $CONF
    echo 'disk /var/lib/database 10%' >> $CONF 
fi 
echo '#' >> $CONF
echo '# system load monitoring definition, usage:' >> $CONF
echo '# load MAX1 [MAX5 [MAX15]]' >> $CONF
echo '# values are maximum load averages for 1, 5 and 15 minute intervals' >> $CONF
echo '#load 100 95 90' >> $CONF
echo '#' >> $CONF
echo '# swap space monitoring definition, usage:' >> $CONF
echo '# swap MIN kb' >> $CONF
echo 'swap 1258291' >> $CONF
echo '#' >> $CONF
echo '# trap community definition, usage:' >> $CONF
echo '# trapcommunity community_name' >> $CONF
echo '# default sending community for traps' >> $CONF
echo '#trapcommunity netwitness' >> $CONF
echo '#' >> $CONF
echo '# SNMPv2c trap sink host definition, usage:' >> $CONF
echo '# trap2sink host | IP Address [COMMUNITY [PORT]]' >> $CONF
echo '# required for sending SNMPv2c traps' >> $CONF
echo "# specify your SNMPv2c manager's IPv4 host name or address here" >> $CONF
echo '#trap2sink localhost' >> $CONF
echo '#' >> $CONF
echo '# system monitor user definition, usage:' >> $CONF
echo '# agentSecName NAME' >> $CONF
echo '# required for sending traps' >> $CONF
echo '#agentSecName trapper' >> $CONF
echo '#' >> $CONF
echo '# system monitoring definition, usage:' >> $CONF
echo '# monitor [OPTIONS] NAME EXPRESSION' >> $CONF
echo '# required for traps, see "man 5 snmpd.conf" for configuration details' >> $CONF 
echo '# disk monitoring' >> $CONF
echo '#monitor -D -u trapper -r 60 -o dskPath -o dskTotal -o dskErrorMsg "Volume Free Space" dskErrorFlag 0 1' >> $CONF
echo '# process monitoring' >> $CONF
echo '#monitor -D -u trapper -r 30 -i -o prNames.1 -o prCount.1 -o prErrMessage.1 "Process nwappliance" prErrorFlag.1 0 1' >> $CONF
if [[ "$appliance_type" = 'Concentrator' ]]; then
    echo '#monitor -D -u trapper -r 30 -i -o prNames.2 -o prCount.2 -o prErrMessage.2 "Process nwconcentrator" prErrorFlag.2 0 1' >> $CONF
elif [[ "$appliance_type" = 'Decoder' ]]; then
    echo '#monitor -D -u trapper -r 30 -i -o prNames.2 -o prCount.2 -o prErrMessage.2 "Process nwdecoder" prErrorFlag.2 0 1' >> $CONF
elif [[ "$appliance_type" = 'Panorama' ]]; then
    echo '#monitor -D -u trapper -r 30 -i -o prNames.2 -o prCount.2 -o prErrMessage.2 "Process nwlogdecoder" prErrorFlag.2 0 1' >> $CONF
elif [[ "$appliance_type" = 'Hybrid' ]]; then
    echo '#monitor -D -u trapper -r 30 -i -o prNames.2 -o prCount.2 -o prErrMessage.2 "Process nwconcentrator" prErrorFlag.2 0 1' >> $CONF
    echo '#monitor -D -u trapper -r 30 -i -o prNames.3 -o prCount.3 -o prErrMessage.3 "Process nwdecoder" prErrorFlag.3 0 1' >> $CONF
elif [[ "$appliance_type" = 'Broker' ]]; then
    echo '#monitor -D -u trapper -r 30 -i -o prNames.2 -o prCount.2 -o prErrMessage.2 "Process nwbroker" prErrorFlag.2 0 1' >> $CONF
elif [[ "$appliance_type" = 'SpecBroker' ]]; then
    echo '#monitor -D -u trapper -r 30 -i -o prNames.2 -o prCount.2 -o prErrMessage.2 "Process nwbroker" prErrorFlag.2 0 1' >> $CONF
    echo '#monitor -D -u trapper -r 30 -i -o prNames.3 -o prCount.3 -o prErrMessage.3 "Process postmaster" prErrorFlag.3 0 1' >> $CONF
    echo '#monitor -D -u trapper -r 30 -i -o prNames.4 -o prCount.4 -o prErrMessage.4 "Process java" prErrorFlag.4 0 1' >> $CONF
elif [[ "$appliance_type" = 'SpecDecoder' ]]; then
    echo '#monitor -D -u trapper -r 30 -i -o prNames.2 -o prCount.2 -o prErrMessage.2 "Process nwdecoder" prErrorFlag.2 0 1' >> $CONF
    echo '#monitor -D -u trapper -r 30 -i -o prNames.3 -o prCount.3 -o prErrMessage.3 "Process postmaster" prErrorFlag.3 0 1' >> $CONF
    echo '#monitor -D -u trapper -r 30 -i -o prNames.4 -o prCount.4 -o prErrMessage.4 "Process java" prErrorFlag.4 0 1' >> $CONF
fi 
}

function getcompid {
# get nw computerid and write it to /tmp/nwcompid.txt
	echo ' starting nwappliance service, determining computer id' >> /dev/tty1
	sleep 5
	chvt 2
	chroot /mnt/sysimage /sbin/service network stop 
	sleep 5
	chroot /mnt/sysimage /sbin/service network start
	sleep 5
	chroot /mnt/sysimage /usr/bin/nohup /usr/sbin/NwAppliance > /dev/null 2>&1 &
	# give appliance service time to start
	sleep 20
	echo . . . > /dev/tty2
	# configure crystal fontz usb display panel on SM 1U and eagle
	if ! [[ -z $1 ]] && [[ `echo $1 | grep -i 'crystalfontz'` ]]; then
		echo 'login localhost.localdomain:50006 admin netwitness' > /mnt/sysimage/root/cmd.txt
		echo 'set /appliance/config/display.port /dev/ttyUSB0' >> /mnt/sysimage/root/cmd.txt
		echo 'exit' >> /mnt/sysimage/root/cmd.txt
		chroot /mnt/sysimage /usr/bin/NwConsole -f /root/cmd.txt 
	        rm -f /mnt/sysimage/root/cmd.txt
	fi 
	echo 'login localhost.localdomain:50006 admin netwitness' > /mnt/sysimage/root/cmd2.txt
	echo 'cd sys/stats' >> /mnt/sysimage/root/cmd2.txt
	echo 'ls' >> /mnt/sysimage/root/cmd2.txt
	echo 'exit' >> /mnt/sysimage/root/cmd2.txt
	chroot /mnt/sysimage /usr/bin/NwConsole -f /root/cmd2.txt > /tmp/nwcompid 2>&1 
	chroot /mnt/sysimage /usr/bin/killall NwAppliance
	sleep 5
	echo . . . > /dev/tty2
	chroot /mnt/sysimage /sbin/service network stop
	clear
	chvt 1
        rm -f /mnt/sysimage/root/cmd2.txt
	if [[ `grep -i 'computer id' /tmp/nwcompid` ]]; then
		compID=`grep -i 'computer id' /tmp/nwcompid | awk -F= '{print $2}'`
	       	echo "Computer ID: $compID"  > /tmp/nwcompid.txt
	fi 
} 

function enable_ipv6_drv {
	# enable IPV6 drivers if disabled
	MODCONF='/mnt/sysimage/etc/modprobe.conf'
	if [[ `grep -E -i 'net-pf-10 +off' $MODCONF` ||`grep -E -i 'ipv6 +off' $MODCONF` || `grep -E -i 'ipv6 +disable=1' $MODCONF` ]]; then
		cp $MODCONF $MODCONF.el5.oem
		sed -r 's/^ *alias +net-pf-10 +off/#alias inet-pf-10 off/' < $MODCONF > $MODCONF.tmp
		mv -f $MODCONF.tmp $MODCONF
		sed -r 's/^ *alias +ipv6 +off/#alias ipv6 off/' < $MODCONF > $MODCONF.tmp
		mv -f $MODCONF.tmp $MODCONF
		sed -r 's/^ *options +ipv6 +disable=1/#options ipv6 disable=1/' < $MODCONF > $MODCONF.tmp
		mv -f $MODCONF.tmp $MODCONF 
	fi 
} 		

function get_swraid_dev {
# wait for system mirror devices to finish synchronizing
	local mirrors
	local resyncs
	local mirror
	local count
	local device
	local usrchoice
	local exitCode

	mirrors=( `grep -E 'md[0-9][[:space:]]+:[[:space:]]+.*raid1' /proc/mdstat | awk '{print $1}'` )
	let count=0
	for mirror in ${mirrors[@]}
	do
		if [[ `mdadm --detail /dev/$mirror | grep -i 'State :' | grep -i -E 're(cover|sync)ing'` ]]; then
			resyncs[$count]=$mirror
		fi
	done
	echo "resyncing mirror devices = ${resyncs[@]}" | tee -a /tmp/post.log > /dev/tty3
	chvt 3
	echo > /dev/tty3
	exec < /dev/tty3 > /dev/tty3 2>&1
	# attempt waiting for each mirror resync
	for device in ${resyncs[@]}
	do
		echo "attempting to wait for software raid resync: /dev/$device" >> /tmp/post.log
		date -u >> /tmp/post.log
		nohup mdadm --misc -W /dev/$device > /dev/null 2>&1 &
		exitCode=$?
		if [ $exitCode != 0 ]; then
			echo "mdadm failed to wait for /dev/$device, returned: $exitCode" >> /tmp/post.log
		else
			while [ 1 ]
			do
				if [[ `ps aux | grep -E "[[:digit:]]+[[:space:]]+mdadm --misc -W /dev/$device"` ]]; then
					echo > /dev/tty3
					echo ' waiting for system mirror synchronization to complete' > /dev/tty3
					cat /proc/mdstat | grep -A2 "$device" > /dev/tty3
					echo ' Enter b within 60 seconds to background task' > /dev/tty3
					read -p ' ?' -t 60 usrchoice
					if [[ $usrchoice = b || $usrchoice = B ]]; then
						echo "resync of raid device /dev/$device cancelled by user" >> /tmp/post.log
						break
					fi
				else
					break
				fi
 
			done
			echo "completed system RAID sync attempt of /dev/$device" >> /tmp/post.log
			date -u >> /tmp/post.log
		fi
	done
	chvt 1
}

function config_spectrum {
# install mp software in %post requires: sudo,tmpwatch and postgresql to be installed first	
	echo ' installing applications, keep install media connected until prompted to reboot' > /dev/tty1 
	
	local opticalMedia=
	local hddMedia=
	local urlMedia=
	local installUrl=
	local strLen=
	local lastChar=

	if [[ `dmesg | grep -i 'kernel command line' | grep 'ks=cdrom'` ]]; then
		opticalMedia='true'
	elif [[ `dmesg | grep -i 'kernel command line' | grep 'ks=hd'` ]]; then
		hddMedia='true'
	elif [[ `dmesg | grep -i 'kernel command line' | grep 'ks=http'` ]]; then
		urlMedia='true'
		installUrl=`dmesg | grep -i 'kernel command line' | awk -F'ks=' '{print $2}' | awk '{print $1}'`
		installUrl=${installUrl%/*}
		echo "config_spectrum(): installUrl = $installUrl" >> /tmp/post.log
		let strLen=${#installUrl}
		let strLen=$strLen-1
		lastChar=${installUrl:$strLen}
		if [[ "$lastChar" != '/' ]]; then
			lastChar='/'
			installUrl="$installUrl$lastChar"
		fi
	fi

	# create temporary yum conf file
	YUMCFG='/mnt/sysimage/root/yum.conf.tmp'
	echo '[main]' > $YUMCFG
	echo 'cachedir=/var/cache/yum' >> $YUMCFG
	echo 'keepcache=0' >> $YUMCFG
	echo 'debuglevel=2' >> $YUMCFG
	echo 'logfile=/var/log/yum.log' >> $YUMCFG
	echo 'distroverpkg=redhat-release' >> $YUMCFG
	echo 'tolerant=1' >> $YUMCFG
	echo 'exactarch=1' >> $YUMCFG
	echo 'obsoletes=1' >> $YUMCFG
	echo 'gpgcheck=1' >> $YUMCFG
	echo 'plugins=1' >> $YUMCFG
	echo 'metadata_expire=1h' >> $YUMCFG
	echo '[fbase]' >> $YUMCFG
	echo 'name=centos-6.x-x86_64-base' >> $YUMCFG 
	
	if [[ $opticalMedia || $hddMedia ]]; then
		echo 'baseurl=file:///mnt/' >> $YUMCFG
		echo 'gpgcheck=0' >> $YUMCFG
		echo 'enabled=1' >> $YUMCFG 
	elif [[ $urlMedia ]]; then
		echo "baseurl=$installUrl" >> $YUMCFG
		echo 'gpgcheck=0' >> $YUMCFG
		echo 'enabled=1' >> $YUMCFG 
	fi 
 
	if [ $opticalMedia ]; then
	    if [[ `mount | grep '/mnt/source'` ]]; then
      		  umount /mnt/source
	    fi		
	    mount -t iso9660 -o ro /dev/sr0 /mnt/sysimage/mnt
	elif [ $hddMedia ]; then	
		cd /mnt/isodir
		local myiso=`ls *.iso | awk '{print $1}'`
		mount -o loop /mnt/isodir/$myiso /mnt/sysimage/mnt
	fi
	sleep 2

	#chroot /mnt/sysimage /usr/bin/yum -c /root/yum.conf.tmp --disablerepo=base,extras,updates -y install postgresql91-server 
	chroot /mnt/sysimage /sbin/service postgresql-9.1 initdb
	chroot /mnt/sysimage /sbin/chkconfig postgresql-9.1 on
	#chroot /mnt/sysimage /usr/bin/yum -c /root/yum.conf.tmp --disablerepo=base,extras,updates -y install @rsa-sa-malware-analysis
	chroot /mnt/sysimage /usr/bin/yum -c /root/yum.conf.tmp --disablerepo=base,extras,updates -y install rsaMalwareDevice
	
	rm -f $YUMCFG
	if [[ `mount | grep '/mnt/sysimage/mnt'` ]]; then
		umount /mnt/sysimage/mnt
	fi
} 

function config_uax {
# setup sa server system environment
	
	local opticalMedia
	local hddMedia
	local urlMedia
	local installUrl
	local strLen
	local lastChar
	local mypwd=`pwd`
	local MYREPO='/var/netwitness/srv/www/rsa/updates/RemoteRPMs/sa/'
	local MYMETA='/var/netwitness/srv/www/rsa/updates/'
	local YUMCFG

	# create logging path
	mkdir -p /mnt/sysimage/var/lib/netwitness/uax/logs
	
	# clone media software repository to SA UI repo
	if [[ `dmesg | grep -i 'kernel command line' | grep 'ks=cdrom'` ]]; then
		opticalMedia='true'
	elif [[ `dmesg | grep -i 'kernel command line' | grep 'ks=hd'` ]]; then
		hddMedia='true'
	elif [[ `dmesg | grep -i 'kernel command line' | grep 'ks=http'` ]]; then
		urlMedia='true'
		installUrl=`dmesg | grep -i 'kernel command line' | awk -F'ks=' '{print $2}' | awk '{print $1}'`
		installUrl=${installUrl%/*}
		echo "setuplogcoll: installUrl = $installUrl" >> /tmp/post.log
		let strLen=${#installUrl}
		let strLen=$strLen-1
		lastChar=${installUrl:$strLen}
		if [[ "$lastChar" != '/' ]]; then
			lastChar='/'
			installUrl="$installUrl$lastChar"
		fi

		# convert to python string for dir parsing
		pyinstallUrl="\"${installUrl}\""
		echo "config_uax: pyinstallUrl = $pyinstallUrl" | tee -a /tmp/post.log >> /dev/tty3
	fi
	
	# create temporary yum conf file
	YUMCFG='/mnt/sysimage/root/yum.conf.tmp'
	echo '[main]' > $YUMCFG
	echo 'cachedir=/var/cache/yum' >> $YUMCFG
	echo 'keepcache=0' >> $YUMCFG
	echo 'debuglevel=2' >> $YUMCFG
	echo 'logfile=/var/log/yum.log' >> $YUMCFG
	echo 'distroverpkg=redhat-release' >> $YUMCFG
	echo 'tolerant=1' >> $YUMCFG
	echo 'exactarch=1' >> $YUMCFG
	echo 'obsoletes=1' >> $YUMCFG
	echo 'gpgcheck=1' >> $YUMCFG
	echo 'plugins=1' >> $YUMCFG
	echo 'metadata_expire=1h' >> $YUMCFG
	echo '[fbase]' >> $YUMCFG
	echo 'name=centos-6.x-x86_64-base' >> $YUMCFG 
	
	if [[ $opticalMedia || $hddMedia ]]; then
		echo 'baseurl=file:///mnt/' >> $YUMCFG
		echo 'gpgcheck=0' >> $YUMCFG
		echo 'enabled=1' >> $YUMCFG 
	elif [[ $urlMedia ]]; then
		echo "baseurl=$installUrl" >> $YUMCFG
		echo 'gpgcheck=0' >> $YUMCFG
		echo 'enabled=1' >> $YUMCFG 
	fi
	
	# ensure repo path
	mkdir -p /mnt/sysimage${MYREPO}	
	
	if [ $opticalMedia ]; then
		if [[ `mount | grep '/mnt/source'` ]]; then
			umount /mnt/source
		fi		
		mount -t iso9660 -o ro /dev/sr0 /mnt/sysimage/mnt
		chroot /mnt/sysimage /usr/bin/yum -c /root/yum.conf.tmp --disablerepo=base,extras,updates -y install rsa-audit-plugins
		cp -p /mnt/sysimage/mnt/Packages/*.rpm /mnt/sysimage${MYREPO} 
		chroot /mnt/sysimage /usr/bin/createrepo $MYREPO -o $MYMETA
		umount /mnt/sysimage/mnt
	elif [ $hddMedia ]; then	
		cd /mnt/isodir
		local myiso=`ls *.iso | awk '{print $1}'`
		mount -o loop /mnt/isodir/$myiso /mnt/sysimage/mnt
		chroot /mnt/sysimage /usr/bin/yum -c /root/yum.conf.tmp --disablerepo=base,extras,updates -y install rsa-audit-plugins
		cp -p /mnt/sysimage/mnt/Packages/*.rpm /mnt/sysimage${MYREPO} 
		chroot /mnt/sysimage /usr/bin/createrepo $MYREPO -o $MYMETA
		umount /mnt/sysimage/mnt
	elif [ $urlMedia ]; then
		chroot /mnt/sysimage /usr/bin/yum -c /root/yum.conf.tmp --disablerepo=base,extras,updates -y install rsa-audit-plugins
		cd /mnt/sysimage${MYREPO} 
		numcuts=`python -c "mystr = $pyinstallUrl; mylist = mystr.split( '/' ); mylistlen = len( mylist ); print mylistlen - 3"` 	 
		wget -r -np -nH -A '*.rpm' --cut-dirs=$numcuts ${installUrl}
		chroot /mnt/sysimage /usr/bin/createrepo $MYREPO -o $MYMETA
		cd $mypwd
	fi
	sleep 2
	#chroot /mnt/sysimage /usr/bin/yum -c /root/yum.conf.tmp --disablerepo=base,extras,updates -y install security-analytics-web-server 
	#rm -f ${YUMCFG}
	mkdir /mnt/sysimage/root/rpms
	cd /mnt/sysimage/root/rpms
	cp /mnt/sysimage${MYREPO}/mongodb-org-*.rpm .
	cp /mnt/sysimage${MYREPO}/security-analytics-web-server-11*.noarch.rpm .
	chroot /mnt/sysimage /bin/rpm -i /root/rpms/*.rpm
	myname=`grep -i -E '^[[:space:]]*HOSTNAME' /mnt/sysimage/etc/sysconfig/network | awk -F= '{print $2}' | awk '{print $1}'`
	echo "myname = $myname" >> /tmp/post.log
	chroot /mnt/sysimage /sbin/sysctl kernel.hostname=$myname 
	echo ' installing applications, keep install media connected until prompted to reboot' > /dev/tty1
	sleep 2
	local TMPWATCH='/mnt/sysimage/etc/cron.daily/tmpwatch'
	sed -r 's/(^[[:space:]]*)(.*[[:space:]]+)([0-9]+[dhm]*[[:space:]]+\/tmp[[:space:]]*$)/\1\2\\\n\1-x \/tmp\/jetty\-0\.0\.0\.0\-7000\-root\.war\-_\-any\- \3/' < $TMPWATCH > $TMPWATCH.tmp 
	mv -f $TMPWATCH.tmp $TMPWATCH
	chmod 755 $TMPWATCH 
	local CTLCFG='/mnt/sysimage/etc/sysctl.conf'
	if ! [ -e $CTLCFG.bkup ]; then
		cp $CTLCFG $CTLCFG.bkup
	else
		cp $CTLCFG $CTLCFG.bkup$RANDOM
	fi
	if [[ `grep -E '^[[:space:]]*fs\.file-max' $CTLCFG` ]]; then
		sed -r 's/(^[[:space:]]*fs\.file-max.*$)/#\1/' < $CTLCFG > $CTLCFG.tmp
		mv -f $CTLCFG.tmp $CTLCFG
	fi
	echo >> $CTLCFG
	
	if [ -z $1 ]; then
		echo '# RSA configuration, please do not edit' >> $CTLCFG
		echo 'fs.file-max = 16384' >> $CTLCFG
		local LIMITSCFG='/mnt/sysimage/etc/security/limits.conf'
		if ! [ -e $LIMITSCFG.bkup ]; then
			cp $LIMITSCFG $LIMITSCFG.bkup
		else
			cp $LIMITSCFG $LIMITSCFG.bkup$RANDOM
		fi
		sed 's/# End of file/#/' < "$LIMITSCFG" > "$LIMITSCFG.tmp"
		mv -f "$LIMITSCFG.tmp" "$LIMITSCFG"
		echo '# RSA configuration, please do not edit' >> $LIMITSCFG
		echo 'root	soft	nofile	8192' >> $LIMITSCFG
		echo 'root	hard	nofile	16384' >> $LIMITSCFG 
		echo '*	soft	nofile	8192' >> $LIMITSCFG
		echo '*	hard	nofile	16384' >> $LIMITSCFG 
		echo '# End of file' >> $LIMITSCFG
	fi
	
	# edit tokumx start script to fix disable kernel huge page error message bug
	#local TOKUINIT=/mnt/sysimage/etc/rc.d/init.d/tokumx
	#sed -r 's/\[[[:space:]]+"\$\?"[[:space:]]+=[[:space:]]+0[[:space:]]+\]/[ "$?" != 0 ]/' < $TOKUINIT > $TOKUINIT.tmp
	#mv -f $TOKUINIT.tmp $TOKUINIT
	#chmod 755 $TOKUINIT
	
	#chroot /mnt/sysimage /sbin/chkconfig tokumx on
}

function setSpectrumTunables {
# setup malware analysis system environment
	local LIMITSCFG='/mnt/sysimage/etc/security/limits.conf'
	cp "$LIMITSCFG" "$LIMITSCFG.eloem"
	sed 's/# End of file/#/' < "$LIMITSCFG" > "$LIMITSCFG.tmp"
	mv -f "$LIMITSCFG.tmp" "$LIMITSCFG"
	echo '# netwitness configuration, please do not edit' >> $LIMITSCFG
	echo '*		soft	nofile		4096' >> $LIMITSCFG
	echo '*		hard	nofile		65536' >> $LIMITSCFG
	# next two lines new in spectrum 1.2
	echo '*		soft	nproc		65536' >> $LIMITSCFG
	echo '*		hard	nproc		unlimited' >> $LIMITSCFG
	echo '# End of file' >> $LIMITSCFG
	# next three lines new in spectrum 1.2
	local DEFAULTLIM='/mnt/sysimage/etc/security/limits.d/90-nproc.conf'
	mv -f $DEFAULTLIM $DEFAULTLIM.eloem
	sed -r 's/(^[[:space:]]*)\*([[:space:]]+)soft([[:space:]]+)nproc([[:space:]]+)[[:digit:]]+[[:space:]]*$/\n# rsa configuration please do not edit\n\1*\2soft\3nproc\4unlimited/' < $DEFAULTLIM.eloem > $DEFAULTLIM
	local TMPWATCH='/mnt/sysimage/etc/cron.daily/tmpwatch'
	# next line was deprecated by spectrum 1.2
	#sed -r 's/(^[[:space:]]*)(.*[[:space:]]+)([0-9]+[dhm]*[[:space:]]+\/tmp[[:space:]]*$)/\1\2\\\n\1-x \/tmp\/jetty\-0\.0\.0\.0\-443\-root\.war\-_\-any\- \3\n\/usr\/sbin\/tmpwatch "\$flags" 60d \/var\/lib\/netwitness\/spectrum\/repository\/files/' < $TMPWATCH > $TMPWATCH.tmp
	sed -r 's/(^[[:space:]]*)(.*[[:space:]]+)([0-9]+[dhm]+)([[:space:]]+\/tmp[[:space:]]*$)/\1\2\\\n\1-x \/tmp\/jetty\-0\.0\.0\.0\-8443\-root\.war\-_\-any\- 1d \4/' < $TMPWATCH > $TMPWATCH.tmp
	mv -f $TMPWATCH.tmp $TMPWATCH
	chmod 755 $TMPWATCH
}

function specFileService {
# configure ftp and samba for mp file sharing	

	local specver="$1"
	SMBCONF='/mnt/sysimage/etc/samba/smb.conf'
	mv -f "$SMBCONF" "$SMBCONF.bkup$RANDOM"
	echo "# rsa malware smb configuration, guest and read only" >> $SMBCONF
	echo "[global]" >> $SMBCONF
	echo "workgroup = RSAMPSRV" >> $SMBCONF
	echo "netbios name =  RSAMPFS" >> $SMBCONF
	echo "local master = no" >> $SMBCONF
	echo "server string = RSA Malware Prevention File Share" >> $SMBCONF
	echo "security = share" >> $SMBCONF
	echo "syslog only = yes" >> $SMBCONF
	echo "max log size = 5120" >> $SMBCONF
	echo "[File Store]" >> $SMBCONF
	echo "comment = RSA Malware Prevention File Store Content" >> $SMBCONF
	# full version
	if [ -z $specver ]; then
		echo "path = /var/lib/rsamalware/spectrum/repository/files" >> $SMBCONF
	# collocated version
	else
		echo "path = /var/lib/netwitness/rsamalware/spectrum/repository/files" >> $SMBCONF
	fi	
	echo "read only = Yes" >> $SMBCONF
	echo "guest only = Yes" >> $SMBCONF
	#
	FTPCONF='/mnt/sysimage/etc/vsftpd/vsftpd.conf'
	mv -f "$FTPCONF" "$FTPCONF.bkup$RANDOM"
	echo "# rsa malware ftp configuration, anonymous and read only" >> $FTPCONF 
	echo "connect_from_port_20=YES" >> $FTPCONF 
	# full version
	if [ -z $specver ]; then
		echo "pasv_min_port=51024" >> $FTPCONF
		echo "pasv_max_port=51073" >> $FTPCONF
		echo "max_clients=50" >> $FTPCONF
		echo "anon_root=/var/lib/rsamalware/spectrum/repository/files" >> $FTPCONF
	# collocated version
	else
		echo "pasv_min_port=51024" >> $FTPCONF
		echo "pasv_max_port=51033" >> $FTPCONF 
		echo "max_clients=10" >> $FTPCONF
		echo "anon_root=/var/lib/netwitness/rsamalware/spectrum/repository/files" >> $FTPCONF
		if [ -d /mnt/sysimage/var/lib/rsamalware ]; then
			mv -f /mnt/sysimage/var/lib/rsamalware /mnt/sysimage/var/lib/netwitness/
			chroot /mnt/sysimage /bin/ln -s -t /var/lib netwitness/rsamalware
		fi
	fi	
	echo "listen=YES" >> $FTPCONF
	echo "ftpd_banner=[RSA Malware Prevention FTP Service] Name: anonymous Password: e-mail address" >> $FTPCONF 
	echo "hide_ids=YES" >> $FTPCONF
	echo "syslog_enable=YES" >> $FTPCONF
	echo "userlist_enable=YES" >> $FTPCONF
}

function config_esa {
# setup esa system environment	
	
	# fix race condtion with shadow-utils and mongo-server
        local opticalMedia=
	local hddMedia=
	local urlMedia=
	local installUrl=
	local strLen=
	local lastChar=

	if [[ `dmesg | grep -i 'kernel command line' | grep 'ks=cdrom'` ]]; then
		opticalMedia='true'
	elif [[ `dmesg | grep -i 'kernel command line' | grep 'ks=hd'` ]]; then
		hddMedia='true'
	elif [[ `dmesg | grep -i 'kernel command line' | grep 'ks=http'` ]]; then
		urlMedia='true'
		installUrl=`dmesg | grep -i 'kernel command line' | awk -F'ks=' '{print $2}' | awk '{print $1}'`
		installUrl=${installUrl%/*}
		echo "setuplogcoll: installUrl = $installUrl" >> /tmp/post.log
		let strLen=${#installUrl}
		let strLen=$strLen-1
		lastChar=${installUrl:$strLen}
		if [[ "$lastChar" != '/' ]]; then
			lastChar='/'
			installUrl="$installUrl$lastChar"
		fi
	fi

	# create temporary yum conf file
	YUMCFG='/mnt/sysimage/root/yum.conf.tmp'
	echo '[main]' > $YUMCFG
	echo 'cachedir=/var/cache/yum' >> $YUMCFG
	echo 'keepcache=0' >> $YUMCFG
	echo 'debuglevel=2' >> $YUMCFG
	echo 'logfile=/var/log/yum.log' >> $YUMCFG
	echo 'distroverpkg=redhat-release' >> $YUMCFG
	echo 'tolerant=1' >> $YUMCFG
	echo 'exactarch=1' >> $YUMCFG
	echo 'obsoletes=1' >> $YUMCFG
	echo 'gpgcheck=1' >> $YUMCFG
	echo 'plugins=1' >> $YUMCFG
	echo 'metadata_expire=1h' >> $YUMCFG
	echo '[fbase]' >> $YUMCFG
	echo 'name=centos-6.x-x86_64-base' >> $YUMCFG 
	
	if [[ $opticalMedia || $hddMedia ]]; then
		echo 'baseurl=file:///mnt/' >> $YUMCFG
		echo 'gpgcheck=0' >> $YUMCFG
		echo 'enabled=1' >> $YUMCFG 
	elif [[ $urlMedia ]]; then
		echo "baseurl=$installUrl" >> $YUMCFG
		echo 'gpgcheck=0' >> $YUMCFG
		echo 'enabled=1' >> $YUMCFG 
	fi 
 
	if [ $opticalMedia ]; then
	    if [[ `mount | grep '/mnt/source'` ]]; then
      		  umount /mnt/source
	    fi		
	    mount -t iso9660 -o ro /dev/sr0 /mnt/sysimage/mnt
	elif [ $hddMedia ]; then	
		cd /mnt/isodir
		local myiso=`ls *.iso | awk '{print $1}'`
		mount -o loop /mnt/isodir/$myiso /mnt/sysimage/mnt
	fi
	sleep 2
	echo ' installing applications, keep install media connected until prompted to reboot' > /dev/tty1
	sleep 2
	chroot /mnt/sysimage /usr/bin/yum -c /root/yum.conf.tmp --disablerepo=base,extras,updates -y install mongodb-org 
	rm -f $YUMCFG
 	if [[ `mount | grep '/mnt/sysimage/mnt'` ]]; then
		umount /mnt/sysimage/mnt
	fi	

	# end fix for package race condition

	MONGO_CONFIG_FILE='/mnt/sysimage/etc/mongod.conf'

	echo "update /etc/mongod.conf file to enable access from off box, and enable authorization"
	sed -i 's/  bindIp: 127.0.0.1/#  bindIp: 127.0.0.1/' ${MONGO_CONFIG_FILE}
	sed -i 's/#security:/security:/' ${MONGO_CONFIG_FILE}
	sed -i '/security:/a\\  authorization: enabled' ${MONGO_CONFIG_FILE}
	
	chroot /mnt/sysimage /sbin/service mongod start
	echo " configuring mongo database" | tee -a /tmp/post.log > /dev/tty1
	sleep 15
	
	echo "Create the admin account"| tee -a /tmp/post.log > /dev/tty1
	chroot /mnt/sysimage /usr/bin/mongo admin --eval "db.createUser({user: 'admin', pwd: 'netwitness', roles: ['readWriteAnyDatabase', 'userAdminAnyDatabase', 'dbAdminAnyDatabase']})"

	echo "Create the ESA MongoDB storage service account" | tee -a /tmp/post.log > /dev/tty1
	chroot /mnt/sysimage /usr/bin/mongo admin -u admin -p netwitness --eval "db.getSiblingDB('esa').createUser({user: 'esa', pwd:'esa', roles: ['readWrite', 'dbAdmin']})"

	echo "Create ESA MongoDB storage query(read-only) account" | tee -a /tmp/post.log > /dev/tty1
	chroot /mnt/sysimage /usr/bin/mongo admin -u admin -p netwitness --eval "db.getSiblingDB('esa').createUser({user: 'esa_query', pwd:'esa', roles: ['read']})"
	
	chroot /mnt/sysimage /sbin/service mongod stop
}

function volumeGroupScan {
# scan for volume groups, create missing device files and activate	

	chroot /mnt/sysimage /sbin/vgscan --mknodes | tee -a /tmp/post.log > /dev/tty3
	chroot /mnt/sysimage /sbin/vgck -v | tee -a /tmp/post.log > /dev/tty3
	chroot /mnt/sysimage /sbin/vgchange -a y --ignorelockingfailure | tee -a /tmp/post.log > /dev/tty3
	# maximize lvm logging verbosity for debugging purposes
	#mv -f /mnt/sysimage/etc/lvm/lvm.conf /mnt/sysimage/etc/lvm/lvm.conf.el5.oem
	#sed 's/verbose = 0/verbose = 3/' < /mnt/sysimage/etc/lvm/lvm.conf.el5.oem > /mnt/sysimage/etc/lvm/lvm.conf.tmp
	#sed 's/level = 0/level = 7/' < /mnt/sysimage/etc/lvm/lvm.conf.tmp > /mnt/sysimage/etc/lvm/lvm.conf
	#rm -f /mnt/sysimage/etc/lvm/lvm.conf.tmp 
}

function set_kernel_tunables {
# set common kernel parameters	

	local CTLCFG='/mnt/sysimage/etc/sysctl.conf'
	if [[ `grep -E '^[[:space:]]*vm.max_map_count' $CTLCFG` ]]; then
		cp $CTLCFG $CTLCFG.eloem
		sed 's/\(^[[:space:]]*vm.max_map_count.*\)/#\1/' < $CTLCFG > $CTLCFG.tmp
		mv -f $CTLCFG.tmp $CTLCFG
	fi
	echo >> $CTLCFG
	echo '# netwitness configuration, please do not edit' >> $CTLCFG
	echo 'vm.max_map_count = 1000000' >> $CTLCFG
}

function config_ipdbextractor {
# configure nwipdbextractor application environment    
    
    echo ' creating application environment, keep install media connected' >> /dev/tty1
    mkdir -p /mnt/sysimage/var/netwitness/ipdbextractor/ipdb
    mkdir -p /mnt/sysimage/etc/netwitness/ng/envision
    mkdir -p /mnt/sysimage/var/netwitness/ipdbextractor/devicelocation
}

function config_postgres_re {
# nstall re-server and configure postgresql database for reporting engine
 	
	local opticalMedia=
	local hddMedia=
	local urlMedia=
	local installUrl=
	local strLen=
	local lastChar=

	# add rsasoc user
	#chroot /mnt/sysimage /usr/sbin/useradd -M -d /home/rsasoc -s /bin/bash -U rsasoc
        chroot /mnt/sysimage /usr/sbin/useradd -m -d /home/rsasoc -s /bin/bash -U rsasoc
	echo 'rs@_.s0c' | chroot /mnt/sysimage /usr/bin/passwd --stdin rsasoc
	
	if [[ `dmesg | grep -i 'kernel command line' | grep 'ks=cdrom'` ]]; then
		opticalMedia='true'
	elif [[ `dmesg | grep -i 'kernel command line' | grep 'ks=hd'` ]]; then
		hddMedia='true'
	elif [[ `dmesg | grep -i 'kernel command line' | grep 'ks=http'` ]]; then
		urlMedia='true'
		installUrl=`dmesg | grep -i 'kernel command line' | awk -F'ks=' '{print $2}' | awk '{print $1}'`
		installUrl=${installUrl%/*}
		echo "setuplogcoll: installUrl = $installUrl" >> /tmp/post.log
		let strLen=${#installUrl}
		let strLen=$strLen-1
		lastChar=${installUrl:$strLen}
		if [[ "$lastChar" != '/' ]]; then
			lastChar='/'
			installUrl="$installUrl$lastChar"
		fi
	fi

	# create temporary yum conf file
	YUMCFG='/mnt/sysimage/root/yum.conf.tmp'
	echo '[main]' > $YUMCFG
	echo 'cachedir=/var/cache/yum' >> $YUMCFG
	echo 'keepcache=0' >> $YUMCFG
	echo 'debuglevel=2' >> $YUMCFG
	echo 'logfile=/var/log/yum.log' >> $YUMCFG
	echo 'distroverpkg=redhat-release' >> $YUMCFG
	echo 'tolerant=1' >> $YUMCFG
	echo 'exactarch=1' >> $YUMCFG
	echo 'obsoletes=1' >> $YUMCFG
	echo 'gpgcheck=1' >> $YUMCFG
	echo 'plugins=1' >> $YUMCFG
	echo 'metadata_expire=1h' >> $YUMCFG
	echo '[fbase]' >> $YUMCFG
	echo 'name=centos-6.x-x86_64-base' >> $YUMCFG 
	
	if [[ $opticalMedia || $hddMedia ]]; then
		echo 'baseurl=file:///mnt/' >> $YUMCFG
		echo 'gpgcheck=0' >> $YUMCFG
		echo 'enabled=1' >> $YUMCFG 
	elif [[ $urlMedia ]]; then
		echo "baseurl=$installUrl" >> $YUMCFG
		echo 'gpgcheck=0' >> $YUMCFG
		echo 'enabled=1' >> $YUMCFG 
	fi 
 
	if [ $opticalMedia ]; then
	    if [[ `mount | grep '/mnt/source'` ]]; then
      		  umount /mnt/source
	    fi		
	    mount -t iso9660 -o ro /dev/sr0 /mnt/sysimage/mnt
	elif [ $hddMedia ]; then	
		cd /mnt/isodir
		local myiso=`ls *.iso | awk '{print $1}'`
		mount -o loop /mnt/isodir/$myiso /mnt/sysimage/mnt
	fi
	sleep 2
	myname=`grep -i -E '^[[:space:]]*HOSTNAME' /mnt/sysimage/etc/sysconfig/network | awk -F= '{print $2}' | awk '{print $1}'`
	echo "myname = $myname" >> /tmp/post.log
	chroot /mnt/sysimage /sbin/sysctl kernel.hostname=$myname 
	echo ' installing applications, keep install media connected until prompted to reboot' > /dev/tty1
	sleep 2
	#chroot /mnt/sysimage /usr/bin/yum -c /root/yum.conf.tmp --disablerepo=base,extras,updates -y install nwappliance nwconsole nwwarehouseconnector 
	chroot /mnt/sysimage /usr/bin/yum -c /root/yum.conf.tmp --disablerepo=base,extras,updates -y install re-server 
	rm -f $YUMCFG
 	if [[ `mount | grep '/mnt/sysimage/mnt'` ]]; then
		umount /mnt/sysimage/mnt
	fi
    
	# don't preserve re postgresql database on upgrade
	if [ -d /mnt/sysimage/var/lib/netwitness/database/pgsql ]; then
		rm -Rf /mnt/sysimage/var/lib/netwitness/database/pgsql/
	fi
    
	# reset home directory permissions in case of upgrade
	chroot /mnt/sysimage /bin/chown -R rsasoc:rsasoc /home/rsasoc 
	mkdir -p /mnt/sysimage/var/lib/netwitness/re/logs   
	mkdir -p /mnt/sysimage/var/netwitness/database/pgsql
	rm -Rf /mnt/sysimage/var/lib/pgsql
	chroot /mnt/sysimage /bin/ln -s -t /var/lib /var/netwitness/database/pgsql  1>>/mnt/sysimage/postinstall.log 2>>/mnt/sysimage/postinstall.log
	chroot /mnt/sysimage /sbin/service postgresql initdb   1>>/mnt/sysimage/postinstall.log 2>>/mnt/sysimage/postinstall.log
	sleep 5
	chroot /mnt/sysimage /bin/chown -R postgres:postgres /var/netwitness/database/pgsql   1>>/mnt/sysimage/postinstall.log 2>>/mnt/sysimage/postinstall.log
	cp  /mnt/sysimage/var/netwitness/database/pgsql/data/postgresql.conf /mnt/sysimage/var/netwitness/database/pgsql/data/postgresql.conf.el6.oem    1>>/mnt/sysimage/postinstall.log 2>>/mnt/sysimage/postinstall.log
	sed "s/^#listen_addresses = 'localhost'/listen_addresses = 'localhost'/" < /mnt/sysimage/var/netwitness/database/pgsql/data/postgresql.conf > /mnt/sysimage/var/netwitness/database/pgsql/data/postgresql.conf.new
	mv -f /mnt/sysimage/var/netwitness/database/pgsql/data/postgresql.conf.new /mnt/sysimage/var/netwitness/database/pgsql/data/postgresql.conf
	sed -r 's/^[[:space:]]*#[[:space:]]*(standard_conforming_strings).*$/\1 = on/' < /mnt/sysimage/var/netwitness/database/pgsql/data/postgresql.conf > /mnt/sysimage/var/netwitness/database/pgsql/data/postgresql.conf.new
	mv -f /mnt/sysimage/var/netwitness/database/pgsql/data/postgresql.conf.new /mnt/sysimage/var/netwitness/database/pgsql/data/postgresql.conf
	
	#Enable postgres autovacuum
	sleep 5
	sed "s/^#autovacuum = on/autovacuum = on/" < /mnt/sysimage/var/netwitness/database/pgsql/data/postgresql.conf > /mnt/sysimage/var/netwitness/database/pgsql/data/postgresql.conf.tmp
	sed "s/^#track_counts = on/track_counts = on/" < /mnt/sysimage/var/netwitness/database/pgsql/data/postgresql.conf.tmp > /mnt/sysimage/var/netwitness/database/pgsql/data/postgresql.conf.newtmp
	cp -f /mnt/sysimage/var/netwitness/database/pgsql/data/postgresql.conf.newtmp  /mnt/sysimage/var/netwitness/database/pgsql/data/postgresql.conf
	cp /mnt/sysimage/var/netwitness/database/pgsql/data/pg_hba.conf /mnt/sysimage/var/netwitness/database/pgsql/data/pg_hba.conf.el6.oem
	echo '# netwitness configuration, please do not edit' > /mnt/sysimage/var/netwitness/database/pgsql/data/pg_hba.conf
	echo 'local          all            all             ident' >> /mnt/sysimage/var/netwitness/database/pgsql/data/pg_hba.conf
	echo 'host           nwtmpdb            nwipdbadptr      127.0.0.1/32       password' >> /mnt/sysimage/var/netwitness/database/pgsql/data/pg_hba.conf

	#remove temp files
	rm -f /mnt/sysimage/var/netwitness/database/pgsql/data/postgresql.conf.newtmp
	rm -f /mnt/sysimage/var/netwitness/database/pgsql/data/postgresql.conf.tmp

	#checkfile.log file is created as a flag to createdb and user only once
	#echo 'File is created to create user and db only at first boot'>>/mnt/sysimage/checkfile.log
	#echo 'if [ -f /checkfile.log ] '>> /mnt/sysimage/etc/rc.local
	#echo 'then'>>  /mnt/sysimage/etc/rc.local
	#echo 'sleep 10' >> /mnt/sysimage/etc/rc.local
	#echo 'chroot / /bin/su -c "/usr/bin/createuser -s -d -r nwipdbadptr" postgres' >> /mnt/sysimage/etc/rc.local
	#echo 'sleep 10' >> /mnt/sysimage/etc/rc.local
	#echo 'chroot / /bin/su -c "/usr/bin/createdb -O nwipdbadptr nwtmpdb" postgres' >> /mnt/sysimage/etc/rc.local
	#echo 'sleep 10' >> /mnt/sysimage/etc/rc.local

	#Remove the file to avoid recreating db and user
	#echo 'rm -f /checkfile.log' >>/mnt/sysimage/etc/rc.local
	#echo 'fi'>> /mnt/sysimage/etc/rc.local

	chroot /mnt/sysimage /sbin/chkconfig postgresql on   1>>/mnt/sysimage/postinstall.log 2>>/mnt/sysimage/postinstall.log
    
	# lengthen sleep interval after postgresql service start
	local INIT=/mnt/sysimage/etc/rc.d/init.d/postgresql
	local PERM=`stat -c %a $INIT`
	sed -r 's/(^[[:space:]]*)sleep[[:space:]]+[[:digit:]]+/\1sleep 4/' < $INIT > $INIT.tmp
	mv -f $INIT.tmp $INIT
	chmod $PERM $INIT

	# create postgresql nwipdbextractor user and database
	chroot /mnt/sysimage /sbin/service postgresql start
	echo ' configuring postgresql application database' | tee -a /tmp/post.log > /dev/tty1
	sleep 15
	chroot /mnt/sysimage /bin/su -c "/usr/bin/createuser -s -d -r nwipdbadptr" postgres
	chroot /mnt/sysimage /bin/su -c "/usr/bin/createdb -O nwipdbadptr nwtmpdb" postgres
	chroot /mnt/sysimage /sbin/service postgresql stop
}

# install mapr in %post because of package quirks
function config_maprwh { 
	local opticalMedia=
	local hddMedia=
	local urlMedia=
	local installUrl=
	local strLen=
	local lastChar=

	if [[ `dmesg | grep -i 'kernel command line' | grep 'ks=cdrom'` ]]; then
		opticalMedia='true'
	elif [[ `dmesg | grep -i 'kernel command line' | grep 'ks=hd'` ]]; then
		hddMedia='true'
	elif [[ `dmesg | grep -i 'kernel command line' | grep 'ks=http'` ]]; then
		urlMedia='true'
		installUrl=`dmesg | grep -i 'kernel command line' | awk -F'ks=' '{print $2}' | awk '{print $1}'`
		installUrl=${installUrl%/*}
		echo "config_maprwh: installUrl = $installUrl" >> /tmp/post.log
		let strLen=${#installUrl}
		let strLen=$strLen-1
		lastChar=${installUrl:$strLen}
		if [[ "$lastChar" != '/' ]]; then
			lastChar='/'
			installUrl="$installUrl$lastChar"
		fi
	fi

	# create temporary yum conf file
	YUMCFG='/mnt/sysimage/root/yum.conf.tmp'
	echo '[main]' > $YUMCFG
	echo 'cachedir=/var/cache/yum' >> $YUMCFG
	echo 'keepcache=0' >> $YUMCFG
	echo 'debuglevel=2' >> $YUMCFG
	echo 'logfile=/var/log/yum.log' >> $YUMCFG
	echo 'distroverpkg=redhat-release' >> $YUMCFG
	echo 'tolerant=1' >> $YUMCFG
	echo 'exactarch=1' >> $YUMCFG
	echo 'obsoletes=1' >> $YUMCFG
	echo 'gpgcheck=1' >> $YUMCFG
	echo 'plugins=1' >> $YUMCFG
	echo 'metadata_expire=1h' >> $YUMCFG
	echo '[fbase]' >> $YUMCFG
	echo 'name=centos-6.x-x86_64-base' >> $YUMCFG 
	
	if [[ $opticalMedia || $hddMedia ]]; then
		echo 'baseurl=file:///mnt/' >> $YUMCFG
		echo 'gpgcheck=0' >> $YUMCFG
		echo 'enabled=1' >> $YUMCFG 
	elif [[ $urlMedia ]]; then
		echo "baseurl=$installUrl" >> $YUMCFG
		echo 'gpgcheck=0' >> $YUMCFG
		echo 'enabled=1' >> $YUMCFG 
	fi 
 
	if [ $opticalMedia ]; then
	    if [[ `mount | grep '/mnt/source'` ]]; then
      		  umount /mnt/source
	    fi		
	    mount -t iso9660 -o ro /dev/sr0 /mnt/sysimage/mnt
	elif [ $hddMedia ]; then	
		cd /mnt/isodir
		local myiso=`ls *.iso | awk '{print $1}'`
		mount -o loop /mnt/isodir/$myiso /mnt/sysimage/mnt
	fi
	echo ' installing applications, keep install media connected until prompted to reboot' > /dev/tty1
	sleep 2
	chroot /mnt/sysimage /usr/bin/yum -c /root/yum.conf.tmp --disablerepo=base,extras,updates -y install mapr-emc mapr-zookeeper mapr-hive mapr-cldb mapr-pig mapr-fileserver mapr-nfs mapr-core mapr-jobtracker mapr-tasktracker mapr-zk-internal mapr-webserver mapr-hbase mapr-hbase-internal mapr-hbase-master mapr-hbase-regionserver maprsnappy 

	rm -f $YUMCFG
	if [[ `mount | grep '/mnt/sysimage/mnt'` ]]; then
		umount /mnt/sysimage/mnt
	fi 
	
	# edit tmpwatch cron job
	local TMPWATCH='/mnt/sysimage/etc/cron.daily/tmpwatch'
	sed -r 's/(^[[:space:]]*)(.*[[:space:]]+)([0-9]+[dhm]*[[:space:]]+\/tmp[[:space:]]*$)/\1\2\\\n\1-x \/tmp\/mapr-hadoop \3/' < $TMPWATCH > $TMPWATCH.tmp 
	mv -f $TMPWATCH.tmp $TMPWATCH
	chmod 755 $TMPWATCH
	rm -f $YUMCFG
	CLDBINIT=`ls -l /mnt/sysimage/etc/rc.d/init.d/mapr-cldb | awk -F\> '{print $2}' | awk '{print $1}'`
	CLDBINIT="/mnt/sysimage$CLDBINIT"
        sed -r 's/(^.*CLDB_OPTS="\$\{CLDB_OPTS\}[[:space:]]+-Dpid=\$\$[[:space:]]+-Dpname=cldb[[:space:]]+-Dmapr.home.dir=\$\{CLDB_HOME\})".*$/\1 -Xss320k"/' < $CLDBINIT > $CLDBINIT.tmp
	mv -f $CLDBINIT.tmp $CLDBINIT
	chmod 755 $CLDBINIT
	HIVE2INIT='/mnt/sysimage/etc/init/hive2.conf'
	echo '# start/stop/respawn hive2 service' > $HIVE2INIT
	echo 'start on runlevel [3]' >> $HIVE2INIT
	echo 'stop on runlevel [!3]' >> $HIVE2INIT
	echo 'respawn' >> $HIVE2INIT
	echo 'respawn limit 10 30' >> $HIVE2INIT
	echo 'console none' >> $HIVE2INIT
	echo "exec su -c 'hive --service hiveserver2' - mapr" >> $HIVE2INIT
	chroot /mnt/sysimage /usr/sbin/useradd -m -s /bin/bash mapr
	#chroot /mnt/sysimage /bin/chown mapr:root /opt/mapr/hadoop/hadoop-0.20.2/conf/taskcontroller.cfg
        #chroot /mnt/sysimage /bin/chmod 644 /opt/mapr/hadoop/hadoop-0.20.2/conf/taskcontroller.cfg
	chroot /mnt/sysimage /bin/chown mapr: /opt/mapr/hive/hive-0.12/
	chroot /mnt/sysimage /bin/chown mapr: /opt/mapr/zookeeper/zookeeper-3.4.5/
        chroot /mnt/sysimage /bin/chown mapr: /opt/mapr/zkdata/	
	touch /mnt/sysimage/opt/mapr/pid/cldb.pid
	chroot /mnt/sysimage /bin/chown mapr: /opt/mapr/pid /opt/mapr/pid/cldb.pid
}

# set netconfig.sh script to run in root's shell profile 
function aiofboot {
	PROF='/mnt/sysimage/root/.bash_profile' 
	echo >> $PROF
	echo 'if ! [ -e /usr/sbin/netflag ]; then' >> $PROF
	echo '        /usr/sbin/netconfig.sh' >> $PROF
	echo 'fi' >> $PROF 
}

# set default network configuration on recent hardware, i.e. nehalem and later
function default_netcfg {
	# set default IP parameters to management interface, eth0 or em1
	local apptype=`cat /tmp/nwapptype | awk '{print $1}'`
	local cfgdir='/mnt/sysimage/etc/sysconfig/network-scripts'
	
	if [ -s $cfgdir/ifcfg-em1 ]; then 
		sed -r 's/BOOTPROTO=dhcp/BOOTPROTO=none/' < $cfgdir/ifcfg-em1 > $cfgdir/ifcfg-em1.tmp
		mv -f $cfgdir/ifcfg-em1.tmp $cfgdir/ifcfg-em1	
		sed -r 's/ONBOOT=no/ONBOOT=yes/' < $cfgdir/ifcfg-em1 > $cfgdir/ifcfg-em1.tmp
		mv -f $cfgdir/ifcfg-em1.tmp $cfgdir/ifcfg-em1
		sed -r 's/NM_CONTROLLED=yes/NM_CONTROLLED=no/' < $cfgdir/ifcfg-em1 > $cfgdir/ifcfg-em1.tmp
		mv -f $cfgdir/ifcfg-em1.tmp $cfgdir/ifcfg-em1
		echo 'IPADDR=192.168.1.1' >> $cfgdir/ifcfg-em1
		echo 'NETMASK=255.255.255.0' >> $cfgdir/ifcfg-em1
		echo 'GATEWAY=192.168.1.254' >> $cfgdir/ifcfg-em1
	elif [ -s $cfgdir/ifcfg-eth0 ] && ! [ $openstack ] && ! [ $vmware ]; then
		sed -r 's/BOOTPROTO=dhcp/BOOTPROTO=none/' < $cfgdir/ifcfg-eth0 > $cfgdir/ifcfg-eth0.tmp
		mv -f $cfgdir/ifcfg-eth0.tmp $cfgdir/ifcfg-eth0	
		sed -r 's/ONBOOT=no/ONBOOT=yes/' < $cfgdir/ifcfg-eth0 > $cfgdir/ifcfg-eth0.tmp
		mv -f $cfgdir/ifcfg-eth0.tmp $cfgdir/ifcfg-eth0
		sed -r 's/NM_CONTROLLED=yes/NM_CONTROLLED=no/' < $cfgdir/ifcfg-eth0 > $cfgdir/ifcfg-eth0.tmp
		mv -f $cfgdir/ifcfg-eth0.tmp $cfgdir/ifcfg-eth0
		echo 'IPADDR=192.168.1.1' >> $cfgdir/ifcfg-eth0
		echo 'NETMASK=255.255.255.0' >> $cfgdir/ifcfg-eth0
		echo 'GATEWAY=192.168.1.254' >> $cfgdir/ifcfg-eth0
	elif [ $openstack ]; then
		# create generic eth0 ifcfg file for packer provisioning
		echo 'DEVICE=eth0' > $cfgdir/bakifcfg-eth0
		echo 'TYPE=Ethernet' >> $cfgdir/bakifcfg-eth0
		echo 'BOOTPROTO=dhcp' >> $cfgdir/bakifcfg-eth0
		echo 'ONBOOT=yes' >> $cfgdir/bakifcfg-eth0
		echo 'NM_CONTROLLED=no' >> $cfgdir/bakifcfg-eth0
		# enable qemu slirp network stack for packer ssh connection
		echo 'DEVICE=eth0' > $cfgdir/ifcfg-eth0
		echo 'IPADDR=10.0.2.15' >> $cfgdir/ifcfg-eth0
		echo 'NETMASK=255.255.255.0' >> $cfgdir/ifcfg-eth0
		echo 'GATEWAY=10.0.2.2' >> $cfgdir/ifcfg-eth0
 		echo 'DNS1=10.0.2.3' >> $cfgdir/ifcfg-eth0
		if [ -f $cfgdir/ifcfg-em1 ]; then
			rm -f $cfgdir/ifcfg-em1
		fi
	elif [ $vmware ]; then
		# create generic eth0 ifcfg file for packer provisioning
		echo 'DEVICE=eth0' > $cfgdir/ifcfg-eth0
		echo 'TYPE=Ethernet' >> $cfgdir/ifcfg-eth0
		echo 'BOOTPROTO=none' >> $cfgdir/ifcfg-eth0
		case "${apptype}" in
			logcollector | logdecoder | spectrumbroker | sabroker | connector )
				echo 'IPADDR=10.101.34.35' >> $cfgdir/ifcfg-eth0
			;;
			archiver | broker | concentrator | decoder | esa | ipdbextractor )
				echo 'IPADDR=10.101.34.36' >> $cfgdir/ifcfg-eth0
			;;
		esac
		echo 'NETMASK=255.255.255.0' >> $cfgdir/ifcfg-eth0
		echo 'GATEWAY=10.101.34.1' >> $cfgdir/ifcfg-eth0 
		echo 'ONBOOT=yes' >> $cfgdir/ifcfg-eth0
		echo 'NM_CONTROLLED=no' >> $cfgdir/ifcfg-eth0
		# create a puppet default config for packer provisioning 
		echo 'DEVICE=eth0' > $cfgdir/bakifcfg-eth0
		echo 'BOOTPROTO=none' >> $cfgdir/bakifcfg-eth0
		echo 'IPADDR=192.168.1.1' >> $cfgdir/bakifcfg-eth0
		echo 'NETMASK=255.255.255.0' >> $cfgdir/bakifcfg-eth0
		echo 'GATEWAY=192.168.1.254' >> $cfgdir/bakifcfg-eth0
 		echo 'TYPE=Ethernet' >> $cfgdir/bakifcfg-eth0
		echo 'ONBOOT=yes' >> $cfgdir/bakifcfg-eth0
		echo 'NM_CONTROLLED=no' >> $cfgdir/bakifcfg-eth0
		if [ -f $cfgdir/ifcfg-em1 ]; then
			rm -f $cfgdir/ifcfg-em1
		fi
	fi
}

function configure_fips {
	if [[ `rpm -q dracut-fips | grep -E 'dracut-fips-[0-9]+-[0-9]+'` ]]; then
		if [[ `rpm -q prelink | grep -E 'prelink-[0-9]+\.[0-9]+'` ]]; then
			local PRELCONF=/mnt/sysimage/etc/sysconfig/prelink
			sed -r 's/^[[:space:]]*PRELINKING=yes.*$/# RSA configuration, please do not edit\n#PRELINKING=yes\nPRELINKING=no/' < $PRELCONF > $PRELCONF.tmp
			mv -f $PRELCONF.tmp $PRELCONF
			chroot /mnt/sysimage /usr/sbin/prelink -u -a
		fi 
		#local GRUBCONF=/mnt/sysimage/boot/grub/grub.conf
		#local bootuuid=`grep -E '[[:space:]]+/boot[[:space:]]+' /mnt/sysimage/etc/fstab | awk '{print $1}'` 
		#sed -r "s/(^[[:space:]]*kernel[[:space:]]+.*$)/\1 fips=1 boot=$bootuuid/g" < $GRUBCONF > $GRUBCONF.tmp
		#mv -f $GRUBCONF.tmp $GRUBCONF
	fi
}

function configure_colowarec {
	local INIT=/mnt/sysimage/etc/init/nwwarehouseconnector.conf
	if [ -s $INIT ]; then
		sed -r 's/(^[[:space:]]*start.*$)/#\1/' < $INIT > $INIT.tmp
		mv -f $INIT.tmp $INIT
	fi
}

function workbench_nice {
	local WBINIT=/mnt/sysimage/etc/init/nwworkbench.conf
	if [ -s $WBINIT ]; then
		sed -r 's/(^[[:space:]]*exec[[:space:]]+.*$)/nice 10\n\1/' < $WBINIT > $WBINIT.tmp
		mv -f $WBINIT.tmp $WBINIT
		chmod 644 $WBINIT
	fi
}

function install_core_services {
# install specified core services in %post because of new index format
	if [ -z $1 ]; then
		return 1
	fi	
	
	local appname=$1
	local opticalMedia=
	local hddMedia=
	local urlMedia=
	local installUrl=
	local strLen=
	local lastChar=

	# determine install method
	if [[ `dmesg | grep -i 'kernel command line' | grep 'ks=cdrom'` ]]; then
		opticalMedia='true'
	elif [[ `dmesg | grep -i 'kernel command line' | grep 'ks=hd'` ]]; then
		hddMedia='true'
	elif [[ `dmesg | grep -i 'kernel command line' | grep 'ks=http'` ]]; then
		urlMedia='true'
		installUrl=`dmesg | grep -i 'kernel command line' | awk -F'ks=' '{print $2}' | awk '{print $1}'`
		installUrl=${installUrl%/*}
		echo "setuplogcoll: installUrl = $installUrl" >> /tmp/post.log
		let strLen=${#installUrl}
		let strLen=$strLen-1
		lastChar=${installUrl:$strLen}
		if [[ "$lastChar" != '/' ]]; then
			lastChar='/'
			installUrl="$installUrl$lastChar"
		fi
	fi

	# create temporary yum conf file
	YUMCFG='/mnt/sysimage/root/yum.conf.tmp'
	echo '[main]' > $YUMCFG
	echo 'cachedir=/var/cache/yum' >> $YUMCFG
	echo 'keepcache=0' >> $YUMCFG
	echo 'debuglevel=2' >> $YUMCFG
	echo 'logfile=/var/log/yum.log' >> $YUMCFG
	echo 'distroverpkg=redhat-release' >> $YUMCFG
	echo 'tolerant=1' >> $YUMCFG
	echo 'exactarch=1' >> $YUMCFG
	echo 'obsoletes=1' >> $YUMCFG
	echo 'gpgcheck=1' >> $YUMCFG
	echo 'plugins=1' >> $YUMCFG
	echo 'metadata_expire=1h' >> $YUMCFG
	echo '[fbase]' >> $YUMCFG
	echo 'name=centos-6.x-x86_64-base' >> $YUMCFG 
	
	if [[ $opticalMedia || $hddMedia ]]; then
		echo 'baseurl=file:///mnt/' >> $YUMCFG
		echo 'gpgcheck=0' >> $YUMCFG
		echo 'enabled=1' >> $YUMCFG 
	elif [[ $urlMedia ]]; then
		echo "baseurl=$installUrl" >> $YUMCFG
		echo 'gpgcheck=0' >> $YUMCFG
		echo 'enabled=1' >> $YUMCFG 
	fi 
 
	if [ $opticalMedia ]; then
	    if [[ `mount | grep '/mnt/source'` ]]; then
      		  umount /mnt/source
	    fi		
	    mount -t iso9660 -o ro /dev/sr0 /mnt/sysimage/mnt
	elif [ $hddMedia ]; then	
		cd /mnt/isodir
		local myiso=`ls *.iso | awk '{print $1}'`
		mount -o loop /mnt/isodir/$myiso /mnt/sysimage/mnt
	fi
	sleep 2
	echo ' installing applications, keep install media connected until prompted to reboot' > /dev/tty1
	sleep 2
	case $appname in
		concentrator )
			chroot /mnt/sysimage /usr/bin/yum -c /root/yum.conf.tmp --disablerepo=base,extras,updates -y install nwconcentrator
		;;
	esac
 
	rm -f $YUMCFG
	if [[ `mount | grep '/mnt/sysimage/mnt'` ]]; then
		umount /mnt/sysimage/mnt
	fi
}

function link_rabbitmq {
# move /var/lib/rabbitmq directory to destination and create symbolic link pointer
	local destdir=$1
	rsync -rlHpEAXogDt /mnt/sysimage/var/lib/rabbitmq/ /mnt/sysimage$destdir
	rm -Rf /var/lib/rabbitmq
	chroot /mnt/sysimage /bin/ln -s -t /var/lib $destdir/rabbitmq 
}

# install nwlogcollector and dependencies in %post after host name change
function setuplogcoll {
	local opticalMedia=
	local hddMedia=
	local urlMedia=
	local installUrl=
	local strLen=
	local lastChar=

	if [[ `dmesg | grep -i 'kernel command line' | grep 'ks=cdrom'` ]]; then
		opticalMedia='true'
	elif [[ `dmesg | grep -i 'kernel command line' | grep 'ks=hd'` ]]; then
		hddMedia='true'
	elif [[ `dmesg | grep -i 'kernel command line' | grep 'ks=http'` ]]; then
		urlMedia='true'
		installUrl=`dmesg | grep -i 'kernel command line' | awk -F'ks=' '{print $2}' | awk '{print $1}'`
		installUrl=${installUrl%/*}
		echo "setuplogcoll: installUrl = $installUrl" >> /tmp/post.log
		let strLen=${#installUrl}
		let strLen=$strLen-1
		lastChar=${installUrl:$strLen}
		if [[ "$lastChar" != '/' ]]; then
			lastChar='/'
			installUrl="$installUrl$lastChar"
		fi
	fi

	# create temporary yum conf file
	YUMCFG='/mnt/sysimage/root/yum.conf.tmp'
	echo '[main]' > $YUMCFG
	echo 'cachedir=/var/cache/yum' >> $YUMCFG
	echo 'keepcache=0' >> $YUMCFG
	echo 'debuglevel=2' >> $YUMCFG
	echo 'logfile=/var/log/yum.log' >> $YUMCFG
	echo 'distroverpkg=redhat-release' >> $YUMCFG
	echo 'tolerant=1' >> $YUMCFG
	echo 'exactarch=1' >> $YUMCFG
	echo 'obsoletes=1' >> $YUMCFG
	echo 'gpgcheck=1' >> $YUMCFG
	echo 'plugins=1' >> $YUMCFG
	echo 'metadata_expire=1h' >> $YUMCFG
	echo '[fbase]' >> $YUMCFG
	echo 'name=centos-6.x-x86_64-base' >> $YUMCFG 
	
	if [[ $opticalMedia || $hddMedia ]]; then
		echo 'baseurl=file:///mnt/' >> $YUMCFG
		echo 'gpgcheck=0' >> $YUMCFG
		echo 'enabled=1' >> $YUMCFG 
	elif [[ $urlMedia ]]; then
		echo "baseurl=$installUrl" >> $YUMCFG
		echo 'gpgcheck=0' >> $YUMCFG
		echo 'enabled=1' >> $YUMCFG 
	fi 
 
	if [ $opticalMedia ]; then
	    if [[ `mount | grep '/mnt/source'` ]]; then
      		  umount /mnt/source
	    fi		
	    mount -t iso9660 -o ro /dev/sr0 /mnt/sysimage/mnt
	elif [ $hddMedia ]; then	
		cd /mnt/isodir
		local myiso=`ls *.iso | awk '{print $1}'`
		mount -o loop /mnt/isodir/$myiso /mnt/sysimage/mnt
	fi
	sleep 2
	myname=`grep -i -E '^[[:space:]]*HOSTNAME' /mnt/sysimage/etc/sysconfig/network | awk -F= '{print $2}' | awk '{print $1}'`
	echo "myname = $myname" >> /tmp/post.log
	chroot /mnt/sysimage /sbin/sysctl kernel.hostname=$myname 
	echo ' installing applications, keep install media connected until prompted to reboot' > /dev/tty1
	sleep 2
	#chroot /mnt/sysimage /usr/bin/yum -c /root/yum.conf.tmp --disablerepo=base,extras,updates -y install nwappliance nwconsole nwlogcollector krb5-workstation nwlogcollectorcontent rssh vsftpd
	chroot /mnt/sysimage /usr/bin/yum -c /root/yum.conf.tmp --disablerepo=base,extras,updates -y install @rsa-sa-remote-logcollector 
	rm -f $YUMCFG
 	if [[ `mount | grep '/mnt/sysimage/mnt'` ]]; then
		umount /mnt/sysimage/mnt
	fi
}

# install nwlogcollector and dependencies in %post after host name change
function setupwarec {
	local opticalMedia=
	local hddMedia=
	local urlMedia=
	local installUrl=
	local strLen=
	local lastChar=

	if [[ `dmesg | grep -i 'kernel command line' | grep 'ks=cdrom'` ]]; then
		opticalMedia='true'
	elif [[ `dmesg | grep -i 'kernel command line' | grep 'ks=hd'` ]]; then
		hddMedia='true'
	elif [[ `dmesg | grep -i 'kernel command line' | grep 'ks=http'` ]]; then
		urlMedia='true'
		installUrl=`dmesg | grep -i 'kernel command line' | awk -F'ks=' '{print $2}' | awk '{print $1}'`
		installUrl=${installUrl%/*}
		echo "setuplogcoll: installUrl = $installUrl" >> /tmp/post.log
		let strLen=${#installUrl}
		let strLen=$strLen-1
		lastChar=${installUrl:$strLen}
		if [[ "$lastChar" != '/' ]]; then
			lastChar='/'
			installUrl="$installUrl$lastChar"
		fi
	fi

	# create temporary yum conf file
	YUMCFG='/mnt/sysimage/root/yum.conf.tmp'
	echo '[main]' > $YUMCFG
	echo 'cachedir=/var/cache/yum' >> $YUMCFG
	echo 'keepcache=0' >> $YUMCFG
	echo 'debuglevel=2' >> $YUMCFG
	echo 'logfile=/var/log/yum.log' >> $YUMCFG
	echo 'distroverpkg=redhat-release' >> $YUMCFG
	echo 'tolerant=1' >> $YUMCFG
	echo 'exactarch=1' >> $YUMCFG
	echo 'obsoletes=1' >> $YUMCFG
	echo 'gpgcheck=1' >> $YUMCFG
	echo 'plugins=1' >> $YUMCFG
	echo 'metadata_expire=1h' >> $YUMCFG
	echo '[fbase]' >> $YUMCFG
	echo 'name=centos-6.x-x86_64-base' >> $YUMCFG 
	
	if [[ $opticalMedia || $hddMedia ]]; then
		echo 'baseurl=file:///mnt/' >> $YUMCFG
		echo 'gpgcheck=0' >> $YUMCFG
		echo 'enabled=1' >> $YUMCFG 
	elif [[ $urlMedia ]]; then
		echo "baseurl=$installUrl" >> $YUMCFG
		echo 'gpgcheck=0' >> $YUMCFG
		echo 'enabled=1' >> $YUMCFG 
	fi 
 
	if [ $opticalMedia ]; then
	    if [[ `mount | grep '/mnt/source'` ]]; then
      		  umount /mnt/source
	    fi		
	    mount -t iso9660 -o ro /dev/sr0 /mnt/sysimage/mnt
	elif [ $hddMedia ]; then	
		cd /mnt/isodir
		local myiso=`ls *.iso | awk '{print $1}'`
		mount -o loop /mnt/isodir/$myiso /mnt/sysimage/mnt
	fi
	sleep 2
	myname=`grep -i -E '^[[:space:]]*HOSTNAME' /mnt/sysimage/etc/sysconfig/network | awk -F= '{print $2}' | awk '{print $1}'`
	echo "myname = $myname" >> /tmp/post.log
	chroot /mnt/sysimage /sbin/sysctl kernel.hostname=$myname 
	echo ' installing applications, keep install media connected until prompted to reboot' > /dev/tty1
	sleep 2
	#chroot /mnt/sysimage /usr/bin/yum -c /root/yum.conf.tmp --disablerepo=base,extras,updates -y install nwappliance nwconsole nwwarehouseconnector 
	chroot /mnt/sysimage /usr/bin/yum -c /root/yum.conf.tmp --disablerepo=base,extras,updates -y install @rsa-sa-warehouse-connector 
	rm -f $YUMCFG
 	if [[ `mount | grep '/mnt/sysimage/mnt'` ]]; then
		umount /mnt/sysimage/mnt
	fi
	chroot /mnt/sysimage /bin/bash -c 'LD_LIBRARY_PATH=/opt/netwitness/warehouseconnector/lib64;export LD_LIBRARY_PATH;/usr/sbin/NwWarehouseConnector --install'
	echo -e 'env LD_LIBRARY_PATH=/opt/netwitness/warehouseconnector/lib64/:$LD_LIBRARY_PATH\nexport LD_LIBRARY_PATH\nenv HOME=/root\nexport HOME' >> /mnt/sysimage/etc/init/nwwarehouseconnector.conf
}

function install_post_package {
# install common %post image packages
	local opticalMedia=
	local hddMedia=
	local urlMedia=
	local installUrl=
	local strLen=
	local lastChar=
	local apptype=`cat /tmp/nwapptype | awk '{print $1}'`
	local OPENSSL_PACKAGE_NAME='openssl-1.0.0-20.el6_2.5.x86_64.rpm'
	local OWB_PACKAGE_NAME='libowb1_0_1-1.1.1.0-1.x86_64.rpm' 
	local OWBFIX_PACKAGE_NAME='rsa-sa-fips-11.0.0.0-3427.1.aee8aeb.el6.x86_64.rpm'
	local EXPECTED_HASH='0a934520859e40bcd45d0257d2900f294523c8cdaa0485832b9defd7826a36bf'
	local MYPWD=`pwd | awk '{print $1}'`

	# determine install method
	if [[ `dmesg | grep -i 'kernel command line' | grep 'ks=cdrom'` ]]; then
		opticalMedia='true'
	elif [[ `dmesg | grep -i 'kernel command line' | grep 'ks=hd'` ]]; then
		hddMedia='true'
	elif [[ `dmesg | grep -i 'kernel command line' | grep 'ks=http'` ]]; then
		urlMedia='true'
		installUrl=`dmesg | grep -i 'kernel command line' | awk -F'ks=' '{print $2}' | awk '{print $1}'`
		installUrl=${installUrl%/*}
		echo "setuplogcoll: installUrl = $installUrl" >> /tmp/post.log
		let strLen=${#installUrl}
		let strLen=$strLen-1
		lastChar=${installUrl:$strLen}
		if [[ "$lastChar" != '/' ]]; then
			lastChar='/'
			installUrl="$installUrl$lastChar"
		fi
	fi

	# create temporary yum conf file
	YUMCFG='/mnt/sysimage/root/yum.conf.tmp'
	echo '[main]' > $YUMCFG
	echo 'cachedir=/var/cache/yum' >> $YUMCFG
	echo 'keepcache=0' >> $YUMCFG
	echo 'debuglevel=2' >> $YUMCFG
	echo 'logfile=/var/log/yum.log' >> $YUMCFG
	echo 'distroverpkg=redhat-release' >> $YUMCFG
	echo 'tolerant=1' >> $YUMCFG
	echo 'exactarch=1' >> $YUMCFG
	echo 'obsoletes=1' >> $YUMCFG
	echo 'gpgcheck=1' >> $YUMCFG
	echo 'plugins=1' >> $YUMCFG
	echo 'metadata_expire=1h' >> $YUMCFG
	echo '[fbase]' >> $YUMCFG
	echo 'name=centos-6.x-x86_64-base' >> $YUMCFG 
	
	if [[ $opticalMedia || $hddMedia ]]; then
		echo 'baseurl=file:///mnt/' >> $YUMCFG
		echo 'gpgcheck=0' >> $YUMCFG
		echo 'enabled=1' >> $YUMCFG 
	elif [[ $urlMedia ]]; then
		echo "baseurl=$installUrl" >> $YUMCFG
		echo 'gpgcheck=0' >> $YUMCFG
		echo 'enabled=1' >> $YUMCFG 
	fi

	# don't install common applications on MapR Warehouse
	if ! [ "$apptype" = 'maprwh' ]; then 
		if [ $opticalMedia ]; then
			if [[ `mount | grep '/mnt/source'` ]]; then
				umount /mnt/source
			fi		
			mount -t iso9660 -o ro /dev/sr0 /mnt/sysimage/mnt
		elif [ $hddMedia ]; then	
			cd /mnt/isodir
			local myiso=`ls *.iso | awk '{print $1}'`
			mount -o loop /mnt/isodir/$myiso /mnt/sysimage/mnt
		fi
		sleep 2
		
		# install both versions of rsa-sa-gpg-pubkeys
		#chroot /mnt/sysimage /usr/bin/yum -c /root/yum.conf.tmp --disablerepo=base,extras,updates -y install rsa-sa-gpg-pubkeys-10.5.0.0.2982-1*
		#chroot /mnt/sysimage /usr/bin/yum -c /root/yum.conf.tmp --disablerepo=base,extras,updates -y update rsa-sa-gpg-pubkeys

		echo ' installing common applications, keep install media connected until prompted to reboot' > /dev/tty1
		sleep 2
		chroot /mnt/sysimage /usr/bin/yum -c /root/yum.conf.tmp --disablerepo=base,extras,updates -y install "${commpack[@]}"
		
		# install fips compliant openssl package in alternate location
		# code snippets courtesy of the SA Core Team
		#cp /mnt/runtime/rpm/$OPENSSL_PACKAGE_NAME /mnt/sysimage/root
		cp /mnt/runtime/rpm/*.rpm /mnt/sysimage/root
	      	cd /mnt/sysimage/root
		
		# upgrade openssl with libowb, install libowb fixes patch
		#chroot /mnt/sysimage /bin/rpm -U /root/${OWB_PACKAGE_NAME}
		#chroot /mnt/sysimage /bin/rpm -i /root/${OWBFIX_PACKAGE_NAME}

		if ! [ -f $OPENSSL_PACKAGE_NAME ]
		then
			chvt 3
			echo "Unable to locate file $PWD/$OPENSSL_PACKAGE_NAME" | tee -a /tmp/post.log > /dev/tty3
			return 0 
		fi

		COMPUTED_HASH=$(openssl dgst -r -sha256 $OPENSSL_PACKAGE_NAME | cut -d ' ' -f 1-1)

		if [ "$COMPUTED_HASH" != "$EXPECTED_HASH" ]
		then
			chvt 3
			echo -e "The sha-256 hash for file $OPENSSL_PACKAGE_NAME is $COMPUTED_HASH\nThis does not match the expected value, please check file integrity\nsha-256 for $OPENSSL_PACKAGE_NAME is $EXPECTED_HASH" | tee -a /tmp/post.log > /dev/tty3
			return 0
		fi
		SSL_INSTALL_ROOT=/opt/$(basename $OPENSSL_PACKAGE_NAME .x86_64.rpm)

		if ! chroot /mnt/sysimage /bin/mkdir -p $SSL_INSTALL_ROOT/var/lib/rpm
		then
			chvt 3
			echo "Unable to create installation root $SSL_INSTALL_ROOT" | tee -a /tmp/post.log > /dev/tty3
			return 0
		fi

		# perform RPM installation of package into alternate root so that it does not conflict with
		# the system-wide openssl
		if ! chroot /mnt/sysimage /bin/rpm -ivh --nodeps --noscripts --nosignature --root $SSL_INSTALL_ROOT /root/$OPENSSL_PACKAGE_NAME
		then
			echo "Unable to install $OPENSSL_PACKAGE_NAME" | tee -a /tmp/post.log > /dev/tty3
			return 0
		fi
		rm -f $OPENSSL_PACKAGE_NAME $OWB_PACKAGE_NAME $OWBFIX_PACKAGE_NAME
		cd $MYPWD
	fi
	rm -f $YUMCFG
	if [[ `mount | grep '/mnt/sysimage/mnt'` ]]; then
		umount /mnt/sysimage/mnt
	fi
}

function doInstallKickstartLog
{
	local PREFIX=/mnt/sysimage
	local blockdev=
	local mytype=
	local model=
	local vendor=
	local item=
	local i=
	local count=
	local grub1=
	local grub2=
	local vflash=
	local mysystem=

	sed "y/ /\n/" < /proc/cmdline | grep ^NW_ > /tmp/nwparameters
	. /tmp/nwparameters
	
	randomizeHostname $PREFIX
	
	# echo some debug info
	mytype=`cat /tmp/nwapptype`
	mysystem=`cat /tmp/nwsystem | awk '{print $1}'`
	echo "nwsystem = $mysystem, nwappliance = $mytype" | tee -a /tmp/post.log > /dev/tty3
	blockdev=( `ls /sys/block | grep sd[a-z]` )
	echo "my block devices:" | tee -a /tmp/post.log > /dev/tty3
	for item in ${blockdev[@]}
	do
		vendor=`cat /sys/block/$item/device/vendor`
		model=`cat /sys/block/$item/device/model`
		echo "$item $vendor $model" | tee -a /tmp/post.log > /dev/tty3
	done
	
	# install grub on boot device(s)
	case "$mysystem" in
		# install grub on linux software mirror
		sm-s2-1u | sm-s2-1u-conc | sm-s3-2u | sm-s2-2u | mckaycreek )
			install_grub
		;;
		# install grub on hw raid mirror
		sm-s3-1u-brok | dell-s3-1u-brok | dell-s3-1u | dell-s4-1u | dell-s4-2u | dell-s4s-1u )
			install_grub_on_first_drive_only
		;;
		# install grub on either sw or hw mirror depending on appliance type
		dell-s3-2u | sm-s3-1u )
			if [ $mytype = packethybrid ]; then
				install_grub
			else 
				install_grub_on_first_drive_only
			fi
		;;
		thirdparty )
				install_grub_on_first_drive_only
		;;
		* )	
			# consider anything else passed an error
			chvt 3
			echo " failed function call doInstallKickstartLog(), exiting" >> /dev/tty3
			sleep 20
			exit 1
		;;
	esac
	
	# configure system panel on sm 1u systems
	if [ "$mysystem" = 'sm-s3-1u' ] || [ "$mysystem" = 'sm-s3-1u-brok' ] || [ "$mysystem" = 'sm-s2-1u-conc' ] || [ "$mysystem" = 'sm-s2-1u' ]; then
		getcompid "crystalfontz"
	fi
	
	# configure network devices
	#set_ethernet_devices 
	default_netcfg
	
	# rotate logs hourly for nextgen
	if [[ `rpm -q nwbroker | grep -E 'nwbroker-[0-9]+\.[0-9]+\.'` || `rpm -q nwconcentrator | grep -E 'nwconcentrator-[0-9]+\.[0-9]+\.'` || `rpm -q nwdecoder | grep -E 'nwdecoder-[0-9]+\.[0-9]+\.'` ]] || [[ `rpm -q nwlogdecoder | grep -E 'nwlogdecoder-[0-9]+\.[0-9]+\.'` ]] || [[ `rpm -q nwarchiver | grep -E 'nwarchiver-[0-9]+\.[0-9]+\.'` ]]; then 
		set_logrotate_param "hourly"
	else
		set_logrotate_param 
	fi
	
	# check if selinux kickstart setting is being ignored
	local SECONFIG=/mnt/sysimage/etc/selinux/config
	if [[ `grep 'SELINUX=enforcing' $SECONFIG` ]]; then 
		sed -r 's/(^[[:space:]]*SELINUX=).*$/\1permissive/' < $SECONFIG > $SECONFIG.tmp
		mv -f $SECONFIG.tmp $SECONFIG
		chmod 644 $SECONFIG
	fi
	
        # enforce gmt/utc time zone
        #local CLOCKCFG=/mnt/sysimage/etc/sysconfig/clock
        #local TLOCALE=/mnt/sysimage/etc/localtime
        #local UTCZONE=/mnt/sysimage/usr/share/zoneinfo/Etc/UTC
        #echo 'ZONE="Etc/UTC"' > $CLOCKCFG
        #rm -f $TLOCALE
        #cp -p $UTCZONE $TLOCALE
        #chroot /mnt/sysimage /sbin/hwclock --utc
	
	# run common %post functions
	genSNMPconf 
	set_kernel_tunables
	
	# enable system V serices to start on boot 
        chroot /mnt/sysimage /sbin/chkconfig ntpd on
	chroot /mnt/sysimage /sbin/chkconfig postfix off 
	chroot /mnt/sysimage /sbin/chkconfig ipmi on
	chroot /mnt/sysimage /sbin/chkconfig yum-updatesd off
	chroot /mnt/sysimage /sbin/chkconfig kdump off
}

function doPost
{
    if [ -z $1 ]; then	
        doInstallKickstartLog "$@" >/mnt/sysimage/root/install_build.log 2>&1
    else
        doInstallKickstartLog "$1" "$@" >/mnt/sysimage/root/install_build.log 2>&1
    fi
}

function check_post_package {
# check that %post installed packages are present 
	
	local errcode
	local item
	local opensslnum
        local apptype=`cat /tmp/nwapptype | awk '{print $1}'`
	
	echo 'validating %post installed packages' >> /tmp/post.log
	if ! [ "$apptype" = 'maprwh' ]; then
		# check for common %post packages
		for item in "${commpack[@]}"
		do
			if ! [[ `rpm -q $item | grep -E "$item-[0-9]+\.[0-9]+"` ]]; then
				echo "required %post install package $item not found" | tee -a /tmp/post.log > /dev/tty3
				errcode=1
			fi
		done
		if ! [ -s /mnt/sysimage/opt/openssl-1.0.0-20.el6_2.5/usr/lib64/libssl.so.1.0.0 ]; then
			echo "required %post install package openssl-1.0.0-20.el6_2.5.x86_64.rpm not found" | tee -a /tmp/post.log > /dev/tty3
			errcode=1	
		fi
	fi
	
	if [[ "$apptype" = 'logdecoder' || "$apptype" = 'logcollector' || "$apptype" = 'logaio' ]] || [ "$apptype" = 'loghybrid' ]; then
		if [[ `grep -i -E '^[[:space:]]*setuplogcoll.*$' /tmp/nwpost.txt` ]]; then 
			if ! [[ `rpm -q nwlogcollector | grep -E 'nwlogcollector-[0-9]+\.[0-9]+'` ]]; then
				echo 'required %post install package nwlogcollector not found' | tee -a /tmp/post.log > /dev/tty3
				errcode=1
			fi
		fi
	fi
	
	if [[ "$apptype" = 'spectrumbroker' ]]; then
		if ! [[ `rpm -q rsaMalwareDevice | grep -E 'rsaMalwareDevice-[0-9]+\.[0-9]+'` ]]; then
			echo 'required %post install package rsaMalwareDevice not found' | tee -a /tmp/post.log > /dev/tty3
			errcode=1
		fi
	fi
	
	if [[ `grep 'setupwarec' /tmp/nwpost.txt` ]]; then
		if ! [[ `rpm -q nwwarehouseconnector | grep -E 'nwwarehouseconnector-[0-9]+\.[0-9]+'` ]]; then
			echo 'required %post install package rsaMalwareDevice not found' | tee -a /tmp/post.log > /dev/tty3 
			errcode=1
		fi
	fi
	
	if [ $errcode ]; then
		echo > /dev/tty1
		echo > /dev/tty1
		echo ' *********************************************************' > /dev/tty1
		echo ' Post installation of one or more package(s) has failed' > /dev/tty1
		echo ' Possible package repository error, check /tmp/post.log' > /dev/tty1
		echo > /dev/tty1
		echo ' Disabling automatic boot of system on next restart' > /dev/tty1
		echo ' Renaming /mnt/sysimage/boot/grub/grub.conf to' > /dev/tty1
	       	echo ' /mnt/sysimage/boot/grub/grub.noboot' > /dev/tty1
		echo ' *********************************************************' > /dev/tty1
		echo > /dev/tty1
		echo > /dev/tty1
		mv -f /mnt/sysimage/boot/grub/grub.conf /mnt/sysimage/boot/grub/grub.noboot
		sleep 300
	fi
}

function kill_installer {
# terminate anaconda process for debugging purposes, assumes 'reboot' command in kickstart
	local usrchoice=N
	local pslist
	chvt 3
	echo > /dev/tty3
	echo '---------------------------------------' > /dev/tty3
	echo ' Install/Upgrade process has completed' > /dev/tty3
	echo ' Please disconnect any installation' > /dev/tty3
	echo ' media and boot to operating system'  > /dev/tty3
	echo ' The system will restart in 30 seconds' > /dev/tty3
	echo > /dev/tty3
	echo ' Enter (y/Y) to terminate the anaconda' > /dev/tty3
	echo ' install process allowing access to a' > /dev/tty3
	echo ' bash shell. NOTE: this feature is for' > /dev/tty3
	echo ' for debugging purposes and may cause' > /dev/tty3
	echo ' unexpected results, defaults to No' >  /dev/tty3
	echo '---------------------------------------' > /dev/tty3
	exec < /dev/tty3 > /dev/tty3 2>&1
	read -t 30 -p ' Enter (y/Y) to terminate anaconda, defaults to No? ' usrchoice
	if [[ $usrchoice = y || $usrchoice = Y ]]; then
		echo > /dev/tty3
		pslist=( `ps aux | grep -i -E '[[:digit:]]+[[:space:]]+/usr/bin/python[[:space:]]+/usr/bin/anaconda' | awk '{print $2}' | sort` )
		echo ' Press <ALT><F2> for Shell Access, <CTRL><ALT><DEL> to Reboot' > /dev/tty3
		echo ' Terminating anaconda in 10 seconds' > /dev/tty3	
		echo > /dev/tty3
		sleep 10 
		kill -s 4 ${pslist[0]}
	else
		return 0
	fi
}

function free_emptypv {
# per doc user was instructed to select one block device for OS installation 
# remove un-used lvm physical volumes for use for application storage
        local pvlist
        declare -a pvlist
        local item
        local totalsize
        local freesize
        pvlist=( `pvs | tr ' ' '_' | grep 'VolGroup' | awk -F_ '{print $3}'` )
        echo "${pvlist[@]}"
        for item in "${pvlist[@]}"
        do
                totalsize=`pvs --units=m | grep "$item" | awk '{print $5}'`
                totalsize=${totalsize%m}
                let totalsize=`printf "%.0f" $totalsize`
                freesize=`pvs --units=m | grep "$item" | awk '{print $6}'`
                freesize=${freesize%m}
                let freesize=`printf "%.0f" $freesize`
		if [ $freesize -eq $totalsize ]; then
	                echo "pv = $item, total size = $totalsize, free size = $freesize" | tee -a /tmp/post.log > /dev/tty3
			echo "removing un-used lvm physical volume: $item" | tee -a /tmp/post.log > /dev/tty3
			vgreduce VolGroup $item
			pvremove -ff $item
		fi
        done
}

function mirrordir {
# copy sub directories, files and links from source folder root to target folder root
	
	local sourcedir="$1"
	local targetdir="$2"
	local mypwd=`pwd`
	local mylog=/tmp/post.log

	cd $sourcedir
	echo "mirroring $sourcedir to $targetdir ..." | tee -a $mylog > /dev/tty3
	find . -maxdepth 0 -type d -exec cp -a '{}' $targetdir \;
	find . -maxdepth 0 -type f -exec cp --perserve=all '{}' $targetdir \;
	find . -maxdepth 0 -type l -exec cp --perserve=all '{}' $targetdir \;
	sync
	sleep 2
	cd $mypwd
}

function getvgfreemib {
# set vgfreemib global variable with free space in MiB from the passed volume group
	
	local vgname="${1}"
	unset vgfreemib
	vgfreemib=`chroot /mnt/sysimage /sbin/vgs --noheadings --units M -o vg_name,vg_free | grep "${vgname}" | awk '{print $2}'`
	vgfreemib=${vgfreemib%*M}
	vgfreemib=`printf "%.0f" $vgfreemib | awk '{print $1}'`
}

function appliance_lvmounts {
# create expected appliance logical volume mounts

	# don't create application volumes for openstack images
	if [ $openstack ] || [ $vmware ]; then
		return 0
	fi
	
	local appliancetype=`cat /tmp/nwapptype`
	local warec
	local logcol
	local remainder
	local size
	local FSTAB=/mnt/sysimage/etc/fstab
	local mylog=/tmp/post.log
	local vgfreemb
	if [[ `grep 'setupwarec' /tmp/nwpost.txt` ]]; then
		warec=true
	fi

	if [[ `grep 'setuplogcoll' /tmp/nwpost.txt` ]]; then
		logcol=true
	fi

	# scan for and activate volume groups
	chroot /mnt/sysimage /sbin/vgscan --mknodes | tee -a $mylog > /dev/tty3
	chroot /mnt/sysimage /sbin/vgck -v | tee -a $mylog  > /dev/tty3
	chroot /mnt/sysimage /sbin/vgchange -ay --ignorelockingfailure | tee -a $mylog > /dev/tty3
	sleep 3

	case "$appliancetype" in
		archiver )
			chroot /mnt/sysimage /sbin/lvcreate -ay -n workbench -l 100%FREE /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/workbench | tee -a $mylog > /dev/tty3
			if [ -d /mnt/sysimage/var/netwitness/workbench ]; then
				mv -f /mnt/sysimage/var/netwitness/workbench /mnt/sysimage/var/netwitness/olworkbench
			fi
			mkdir -p /mnt/sysimage/var/netwitness/workbench | tee -a $mylog > /dev/tty3
			mount -t xfs /dev/VolGroup00/workbench /mnt/sysimage/var/netwitness/workbench | tee -a $mylog > /dev/tty3
			mirrordir /mnt/sysimage/var/netwitness/olworkbench /mnt/sysimage/var/netwitness/workbench | tee -a $mylog > /dev/tty3		
			echo '/dev/mapper/VolGroup00-workbench /var/netwitness/workbench xfs defaults,noatime,nosuid 1 2' >> $FSTAB
		;;
		broker )
			if [ $openstack ]; then
				chroot /mnt/sysimage /sbin/lvcreate -ay -n broker -l 100%FREE /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			else
				chroot /mnt/sysimage /sbin/lvcreate -ay -n broker -L 102400M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			fi
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/broker | tee -a $mylog > /dev/tty3
			mkdir -p /mnt/sysimage/var/netwitness/broker | tee -a $mylog > /dev/tty3
			echo '/dev/mapper/VolGroup00-broker /var/netwitness/broker xfs defaults,noatime,nosuid 1 2' >> $FSTAB
		;;
		concentrator )
			echo > /dev/null
		;;
		connector )
			chroot /mnt/sysimage /sbin/lvcreate -ay -n warec -L 409600M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/warec | tee -a $mylog > /dev/tty3
			mkdir -p /mnt/sysimage/var/netwitness/warehouseconnector | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /bin/mount -t xfs /dev/VolGroup00/warec /var/netwitness/warehouseconnector | tee -a $mylog > /dev/tty3
			echo '/dev/mapper/VolGroup00-warec /var/netwitness/warehouseconnector xfs defaults,noatime,nosuid 1 2' >> $FSTAB
		;;
		esa )
			chroot /mnt/sysimage /sbin/lvcreate -ay -n rsaapps -l 100%FREE /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/rsaapps | tee -a $mylog > /dev/tty3
			if [ -d /mnt/sysimage/opt/rsa ]; then
				mv -f /mnt/sysimage/opt/rsa /mnt/sysimage/opt/olrsa | tee -a $mylog > /dev/tty3
			fi
			mkdir -p /mnt/sysimage/opt/rsa | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /bin/mount -t xfs /dev/VolGroup00/rsaapps /opt/rsa | tee -a $mylog > /dev/tty3
			if [ -d /mnt/sysimage/opt/olrsa ]; then
				mirrordir /mnt/sysimage/opt/olrsa /mnt/sysimage/opt/rsa | tee -a $mylog > /dev/tty3
			fi
			echo '/dev/mapper/VolGroup00-rsaapps /opt/rsa xfs defaults,noatime,nosuid 1 2' >> $FSTAB
		;;
		decoder )
			if [ $warec ]; then
				if [ $openstack ]; then
					chroot /mnt/sysimage /sbin/lvcreate -ay -n warec -L 10240M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
				else
					chroot /mnt/sysimage /sbin/lvcreate -ay -n warec -L 409600M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
				fi
				chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/warec | tee -a $mylog > /dev/tty3
				mkdir -p /mnt/sysimage/var/netwitness/warehouseconnector | tee -a $mylog > /dev/tty3
				chroot /mnt/sysimage /bin/mount -t xfs /dev/VolGroup00/warec /var/netwitness/warehouseconnector | tee -a $mylog > /dev/tty3
				echo '/dev/mapper/VolGroup00-warec /var/netwitness/warehouseconnector xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			fi
		;;
		ipdbextractor )
			chroot /mnt/sysimage /sbin/lvcreate -ay -n ipdbext -L 30720M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/ipdbext | tee -a $mylog > /dev/tty3
			mv -f /mnt/sysimage/var/netwitness/ipdbextractor /mnt/sysimage/var/netwitness/olipdbextractor | tee -a $mylog > /dev/tty3
			mkdir -p /mnt/sysimage/var/netwitness/ipdbextractor | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /bin/mount -t xfs /dev/VolGroup00/ipdbext /var/netwitness/ipdbextractor | tee -a $mylog > /dev/tty3
			mirrordir /mnt/sysimage/var/netwitness/olipdbextractor /mnt/sysimage/var/netwitness/ipdbextractor | tee -a $mylog > /dev/tty3
			rm -Rf /mnt/sysimage/var/netwitness/olipdbextractor | tee -a $mylog > /dev/tty3 | tee -a $mylog > /dev/tty3
			echo '/dev/mapper/VolGroup00-ipdbext /var/netwitness/ipdbextractor xfs defaults,noatime,nosuid 1 2' >> $FSTAB
		;;
		logaio )
			chroot /mnt/sysimage /sbin/lvcreate -ay -n broker -L 51200M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/lvcreate -ay -n ipdbext -L 30720M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/lvcreate -ay -n rsasoc -L 155648M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/lvcreate -ay -n redb -L 155648M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/lvcreate -ay -n uax -L 51200M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			# keep core lvs' 30 GB max
			chroot /mnt/sysimage /sbin/lvcreate -ay -n concroot -L 30720M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/lvcreate -ay -n concinde -L 307200M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/lvcreate -ay -n concmeta -L 4096M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/lvcreate -ay -n concsess -L 3072M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/lvcreate -ay -n ldecroot -L 30720M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/lvcreate -ay -n ldecinde -L 30720M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/lvcreate -ay -n ldecmeta -L 307200M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/lvcreate -ay -n ldecpack -L 4096M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/lvcreate -ay -n ldecsess -L 30720M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/broker | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/ipdbext | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/rsasoc | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/redb | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/uax | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/concroot | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/concinde | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/concmeta | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/concsess | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/ldecroot | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/ldecinde | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/ldecmeta | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/ldecpack | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/ldecsess | tee -a $mylog > /dev/tty3
			if [ -d /mnt/sysimage/var/lib/netwitness ]; then
				mv -f /mnt/sysimage/var/lib/netwitness /mnt/sysimage/var/lib/olnetwitness | tee -a $mylog > /dev/tty3
			fi
			mv -f /mnt/sysimage/var/netwitness/ipdbextractor /mnt/sysimage/var/netwitness/olipdbextractor | tee -a $mylog > /dev/tty3
			mkdir -p /mnt/sysimage/var/netwitness/broker /mnt/sysimage/var/netwitness/concentrator /mnt/sysimage/var/netwitness/logdecoder /mnt/sysimage/var/netwitness/database /mnt/sysimage/var/lib/netwitness /mnt/sysimage/home/rsasoc /mnt/sysimage/var/netwitness/ipdbextractor | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /bin/mount -t xfs /dev/VolGroup00/redb /var/netwitness/database | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /bin/mount -t xfs /dev/VolGroup00/rsasoc /home/rsasoc | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /bin/mount -t xfs /dev/VolGroup00/ldecroot /var/netwitness/logdecoder | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /bin/mount -t xfs /dev/VolGroup00/uax /var/lib/netwitness | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /bin/mount -t xfs /dev/VolGroup00/ipdbext /var/netwitness/ipdbextractor | tee -a $mylog > /dev/tty3
			mirrordir /mnt/sysimage/var/netwitness/olipdbextractor /mnt/sysimage/var/netwitness/ipdbextractor | tee -a $mylog > /dev/tty3
			rm -Rf /mnt/sysimage/var/netwitness/olipdbextractor | tee -a $mylog > /dev/tty3 | tee -a $mylog > /dev/tty3
			mkdir -p /mnt/sysimage/var/netwitness/logdecoder/index /mnt/sysimage/var/netwitness/logdecoder/metadb /mnt/sysimage/var/netwitness/logdecoder/packetdb /mnt/sysimage/var/netwitness/logdecoder/sessiondb | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /bin/mount -t xfs /dev/VolGroup00/concroot /var/netwitness/concentrator | tee -a $mylog > /dev/tty3
			mkdir -p /mnt/sysimage/var/netwitness/concentrator/index /mnt/sysimage/var/netwitness/concentrator/metadb /mnt/sysimage/var/netwitness/concentrator/sessiondb | tee -a $mylog > /dev/tty3
			if [ -d /mnt/sysimage/var/lib/olnetwitness ]; then
				mirrordir /mnt/sysimage/var/lib/olnetwitness /mnt/sysimage/var/lib/netwitness | tee -a $mylog > /dev/tty3
				rm -Rf /mnt/sysimage/var/lib/olnetwitness | tee -a $mylog > /dev/tty3
			fi
			echo '/dev/mapper/VolGroup00-broker /var/netwitness/broker xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			echo '/dev/mapper/VolGroup00-concroot /var/netwitness/concentrator xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			echo '/dev/mapper/VolGroup00-concinde /var/netwitness/concentrator/index xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			echo '/dev/mapper/VolGroup00-concmeta /var/netwitness/concentrator/metadb xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			echo '/dev/mapper/VolGroup00-concsess /var/netwitness/concentrator/sessiondb xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			echo '/dev/mapper/VolGroup00-ldecroot /var/netwitness/logdecoder xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			echo '/dev/mapper/VolGroup00-ldecinde /var/netwitness/logdecoder/index xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			echo '/dev/mapper/VolGroup00-ldecmeta /var/netwitness/logdecoder/metadb xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			echo '/dev/mapper/VolGroup00-ldecpack /var/netwitness/logdecoder/packetdb xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			echo '/dev/mapper/VolGroup00-ldecsess /var/netwitness/logdecoder/sessiondb xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			echo '/dev/mapper/VolGroup00-ipdbext /var/netwitness/ipdbextractor xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			echo '/dev/mapper/VolGroup00-rsasoc /home/rsasoc xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			echo '/dev/mapper/VolGroup00-redb /var/netwitness/database xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			echo '/dev/mapper/VolGroup00-uax /var/lib/netwitness xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			if [ $logcol ]; then
				getvgfreemib "VolGroup00"
				# half freemib
				remainder=`expr	$vgfreemib % 2`
				if [ $remainder = 0 ]; then
					size=`expr $vgfreemib / 2`
				else
					vgfreemib=`expr $vgfreemib - 1`
					size=`expr $vgfreemib / 2`
				fi
				chroot /mnt/sysimage /sbin/lvcreate -ay -n lcol -L ${size}M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
				chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/lcol | tee -a $mylog > /dev/tty3
				mkdir -p /mnt/sysimage/var/netwitness/logcollector | tee -a $mylog > /dev/tty3
				chroot /mnt/sysimage /bin/mount -t xfs /dev/VolGroup00/lcol /var/netwitness/logcollector | tee -a $mylog > /dev/tty3
				echo '/dev/mapper/VolGroup00-lcol /var/netwitness/logcollector xfs defaults,noatime,nosuid 1 2' >> $FSTAB
				chroot /mnt/sysimage /sbin/lvresize -l +100%FREE /dev/VolGroup00/rabmq | tee -a $mylog > /dev/tty3
				chroot /mnt/sysimage /usr/sbin/xfs_growfs /var/lib/rabbitmq | tee -a $mylog > /dev/tty3
			fi
		;;
		logcollector )
			getvgfreemib "VolGroup00"
			# half freemib
			remainder=`expr	$vgfreemib % 2`
			if [ $remainder = 0 ]; then
				size=`expr $vgfreemib / 2`
			else
				vgfreemib=`expr $vgfreemib - 1`
				size=`expr $vgfreemib / 2`
			fi
			chroot /mnt/sysimage /sbin/lvcreate -ay -n lcol -L ${size}M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/lcol | tee -a $mylog > /dev/tty3
			mkdir -p /mnt/sysimage/var/netwitness/logcollector | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /bin/mount -t xfs /dev/VolGroup00/lcol /var/netwitness/logcollector | tee -a $mylog > /dev/tty3
			echo '/dev/mapper/VolGroup00-lcol /var/netwitness/logcollector xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			chroot /mnt/sysimage /sbin/lvresize -l +100%FREE /dev/VolGroup00/rabmq | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /usr/sbin/xfs_growfs /mnt/sysimage/var/lib/rabbitmq | tee -a $mylog > /dev/tty3
		;;
		logdecoder )
			if [ $openstack ]; then
				chroot /mnt/sysimage /sbin/lvcreate -ay -n warec -L 10240M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
				chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/warec | tee -a $mylog > /dev/tty3
				mkdir -p /mnt/sysimage/var/netwitness/warehouseconnector | tee -a $mylog > /dev/tty3
				echo '/dev/mapper/VolGroup00-warec /var/netwitness/warehouseconnector xfs defaults,noatime,nosuid 1 2' >> $FSTAB
				chroot /mnt/sysimage /sbin/lvcreate -ay -n lcol -L 10240M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
				chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/lcol | tee -a $mylog > /dev/tty3
				echo '/dev/mapper/VolGroup00-lcol /var/netwitness/logcollector xfs defaults,noatime,nosuid 1 2' >> $FSTAB
				chroot /mnt/sysimage /sbin/lvresize -L +10240M /dev/VolGroup00/rabmq | tee -a $mylog > /dev/tty3
				chroot /mnt/sysimage /usr/sbin/xfs_growfs /var/lib/rabbitmq | tee -a $mylog > /dev/tty3

			else
				if [ $warec ]; then
					chroot /mnt/sysimage /sbin/lvcreate -ay -n warec -L 409600M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
					chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/warec | tee -a $mylog > /dev/tty3
					mkdir -p /mnt/sysimage/var/netwitness/warehouseconnector | tee -a $mylog > /dev/tty3
					chroot /mnt/sysimage /bin/mount -t xfs /dev/VolGroup00/warec /var/netwitness/warehouseconnector | tee -a $mylog > /dev/tty3
					echo '/dev/mapper/VolGroup00-warec /var/netwitness/warehouseconnector xfs defaults,noatime,nosuid 1 2' >> $FSTAB
				fi
				if [ $logcol ]; then
					if ! [ $warec ]; then
						chroot /mnt/sysimage /sbin/lvcreate -ay -n lcol -L 204800M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
						chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/lcol | tee -a $mylog > /dev/tty3
						mkdir -p /mnt/sysimage/var/netwitness/logcollector | tee -a $mylog > /dev/tty3
						chroot /mnt/sysimage /bin/mount -t xfs /dev/VolGroup00/lcol /var/netwitness/logcollector | tee -a $mylog > /dev/tty3
						echo '/dev/mapper/VolGroup00-lcol /var/netwitness/logcollector xfs defaults,noatime,nosuid 1 2' >> $FSTAB
						chroot /mnt/sysimage /sbin/lvresize -L +204800M /dev/VolGroup00/rabmq | tee -a $mylog > /dev/tty3
						chroot /mnt/sysimage /usr/sbin/xfs_growfs /var/lib/rabbitmq | tee -a $mylog > /dev/tty3
					else
						getvgfreemib "VolGroup00"
						# half freemib
						remainder=`expr	$vgfreemib % 2`
						if [ $remainder = 0 ]; then
							size=`expr $vgfreemib / 2`
						else
							vgfreemib=`expr $vgfreemib - 1`
							size=`expr $vgfreemib / 2`
						fi
						chroot /mnt/sysimage /sbin/lvcreate -ay -n lcol -L ${size}M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
						chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/lcol | tee -a $mylog > /dev/tty3
						mkdir -p /mnt/sysimage/var/netwitness/logcollector | tee -a $mylog > /dev/tty3
						chroot /mnt/sysimage /bin/mount -t xfs /dev/VolGroup00/lcol /var/netwitness/logcollector | tee -a $mylog > /dev/tty3
						echo '/dev/mapper/VolGroup00-lcol /var/netwitness/logcollector xfs defaults,noatime,nosuid 1 2' >> $FSTAB
						chroot /mnt/sysimage /sbin/lvresize -l +100%FREE /dev/VolGroup00/rabmq | tee -a $mylog > /dev/tty3
						chroot /mnt/sysimage /usr/sbin/xfs_growfs /var/lib/rabbitmq | tee -a $mylog > /dev/tty3
					fi
				fi
			fi
		;;
		loghybrid )
			chroot /mnt/sysimage /sbin/lvcreate -ay -n concroot -L 30720M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/lvcreate -ay -n concinde -L 307200M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/lvcreate -ay -n concsess -L 30720M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/lvcreate -ay -n ldecroot -L 30720M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/lvcreate -ay -n ldecinde -L 30720M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/lvcreate -ay -n ldecmeta -L 307200M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/lvcreate -ay -n ldecsess -L 30720M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/concroot | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/concinde | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/concsess | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/ldecroot | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/ldecinde | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/ldecmeta | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/ldecsess | tee -a $mylog > /dev/tty3
			mkdir -p /mnt/sysimage/var/netwitness/concentrator /mnt/sysimage/var/netwitness/logdecoder | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /bin/mount -t xfs /dev/VolGroup00/ldecroot /var/netwitness/logdecoder | tee -a $mylog > /dev/tty3
			mkdir -p /mnt/sysimage/var/netwitness/logdecoder/index /mnt/sysimage/var/netwitness/logdecoder/metadb /mnt/sysimage/var/netwitness/logdecoder/packetdb /mnt/sysimage/var/netwitness/logdecoder/sessiondb | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /bin/mount -t xfs /dev/VolGroup00/concroot /var/netwitness/concentrator | tee -a $mylog > /dev/tty3
			mkdir -p /mnt/sysimage/var/netwitness/concentrator/index /mnt/sysimage/var/netwitness/concentrator/metadb /mnt/sysimage/var/netwitness/concentrator/sessiondb | tee -a $mylog > /dev/tty3
			echo '/dev/mapper/VolGroup00-concroot /var/netwitness/concentrator xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			echo '/dev/mapper/VolGroup00-concinde /var/netwitness/concentrator/index xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			echo '/dev/mapper/VolGroup00-concsess /var/netwitness/concentrator/sessiondb xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			echo '/dev/mapper/VolGroup00-ldecroot /var/netwitness/logdecoder xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			echo '/dev/mapper/VolGroup00-ldecinde /var/netwitness/logdecoder/index xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			echo '/dev/mapper/VolGroup00-ldecmeta /var/netwitness/logdecoder/metadb xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			echo '/dev/mapper/VolGroup00-ldecsess /var/netwitness/logdecoder/sessiondb xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			if [ $warec ]; then
				chroot /mnt/sysimage /sbin/lvcreate -ay -n warec -L 409600M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
				chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/warec | tee -a $mylog > /dev/tty3
				mkdir -p /mnt/sysimage/var/netwitness/warehouseconnector | tee -a $mylog > /dev/tty3
				chroot /mnt/sysimage /bin/mount -t xfs /dev/VolGroup00/warec /var/netwitness/warehouseconnector | tee -a $mylog > /dev/tty3
				echo '/dev/mapper/VolGroup00-warec /var/netwitness/warehouseconnector xfs defaults,noatime,nosuid 1 2' >> $FSTAB
				fi
			if [ $logcol ]; then
				if ! [ $warec ]; then
					chroot /mnt/sysimage /sbin/lvcreate -ay -n lcol -L 204800M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
					chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/lcol | tee -a $mylog > /dev/tty3
					mkdir -p /mnt/sysimage/var/netwitness/logcollector | tee -a $mylog > /dev/tty3
					chroot /mnt/sysimage /bin/mount -t xfs /dev/VolGroup00/lcol /var/netwitness/logcollector | tee -a $mylog > /dev/tty3
					chroot /mnt/sysimage /sbin/lvresize -L +204800M /dev/VolGroup00/rabmq | tee -a $mylog > /dev/tty3
					chroot /mnt/sysimage /usr/sbin/xfs_growfs /var/lib/rabbitmq | tee -a $mylog > /dev/tty3
					echo '/dev/mapper/VolGroup00-lcol /var/netwitness/logcollector xfs defaults,noatime,nosuid 1 2' >> $FSTAB
				else
					getvgfreemib "VolGroup00"
					# quarter freemib, use one fourth each for LC and raabbitmq
					remainder=`expr	$vgfreemib % 2`
					if [ $remainder = 0 ]; then
						size=`expr $vgfreemib / 4`
					else
						vgfreemib=`expr $vgfreemib - 1`
						size=`expr $vgfreemib / 4`
					fi
					chroot /mnt/sysimage /sbin/lvcreate -ay -n lcol -L ${size}M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
					chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/lcol | tee -a $mylog > /dev/tty3
					mkdir -p /mnt/sysimage/var/netwitness/logcollector | tee -a $mylog > /dev/tty3
					chroot /mnt/sysimage /bin/mount -t xfs /dev/VolGroup00/lcol /var/netwitness/logcollector | tee -a $mylog > /dev/tty3
					echo '/dev/mapper/VolGroup00-lcol /var/netwitness/logcollector xfs defaults,noatime,nosuid 1 2' >> $FSTAB
					chroot /mnt/sysimage /sbin/lvresize -L +${size}M /dev/VolGroup00/rabmq | tee -a $mylog > /dev/tty3
					chroot /mnt/sysimage /usr/sbin/xfs_growfs /var/lib/rabbitmq | tee -a $mylog > /dev/tty3
				fi
			fi
			
			# allocate remaining free space to decoder/packetdb and concentrator/metadb
			getvgfreemib "VolGroup00"
			let size=${vgfreemib}
			remainder=`expr $size % 2`
			if ! [ $remainder = 0 ]; then
				let size=$size-1
			fi
			let size=$size/2 
			chroot /mnt/sysimage /sbin/lvcreate -ay -n ldecpack -L ${size}M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/ldecpack | tee -a $mylog > /dev/tty3
			echo '/dev/mapper/VolGroup00-ldecpack /var/netwitness/logdecoder/packetdb xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			chroot /mnt/sysimage /sbin/lvcreate -ay -n concmeta -l 100%FREE /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/concmeta | tee -a $mylog > /dev/tty3
			echo '/dev/mapper/VolGroup00-concmeta /var/netwitness/concentrator/metadb xfs defaults,noatime,nosuid 1 2' >> $FSTAB
		;;
		packetaio )
			chroot /mnt/sysimage /sbin/lvcreate -ay -n broker -L 102400M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/lvcreate -ay -n ipdbext -L 30720M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/lvcreate -ay -n rsasoc -L 20480M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/lvcreate -ay -n redb -L 20480M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/lvcreate -ay -n uax -L 20480M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			# keep core lvs' 30 GB max
			chroot /mnt/sysimage /sbin/lvcreate -ay -n concroot -L 30720M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/lvcreate -ay -n concinde -L 307200M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/lvcreate -ay -n concmeta -L 4096M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/lvcreate -ay -n concsess -L 3072M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/lvcreate -ay -n decoroot -L 30720M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/lvcreate -ay -n decoinde -L 30720M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/lvcreate -ay -n decometa -L 307200M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/lvcreate -ay -n decopack -L 4096M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/lvcreate -ay -n decosess -L 30720M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/broker | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/ipdbext | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/rsasoc | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/redb | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/uax | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/concroot | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/concinde | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/concmeta | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/concsess | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/decoroot | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/decoinde | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/decometa | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/decopack | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/decosess | tee -a $mylog > /dev/tty3
			if [ -d /mnt/sysimage/var/lib/netwitness ]; then
				mv -f /mnt/sysimage/var/lib/netwitness /mnt/sysimage/var/lib/olnetwitness | tee -a $mylog > /dev/tty3
			fi
			mv -f /mnt/sysimage/var/netwitness/ipdbextractor /mnt/sysimage/var/netwitness/olipdbextractor | tee -a $mylog > /dev/tty3
			mkdir -p /mnt/sysimage/var/netwitness/broker /mnt/sysimage/var/netwitness/concentrator /mnt/sysimage/var/netwitness/decoder /mnt/sysimage/var/netwitness/database /mnt/sysimage/var/lib/netwitness /mnt/sysimage/home/rsasoc /mnt/sysimage/var/netwitness/ipdbextractor | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /bin/mount -t xfs /dev/VolGroup00/decoroot /var/netwitness/decoder | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /bin/mount -t xfs /dev/VolGroup00/uax /var/lib/netwitness | tee -a $mylog > /dev/tty3
			mkdir -p /mnt/sysimage/var/netwitness/decoder/index /mnt/sysimage/var/netwitness/decoder/metadb /mnt/sysimage/var/netwitness/decoder/packetdb /mnt/sysimage/var/netwitness/decoder/sessiondb | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /bin/mount -t xfs /dev/VolGroup00/concroot /var/netwitness/concentrator | tee -a $mylog > /dev/tty3
			mkdir -p /mnt/sysimage/var/netwitness/concentrator/index /mnt/sysimage/var/netwitness/concentrator/metadb /mnt/sysimage/var/netwitness/concentrator/sessiondb | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /bin/mount -t xfs /dev/VolGroup00/redb /var/netwitness/database | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /bin/mount -t xfs /dev/VolGroup00/rsasoc /home/rsasoc | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /bin/mount -t xfs /dev/VolGroup00/ipdbext /var/netwitness/ipdbextractor | tee -a $mylog > /dev/tty3
			mirrordir /mnt/sysimage/var/netwitness/olipdbextractor /mnt/sysimage/var/netwitness/ipdbextractor | tee -a $mylog > /dev/tty3
			rm -Rf /mnt/sysimage/var/netwitness/olipdbextractor | tee -a $mylog > /dev/tty3 | tee -a $mylog > /dev/tty3
			if [ -d /mnt/sysimage/var/lib/olnetwitness ]; then
				mirrordir /mnt/sysimage/var/lib/olnetwitness /mnt/sysimage/var/lib/netwitness | tee -a $mylog > /dev/tty3
				rm -Rf /mnt/sysimage/var/lib/olnetwitness | tee -a $mylog > /dev/tty3
			fi
			echo '/dev/mapper/VolGroup00-broker /var/netwitness/broker xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			echo '/dev/mapper/VolGroup00-concroot /var/netwitness/concentrator xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			echo '/dev/mapper/VolGroup00-concinde /var/netwitness/concentrator/index xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			echo '/dev/mapper/VolGroup00-concmeta /var/netwitness/concentrator/metadb xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			echo '/dev/mapper/VolGroup00-concsess /var/netwitness/concentrator/sessiondb xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			echo '/dev/mapper/VolGroup00-decoroot /var/netwitness/decoder xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			echo '/dev/mapper/VolGroup00-decoinde /var/netwitness/decoder/index xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			echo '/dev/mapper/VolGroup00-decometa /var/netwitness/decoder/metadb xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			echo '/dev/mapper/VolGroup00-decopack /var/netwitness/decoder/packetdb xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			echo '/dev/mapper/VolGroup00-decosess /var/netwitness/decoder/sessiondb xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			echo '/dev/mapper/VolGroup00-ipdbext /var/netwitness/ipdbextractor xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			echo '/dev/mapper/VolGroup00-rsasoc /home/rsasoc xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			echo '/dev/mapper/VolGroup00-redb /var/netwitness/database xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			echo '/dev/mapper/VolGroup00-uax /var/lib/netwitness xfs defaults,noatime,nosuid 1 2' >> $FSTAB
		;;
		packethybrid )
			chroot /mnt/sysimage /sbin/lvcreate -ay -n concroot -L 30720M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/lvcreate -ay -n concinde -L 307200M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/lvcreate -ay -n concsess -L 30720M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/lvcreate -ay -n decoroot -L 30720M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/lvcreate -ay -n decoinde -L 30720M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/lvcreate -ay -n decometa -L 307200M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/lvcreate -ay -n decosess -L 30720M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			if [ $warec ]; then
				chroot /mnt/sysimage /sbin/lvcreate -ay -n warec -L 409600M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
				chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/warec | tee -a $mylog > /dev/tty3
				mkdir -p /mnt/sysimage/var/netwitness/warehouseconnector | tee -a $mylog > /dev/tty3
				chroot /mnt/sysimage /bin/mount -t xfs /dev/VolGroup00/warec /var/netwitness/warehouseconnector | tee -a $mylog > /dev/tty3
				echo '/dev/mapper/VolGroup00-warec /var/netwitness/warehouseconnector xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			fi
			# allocate remaining free space to decoder/packetdb and concentrator/metadb
			getvgfreemib "VolGroup00"
			let size=${vgfreemib}
			remainder=`expr $size % 2`
			if ! [ $remainder = 0 ]; then
				let size=$size-1
			fi
			let size=$size/2			
			chroot /mnt/sysimage /sbin/lvcreate -ay -n decopack -L ${size}M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/lvcreate -ay -n concmeta -l 100%FREE /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/concroot | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/concinde | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/concmeta | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/concsess | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/decoroot | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/decoinde | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/decometa | tee -a $mylog > /dev/tty3		
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/decopack | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/decosess | tee -a $mylog > /dev/tty3
			mkdir -p /mnt/sysimage/var/netwitness/concentrator /mnt/sysimage/var/netwitness/decoder | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /bin/mount -t xfs /dev/VolGroup00/decoroot /var/netwitness/decoder | tee -a $mylog > /dev/tty3
			mkdir -p /mnt/sysimage/var/netwitness/decoder/index /mnt/sysimage/var/netwitness/decoder/metadb /mnt/sysimage/var/netwitness/decoder/packetdb /mnt/sysimage/var/netwitness/decoder/sessiondb | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /bin/mount -t xfs /dev/VolGroup00/concroot /var/netwitness/concentrator | tee -a $mylog > /dev/tty3
			mkdir -p /mnt/sysimage/var/netwitness/concentrator/index /mnt/sysimage/var/netwitness/concentrator/metadb /mnt/sysimage/var/netwitness/concentrator/sessiondb | tee -a $mylog > /dev/tty3
			echo '/dev/mapper/VolGroup00-concroot /var/netwitness/concentrator xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			echo '/dev/mapper/VolGroup00-concinde /var/netwitness/concentrator/index xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			echo '/dev/mapper/VolGroup00-concmeta /var/netwitness/concentrator/metadb xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			echo '/dev/mapper/VolGroup00-concsess /var/netwitness/concentrator/sessiondb xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			echo '/dev/mapper/VolGroup00-decoroot /var/netwitness/decoder xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			echo '/dev/mapper/VolGroup00-decoinde /var/netwitness/decoder/index xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			echo '/dev/mapper/VolGroup00-decometa /var/netwitness/decoder/metadb xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			echo '/dev/mapper/VolGroup00-decopack /var/netwitness/decoder/packetdb xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			echo '/dev/mapper/VolGroup00-decosess /var/netwitness/decoder/sessiondb xfs defaults,noatime,nosuid 1 2' >> $FSTAB

		;;
		sabroker )
			if [ $openstack ]; then
				getvgfreemib "VolGroup00"
				local afifth=`python -c "myvar=${vgfreemib}; print myvar / 5"`
				afifth=`printf %.0f ${afifth}` 
				chroot /mnt/sysimage /sbin/lvcreate -ay -n broker -L ${afifth}M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
				chroot /mnt/sysimage /sbin/lvcreate -ay -n ipdbext -L ${afifth}M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
				chroot /mnt/sysimage /sbin/lvcreate -ay -n rsasoc -L ${afifth}M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
				chroot /mnt/sysimage /sbin/lvcreate -ay -n redb -L ${afifth}M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
				chroot /mnt/sysimage /sbin/lvcreate -ay -n uax -l 100%FREE /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			else
				chroot /mnt/sysimage /sbin/lvcreate -ay -n broker -L 102400M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
				chroot /mnt/sysimage /sbin/lvcreate -ay -n ipdbext -L 30720M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
				chroot /mnt/sysimage /sbin/lvcreate -ay -n rsasoc -L 204800M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
				chroot /mnt/sysimage /sbin/lvcreate -ay -n redb -L 204800M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
				chroot /mnt/sysimage /sbin/lvcreate -ay -n uax -L 204800M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			fi
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/broker | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/ipdbext | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/rsasoc | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/redb | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/uax | tee -a $mylog > /dev/tty3
			if [ -d /mnt/sysimage/var/lib/netwitness ]; then
				mv -f /mnt/sysimage/var/lib/netwitness /mnt/sysimage/var/lib/olnetwitness | tee -a $mylog > /dev/tty3
			fi
			mv -f /mnt/sysimage/var/netwitness/ipdbextractor /mnt/sysimage/var/netwitness/olipdbextractor | tee -a $mylog > /dev/tty3
			mkdir -p /mnt/sysimage/var/netwitness/broker /mnt/sysimage/var/netwitness/database /mnt/sysimage/var/lib/netwitness /mnt/sysimage/home/rsasoc /mnt/sysimage/var/netwitness/ipdbextractor | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /bin/mount -t xfs /dev/VolGroup00/uax /var/lib/netwitness | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /bin/mount -t xfs /dev/VolGroup00/redb /var/netwitness/database | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /bin/mount -t xfs /dev/VolGroup00/rsasoc /home/rsasoc | tee -a $mylog > /dev/tty3		
			chroot /mnt/sysimage /bin/mount -t xfs /dev/VolGroup00/ipdbext /var/netwitness/ipdbextractor | tee -a $mylog > /dev/tty3
			mirrordir /mnt/sysimage/var/netwitness/olipdbextractor /mnt/sysimage/var/netwitness/ipdbextractor | tee -a $mylog > /dev/tty3
			rm -Rf /mnt/sysimage/var/netwitness/olipdbextractor | tee -a $mylog > /dev/tty3 | tee -a $mylog > /dev/tty3
			if [ -d /mnt/sysimage/var/lib/olnetwitness ]; then
				mirrordir /mnt/sysimage/var/lib/olnetwitness /mnt/sysimage/var/lib/netwitness | tee -a $mylog > /dev/tty3
				rm -Rf /mnt/sysimage/var/lib/olnetwitness | tee -a $mylog > /dev/tty3
			fi
			echo '/dev/mapper/VolGroup00-broker /var/netwitness/broker xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			echo '/dev/mapper/VolGroup00-ipdbext /var/netwitness/ipdbextractor xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			echo '/dev/mapper/VolGroup00-rsasoc /home/rsasoc xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			echo '/dev/mapper/VolGroup00-redb /var/netwitness/database xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			echo '/dev/mapper/VolGroup00-uax /var/lib/netwitness xfs defaults,noatime,nosuid 1 2' >> $FSTAB
		;;
		spectrumbroker )
			getvgfreemib "VolGroup00"
			# 60% file, 40% database
			size=`python -c "sizemib = ${vgfreemib}.0; print sizemib * 0.60"`
			size=`printf "%.0f" $size | awk '{print $1}'`
			chroot /mnt/sysimage /sbin/lvcreate -ay -n specfile -L ${size}M /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/lvcreate -ay -n specdb -l 100%FREE /dev/VolGroup00 | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/specfile | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /sbin/mkfs.xfs /dev/VolGroup00/specdb | tee -a $mylog > /dev/tty3
			mv -f /mnt/sysimage/var/lib/pgsql /mnt/sysimage/var/lib/olpgsql | tee -a $mylog > /dev/tty3
			mkdir -p /mnt/sysimage/var/lib/rsamalware /mnt/sysimage/var/lib/pgsql | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /bin/mount -t xfs /dev/VolGroup00/specdb /var/lib/pgsql | tee -a $mylog > /dev/tty3
			chroot /mnt/sysimage /bin/mount -t xfs /dev/VolGroup00/specfile /var/lib/rsamalware | tee -a $mylog > /dev/tty3
			mirrordir /mnt/sysimage/var/lib/olpgsql /mnt/sysimage/var/lib/pgsql
			rm -Rf /mnt/sysimage/var/lib/olpgsql
			echo '/dev/mapper/VolGroup00-specfile /var/lib/rsamalware xfs defaults,noatime,nosuid 1 2' >> $FSTAB
			echo '/dev/mapper/VolGroup00-specdb /var/lib/pgsql xfs defaults,noatime,nosuid 1 2' >> $FSTAB

		;;
		* )
			echo > /dev/null
		;;
	esac

}

function runPostScript {
# run %post function calls in /tmp/nwpost.txt
	
	local POSTCALLS='/tmp/nwpost.txt'
	local calls
	local count
	local item
	
	# copy install files and logs to /root/imagefiles folder, set appliance type in /etc/issue
	function bakimagefiles {
		local apptype
		local appstr 

		mkdir /mnt/sysimage/root/imagefiles
		rsync -rL --exclude='uudecode' --exclude='MegaCLI' --exclude='mnt' --exclude='updates' --exclude='mpoint' /tmp/ /mnt/sysimage/root/imagefiles
	
		apptype=`cat /tmp/nwapptype | awk '{print $1}'`
		case $apptype in
			broker )
				appstr='RSA Broker Appliance'
			;;
			concentrator )
				appstr='RSA Concentrator Appliance'	
			;;
			decoder )
				appstr='RSA Packet Decoder Appliance'
			;;
			logdecoder )
				appstr='RSA Log Decoder Appliance'
			;;
			spectrumbroker )
				appstr='RSA Malware Protection Appliance'
			;;
			sabroker )
				appstr='RSA Security Analytics Server Appliance'
			;;
			loghybrid )
				appstr='RSA Logs Hybrid Appliance'
			;;
			packethybrid )
				appstr='RSA Packet Hybrid Appliance'
			;;
			logaio )
				appstr='RSA Logs AIO Appliance'
			;;
			packetaio )
				appstr='RSA Packet AIO Appliance'
			;;
			logcollector )
				appstr='RSA Log Collector Appliance'
			;;
			ipdbextractor )
				appstr='RSA IPDB Extractor Appliance'
			;;
			maprwh )
				appstr='RSA Warehouse Powered by MapR Appliance'
			;;
			archiver )
				appstr='RSA Archiver Appliance'
			;;
			connector )
				appstr='RSA Warehouse Connector Appliance'
			;;
			esa )
				appstr='RSA Event Stream Analysis Appliance'
			;;
			* )
				appstr='RSA Security Analytics Appliance'
			;; 
		esac
	
		echo "$appstr" > /mnt/sysimage/etc/issue
		if [ -s /tmp/nwcompid.txt ]; then
			 cat /tmp/nwcompid.txt >> /mnt/sysimage/etc/issue
		fi
		echo "Kernel \r on an \m" >> /mnt/sysimage/etc/issue
	}

	# insert common, read in and run %post function calls
	let count=0
	calls[$count]='install_post_package'
	let count=$count+1
	if [ -s $POSTCALLS ]; then	
		while read line
		do
			# skip comments and blank lines
			if [[ `echo "$line" | grep -E '^[[:space:]]*#'` || `echo "$line" | grep -E '^[[:space:]]*$'` ]]; then
				continue
			else
				calls[$count]="$line"
				let count=$count+1
			fi
		done < $POSTCALLS
	fi 
	if ! [ -s $POSTCALLS ] || ! [[ `grep 'check_post_package' $POSTCALLS` ]]; then
		calls[$count]='check_post_package'
		let count=$count+1
	fi
	calls[$count]='bakimagefiles'
	let count=$count+1
	calls[$count]='kill_installer'
	for item in "${calls[@]}"
	do
		echo "calling %post function: $item" | tee -a /tmp/post.log > /dev/tty3
		$item >> /tmp/post.log 2>&1
	done
} 
