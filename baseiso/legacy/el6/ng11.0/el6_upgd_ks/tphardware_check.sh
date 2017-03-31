# pre install functions for third party hardware appliance installations


# ^^^^^^^^^^^^^^^^^^^^^^^^ global variables ^^^^^^^^^^^^^^^^^^^^^^^^^^^^

# user selected disk for OS installation
installdisk=

# 3rd party appliance type, parsed from dmesg
tpapptype=

# build the appliance as an openstack image
openstack=

# add vmware customizations to openstack image options
vmware=

# ^^^^^^^^^^^^^^^^^^^^^^^^ global functions ^^^^^^^^^^^^^^^^^^^^^^^^^^^^

function promptReboot
{
	echo
	if ! [ -z $1 ]; then
		echo "Run installation again after restart"
	fi
        echo "Press enter to reboot"
	read 
	reboot
}

function writeBootRaid
{
	local SYSPARTS='/tmp/nwpart.txt'
	local partable=`parted -s /dev/${1} print | grep -i -E 'Partition[[:space:]]+Table:'`

	# mirror $1 and $2 (small internal drives)
	# /boot partition raid:  so either drive can be used as the boot drive.
	if ! [[ -z $2 ]]; then
            # assume SW RAID1
            echo "part raid.10 --size=16 --maxsize=520 --grow --ondisk=$1 --asprimary" >> $SYSPARTS
	    echo "part raid.11 --size=16 --maxsize=520 --grow --ondisk=$2 --asprimary" >> $SYSPARTS
	    echo "raid /boot --fstype=ext4 --fsoptions='nosuid' --level=RAID1 --device=md0 raid.10 raid.11" >> $SYSPARTS
        else
            # assume planar sata controller or Dell HW RAID1
            echo "part /boot --size=16 --maxsize=520 --grow --ondisk=$1 --asprimary --fstype=ext4" >> $SYSPARTS
        fi
	# add vfat partition for grub efi boot loader and config
	if [[ `echo "$partable" | grep -i 'gpt'` ]]; then
            echo "part /boot/efi --size=16 --maxsize=136 --grow --ondisk=$1 --fstype=efi" >> $SYSPARTS
	fi
	
	return 0
}

function mk_disk_labels {
	local size
	while ! [ -z $1 ] 
	do
		if ! [[ `ls -A /sys/block | grep "$1"` ]]; then
			echo "/dev/$1 device not found" >> /tmp/pre.log
			shift
			continue 
		fi	
		# check for mounted block devices, seems to happen with usb vfat partitions
		local regexstr='[0-9]'
		local devstr="/dev/$1$regexstr"
		mount > /tmp/mount.txt 2>&1
		if [[ `grep "$devstr" /tmp/mount.txt` ]]; then
			echo "mounted device: $1" >> /tmp/pre.log 2>&1
			grep "$devstr" /tmp/mount.txt >> /tmp/pre.log 2>&1
			local mymounts=( `grep "$devstr" /tmp/mount.txt | awk '{print $1}'` )
			for item in ${mymounts[@]}
			do
				echo "umount -f $item" >> /tmp/pre.log
				umount -f $item >> /tmp/pre.log 2>&1
			done
		fi
		# make gpt labels by default, required for uninitialized disks
		## make msdos labels by default, required for uninitialized disks
		#echo 'making default msdos disk label' >> /tmp/pre.log
		echo 'making default gpt disk label' >> /tmp/pre.log
		#echo "/usr/sbin/parted -s /dev/$1 mklabel msdos" >> /tmp/pre.log
		echo "/usr/sbin/parted -s /dev/$1 mklabel gpt" >> /tmp/pre.log
		#/usr/sbin/parted -s /dev/$1 mklabel msdos >> /tmp/pre.log 2>&1
		/usr/sbin/parted -s /dev/$1 mklabel gpt >> /tmp/pre.log 2>&1
		echo 1 > /sys/block/$1/device/rescan
		sleep 2
		## get number of 512 byte disk sectors
		#size=`/usr/sbin/parted -s /dev/$1 unit s print | grep -i '^Disk' | awk '{print $3}'` 
		#size=${size%s}
		## compute disk size in MiB
	        #let size=`expr $size / 2 / 1024`
		#echo 'checking disk size' >> /tmp/pre.log
		#echo "/dev/$1 $size MiB" >> /tmp/pre.log
		## enforce 2 TiB msdos partition size limitation
		#if [ $size -gt  2097152 ]; then
		#	echo 'disk larger than 2 TiB, making gpt label' >> /tmp/pre.log
		#		echo "/usr/sbin/parted -s /dev/$1 mklabel gpt" >> /tmp/pre.log
		#	/usr/sbin/parted -s /dev/$1 mklabel gpt >> /tmp/pre.log 2>&1
		#	echo 1 > /sys/block/$1/device/rescan
		#fi
		#sleep 2 
		shift 
	done
	#return 0
} 

