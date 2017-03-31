# ^^^^^^^^^^^^^^^^^^^^^^ global constants ^^^^^^^^^^^^^^^^^^^^^^^^^

raid_models_list=( "PERC H700" "PERC H710P" "SRCSAS144E" "MegaRAID 8888ELP" "MR9260DE-8i" "MR9260-8i" "MR9260-4i" "AOC-USAS2LP-H8iR" "Internal Dual SD" )

# list of common packages to install in %post
commpack=( "nwsupport-script" )
pxetesthost='hwimgsrv.nw-xlabs'

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

	echo "password --md5 \$1\$K7uqK\$bUbRkTIRK5zem3tYXF7ai0
default 0
timeout 5
title Boot
	root (hd0,0)
	kernel /$KERNEL root=/dev/VolGroup00/root ro nodmraid quiet
	initrd /$INITRD
" > /mnt/sysimage/boot/grub/grub.conf
		
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
	local mysystype=`cat /tmp/nwsystem`
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
	elif [[ "${mysystype}" = 'dell-s9-1u' || "${mysystype}" = 'dell-s5-2u' ]]; then
			# change ethernet device naming making 1G ports em1 & em2 and 10G em3 & em4
			cd /mnt/sysimage/etc/sysconfig/network-scripts
			# re-config em3: 1000Base-T as em1
			sed 's/DEVICE=.*/DEVICE=em1/' < ifcfg-em3 > ifcfg-emC
			# re-config em1: 10000Base-T as em3
			sed 's/DEVICE=.*/DEVICE=em3/' < ifcfg-em1 > ifcfg-emA
			mv -f ifcfg-emA ifcfg-em1
			sed 's/NM_CONTROLLED=.*/NM_CONTROLLED=no/' < ifcfg-em1 > ifcfg-emA
			mv -f ifcfg-emA ifcfg-em1
			sed 's/BOOTPROTO=.*/BOOTPROTO=none/' < ifcfg-em1 > ifcfg-emA
			mv -f ifcfg-emA ifcfg-em3
			mv -f ifcfg-emC ifcfg-em1
			# re-config em4: 1000Base-T as em2
			sed 's/DEVICE=.*/DEVICE=em2/' < ifcfg-em4 > ifcfg-emD
			mv -f ifcfg-emD ifcfg-em4
			sed 's/NM_CONTROLLED=.*/NM_CONTROLLED=no/' < ifcfg-em4 > ifcfg-emD
			mv -f ifcfg-emD ifcfg-em4
			sed 's/BOOTPROTO=.*/BOOTPROTO=none/' < ifcfg-em4 > ifcfg-emD
			# re-config em2: 10000Base-T as em4
			sed 's/DEVICE=.*/DEVICE=em4/' < ifcfg-em2 > ifcfg-emB
			mv -f ifcfg-emB ifcfg-em2
			sed 's/NM_CONTROLLED=.*/NM_CONTROLLED=no/' < ifcfg-em2 > ifcfg-emB
			mv -f ifcfg-emB ifcfg-em2
			sed 's/BOOTPROTO=.*/BOOTPROTO=none/' < ifcfg-em2 > ifcfg-emB
			mv -f ifcfg-emD ifcfg-em2
			mv -f ifcfg-emB ifcfg-em4
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
	local MYMETA='/var/netwitness/srv/www/rsa/updates'
	local YUMCFG

	# clone media software repository to SA UI repo
	if [[ `dmesg | grep -i 'kernel command line' | grep 'ks=cdrom'` ]]; then
		opticalMedia='true'
	elif [[ `dmesg | grep -i 'kernel command line' | grep 'ks=hd'` ]]; then
		hddMedia='true'
	elif [[ `dmesg | grep -i 'kernel command line' | grep 'ks=http'` ]]; then
		urlMedia='true'
		installUrl=`dmesg | grep -i 'kernel command line' | awk -F'ks=' '{print $2}' | awk '{print $1}'`
		installUrl=${installUrl%/*}
		echo "config_uax: installUrl = $installUrl" | tee -a /tmp/post.log >> /dev/tty3
		let strLen=${#installUrl}
		let strLen=$strLen-1
		lastChar=${installUrl:$strLen}
		if [[ "$lastChar" != '/' ]]; then
			installUrl="${installUrl}/Packages/"
		else
			installUrl="${installUrl}Packages/"
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
		cd /mnt/sysimage${MYREPO}
		chroot /mnt/sysimage /usr/bin/yum -c /root/yum.conf.tmp --disablerepo=base,extras,updates -y install rsa-audit-plugins 
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
# configure postgresql database for reporting engine 
    
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

# install nwwarehouseconnector and dependencies in %post because of yum dependency bug
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
	chroot /mnt/sysimage /usr/bin/yum -c /root/yum.conf.tmp --disablerepo=base,extras,updates -y install nwappliance nwconsole nwwarehouseconnector 
	rm -f $YUMCFG
 	if [[ `mount | grep '/mnt/sysimage/mnt'` ]]; then
		umount /mnt/sysimage/mnt
	fi
}

# add mounts purposely ignored by system upgrade to /etc/fstab
function check_upgd_mounts { 
	if [ -s /tmp/nwvols.txt ]; then
		chvt 3
		echo | tee -a /tmp/post.log > /dev/tty3
		echo ' validating system upgrade mounts' | tee -a /tmp/post.log > /dev/tty3
		
		local count
		local appmounts
		local numloops
		local device
		local mpoint
		local format
		local options
		local numslash
		local approot
		local apppath
		local index
		local fstype
		local errcode
		local mddevices
		local mddev
		local mdid
		local myinitrd
		local mykver
		local stalemd
		local rootlv
		local rootlvdev
		local rootfsuuid

		let count=0
		while read line
		do
			appmounts[$count]="$line"
			count=$count+1
		done < /tmp/nwvols.txt

		# check %pre install generated mdadm config, activate all md raid devices
		let count=`wc -l /tmp/mdadm.conf | awk '{print $1}'`
		if [ $count -gt 3 ]; then
			echo 'checking for offline linux raid devices ...' | tee -a /tmp/post.log > /dev/tty3
			let count=0
			while read line
			do
				# ignore comments
				if [[ `echo "$line" | grep -E '^[[:space:]]*#'` ]]; then
					continue
				fi
				mddevices[$count]="$line"
				let count=$count+1
			done < /tmp/mdadm.conf	
			for device in "${mddevices[@]}"
			do
				mddev=`echo "$device" | awk '{print $2}'`
				mdid=`basename $mddev`
				if ! [[ `grep -E "$mdid[[:space:]]+:[[:space:]]+active" /proc/mdstat` ]]; then
					stalemd=true
					#mdadm -A -U super-minor -f -c /tmp/mdadm.conf $mddev
					echo "assembling raid device $mdid" | tee -a /tmp/post.log > /dev/tty3
					mdadm -A -f -c /tmp/mdadm.conf $mddev | tee -a /tmp/post.log > /dev/tty3
				fi
			done

			# copy script generated mdadm.conf to system
			if [ -s /mnt/sysimage/etc/mdadm.conf ]; then
				mv -f /mnt/sysimage/etc/mdadm.conf /tmp/cfgbak/mdadm.conf.inst
			fi
			cp /tmp/mdadm.conf /mnt/sysimage/etc/
			
			# rescan for and activate volume groups/LVs'
			volumeGroupScan
			
			# new in centos 6.5, /etc/mdadm.conf is included in kernel ram disk
			# rebuild initrd with updated mdadm.conf file as required
			if [ $stalemd ]; then
				myinitrd=`ls /mnt/sysimage/boot | grep 'initramfs'`
				if [[ `lsinitrd /mnt/sysimage/boot/$myinitrd | grep 'etc/mdadm.conf'` ]]; then
					echo "re-building kernel ramdisk: $myinitrd" | tee -a /tmp/post.log > /dev/tty3
					mykver=${myinitrd#initramfs-}
					mykver=${mykver%\.img}
					mv /mnt/sysimage/boot/$myinitrd /mnt/sysimage/boot/$myinitrd.bak
					chroot /mnt/sysimage /bin/bash -c "cd /; dracut -f /boot/$myinitrd $mykver --mdadmconf"
				fi
			fi
		fi
		
		let numloops=${#appmounts[@]}
		let count=0
		while [ $count -lt $numloops ]
		do
			device=`echo "${appmounts[$count]}" | awk '{print $1}'`
			mpoint=`echo "${appmounts[$count]}" | awk '{print $2}'`
			format=`echo "${appmounts[$count]}" | awk '{print $3}'` 
			options=`echo "${appmounts[$count]}" | awk '{print $4}'`		
			
			if ! [[ `grep -E "^[[:space:]]*$device " /mnt/sysimage/etc/fstab` ]]; then
				if ! [ $format = swap ] && ! [ -d "/mnt/sysimage$mpoint" ]; then
					let numslash=`echo "$mpoint" | grep -o '/' | wc -l`
					# check if appliance root folder is mounted under either
					# /var/lib or /var/netwitness which should be already created and mounted
					if [ $numslash -gt 3 ]; then
						index=`expr match "$mpoint" '/[[:alnum:]]*/[[:alnum:]]*'`
						apppath=`${mpoint:0:$index}`	
						approot=${mpoint#/*/*/}
						approot=${approot%%/*}
						if ! [ -d "/mnt/sysimage$apppath/$approot" ]; then
							mkdir -p "/mnt/sysimage$apppath/$approot"
						fi 
						if ! [[ `mount -l | grep "/mnt/sysimage$apppath/$approot "` ]]; then
							fstype=`grep -E "^[[:space:]]*$appath/$approot " /tmp/nwvols.txt | awk '{print $3}'`
							mount -t $fstype /mnt/sysimage$apppath/$approot >> /tmp/post.log 2>&1
							if ! [ "$?" = '0' ]; then
								echo " error mounting application root, see /root/post.log for details" > /dev/tty3
								echo " some application volume mount points maybe missing" > /dev/tty3
							fi
						fi
						mkdir -p "/mnt/sysimage$mpoint"
					else
						mkdir -p "/mnt/sysimage$mpoint"
					fi
				fi

				if ! [[ $format = cifs || $format = nfs || $format = swap ]]; then
					# attempt mount
					mount -t "$format" "$device" "/mnt/sysimage$mpoint" >> /tmp/post.log 2>&1
					errcode=$?
					if [ "$errcode" = '0' ]; then
						if [[ `echo $mpoint | grep '/var/netwitness'` ]]; then
							echo "$device $mpoint $format defaults,noatime,nosuid 1 2" >> /mnt/sysimage/etc/fstab
						else
							echo "$device $mpoint $format defaults 1 2" >> /mnt/sysimage/etc/fstab
						fi
					else
						echo ' error mounting application volume, check /root/post.log for details' >> /dev/tty3
						echo ' leaving mount commented out in /etc/fstab' >> /dev/tty3
						if [[ `echo $mpoint | grep '/var/netwitness'` ]]; then
							echo "# $device $mpoint $format defaults,noatime,nosuid 1 2" >> /mnt/sysimage/etc/fstab
						else
							echo "# $device $mpoint $format defaults 1 2" >> /mnt/sysimage/etc/fstab
						fi
					fi
				else
					if [ $format = swap ]; then
						echo "$device $mpoint $format defaults 0 0" >> /mnt/sysimage/etc/fstab
					else
						if [ ${#options} != 0 ]; then
							echo "$device $mpoint $format $options 0 0" >> /mnt/sysimage/etc/fstab					
						else
							echo "$device $mpoint $format defaults 0 0" >> /mnt/sysimage/etc/fstab					
						fi
					fi
				fi

			fi
			let count=$count+1
		done

		# restore nw appliance configurations
		if [ -s /tmp/cfgbak/nw.tbz ]; then
			if [ -d /mnt/sysimage/etc/netwitness ]; then
				mv /mnt/sysimage/etc/netwitness /mnt/sysimage/etc/netwitness.oem
				tar -C /mnt/sysimage/etc -xjf /tmp/cfgbak/nw.tbz
				if [ -d /mnt/sysimage/etc/netwitness/9.0 ]; then
					mv /mnt/sysimage/etc/netwitness/9.0/ /mnt/sysimage/etc/netwitness/ng/
				fi
				# restore rsaCAS application directory
				cp -Rp /mnt/sysimage/etc/netwitness.oem/rsaCAS/ /mnt/sysimage/etc/netwitness/
			fi
		fi
	
		# restore network configuration
		restore_net_config

		# restore root password
		if [ -s /tmp/cfgbak/shadow ] && [[ `grep -E '^root:[^:]*:' /tmp/cfgbak/shadow` ]]; then
			local SHADFILE=/mnt/sysimage/etc/shadow
			cp -p $SHADFILE $SHADFILE.eloem
			local shadperm=`stat -c %a $SHADFILE`
			local shaduid=`stat -c %u $SHADFILE`
			local shadgid=`stat -c %g $SHADFILE`
			local oldpw=`grep '^root' /tmp/cfgbak/shadow | awk -F: '{print $2}'`
			oldpw=${oldpw//\//\\/}
			sed -r "s/(^root:)([^:]*)(:.*$)/\1$oldpw\3/" < $SHADFILE > $SHADFILE.tmp
			chmod $shadperm $SHADFILE.tmp
			chown $shaduid:$shadgid $SHADFILE.tmp
			mv -f $SHADFILE.tmp $SHADFILE
		fi

		# remove upgrade attempt flag volume
		lvchange -an /dev/mapper/VolGroup00-rsaupgdtry
		lvremove -f /dev/mapper/VolGroup00-rsaupgdtry
		
		# set upgrade flag for nwsupport-script rpm, only enable netconfig.sh on new installs
		echo 'script execution flag: /usr/sbin/netconfig.sh' > /mnt/sysimage/usr/sbin/netflag

		# extend nwhome, i.e. /var/netwitness, if used for a local backup device on a s4 system
		if [ -s /tmp/baknwhome ]; then
			if ! [[ `mount -l | grep '/mnt/sysimage/var/netwitness'` ]]; then
				lvchange -ay /dev/mapper/VolGroup00-nwhome | tee -a /tmp/post.log > /dev/tty3
				mount /dev/mapper/VolGroup00-nwhome /mnt/sysimage/var/netwitness | tee -a /tmp/post.log > /dev/tty3
			fi
			lvresize -f -l +100%FREE /dev/mapper/VolGroup00-nwhome | tee -a /tmp/post.log > /dev/tty3
			chroot /mnt/sysimage /usr/sbin/xfs_growfs /dev/mapper/VolGroup00-nwhome | tee -a /tmp/post.log > /dev/tty3
		fi

		# restore directory root uuid
		rootlv=`mount -l | grep -E '[[:space:]]+/mnt/sysimage[[:space:]]+' | awk '{print $1}'`
		echo "\$rootlv = $rootlv" | tee -a /tmp/post.log > /dev/tty3
		rootfsuuid=`cat /tmp/rootfsuuid.txt`
		echo "restoring root fs uuid: $rootfsuuid" | tee -a /tmp/post.log > /dev/tty3
		#chroot /mnt/sysimage /sbin/tune2fs -U $rootfsuuid $rootlv
		tune2fs -U $rootfsuuid $rootlv
			
		# restore root's .ssh/ folder and crontab
		if [ -d /tmp/cfgbak/.ssh ]; then
			echo "restoring root's .ssh/ folder" | tee -a /tmp/post.log > /dev/tty3
			cp -Rp /tmp/cfgbak/.ssh /mnt/sysimage/root/
		fi
		if [ -s /tmp/cfgbak/root.cron ]; then
			echo "restoring root's crontab file" | tee -a /tmp/post.log > /dev/tty3
			cp -P /tmp/cfgbak/root.cron /mnt/sysimage/var/spool/cron/root
		fi
		
		# restore any fneserver trusted store data
		if [ -s /tmp/cfgbak/fnetruststore.tgz ]; then
			tar -C /mnt/sysimage/var/lib/fneserver --overwrite -xzf /tmp/cfgbak/fnetruststore.tgz
		fi
		
		# restore any retro installed warehouse connector folders
		if [ -s /tmp/cfgbak/warec.tgz ]; then
			tar -C /mnt/sysimage/var/netwitness -xzf /tmp/cfgbak/warec.tgz
		fi

		# for decoders missing a index volume but have a conc root, create symlink pointing to /var/netwitness/concentrator
		local apptype=`cat /tmp/nwapptype`
		if [[ "$apptype" = 'decoder' ]]; then
			if ! [ -d /mnt/sysimage/var/netwitness/decoder/index ] && [ -d /mnt/sysimage/var/netwitness/concentrator ]; then
				ln -s ../concentrator /mnt/sysimage/var/netwitness/decoder/index
			fi
		fi
		chvt 1
	fi
}

# restore previous network configuration on upgraded systems
function restore_net_config {
	datestr=`date +%y%m%d%H%M%S` 
	# restore hosts, resolv.conf and global network configuration
	if [ -s /tmp/cfgbak/hosts ]; then
		mv -f /mnt/sysimage/etc/hosts /mnt/sysimage/etc/hosts.$datestr
		cp /tmp/cfgbak/hosts /mnt/sysimage/etc/
	fi
	if [ -s /tmp/cfgbak/network ]; then
		mv -f /mnt/sysimage/etc/sysconfig/network /mnt/sysimage/etc/sysconfig/network.$datestr
		cp /tmp/cfgbak/network /mnt/sysimage/etc/sysconfig/
	fi
	if [ -s /tmp/cfgbak/resolv.conf ]; then
		mv -f /mnt/sysimage/etc/resolv.conf /mnt/sysimage/etc/resolv.conf.$datestr
		cp /tmp/cfgbak/resolv.conf /mnt/sysimage/etc/
	fi
	# restore network interface configuration
	local ifdir=/mnt/sysimage/etc/sysconfig/network-scripts
	local ifbak=$ifdir/cfgbak
	#local sysnetbios=
	#local baknetbios=
	local item=
	local sysnetdev=
	local baknetdev=
	local sysdevcfg=
	local baknetcfg=
	local count=
	local listlen=
	local index=
	local line=
	
	# probably don't need this since the net device names are in alphabetical sort order 
	# check for system netbios support
	#if [[ -s $ifdir/ifcfg-em[0-9] || -s $ifdir/ifcfg-p[0-9]p[0-9] ]]; then
	#	sysnetbios=true
	#fi		
	
	# check for backup netbios support
	#if [[ -s /tmp/cfgbak/ifcfg-em[0-9] || -s /tmp/cfgbak/ifcfg-p[0-9]p[0-9] ]]; then
	#	baknetbios=true
	#fi
	
	# get listing of system network devices
	sysnetdev=( `ls $ifdir | grep 'ifcfg-' | grep -v 'ifcfg-lo'` )
	let listlen=${#sysnetdev[@]}
	
	# backup installer created interface files 
	mkdir -p $ifbak 
	for item in "${sysnetdev[@]}"
	do
		cp $ifdir/$item $ifbak/$item.$datestr
	done
	
	# get listing of backed up network devices
	baknetdev=( `ls /tmp/cfgbak | grep 'ifcfg-'` )
	
	# copy net device file backups to file system	
	for item in "${baknetdev[@]}"
	do
		cp /tmp/cfgbak/$item $ifbak/$item.bak$datestr
	done

	# read in net device configurations
	let index=0
	while [ $index -lt $listlen ]
	do
		# read in system net device config
		let count=0
		while read line
		do
			if [[ `echo "$line" | grep -i -E '^[[:space:]]*BOOTPROTO'` || `echo "$line" | grep -i -E '^[[:space:]]*IPADDR'` || `echo "$line" | grep -i -E '^[[:space:]]*NETMASK'` ]] || [[ `echo "$line" | grep -i -E '^[[:space:]]*GATEWAY'` || `echo "$line" | grep -i -E '^[[:space:]]*DNS[0-9]'` || `echo "$line" | grep -i -E '^[[:space:]]*ONBOOT'` ]] || [[ `echo "$line" | grep -i -E '^[[:space:]]*NM_CONTROLLED'` ]] ; then
				continue
			fi 
			sysdevcfg[$count]="$line"
			let count=$count+1
		done < $ifdir/${sysnetdev[$index]}
		
		# read in backup net device config					
		unset line
		let count=0
		while read line
		do
			if ! [[ `echo "$line" | grep -i -E '^[[:space:]]*BOOTPROTO'` || `echo "$line" | grep -i -E '^[[:space:]]*IPADDR'` || `echo "$line" | grep -i -E '^[[:space:]]*NETMASK'` ]] && ! [[ `echo "$line" | grep -i -E '^[[:space:]]*GATEWAY'` || `echo "$line" | grep -i -E '^[[:space:]]*DNS[0-9]'` || `echo "$line" | grep -i -E '^[[:space:]]*ONBOOT'` ]]; then
				continue
			fi
			bakdevcfg[$count]="$line"
			let count=$count+1
		done < /tmp/cfgbak/${baknetdev[$index]}
		
		# restore network configuration		
		rm -f  $ifdir/${sysnetdev[$index]}
		for item in "${sysdevcfg[@]}"
		do
			echo "$item" >> $ifdir/${sysnetdev[$index]}
		done
		echo 'NM_CONTROLLED=no' >> $ifdir/${sysnetdev[$index]}	
		for item in "${bakdevcfg[@]}"
		do
			echo "$item" >> $ifdir/${sysnetdev[$index]}
		done
		let index=$index+1
		unset sysdevcfg bakdevcfg
	done 
}

# set default network configuration on recent hardware, i.e. nehalem and later
function default_netcfg {
	# set default IP parameters to management interface, eth0 or em1
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
	elif [ -s $cfgdir/ifcfg-eth0 ]; then
		sed -r 's/BOOTPROTO=dhcp/BOOTPROTO=none/' < $cfgdir/ifcfg-eth0 > $cfgdir/ifcfg-eth0.tmp
		mv -f $cfgdir/ifcfg-eth0.tmp $cfgdir/ifcfg-eth0	
		sed -r 's/ONBOOT=no/ONBOOT=yes/' < $cfgdir/ifcfg-eth0 > $cfgdir/ifcfg-eth0.tmp
		mv -f $cfgdir/ifcfg-eth0.tmp $cfgdir/ifcfg-eth0
		sed -r 's/NM_CONTROLLED=yes/NM_CONTROLLED=no/' < $cfgdir/ifcfg-eth0 > $cfgdir/ifcfg-eth0.tmp
		mv -f $cfgdir/ifcfg-eth0.tmp $cfgdir/ifcfg-eth0
		echo 'IPADDR=192.168.1.1' >> $cfgdir/ifcfg-eth0
		echo 'NETMASK=255.255.255.0' >> $cfgdir/ifcfg-eth0
		echo 'GATEWAY=192.168.1.254' >> $cfgdir/ifcfg-eth0
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
	sed -r 's/(^[[:space:]]*start.*$)/#\1/' < $INIT > $INIT.tmp
	mv -f $INIT.tmp $INIT
}

function workbench_nice {
	local WBINIT=/mnt/sysimage/etc/init/nwworkbench.conf
	sed -r 's/(^[[:space:]]*exec[[:space:]]+.*$)/nice 10\n\1/' < $WBINIT > $WBINIT.tmp
	mv -f $WBINIT.tmp $WBINIT
	chmod 644 $WBINIT 
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
		sm-s3-1u-brok | dell-s3-1u-brok | dell-s3-1u | dell-s4-1u | dell-s4-2u | dell-s4s-1u | dell-s9-1u | dell-s5-2u )
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
	set_ethernet_devices 
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
	
	# run common %post functions
	genSNMPconf 
	set_kernel_tunables
	check_upgd_mounts
	#configure_fips
	
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
	
	# package names prepended with a dash '-', eg: -rsa-saw-server, are assumed to be installed in %post
	# or not installed
	# current defined appliance types, global variable string value
	# nwbroker, broker 
	# nwconcentrator, concentrator
	# nwdecoder, decoder
	# nwlogdecoder, logdecoder
	# spectrum enterprise, spectrumbroker
	# spectrum stand alone, spectrumdecoder
	# security analytics and broker and re, sabroker
	# logs hybrid, loghybrid
	# packet hybrid, packethybrid
	# logs aio, logaio
	# packet aio, packetaio
	# remote logcollector, logcollector
	# remote ipdb extractor, ipdbextractor
	# warehouse powered by mapr, maprwh
	# nwarchiver, archiver
	# nwwarehouseconnector, connector
	# event stream analytics, esa

	echo 'validating %post installed packages' >> /tmp/post.log
	
	local errcode=
	local apptype=`cat /tmp/nwapptype`
	local item=
	local opensslnum=
	
	if [[ "$apptype" = 'logdecoder' || "$apptype" = 'logcollector' || "$apptype" = 'logaio' ]] || [ "$apptype" = 'loghybrid' ]; then
		if [[ `grep -i -E '^[[:space:]]*setuplogcoll.*$' /tmp/nwpost.txt` ]]; then 
			if ! [[ `rpm -q nwlogcollector | grep -E 'nwlogcollector-[0-9]+\.[0-9]+'` ]]; then
				echo 'required %post install package nwlogcollector not found' | tee -a /tmp/post.log > /dev/tty3
				errcode=1
			fi
		fi
	fi

	if [ "$apptype" = 'maprwh' ]; then
		if ! [[ `rpm -q mapr-core | grep -E 'mapr-core-[0-9]+\.[0-9]+'` ]]; then
			echo 'required %post install package mapr-core not found' | tee -a /tmp/post.log > /dev/tty3
			errcode=1
		fi
	fi
	
	if [[ "$apptype" = 'spectrumbroker' || "$apptype" = 'spectrumdecoder' ]]; then
		if ! [[ `rpm -q rsaMalwareDevice | grep -E 'rsaMalwareDevice-[0-9]+\.[0-9]+'` ]]; then
			echo 'required %post install package rsaMalwareDevice not found' | tee -a /tmp/post.log > /dev/tty3
			errcode=1
		fi
	fi
	
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
		echo '  Post installation of one or more package(s) has failed' > /dev/tty1
		echo '  Possible package repository error, check /tmp/post.log' > /dev/tty1
		echo > /dev/tty1
		echo '  Disabling automatic boot of system on next restart' > /dev/tty1
		echo '	Renaming /mnt/sysimage/boot/grub/grub.conf to' > /dev/tty1
	       	echo '  /mnt/sysimage/boot/grub/grub.noboot' > /dev/tty1
		echo ' *********************************************************' > /dev/tty1
		echo > /dev/tty1
		echo > /dev/tty1
		mv -f /mnt/sysimage/boot/grub/grub.conf /mnt/sysimage/boot/grub/grub.noboot
		sleep 300
	fi
}

function kill_installer {
# terminate anaconda process for debugging purposes, assumes 'reboot' command in kickstart
	local installbool='/tmp/nwinstallbool'
	touch ${installbool} 
	local usrchoice=N
	local pslist
	declare -a pslist
	pslist=( `ps aux | grep -i -E '[[:digit:]]+[[:space:]]+/usr/bin/python[[:space:]]+/usr/bin/anaconda' | awk '{print $2}' | sort` )
	if [[ `dmesg | grep -i 'Kernel command line:' | grep "ks=http://${pxetesthost}"` ]]; then
		kill -s 4 ${pslist[0]}
	else
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
			echo ' Press <ALT><F2> for Shell Access, <CTRL><ALT><DEL> to Reboot' > /dev/tty3
			echo ' Terminating anaconda in 10 seconds' > /dev/tty3	
			echo > /dev/tty3
			sleep 10 
			kill -s 4 ${pslist[0]}
		fi
	fi
}

function virtualPostScript {
	# run standard chkconfig calls
        chroot /mnt/sysimage /sbin/chkconfig ntpd on
        chroot /mnt/sysimage /sbin/chkconfig irqbalance off
	chroot /mnt/sysimage /sbin/chkconfig postfix off 
	chroot /mnt/sysimage /sbin/chkconfig yum-updatesd off 
	chroot /mnt/sysimage /sbin/chkconfig kdump off

	# read in and run %post function calls
	local POSTCALLS='/tmp/post.txt'
	local calls
	local count
	if [ -s $POSTCALLS ]; then
		let count=0
		while read line
		do
			calls[$count]="$line"
			let count=$count+1
		done < $POSTCALLS
	
		for call in ${calls[@]}
		do
			$call
		done
	fi
	
	# set up x11 enviroment if installed
	if [[ `rpm -qa | grep -E 'xorg-x11-server-Xorg-[0-9]+\.[0-9]+'` ]]; then
		chroot /mnt/sysimage /usr/sbin/adduser -m demo
		echo 'netwitness' | chroot /mnt/sysimage /usr/bin/passwd --stdin demo
		INITFILE='/mnt/sysimage/etc/inittab' 
		sed -r 's/(^[[:space:]]*)id:[[:digit:]]:initdefault:(.*$)/\1id:5:initdefault:\2/' < $INITFILE > $INITFILE.tmp
		mv -f $INITFILE.tmp $INITFILE
	fi

	# edit mapr disk configuration template for one data disk, /dev/sdb 
        if [[ `rpm -q mapr-core | grep -E 'mapr-core-[0-9]+\.[0-9]+'` ]]; then 
		DISKCFG='/mnt/sysimage/opt/rsa/maprwh/config/conf.template'
		sed -r 's/(^[[:space:]]*)(disks=\/dev\/.*$)/#\1\2\n\1# list of disks to be MapR formatted seperated by spaces\n\1disks=\/dev\/sdb/' < $DISKCFG > $DISKCFG.rpmsave
		rm -f $DISKCFG
		cp DISKCFG.rpmsave DISKCFG
	fi
	
	# copy %pre and %post install logs to virtual machine
	cp /tmp/pre.log /mnt/sysimage/root
	cp /tmp/post.log /mnt/sysimage/root

}

function posthwimgsrv {
	# add hooks for automated image testing if detected

	local authdir='/mnt/sysimage/root/.ssh'
	local authfile="${authdir}/authorized_keys"
	local pubkey='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCzGI0OCQd8PEwzfXK0IEfEPo3sedb9U7cHSOO1buruitjKWh3E0J8MklaOk2A1k+lF88OalpQw5l2wFFQ8MogUE6ImgjoldifpCHGP4qmnSDZat9rVLVzfNxtYIqMU+4M1y5duW3QIvHFJJpEv2eIZ1ErlHdsdWaMSG9xYrC21IUXznukVVNTdcED0hUhsaz23kghqhTGfaxHDjSUKTK9MY3Yk4cjBFr1YGt5PucMO6vF+e9YKpSCDLHuqrnSk5QmG9ufEl79MlYrwA6giaxytVqm53hPyaWR5CU/cCWUyAg7zx8lwHOpjZT6qR34VjbWk9jXgXihXe+r1UnPc0RMjh9j5HrbCN+N2Vn5TCWQtnamKogUdHLHOFCeQ65WYuFrUWXZFIwbA1inHoBb4Z33SKunGda+utexFnOFIE1AsZqWePmSAB7keFJGcRiHiGgcUCs8JWUW37Zk47lCWm/bhqNT/l3oxk7m1QQ+DTovGgQgiBRWhMTzMwurj8fDUHEkFnPK5m6gYn7SFjTmlRPnkK/lRE63bHIsqMein2mPObp/sloTUCqwEA1Pbxs9mbr6Y03ijaNIWZw7bRuN/xkTXezzF5Oaf5cowOsEsqhOhCHfFuyrku9qGSX4eycsTu2lxN/PNoE0K2GWOm4Hn1StBmBys8oYjhZB9KMiUhwFVMQ== root@hwimgsrv'
	local ifdev='/mnt/sysimage/etc/sysconfig/network-scripts/ifcfg-em1'
	local rootprof='/mnt/sysimage/root/.bash_profile'

	if [[ `dmesg | grep -i 'Kernel command line:' | grep "ks=http://${pxetesthost}"` ]]; then
		echo 'posthwimgsrv() enabling dhcp for em1, adding hwimgsrv ssh key to /root/authorized_hosts' | tee -a /tmp/post.log > /dev/tty3 
		if ! [ -d ${authdir} ]; then
			mkdir ${authdir}
		fi
		chmod 700 ${authdir}
		echo ${pubkey} >> ${authfile}
		chmod 700 ${authfile}
		sed -r 's/(^[[:space:]]*)(BOOTPROTO=)(.*$)/\2dhcp/' < ${ifdev} > ${ifdev}.tmp
		mv -f ${ifdev}.tmp ${ifdev}
		sed -r 's/^[[:space:]]*IPADDR=.*$/#/' < ${ifdev} > ${ifdev}.tmp
		mv -f ${ifdev}.tmp ${ifdev}
		sed -r 's/^[[:space:]]*NETMASK=.*$/#/' < ${ifdev} > ${ifdev}.tmp
		mv -f ${ifdev}.tmp ${ifdev}
		sed -r 's/^[[:space:]]*GATEWAY=.*$/#/' < ${ifdev} > ${ifdev}.tmp
		mv -f ${ifdev}.tmp ${ifdev}i
		sed -r 's/(^[[:space:]]*)(\/usr\/sbin\/saApplPuppetInit.py)(.*$)/\1echo \2 > \/dev\/null/' < ${rootprof} > ${rootprof}.tmp
		mv -f ${rootprof}.tmp ${rootprof}

	fi
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
		rsync -rL --exclude='uudecode' --exclude='MegaCLI' --exclude='mnt' --exclude='updates' /tmp/ /mnt/sysimage/root/imagefiles
	
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
	calls[$count]='posthwimgsrv'
	let count=$count+1
	calls[$count]='bakimagefiles'
	let count=$count+1
	calls[$count]='kill_installer'
	for item in "${calls[@]}"
	do
		echo "calling %post function: $item" | tee -a /tmp/post.log > /dev/tty3
		$item >> /tmp/post.log 2>&1
	done
}