function get_tpapptype {
# determine appliance type from syslinux kernel options	
	local KPARAM=`dmesg | grep -i -E 'Command[[:space:]]+line:'` 
	
	if [[ `echo $KPARAM | grep -E '[[:space:]]+archiver'` ]]; then
		echo "archiver" > /tmp/nwapptype
		tpapptype="archiver"
	elif [[ `echo $KPARAM | grep -E '[[:space:]]+broker'` ]]; then
		echo "broker" > /tmp/nwapptype	
		tpapptype="broker"
	elif [[ `echo $KPARAM | grep -E '[[:space:]]+concentrator'` ]]; then
		echo "concentrator" > /tmp/nwapptype	
		tpapptype="concentrator"
	elif [[ `echo $KPARAM | grep -E '[[:space:]]+connector'` ]]; then
		echo "connector" > /tmp/nwapptype
		tpapptype="connector"
	elif [[ `echo $KPARAM | grep -E '[[:space:]]+decoder'` ]]; then
		echo "decoder" > /tmp/nwapptype
		tpapptype="decoder"
	elif [[ `echo $KPARAM | grep -E '[[:space:]]+demolab'` ]]; then
		echo "demolab" > /tmp/nwapptype
		tpapptype="demolab"
	elif [[ `echo $KPARAM | grep -E '[[:space:]]+esa'` ]]; then
		echo "esa" > /tmp/nwapptype
		tpapptype="esa"
	elif [[ `echo $KPARAM | grep -E '[[:space:]]+ipdbextractor'` ]]; then
		echo "ipdbextractor" > /tmp/nwapptype
		tpapptype="ipdbextractor"
	elif [[ `echo $KPARAM | grep -E '[[:space:]]+logaio'` ]]; then
		echo "logaio" > /tmp/nwapptype
		tpapptype="logaio"
	elif [[ `echo $KPARAM | grep -E '[[:space:]]+logcollector'` ]]; then
		echo "logcollector" > /tmp/nwapptype
		tpapptype="logcollector"
	elif [[ `echo $KPARAM | grep -E '[[:space:]]+logdecoder'` ]]; then
		echo "logdecoder" > /tmp/nwapptype
		tpapptype="logdecoder"
	elif [[ `echo $KPARAM | grep -E '[[:space:]]+loghybrid'` ]]; then
		echo "loghybrid" > /tmp/nwapptype
		tpapptype="loghybrid"
	elif [[ `echo $KPARAM | grep -E '[[:space:]]+packetaio'` ]]; then
		echo "packetaio" > /tmp/nwapptype
		tpapptype="packetaio"
	elif [[ `echo $KPARAM | grep -E '[[:space:]]+packethybrid'` ]]; then
		echo "packethybrid" > /tmp/nwapptype
		tpapptype="packethybrid"
	elif [[ `echo $KPARAM | grep -E '[[:space:]]+sabroker'` ]]; then
		echo "sabroker" > /tmp/nwapptype
		tpapptype="sabroker"
	elif [[ `echo $KPARAM | grep -E '[[:space:]]+spectrumbroker'` ]]; then
		echo "spectrumbroker" > /tmp/nwapptype
		tpapptype="spectrumbroker"
	fi
	
	# set nwsystem for %post function doPost() 
	nwsystem='thirdparty'
	echo "$nwsystem" > /tmp/nwsystem
	echo "nwsystem = $nwsystem" >> /tmp/pre.log
}

function make_install_parts {
# create anaconda partition script

local mylog=/tmp/pre.log
local vgfreemib
local logicaldisk
local diskgib
local diskmib
local osmax="$1"
local percentage
local partsizemib

# get appliance type
get_tpapptype


# coonfigure boot parttion
writeBootRaid ${installdisk}

# rename conflicting volume group
if [[ `vgscan | grep 'VolGroup00'` ]]; then
	echo 'renaming conflicting volume group name VolGroup00 to VolGroup09' | tee -a $mylog > /dev/tty3
	vgrename VolGroup00 VolGroup09 >> $mylog 2>&1
fi

if [ $tpapptype = "demolab" ]; then
	echo  "part pv.nwsto --size=1 --grow --ondisk=${installdisk}
volgroup VolGroup00 pv.nwsto" >> /tmp/nwpart.txt
	echo 'logvol swap --vgname=VolGroup00 --size=4096 --fstype=swap --name=swap00
logvol / --vgname=VolGroup00 --size=1 --grow --fstype=ext4 --name=root' >> /tmp/nwpart.txt
else
	# calculate os partiion size as a percentage of total disk size
	echo "osmax = $osmax" | tee -a $mylog > /dev/tty3
	logicaldisk=`cat /tmp/partdisk.txt`
	echo "logicaldisk = $logicaldisk" | tee -a $mylog > /dev/tty3
	diskgib=`grep "$logicaldisk" /tmp/osdisk.txt | awk '{print $3}'`
	echo "diskgib = $diskgib" | tee -a $mylog > /dev/tty3
	diskmib=`python -c "sizegib=$diskgib; print sizegib * 1024"`
	diskmib=`printf "%.0f" $diskmib | awk '{print $1}'`
	echo "diskmib = $diskmib" | tee -a $mylog > /dev/tty3
	percentage=`python -c "disksize=${diskgib}.0; ossize=${osmax}.0; print ossize / disksize"`
	echo "percentage = $percentage" | tee -a $mylog > /dev/tty3
	partsizemib=`python -c "sizemib=$diskmib; percent=$percentage; print sizemib * percent"`
	partsizemib=`printf "%.0f" $partsizemib | awk '{print $1}'`
	# take off 1024 MiB for boot partition(s) and round errors
	let partsizemib=$partsizemib-1024
	echo "partsizemib = $partsizemib" | tee -a $mylog > /dev/tty3

	if ! [ $openstack ] && ! [ $vmware ]; then
		echo "part pv.nwsto --size=$partsizemib --ondisk=${installdisk}
volgroup VolGroup00 pv.nwsto" >> /tmp/nwpart.txt
		echo 'logvol swap --vgname=VolGroup00 --size=4096 --fstype=swap --name=swap00
logvol / --vgname=VolGroup00 --size=16384 --fstype=ext4 --name=root
logvol /home --vgname=VolGroup00 --size=4096 --fstype=ext4 --name=usrhome --fsoptions="nosuid"
logvol /opt --vgname=VolGroup00 --size=10240 --fstype=ext4 --name=opt --fsoptions="nosuid"
logvol /tmp --vgname=VolGroup00 --size=10240 --fstype=xfs --name=tmp --fsoptions="nosuid"
logvol /var --vgname=VolGroup00 --size=10240 --fstype=xfs --name=var
logvol /var/log --vgname=VolGroup00 --size=10240 --fstype=xfs --name=varlog
logvol /var/lib/rabbitmq --vgname=VolGroup00 --size=20480 --fstype=xfs --name=rabmq
logvol /var/tmp --vgname=VolGroup00 --size=4096 --fstype=xfs --name=vartmp --fsoptions="nosuid"' >> /tmp/nwpart.txt
		if ! [ $tpapptype = "esa" ]; then
			echo 'logvol /var/netwitness --vgname=VolGroup00 --size=30720 --fstype=xfs --name=nwhome --fsoptions="nosuid"' >> /tmp/nwpart.txt
		fi
	else
		echo "part pv.nwsto --size=1 --grow --ondisk=${installdisk}
volgroup VolGroup00 pv.nwsto" >> /tmp/nwpart.txt
		echo 'logvol swap --vgname=VolGroup00 --size=4096 --fstype=swap --name=swap00
logvol / --vgname=VolGroup00 --size=8192 --fstype=ext4 --name=root
logvol /home --vgname=VolGroup00 --size=2048 --fstype=ext4 --name=usrhome --fsoptions="nosuid"
logvol /opt --vgname=VolGroup00 --size=8192 --fstype=ext4 --name=opt --fsoptions="nosuid"
logvol /tmp --vgname=VolGroup00 --size=8192 --fstype=xfs --name=tmp --fsoptions="nosuid"
logvol /var --vgname=VolGroup00 --size=8192 --fstype=xfs --name=var
logvol /var/log --vgname=VolGroup00 --size=6144 --fstype=xfs --name=varlog
logvol /var/tmp --vgname=VolGroup00 --size=2048 --fstype=xfs --name=vartmp --fsoptions="nosuid"' >> /tmp/nwpart.txt
		if ! [ $tpapptype = "esa" ]; then
			echo 'logvol /var/lib/rabbitmq --vgname=VolGroup00 --size=10240 --fstype=xfs --name=rabmq
logvol /var/netwitness --vgname=VolGroup00 --size=1 --grow --fstype=xfs --name=nwhome --fsoptions="nosuid"' >> /tmp/nwpart.txt
		else
			echo 'logvol /var/lib/rabbitmq --vgname=VolGroup00 --size=1 --grow --fstype=xfs --name=rabmq' >> /tmp/nwpart.txt
		fi
	fi
fi
}

function chomp {
	
	local mystr="$1"
	local mylen
	local strchar
	rm -f /tmp/chompstr
	if [[ `echo "$mystr" | grep -E '[[:space:]]+$'` ]]; then
		while [ 1 ]
		do 
			let mylen="${#mystr}"
			strchar="${mystr:$mylen-1}"
			if [[ `echo "$strchar" | grep -E '[[:space:]]'` ]]; then
				mystr="${mystr:0:$mylen-1}"
			else
				break
			fi
		done
		echo "$mystr" > /tmp/chompstr
	fi
}

function scan_blockdev {
# check minimum disk size for os installation
        local item
	local size
        local minsize
	local metminsize
	local sysblock
	local blkdev 
	local device
	local installdisk 
	local sectors
	local vendor
	local model
	local bus 
	local KPARAM=`dmesg | grep -i -E 'Command[[:space:]]+line:'`

	if [[ `echo $KPARAM | grep -E '[[:space:]]+demolab'` ]]; then
		# 20 GiB
		let minsize=20
	elif [ $openstack ] || [ $vmware ]; then
		# 80 GB not GiB for openstack m1.large flavor
		let minsize=78
	elif [[ `echo $KPARAM | grep -E '[[:space:]]+logaio'` || `echo $KPARAM | grep -E '[[:space:]]+loghybrid'` ]]; then
		# 2040 GiB
		let minsize=2040
	elif [[ `echo $KPARAM | grep -E '[[:space:]]+packetaio'` || `echo $KPARAM | grep -E '[[:space:]]+packethybrid'` ]]; then
		# 1640 GiB
		let minsize=1640
	else
		# 928 GiB
		let minsize=928
	fi
	declare -a sysblock
	declare -a blkdev
	
	echo "Scanning system block devices for size capacity" | tee -a /tmp/pre.log > /dev/tty3
	sysblock=( `ls /sys/block` )
        echo "\${sysblock[@]} = ${sysblock[@]}" | tee -a /tmp/pre.log > /dev/tty3
        rm -f /tmp/hdparm.out
        for item in "${sysblock[@]}"
        do
        	# parse out non disk block devices and hdd installation media
		case "$item" in
                        loop[0-9]* | ram[0-9]* | sr[0-9]* | dm-[0-9]* | fd[0-9]* )
                                continue
                        ;;
                        * )
				# parted won't print sectors of un-initialized disks, use hdparm instead
				sectors=`hdparm -g /dev/$item | grep 'sectors' | awk -F, '{print $2}' | awk -F= '{print $2}' | awk '{print $1}'`
				# convert sectors to GiB, sector size 512B
				let size=`expr $sectors / 2 / 1024 / 1024`
				vendor=`cat /sys/block/$item/device/vendor`
				chomp "$vendor"
				if [ -s /tmp/chompstr ]; then
					vendor=`cat /tmp/chompstr`
				fi
				model=`cat /sys/block/$item/device/model`
				chomp "$model"
				if [ -s /tmp/chompstr ] ; then
					model=`cat /tmp/chompstr`
				fi 
				# create initial list of disk drives detected by kernel
				echo "Disk: /dev/$item $size GiB" >> /tmp/hdparm.out
				echo "Vendor: $vendor Model: $model" >> /tmp/hdparm.out
                        ;;
                esac
        done 
	unset sysblock
	# create array of disks and sizes
	blkdev=( `grep -i -E 'Disk:[[:space:]]+/dev' /tmp/hdparm.out | tr ' ' '_'` )
	echo "\${blkdev[@]} = ${blkdev[@]}" | tee -a /tmp/pre.log 
        
	rm -f /tmp/nwdisk.txt
	for item in ${blkdev[@]}
	do
		let size=`echo "$item" | awk -F_ '{print $3}'`
       		device=`echo $item | awk -F_ '{print $2}'`                       	
 		# create formatted list for on error display
		grep -A1 -i -E "Disk:[[:space:]]$device" /tmp/hdparm.out >> /tmp/nwdisk.txt
       		echo >> /tmp/nwdisk.txt 
		if [ $size -ge $minsize ]; then
                        metminsize=true
			# create user selection list of hard drives suitable or os installation
			grep -A1 -i -E "Disk:[[:space:]]$device" /tmp/hdparm.out >> /tmp/osdisk.txt		
                fi
	done
	if ! [ $metminsize ]; then
                chvt 3
		exec < /dev/tty3 > /dev/tty3 2>&1
                echo > /dev/tty3
                echo '--------------------------------------------------' > /dev/tty3
		echo "Minimum Disk Size for Installation is $minsize GiB" | tee -a /tmp/pre.log > /dev/tty3
                echo -e 'Detected Block Device(s):\n' | tee -a /tmp/pre.log > /dev/tty3
		cat /tmp/nwdisk.txt | tee -a /tmp/pre.log > /dev/tty3
                echo '--------------------------------------------------' > /dev/tty3	
		echo > /dev/tty3
		echo "Installation Cannot Continue" | tee -a /tmp/pre.log > /dev/tty3
		promptReboot
	elif [ $openstack ] || [ $vmware ]; then
		installdisk=`head -n1 /tmp/osdisk.txt | awk '{print $2}'`
		installdisk=${installdisk#/dev/}
		echo "${installdisk}" > /tmp/partdisk.txt
		mk_disk_labels ${installdisk}
		make_install_parts "$minsize"	
	else
                echo -e 'Detected Block Device(s):\n' | tee -a /tmp/pre.log > /dev/tty3	
		cat /tmp/nwdisk.txt | tee -a /tmp/pre.log > /dev/tty3
		chvt 3
		/usr/bin/getosdisk.py < /dev/tty3 > /dev/tty3 2>&1
		installdisk=`cat /tmp/partdisk.txt`
		mk_disk_labels ${installdisk}
		make_install_parts "$minsize"
		chvt 1
	fi
}

function get_cpunram { 
# compare cpu and ram stats to series 4s, give warning prompt if inadequate
	
	local KPARAM=`dmesg | grep -i -E 'Command[[:space:]]+line:'`
	# check for OpenStack kernel parameter
	if [[ `echo $KPARAM | grep -i -E '[[:space:]]+OpenStack'` ]]; then
		echo 'openstack=true' | tee -a /tmp/pre.log
		openstack='true'
		echo 'OpenStack' > /tmp/nwcloud.txt
		return 0
	fi
	
	# check for VMware  kernel parameter
	if [[ `echo $KPARAM | grep -i -E '[[:space:]]+VMware'` ]]; then
		echo 'vmware=true' | tee -a /tmp/pre.log
		vmware='true'
		echo 'VMware' > /tmp/nwcloud.txt
		return 0
	fi

	local cpucores
	let cpucores=16
	local cpumhz
	let cpumhz=2599
	local ram
	let ram=99156644
	local cputhreads
	let cputhreads=`expr $cpucores \* 2`	
	local myram
	let myram=`grep -i 'MemTotal:' /proc/meminfo | awk '{print $2}'`
	local mycores
	let mycores=`grep -m1 -i 'siblings' /proc/cpuinfo | awk -F: '{print $2}' | awk '{print $1}'` 
	local mymhz=`grep -m1 -i -E 'cpu[[:space:]]+MHz' /proc/cpuinfo | awk -F: '{print $2}' | awk '{print $1}'`
	let mymhz=${mymhz%\.[0-9]*}
	local mythreads
	let mythreads=`grep -c 'processor' /proc/cpuinfo`
	#echo "cpucores = $cpucores, mycores = $mycores, cpumhz = $cpumhz, mymhz = $mymhz, cputhreadss = $cputhreads, mythreads = $mythreads, ram = $ram, myram = $myram"
	#sleep 5		
	if [ $mycores -lt $cpucores ] || [ $mymhz -lt $cpumhz ] || [ $myram -lt $ram ] || [ $mythreads -lt $cputhreads ]; then
		chvt 3 
		exec < /dev/tty3 > /dev/tty3 2>&1
		python -c "import curses, os
mycores = "$mycores"
cpucores = "$cpucores"
mymhz = "$mymhz"
cpumhz = "$cpumhz"
mythreads = "$mythreads"
cputhreads = "$cputhreads"
myram = "$myram"
ram = "$ram"
stdscr = curses.initscr()
# bold white on blue, if color tty
if ( curses.has_colors() ):
        curses.start_color()
        curses.init_pair(1, curses.COLOR_WHITE, curses.COLOR_BLUE)
        stdscr.bkgd( 32, curses.color_pair(1))
	stdscr.attron( curses.A_BOLD )
        stdscr.refresh()
stdscr.border()
stdscr.addstr( 2, 4, 'System resources do not meet all optimal parameters' )
mystr = 'Detected\t\tOptimal\t\t\tResults'
stdscr.addstr( 4, 2, mystr )
mystr = '-----------------------------------------------------'
stdscr.addstr( 5, 2, mystr )

mystr = 'CPU Speed mHZ: ' + str(mymhz) + '\tCPU Speed mHZ: ' + str(cpumhz)
if ( cpumhz <= mymhz ):
	mystr = mystr + '\tPASS'
else:
	mystr = mystr + '\tFAIL'
stdscr.addstr( 6, 2, mystr )
mystr = 'CPU Cores: ' + str(mycores) + '\t\tCPU Cores: ' + str(cpucores)
if ( mycores >= cpucores ):
	mystr = mystr + '\t\tPASS'
else:
	mystr = mystr + '\t\tFAIL'
stdscr.addstr( 7, 2, mystr )
mystr = 'CPU Threads: ' + str(mythreads) + '\tCPU Threads: ' + str(cputhreads)
if ( mythreads >= cputhreads ):
	mystr = mystr + '\t\tPASS'
else:
	mystr = mystr + '\t\tFAIL'
stdscr.addstr( 8, 2, mystr )
mystr = 'RAM kB: ' + str(myram) + '\tRAM kB: ' + str(ram)
if ( myram >= ram ):
	mystr = mystr + '\tPASS'
else:
	mystr = mystr + '\tFAIL'
stdscr.addstr( 9, 2, mystr )
mystr = '-----------------------------------------------------'
stdscr.addstr( 10, 2, mystr )
stdscr.addstr( 12, 2, 'Note: Optimal parameters are provided as a guideline' )
stdscr.addstr( 13, 2, 'for resource intensive applications such as Packet' )
stdscr.addstr( 14, 2, 'Decoder and may not be applicable for all deployment' )
stdscr.addstr( 15, 2, 'scenarios or intended usage. Please consult the install' )
stdscr.addstr( 16, 2, 'guide for minimal system requirements and expectations.' )
stdscr.addstr( 18, 2, 'Press c to continue, t to terminate the installation' )
curses.noecho()
stdscr.move( 19, 2)
curses.cbreak()
stdscr.refresh() 
while ( True ):
	mychar = stdscr.getch()
	# <C>|<c>
	if ( mychar == 87 ) or ( mychar == 99 ):
		curses.endwin()
		break
	# <T>|<t>
	elif ( mychar == 84 ) or ( mychar == 116 ):
		curses.endwin()
		os.system( '/sbin/reboot' )
	stdscr.move( 13, 2)
"
	chvt 1
fi
}

function getoptsw {
# get per appliance optional software components from comps.xml file	
	
	local opticalMedia
	local hddMedia
	local urlMedia
	local installUrl
	local strLen
	local lastChar
	local compfile
	local complist
	declare -a complist
	local rsagroup="$1"
	local line
	local count
	local optsw
	declare -a optsw
	local lenoptsw
	local item
	local ingroup
	local packstr
	local mypwd=`pwd`
	local blockdev

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
 
	if ! [ -d /tmp/mnt ]; then
		mkdir /tmp/mnt
	fi

	if ! [ -d /tmp/mpoint ]; then
		mkdir /tmp/mpoint
	fi
	
	if [[ `mount | grep '/tmp/mnt'` ]]; then
		umount /tmp/mnt
	fi 
	
	if [[ `mount | grep '/tmp/mpoint'` ]]; then
		umount /tmp/mpoint
	fi
	
	if [ $opticalMedia ]; then 
		echo 'install method = opticalMedia' | tee -a /tmp/pre.log > /dev/tty3
		mount -t iso9660 -o ro /dev/sr0 /tmp/mnt
 		compfile=`ls /tmp/mnt/repodata/*-comps.xml | awk '{print $1}'`
	elif [ $hddMedia ]; then	
		echo 'install method = hddMedia' | tee -a /tmp/pre.log > /dev/tty3		
		declare -a blockdev
		blockdev=( `ls /sys/block` )
	        for item in "${blockdev[@]}"
		do
			# skip non disk block devices
			case "$item" in
				loop[0-9]* | ram[0-9]* | sr[0-9]* | dm-[0-9]* | fd[0-9]* )
					continue
				;;
				* )
					# check usb block devices for install iso file
					if [ -d /sys/block/${item}/${item}1 ]; then
						mount /dev/${item}1 /tmp/mpoint
					else
						mount /dev/${item} /tmp/mpoint
					fi
					ls /tmp/mpoint > /tmp/dircat.txt
					if [[ `grep 'sa-upgrade.*-usb\.iso' /tmp/dircat.txt` ]]; then
						break
					else
						umount /tmp/mpoint
					fi
				;;
			esac
		done
		local myiso=`grep 'sa-upgrade.*-usb\.iso' /tmp/dircat.txt | awk '{print $1}'`
		if [ $? = 0 ]; then
			mount -o loop /tmp/mpoint/${myiso} /tmp/mnt
			compfile=`ls /tmp/mnt/repodata/*-comps.xml | awk '{print $1}'`
		fi
	elif [ $urlMedia ]; then
		echo 'install method = urlMedia' | tee -a /tmp/pre.log > /dev/tty3
		cd /tmp
		wget $installUrl/repodata -O myindex.html
		compfile=`grep 'href=".*comps\.xml"' myindex.html | awk -F'href="' '{print $2}'`
	       	compfile=${compfile%%\">*}
	fi
	sleep 2
	# read in rsa package groups
	let count=0
	while read line
	do	
		complist[$count]="$line"
		let count=$count+1
		if [[ `echo "$line" | grep -i -E '<!--[[:space:]]+End[[:space:]]+RSA[[:space:]]+Groups[[:space:]]+Insert[[:space:]]+-->'` ]]; then
			break
		fi
	done < $compfile
	
	# un-mount iso image and hdd media
	if [[ `mount | grep '/tmp/mnt'` ]]; then
		umount /tmp/mnt
		sleep 2
	fi
	if [[ `mount | grep '/tmp/mpoint'` ]]; then
		umount /tmp/mpoint
		sleep 2
	fi
	
	# get list of optional rsa software groups
	let count=0
	for item in "${complist[@]}"
	do
		if [[ `echo "$item" | grep "<id>$rsagroup</id>"` ]]; then
			ingroup=true
		fi
		if [ $ingroup ] && [[ `echo "$item" | grep '</packagelist>'` ]]; then
			break
		fi
		# skip comments
		if [[ `echo "$item" | grep -E '^[[:space:]]*<!--.*$'` ]]; then
			continue
		fi
		if [ $ingroup ] && [[ `echo "$item" | grep -i -E '<packagereq[[:space:]]+type="optional">.*</packagereq>'` ]]; then
			packstr="${item%<*}"
			packstr="${packstr#*>}"
			optsw[$count]="$packstr"
			let count=$count+1
		fi
	done

	let lenoptsw="${#optsw[@]}"
	if [ $lenoptsw -gt 0 ]; then
		if [ $vmware ]; then
			for item in "${optsw[@]}"
			do
				if [[ `echo "${item}" | grep 'rsaMalwareDeviceCoLo'` ]]; then
					echo '@rsa-sa-malware-analysis-colocated' >> /tmp/nwpack.txt
				fi
			done
			return 0
		fi
		# install all optional components for openstack images
		if [ $openstack ] || [ $vmware ]; then
			for item in "${optsw[@]}"
			do
				if [[ `echo "${item}" | grep 'nwlogcollector'` ]]; then
					echo '-@rsa-sa-remote-logcollector' >> /tmp/nwpack.txt
				elif [[ `echo "${item}" | grep 'rsaMalwareDeviceCoLo'` ]]; then
					echo "@rsa-sa-malware-analysis-colocated" >> /tmp/nwpack.txt
				elif [[ `echo "${item}" | grep 'nwwarehouseconnector'` ]]; then
					echo '-@rsa-sa-warehouse-connector' >> /tmp/nwpack.txt
				fi
			done
			return 0
		fi
		echo "${optsw[@]}" > /tmp/nwoptsw.txt
		chvt 3
		echo > /dev/tty3
		echo "optsw[] = ${optsw[@]}" | tee -a /tmp/pre.log > /dev/tty3
		echo > /dev/tty3
		/usr/bin/optinstall.py "${optsw[@]}" < /dev/tty3 > /dev/tty3 2>&1
		chvt 1
	else
		echo "error reading comps.xml file or no optional packages available" | tee -a /tmp/pre.log > /dev/tty3
	fi
}

function get_appsw {
	
	local KPARAM=`dmesg | grep -i -E 'Command[[:space:]]+line:'`
	local premntpath=/mnt/stage2
	local isover
	
	# get iso version string
	local isover=`ls ${premntpath}/*.mf`
	if [[ `echo ${isover} | grep '\.mf$'` ]]; then
		isover=${isover%\.mf}
		isover=${isover##*/}
		isover="${isover}.iso"
		echo ${isover} > /tmp/nwiso.txt
	else
		echo 'undetermined'  > /tmp/nwiso.txt	
	fi
	
	echo '-libowb1_0_1' >> /tmp/nwpack.txt

	case "$tpapptype" in
		archiver )	
			echo -e '@rsa-sa-core\n@rsa-sa-archiver' >  /tmp/nwpack.txt
			#getoptsw 'rsa-sa-archiver'
			echo -e 'workbench_nice\ndoPost\nappliance_lvmounts' >> /tmp/nwpost.txt
		;;
		broker )
			echo -e '@rsa-sa-core\n@rsa-sa-broker' >  /tmp/nwpack.txt
			#getoptsw 'rsa-sa-broker'
			echo -e 'doPost\nappliance_lvmounts' >> /tmp/nwpost.txt
		;;
		concentrator )
			echo -e '@rsa-sa-core\n@rsa-sa-concentrator' >  /tmp/nwpack.txt	
			#getoptsw 'rsa-sa-concentrator'
			echo -e 'doPost\nappliance_lvmounts' >> /tmp/nwpost.txt
		;;
		connector )
			echo -e '@rsa-sa-core' >  /tmp/nwpack.txt
			#getoptsw 'rsa-sa-warehouse-connector'
			echo -e 'doPost\nappliance_lvmounts\nsetupwarec' >> /tmp/nwpost.txt
		;;
		decoder )
			echo -e '@rsa-sa-core\n@rsa-sa-packet-decoder' > /tmp/nwpack.txt
			getoptsw 'rsa-sa-packet-decoder'
			if [[ `grep '\-\@rsa-sa-warehouse-connector' /tmp/nwpack.txt` ]]; then		
				echo -e 'doPost\nappliance_lvmounts\nsetupwarec' >> /tmp/nwpost.txt
			else
				echo -e 'doPost\nappliance_lvmounts' >> /tmp/nwpost.txt
			fi
		;;
		demolab )
			echo -e '@rsa-sa-core' > /tmp/nwpack.txt
			getoptsw 'rsa-sa-demo-lab'
			echo -e 'doPost' >> /tmp/nwpost.txt
			if [[ `grep '\@rsa-sa-archiver' /tmp/nwpack.txt` ]]; then
			echo 'workbench_nice' >> /tmp/nwpost.txt
			fi

			if [[ `grep '\@rsa-sa-esa-server' /tmp/nwpack.txt` ]]; then
				echo 'config_esa' >> /tmp/nwpost.txt
			fi

			if [[ `grep '\@rsa-sa-malware-analysis-colocated' /tmp/nwpack.txt` ]]; then
				echo -e 'setSpectrumTunables\nspecFileService colo' >> /tmp/nwpost.txt
			fi

			if [[ `grep -E '^[[:space:]]*\@rsa-sa-malware-analysis[[:space:]]*$' /tmp/nwpack.txt` ]]; then
				echo -e 'config_spectrum\nsetSpectrumTunables\nspecFileService' >> /tmp/nwpost.txt
			fi

			if [[ `grep '\-\@rsa-sa-remote-logcollector' /tmp/nwpack.txt` ]]; then
				echo 'setuplogcoll' >> /tmp/nwpost.txt
			fi

			if [[ `grep '\-\@rsa-sa-warehouse-connector' /tmp/nwpack.txt` ]]; then
				echo 'setupwarec' >> /tmp/nwpost.txt
			fi

			if [[ `grep '\@rsa-sa-remote-ipdbextractor' /tmp/nwpack.txt` ]]; then
				echo 'config_ipdbextractor' >> /tmp/nwpost.txt
			fi

			if [[ `grep '\@rsa-sa-server' /tmp/nwpack.txt` ]]; then
				echo -e 'config_postgres_re\nconfig_ipdbextractor\nconfig_uax' >> /tmp/nwpost.txt
			fi

			if [[ `grep 'nwworkbench' /tmp/nwpack.txt` ]]; then
				echo 'workbench_nice' >> /tmp/nwpost.txt
			fi
		;;
		esa )
			echo -e '@rsa-sa-core\n@rsa-sa-esa-server' >  /tmp/nwpack.txt
			#getoptsw 'rsa-sa-esa-server'
			echo -e 'doPost\nappliance_lvmounts\nconfig_esa' >> /tmp/nwpost.txt
		;;
		ipdbextractor )
			echo -e '@rsa-sa-core\n@rsa-sa-remote-ipdbextractor' >  /tmp/nwpack.txt	
			#getoptsw 'rsa-sa-remote-ipdbextractor'
			echo -e 'doPost\nappliance_lvmounts\nconfig_ipdbextractor' >> /tmp/nwpost.txt
		;;
		logaio )
			echo -e '-re-server\n@rsa-sa-core\n@rsa-sa-log-aio' >  /tmp/nwpack.txt
			getoptsw 'rsa-sa-log-aio'
			echo -e 'doPost\nappliance_lvmounts\nconfig_postgres_re\nconfig_ipdbextractor\nconfig_uax' >> /tmp/nwpost.txt
			if [[ `grep '\@rsa-sa-malware-analysis-colocated' /tmp/nwpack.txt` ]]; then
				echo -e 'setSpectrumTunables\nspecFileService colo' >> /tmp/nwpost.txt			
			fi
			if [[ `grep '\-\@rsa-sa-remote-logcollector' /tmp/nwpack.txt` ]]; then
				echo 'setuplogcoll' >> /tmp/nwpost.txt			
			fi
		;;
		logcollector )
			echo -e '@rsa-sa-core' >  /tmp/nwpack.txt
			#getoptsw 'rsa-sa-remote-logcollector'
			echo -e 'appliance_lvmounts\nsetuplogcoll\ndoPost' >> /tmp/nwpost.txt
		;;
		logdecoder )
			echo -e '@rsa-sa-core\n@rsa-sa-log-decoder' >  /tmp/nwpack.txt
			getoptsw 'rsa-sa-log-decoder'
			echo -e 'doPost\nappliance_lvmounts' >> /tmp/nwpost.txt
			if [ $vmware ] || [[ `grep '\-\@rsa-sa-remote-logcollector' /tmp/nwpack.txt` ]]; then
				echo 'setuplogcoll' >> /tmp/nwpost.txt			
			fi
			if [[ `grep '\-\@rsa-sa-warehouse-connector' /tmp/nwpack.txt` ]]; then		
				echo 'setupwarec' >> /tmp/nwpost.txt
			fi
		;;
		loghybrid )
			echo -e '@rsa-sa-core\n@rsa-sa-log-hybrid' >  /tmp/nwpack.txt
			getoptsw 'rsa-sa-log-hybrid'
			echo -e 'doPost\nappliance_lvmounts' >> /tmp/nwpost.txt
			if [[ `grep '\-\@rsa-sa-remote-logcollector' /tmp/nwpack.txt` ]]; then
				echo 'setuplogcoll' >> /tmp/nwpost.txt			
			fi
			if [[ `grep '\-\@rsa-sa-warehouse-connector' /tmp/nwpack.txt` ]]; then		
				echo 'setupwarec' >> /tmp/nwpost.txt
			fi
		;;
		packetaio )
			echo -e '-re-server\n@rsa-sa-core\n@rsa-sa-packet-aio' >  /tmp/nwpack.txt
			getoptsw 'rsa-sa-packet-aio'
			echo -e 'doPost\nappliance_lvmounts\nconfig_postgres_re\nconfig_ipdbextractor\nconfig_uax' >> /tmp/nwpost.txt
			if [[ `grep '\@rsa-sa-malware-analysis-colocated' /tmp/nwpack.txt` ]]; then
				echo -e 'setSpectrumTunables\nspecFileService colo' >> /tmp/nwpost.txt			
			fi
			if [[ `grep 'nwworkbench' /tmp/nwpack.txt` ]]; then
				echo 'workbench_nice' >> /tmp/nwpost.txt
			fi
		;;
		packethybrid )
			echo -e '@rsa-sa-core\n@rsa-sa-packet-hybrid' >  /tmp/nwpack.txt
			getoptsw 'rsa-sa-packet-hybrid'
			echo -e 'doPost\nappliance_lvmounts' > /tmp/nwpost.txt
			if [[ `grep '\-\@rsa-sa-warehouse-connector' /tmp/nwpack.txt` ]]; then		
				echo 'setupwarec' >> /tmp/nwpost.txt
			fi
		;;
		sabroker )
			echo -e '-re-server\n@rsa-sa-core\n@rsa-sa-server' >  /tmp/nwpack.txt
			getoptsw 'rsa-sa-server'
			if [ $vmware ]; then
				echo '-nwbroker' >> /tmp/nwpack.txt
			fi
			echo -e 'doPost\nappliance_lvmounts\nconfig_postgres_re\nconfig_ipdbextractor\nconfig_uax' >> /tmp/nwpost.txt
			if [[ `grep '\@rsa-sa-malware-analysis-colocated' /tmp/nwpack.txt` ]]; then
				echo -e 'setSpectrumTunables\nspecFileService colo' >> /tmp/nwpost.txt			
			fi
			if [[ `grep 'nwworkbench' /tmp/nwpack.txt` ]]; then
				echo 'workbench_nice' >> /tmp/nwpost.txt
			fi
		;;
		spectrumbroker )
			echo -e '@rsa-sa-core\n@rsa-sa-malware-analysis' >  /tmp/nwpack.txt
			#getoptsw 'rsa-sa-malware-analysis'
			if [ $vmware ]; then
				echo '-nwbroker' >> /tmp/nwpack.txt
			fi
			echo -e 'appliance_lvmounts\nconfig_spectrum\nsetSpectrumTunables\nspecFileService\ndoPost' >> /tmp/nwpost.txt
		;;
	esac
	
	if [ $openstack ]; then
		echo 1> /dev/null
		#echo '@rsa-sa-cloud-tools' >> /tmp/nwpack.txt
	fi
	
	echo '%end' >> /tmp/nwpack.txt
}
