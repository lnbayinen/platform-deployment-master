# Hardware Check Functions $Revisi:on: 4084 $ 

# ^^^^^^^^^^^^^^^^^^^^^ global constants ^^^^^^^^^^^^^^^^^^^^^^^^

# series 1 and series 2 hardware with 60+ GB system drives
root_volumes='# OS partitions on the RAID 1 volume on the internal drives
logvol / --fstype=ext4 --name=root --vgname=VolGroup00 --size=8192
logvol swap --fstype=swap --name=swap --vgname=VolGroup00 --size=4096
logvol /home --fstype=ext4 --name=usrhome --vgname=volgroup00 --size=2048 --fsoptions="nosuid"
logvol /opt --fstype=ext4 --name=opt --vgname=volgroup00 --size=6144 --fsoptions="nosuid"
logvol /tmp --fstype=ext4 --name=tmp --vgname=VolGroup00 --size=8192 --fsoptions="nosuid"
logvol /var --fstype=ext4 --name=var --vgname=VolGroup00 --size=6144
logvol /var/tmp --fstype=ext4 --name=vartmp --vgname=VolGroup00 --size=4096 --fsoptions="nosuid"'

upsz_root_volumes='# OS partitions on the RAID 1 volume on the internal drives
logvol / --fstype=ext4 --name=root --vgname=VolGroup00 --size=16384
logvol swap --fstype=swap --name=swap --vgname=VolGroup00 --size=10240
logvol /tmp --fstype=ext4 --name=tmp --vgname=VolGroup00 --size=20480 --fsoptions="nosuid"
logvol /var --fstype=ext4 --name=var --vgname=VolGroup00 --size=12288
logvol /var/tmp --fstype=ext4 --name=vartmp --vgname=VolGroup00 --size=6144 --fsoptions="nosuid" 
logvol /home --fstype=ext4 --name=usrhome --vgname=VolGroup00 --size=2048 --fsoptions="nosuid"
logvol /opt --fstype=ext4 --name=opt --vgname=VolGroup00 --size=10240 --fsoptions="nosuid"
logvol /var/lib/rabbitmq --fstype=xfs --name=rabmq --vgname=VolGroup00 --size=20480 --fsoptions="nosuid,noatime"
logvol /var/netwitness --fstype=xfs --name=nwhome --vgname=VolGroup00 --size=1 --grow --fsoptions="nosuid,noatime"'

hybrid_volumes='logvol /var/netwitness/concentrator --vgname=concentrator --size=30720 --name=concroot --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/concentrator/index --vgname=concentrator --size=204800 --name=concinde --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/concentrator/sessiondb --vgname=concentrator --size=61440 --name=concsess --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/concentrator/metadb --vgname=concentrator --size=1 --grow --name=concmeta --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/decoder --vgname=decoder --size=30720 --name=decoroot --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/decoder/index --vgname=decoder --size=30720 --name=decoinde --fstype=ext4 --fsoptions="noatime,nosuid"
logvol /var/netwitness/decoder/metadb --vgname=decoder --size=102400 --name=decometa --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/decoder/sessiondb --vgname=decoder --size=61440 --name=decosess --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/decoder/packetdb --vgname=decoder --size=1 --grow --name=decopack --fstype=xfs --fsoptions="nosuid,noatime"'

eusb_root_volumes='# OS partitions on the RAID 1 volume on the internal drives
logvol /home --fstype=ext4 --name=usrhome --vgname=VolGroup00 --size=4096 --fsoptions="nosuid"
logvol /var/tmp --fstype=ext4 --name=vartmp --vgname=VolGroup00 --size=6144 --fsoptions="nosuid"
logvol / --fstype=ext4 --name=root --vgname=VolGroup00 --size=1 --grow'

# ng 9.8 format
old_esb_root_volumes='OS partitions on the RAID 1 volume on the internal drives
logvol / --fstype=ext4 --name=root --vgname=VolGroup00 --size=6912
logvol /home --fstype=ext4 --name=usrhome --vgname=VolGroup00 --size=2048 --fsoptions="nosuid"
logvol /tmp --fstype=ext4 --name=tmp --vgname=VolGroup00 --size=8448 --fsoptions="nosuid"
logvol /var/tmp --fstype=ext4 --name=vartmp --vgname=VolGroup00 --size=4096 --grow  --fsoptions="nosuid"
logvol /var --fstype=ext4 --name=var --vgname=VolGroup00 --size=1 --grow'

saw_root_volumes='# OS partitions on the RAID 1 volume on the internal drives
logvol /home --fstype=ext4 --name=usrhome --vgname=VolGroup00 --size=4096 --fsoptions="nosuid"
logvol /var/tmp --fstype=ext4 --name=vartmp --vgname=VolGroup00 --size=6144 --fsoptions="nosuid"
logvol / --fstype=ext4 --name=root --vgname=VolGroup00 --size=1 --grow' 

sv_root_volumes='# OS partitions on the RAID 1 volume on the internal drives
logvol swap --fstype=swap --name=swap --vgname=VolGroup00 --size=4096
logvol / --fstype=ext4 --name=root --vgname=VolGroup00 --size=20480 
logvol /home --fstype=ext4 --name=usrhome --vgname=VolGroup00 --size=4096 --fsoptions="nosuid"
logvol /opt --fstype=xfs --name=opt --vgname=VolGroup00 --size=20480 --fsoptions="nosuid"
logvol /opt/rsa --fstype=xfs --name=rsaroot --vgname=VolGroup00 --size=10240 --fsoptions="nosuid"
logvol /var --fstype=xfs --name=var --vgname=VolGroup00 --size=20480
logvol /var/lib/rabbitmq --fstype=xfs --name=rabmq --vgname=VolGroup00 --size=20480 --fsoptions="nosuid,noatime"
logvol /var/log --fstype=xfs --name=varlog --vgname=VolGroup00 --size=16384
logvol /var/tmp --fstype=xfs --name=vartmp --vgname=VolGroup00 --size=4096 --fsoptions="nosuid"
logvol /tmp --fstype=xfs --name=tmp --vgname=VolGroup00 --size=20480 --fsoptions="nosuid"
logvol /var/netwitness --fstype=xfs --name=nwhome --vgname=VolGroup00 --size=30720 --fsoptions="nosuid,noatime"'

raid_vendors='DELL INTEL LSI'

raid_models='PERC H700 SRCSAS144E MegaRAID 8888ELP MR9260DE-8i MR9260-8i MR9260-4i AOC-USAS2LP-H8iR Internal Dual SD PERC H730P Mini' 

raid_models_list=( "PERC H700" "PERC H710P" "SRCSAS144E" "MegaRAID 8888ELP" "MR9260DE-8i" "MR9260-8i" "MR9260-4i" "AOC-USAS2LP-H8iR" "Internal Dual SD" "PERC H730P Mini" )

pxetesthost='hwimgsrv.nw-xlabs'

# ^^^^^^^^^^^^^^^^^^^^^ global variables ^^^^^^^^^^^^^^^^^^^^^^^^^^

# type of netwitness software to install, parsed from kickstart %packages
nwapptype=

# anaconda install method: if set install is considered 'harddrive', otherwise 'cdrom' or 'url'
installtype=

# type of supported netwitness appliance hardware 
nwsystem=

# number of virtual drives on internal raid controller
numld=

# first drive validation test to run
drivetest=

# second drive validation test to run
drivetest2= 

# configure HW RAID
hwraid=

# S4S Newport System
inewport=

# installation logical block device list, alphabetical
declare -a installdev

# position of first planar ata block device in ${installdev[@]}
atablkdev=

# corresponding logical block devivce list's model
declare -a installmodel

# logcollector installation flag for upgrade package list
logcoll=

# nwwarehouseconnector installation flag for upgrade list and backup
warehouseconn=

# Path of LSI MegaRaid CLI uility
COMMAND_TOOL=/usr/bin/MegaCLI

if ! [ -s $COMMAND_TOOL ] || ! [ -x $COMMAND_TOOL ]; then
	chvt 3
	echo ' -----------------------------------------------------' > /dev/tty3
	echo ' Usable LSI MegaRaid CLI utility Not found in /usr/bin' 
	echo ' installation cannot continue, exiting in 2 minutes' > /dev/tty3
	echo ' press <CTRL><ALT><DEL> to reboot now' > /dev/tty3
	echo ' -----------------------------------------------------' > /dev/tty3
	sleep 120
	chvt 1
	exit 1
fi 

# ^^^^^^^^^^^^^^^^^^^ function definitions ^^^^^^^^^^^^^^^^^^^^^^^

function writeBootRaid
{
	local SYSPARTS='/tmp/nwpart.txt'
	
	# mirror $1 and $2 (small internal drives)
	# /boot partition raid:  so either drive can be used as the boot drive.
	if ! [[ -z $2 ]]; then
            # assume SW RAID1
            echo "part raid.10 --size=16 --maxsize=520 --grow --ondisk=$1 --asprimary" >> $SYSPARTS
	    echo "part raid.11 --size=16 --maxsize=520 --grow --ondisk=$2 --asprimary" >> $SYSPARTS
	    echo 'raid /boot --fstype ext4 --fsoptions "nosuid" --level=RAID1 --device=md0 raid.10 raid.11' >> $SYSPARTS
        else
            # assume planar sata controller or Dell HW RAID1
            echo "part /boot --size=16 --maxsize=520 --grow --ondisk=$1 --asprimary --fstype=ext4" >> $SYSPARTS
        fi
	return 0
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
		
		# make msdos labels by default, required for uninitialized disks
		echo 'making default msdos disk label' >> /tmp/pre.log
		echo "/usr/sbin/parted -s /dev/$1 mklabel msdos" >> /tmp/pre.log
		/usr/sbin/parted -s /dev/${1} mklabel msdos >> /tmp/pre.log 2>&1
		echo 1 > /sys/block/${1}/device/rescan
		sleep 2
	
		# get number of 512 byte disk sectors
		size=`/usr/sbin/parted -s /dev/$1 unit s print | grep -i '^Disk' | awk '{print $3}'` 
		size=${size%s}
		# compute disk size in MiB
	        let size=`expr $size / 2 / 1024`
		echo 'checking disk size' >> /tmp/pre.log
		echo "/dev/$1 $size MiB" >> /tmp/pre.log
		# enforce 2 TiB msdos partition size limitation
		if [ $size -gt  2097152 ]; then
			echo 'disk larger than 2 TiB, making gpt label' >> /tmp/pre.log
			echo "/usr/sbin/parted -s /dev/$1 mklabel gpt" >> /tmp/pre.log
			/usr/sbin/parted -s /dev/$1 mklabel gpt >> /tmp/pre.log 2>&1
			echo 1 > /sys/block/$1/device/rescan
		fi
		sleep 2 
		shift 
	done
	
	### debug statements ###
	#local usrin
	#chvt 3
	#exec < /dev/tty3 > /dev/tty3 2>&1
	#read -t 99999 -p "Completed mk_disk_labels( ), press Enter to continue" usrin
	
	#return 0
} 

function detect_mdraid {
	local MDADMCFG='/etc/mdadm.conf'
	echo '# mdadm.conf generated by rsa appliance upgrade' > $MDADMCFG
	echo 'MAILADDR root' >> $MDADMCFG 
	echo 'AUTO +0.90 +1.x +imsm -all' >> $MDADMCFG
	local blockdev=( `ls /sys/block | grep '[hs]d[a-z]'` )
	local numpart
	local count
	local part
	local mdnumdev
	local mduuid
	local mddev
	local mdlevel
	local mdstats
	local stat
	
	for device in ${blockdev[@]}
	do 
		if [[ `parted -s /dev/$device print | grep 'raid'` ]]; then 
			# get number of parttions
			let numpart=`ls /sys/block/$device | grep "$device[1-9]" | wc -l`
			# partitions start at one
			let count=1
			while [ $count -le $numpart ]
			do
				part=`parted -s /dev/$device print | grep -E -i -A$numpart '^[[:space:]]*Number[[:space:]]+Start[[:space:]]+End[[:space:]]+Size[[:space:]]+Type[[:space:]]+File[[:space:]]+system[[:space:]]+Flags' |  grep -E "^[[:space:]]*$count"` 
				if [[ `echo $part | grep 'raid'` ]]; then
					mdstats=( `mdadm --examine --scan /dev/$device$count` )
					for stat in ${mdstats[@]}
					do
						if [[ `echo $stat | grep '/dev/md/*[0-9]'` ]]; then
							# get md device
							mddev=$stat
						elif [[ `echo $stat | grep -i 'UUID'` ]]; then
							# get RAID UUID
							mduuid=$stat
						fi
					done
					# get number of devices
					mdnumdev=`mdadm -E /dev/$device$count | grep -E 'Raid[[:space:]]*Devices' | awk '{print $4}'`
					# get raid level		
					mdlevel=`mdadm -E /dev/$device$count | grep -E 'Raid[[:space:]]*Level' | awk '{print $4}'`
					# create mdadm conf file
					if ! [[ `grep -E "^[[:space:]]*ARRAY[[:space:]]+$mddev[[:space:]]+level=$mdlevel[[:space:]]+num-devices=$mdnumdev[[:space:]]+$mduuid" $MDADMCFG` ]]; then
						echo "ARRAY $mddev level=$mdlevel num-devices=$mdnumdev $mduuid" >> $MDADMCFG
						# activate device
						#mdadm -A -U super-minor -f -c /tmp/mdadm.conf $mddev
						mdadm -A -f -c /etc/mdadm.conf $mddev
					fi
				fi
				let count=$count+1
			done
		
		fi 
	done
	# copy mdadm.conf to tmp for installation/backup
	cp $MDADMCFG /tmp/
}

function backupprompt { 
	echo > /dev/tty3
	echo > /dev/tty3
	echo "------------------------------------------" > /dev/tty3
	if [ -z $1 ]; then 
		echo " ** Failed Backup ** of /tmp/nw.tbz and" > /dev/tty3 
		echo " /tmp/fstab.bak. Please backup manually" > /dev/tty3
	else
		echo " ** Failed Backup ** of $1" > /dev/tty3
		echo " Please backup filei(s) manually" > /dev/tty3
	fi
	echo " to removeable media or network share" > /dev/tty3
	echo " before proceeding with system upgrade" > /dev/tty3
	echo " Without these files any upgrade errors" > /dev/tty3
	echo " will be unrecoverable possibly requiring" > /dev/tty3 
	echo " a re-install of the system and data loss" > /dev/tty3
	echo " Please enter C to continue or Q to quit" > /dev/tty3
	echo "------------------------------------------" > /dev/tty3
}

function set_nwapptype {
	# determine appliance type from kickstart %packages section
	# package names prepended with a dash '-', eg: -rsa-saw-server, are assumed to be either installed
	# in %post or not installed at all
	# current defined appliance types, global variable string value
	# nwbroker, broker 
	# nwconcentrator, concentrator
	# nwdecoder, decoder
	# nwlogdecoder, logdecoder
	# spectrum enterprise, spectrumbroker
	# security analytics and broker and re, sabroker
	# logs hybrid, loghybrid
	# packet hybrid, packethybrid
	# logs aio, logaio
	# packet aio, packetaio
	# remote logcollector, logcollector
	# remote ipdb extractor, ipdbextractor
	# warehouse powered by mapR, maprwh
	# nwarchiver, archiver
	# nwwarehouseconnector, connector
	# event stream analytics, esa
	local packstart=
	local packend=
	local numlines=
	packstart=`grep -n '%packages' /tmp/ks.cfg`
	packstart=${packstart%%:*}
	packend=`grep -E -n '^[[:space:]]*%include[[:space:]]+/tmp/nwpack.txt' /tmp/ks.cfg`
	packend=${packend%%:*}
	numlines=`expr $packend - $packstart`
	echo "numlines in %packages = $numlines" >> /tmp/pre.log	
	if [[ `grep -A$numlines '%packages' /tmp/ks.cfg | grep -E '^[[:space:]]*\@rsa-sa-broker[[:space:]]*$'` ]]; then
		nwapptype='broker'
	elif [[ `grep -A$numlines '%packages' /tmp/ks.cfg | grep -E '^[[:space:]]*\@rsa-sa-concentrator[[:space:]]*$'` ]]; then
		nwapptype='concentrator'
	elif [[ `grep -A$numlines '%packages' /tmp/ks.cfg | grep -E '^[[:space:]]*\@rsa-sa-packet-decoder[[:space:]]*$'` ]]; then
		nwapptype='decoder'
	elif [[ `grep -A$numlines '%packages' /tmp/ks.cfg | grep -E '^[[:space:]]*\@rsa-sa-log-decoder[[:space:]]*$'` ]]; then
		nwapptype='logdecoder'
	elif [[ `grep -A$numlines '%packages' /tmp/ks.cfg | grep -E '^[[:space:]]*\@rsa-sa-packet-hybrid[[:space:]]*$'` ]]; then
		nwapptype='packethybrid'
	elif [[ `grep -A$numlines '%packages' /tmp/ks.cfg | grep -E '^[[:space:]]*\@rsa-sa-log-hybrid[[:space:]]*$'` ]]; then
		nwapptype='loghybrid'
	elif [[ `grep -A$numlines '%packages' /tmp/ks.cfg | grep -E '^[[:space:]]*\@rsa-sa-malware-analysis[[:space:]]*$'` ]]; then
		nwapptype='spectrumbroker'
	elif [[ `grep -A$numlines '%packages' /tmp/ks.cfg | grep -E '^[[:space:]]*\@rsa-sa-server[[:space:]]*$'` ]]; then
		nwapptype='sabroker'
	elif [[ `grep -A$numlines '%packages' /tmp/ks.cfg | grep -E '^[[:space:]]*\@rsa-sa-log-aio[[:space:]]*$'` ]]; then
		nwapptype='logaio'
	elif [[ `grep -A$numlines '%packages' /tmp/ks.cfg | grep -E '^[[:space:]]*\@rsa-sa-packet-aio[[:space:]]*$'` ]]; then
		nwapptype='packetaio'
	elif [[ `grep -A$numlines '%packages' /tmp/ks.cfg | grep -E '^[[:space:]]*-\@rsa-sa-remote-logcollector[[:space:]]*$'` ]] && ! [[ `grep -A$numlines '%packages' /tmp/ks.cfg | grep -E '^[[:space:]]*\@rsa-sa-log-decoder[[:space:]]*$'` ]] && ! [[ `grep -A$numlines '%packages' /tmp/ks.cfg | grep -E '^[[:space:]]*\@rsa-sa-log-aio[[:space:]]*$'` ]] && ! [[ `grep -A$numlines '%packages' /tmp/ks.cfg | grep -E '^[[:space:]]*\@rsa-sa-log-hybrid[[:space:]]*$'` ]]; then
		nwapptype='logcollector'
	elif [[ `grep -A$numlines '%packages' /tmp/ks.cfg | grep -E '^[[:space:]]*\@rsa-sa-remote-ipdbextractor[[:space:]]*$'` ]]; then
		nwapptype='ipdbextractor' 
	elif [[ `grep -A$numlines '%packages' /tmp/ks.cfg | grep -E '^[[:space:]]*-rsa-saw-server[[:space:]]*$'` ]]; then
		nwapptype='maprwh'
	elif [[ `grep -A$numlines '%packages' /tmp/ks.cfg | grep -E '^[[:space:]]*\@rsa-sa-archiver[[:space:]]*$'` ]]; then
		nwapptype='archiver'
	elif [[ `grep -A$numlines '%packages' /tmp/ks.cfg | grep -E '^[[:space:]]*-\@rsa-sa-warehouse-connector[[:space:]]*$'` ]] && ! [[ `grep -A$numlines '%packages' /tmp/ks.cfg | grep -E '^[[:space:]]*\@rsa-sa-log-decoder[[:space:]]*$'` ]] && ! [[ `grep -A$numlines '%packages' /tmp/ks.cfg | grep -E '^[[:space:]]*\@rsa-sa-log-hybrid[[:space:]]*$'` ]] && ! [[ `grep -A$numlines '%packages' /tmp/ks.cfg | grep -E '^[[:space:]]*\@rsa-sa-packet-decoder[[:space:]]*$'` ]] && ! [[ `grep -A$numlines '%packages' /tmp/ks.cfg | grep -E '^[[:space:]]*\@rsa-sa-packet-hybrid[[:space:]]*$'` ]]; then
		nwapptype='connector'
	elif [[ `grep -A$numlines '%packages' /tmp/ks.cfg | grep -E '^[[:space:]]*\@rsa-sa-esa-server[[:space:]]*$'` ]]; then
		nwapptype='esa'
	fi
	
	if [ $nwapptype ]; then
		#echo "nwapptype = $nwapptype" > /dev/tty3
		echo "$nwapptype" > /tmp/nwapptype
		echo "nwapptype = $nwapptype" >> /tmp/pre.log
	fi
}

function set_nwsystem {
	# check supported hardware
	local my_board=`dmidecode -t 2 | grep -i 'Product Name:' | awk '{print $3}'`
	local my_system=`dmidecode -t 1 | grep -i 'Product Name:' | awk '{print $4}'`
	local my_manufacturer=`dmidecode -t 1 | grep -i 'Manufacturer:' | awk '{print $2}'`
	local my_id=
	echo "my_board = $my_board" >> /tmp/pre.log
	echo "my_manufacturer = $my_manufacturer" >> /tmp/pre.log
	echo "my_system = $my_system" >> /tmp/pre.log

	if [[ `echo "$my_manufacturer" | grep -i 'Supermicro'` ]]; then
		case "$my_board" in
			"X8DTN+-F" )
				# sm (nehalem cpu) 1200n/2400n series concentrator, decoder and spectrum
				nwsystem='sm-s3-2u'
			;;
			"X7DWN+" )
				# sm 1200/2400 series decoder and concentrator
				nwsystem='sm-s2-2u'
			;;
			# eagle no longer supported for NG 10.x
			#"X7SB4/E" )
			#	nwsystem='sm-eagle'
			#;;
			"X8SIU" )
				# sm 200 series broker
				nwsystem='sm-s3-1u-brok'
			;;
			"X8DTU-6+" )
				# sm 200 series hybrid and spectrum
				nwsystem='sm-s3-1u'
			;;
			"X7SBi" )
				# sm 100 series broker and decoder
				nwsystem='sm-s2-1u'
			;;
			"X7DBU" )
				# sm 100 series concentrator
				nwsystem='sm-s2-1u-conc'
			;;
			* )
				# third party hw
				nwsystem='thirdparty'
			;; 
		esac
	elif [[ `echo "$my_manufacturer" | grep -i 'Intel'` ]]; then
		case "$my_board" in
			"S2600GZ" )
				nwsystem='grizzlypass'
			;;
			"S5000PSL" )
				nwsystem='mckaycreek'
			;;
			* )
				# third party hw
				nwsystem='thirdparty'
			;; 
		esac
	elif [[ `echo "$my_manufacturer" | grep -i 'Dell'` ]] || ! [ $my_manufacturer ]; then
		# white box system, attempt to get product ID
		if ! [ $my_manufacturer ]; then
			my_id=`dmidecode -t 11 | grep -i 'String 5' | awk -F[ '{print $2}' | awk '{print $1}'`
		        my_id=${my_id%]}
			if ! [[ `echo ${my_id} | grep -E '[0-9]+'` ]]; then
				my_id=`dmidecode -t 11 | grep -i 'String 4' | awk -F[ '{print $2}' | awk '{print $1}'`
			        my_id=${my_id%]}
			fi
		fi 
		if [[ `echo "$my_board" | grep -E '0P229K|05XKKK'` ]] || [[ "$my_system" == "R310" ]]; then
			nwsystem='dell-s3-1u-brok'
		elif [[ "$my_board" = "0N83VF" || "$my_system" = "R410" ]]; then
			nwsystem='dell-s3-1u'
		elif [[ `echo "$my_board" | grep -E '00HDP0|0DPRKF'` ]] || [[ "$my_system" == "R510" ]]; then
			nwsystem='dell-s3-2u'
		elif [[ "$my_board" = "0P8FRD" || "$my_system" = "R610" ]]; then
			nwsystem='dell-s4-1u'
		elif [[ "$my_board" = "0XDX06" || "$my_system" = "R710" ]]; then
			nwsystem='dell-s4-2u'
		elif [[ "$my_board" = "0KFFK8" || "$my_board" == "036FVD" || "$my_system" = "R620" ]] || [ "$my_id" = '8122' ]; then
			nwsystem='dell-s4s-1u'
		elif [[ "$my_board" = "086D43" || "$my_system" = "R630" ]] || [ "$my_id" = '8134' ]; then
			nwsystem='dell-s9-1u'
		elif [[ "$my_board" = "04N3DF" || "$my_system" = "R730" ]] || [ "$my_id" = '8149' ]; then
			nwsystem='dell-s5-2u'
		else
			nwsystem='thirdparty' 
		fi 
	fi

	if [ $nwsystem ]; then
		echo "$nwsystem" > /tmp/nwsystem
		echo "nwsystem = $nwsystem" >> /tmp/pre.log
	else
		nwsystem='thirdparty'
		echo "$nwsystem" > /tmp/nwsystem
		echo "nwsystem = $nwsystem" >> /tmp/pre.log
	fi
}

function verify_upgrade_path {
	# rename install image's rpm database, no installer kernel support for rpm --dbpath switch 
	echo "re-naming installer rpm database" >> /tmp/pre.log
	mv -f  /var/lib/rpm /var/lib/oldrpm
	sleep 2	
	# mount existing var or root volumes and link rpm database path to install image
	if [[ `grep -E '[[:space:]]/var[[:space:]]' /tmp/cfgbak/fstab` ]]; then
		local varvol=`grep -E '[[:space:]]/var[[:space:]]' /tmp/cfgbak/fstab | awk '{print $1}'`
		echo "mounting '/var' lv $varvol for rpm package check" >> /tmp/pre.log
		mount $varvol /tmp/mnt
		sleep 2 
		echo "linking existing rpm database to installer" >> /tmp/pre.log
		ln -s -t /var/lib /tmp/mnt/lib/rpm
		sleep 2
		# remove any stale locks	
		echo "removing any stale locks from existing rpm database" >> /tmp/pre.log
		rm -f /var/lib/rpm/__db.*
		# archive rpm db
		echo 'backing up existing rpm database: /tmp/cfgbak/rpm.tbz' | tee -a /tmp/pre.log > /dev/tty3
		tar -C /tmp/mnt/lib -cjf /tmp/cfgbak/rpm.tbz rpm/
	else
		echo "mounting '/' root lv /dev/VolGroup00/root for rpm package check" >> /tmp/pre.log
		mount /dev/VolGroup00/root /tmp/mnt
		sleep 2
		echo "linking existing rpm database to installer" >> /tmp/pre.log
		ln -s -t /var/lib /tmp/mnt/var/lib/rpm
		sleep 2
		# remove any stale locks	
		echo "removing any stale locks from existing rpm database" >> /tmp/pre.log
		rm -f /var/lib/rpm/__db.*
		# archive rpm db
		echo 'backing up existing rpm database: /tmp/cfgbak/rpm.tbz' | tee -a /tmp/pre.log > /dev/tty3
		tar -C /tmp/mnt/var/lib -cjf /tmp/cfgbak/rpm.tbz rpm/
	fi

	# check for logcollector installation
	if [[ `rpm -q nwlogcollector | grep -E 'nwlogcollector-[0-9]+\.[0-9]+'` ]]; then
		logcoll=true
	fi
	
	# check for warehouse connector installation
	if [[ `rpm -q nwwarehouseconnector | grep -E 'nwwarehouseconnector-[0-9]+\.[0-9]+'` ]]; then
		warehouseconn=true
	fi

	# validate installed system against menu item selected
	local errcode=
	local errstr=
	case $nwapptype in
		archiver )
			if [[ `rpm -q nwarchiver | grep -E 'nwarchiver-[0-9]+\.[0-9]+'` ]]; then
				errcode=0
			else
				errcode=1
				errstr='missing application(s) detected'
			fi
		;;
		broker )
			if [[ `rpm -q nwbroker | grep -E 'nwbroker-[0-9]+\.[0-9]+'` ]] && ! [[ `rpm -q security-analytics-web-server | grep -E 'security-analytics-web-server-[0-9]+\.[0-9]+'` || `rpm -q sa-server | grep -E 'sa-server-[0-9]+\.[0-9]+'` || `rpm -q sa | grep -E 'sa-[0-9]+\.[0-9]+'` ]] && ! [[ `rpm -q rsaMalwareDeivce | grep -E 'rsaMalwareDevice-[0-9]+\.[0-9]+'` ]]; then
				errcode=0
			else
				errcode=1
				errstr='missing or additional application(s) detected'
			fi
		;;
		concentrator )
			if  [[ `rpm -q nwconcentrator | grep -E 'nwconcentrator-[0-9]+\.[0-9]+'` ]] && ! [[ `rpm -q nwdecoder | grep -E 'nwdecoder-[0-9]+\.[0-9]+'` ]] && ! [[ `rpm -q nwlogdecoder | grep -E 'nwlogdecoder-[0-9]+\.[0-9]+'` ]]; then
				errcode=0
			else
				errcode=1
				errstr='missing or additional application(s) detected'
			fi
		;;
		# stand alone warehouse connector not currently released
		#connector )
		#;;
		decoder )
			if  [[ `rpm -q nwdecoder | grep -E 'nwdecoder-[0-9]+\.[0-9]+'` ]] && ! [[ `rpm -q nwconcentrator | grep -E 'nwconcentrator-[0-9]+\.[0-9]+'` ]]; then
				errcode=0
			else
				errcode=1
				errstr='missing or additional application(s) detected'
			fi
		;;
		esa )
			if [[ `rpm -q rsa-esa-server | grep -E 'rsa-esa-server-[0-9]+\.[0-9]+'` ]]; then
				errcode=0
			else
				errcode=1
				errstr='missing application(s) detected'
			fi
		;;
		ipdbextractor )
			if [[ `rpm -q nwipdbextractor | grep -E 'nwipdbextractor-[0-9]+\.[0-9]+'` ]] && ! [[ `rpm -q re-server | grep -E 're-server-[0-9]+\.[0-9]+'` ]]; then
				errcode=0
			else
				errcode=1
				errstr='missing or additional application(s) detected'
			fi
		;;
		logaio )
			if [[ `rpm -q nwlogdecoder | grep -E 'nwlogdecoder-[0-9]+\.[0-9]+'` && `rpm -q nwlogcollector | grep -E 'nwlogcollector-[0-9]+\.[0-9]+'` && `rpm -q nwconcentrator | grep -E 'nwconcentrator-[0-9]+\.[0-9]+'` ]] && [[ `rpm -q nwbroker | grep -E 'nwbroker-[0-9]+\.[0-9]+'` ]] && [[ `rpm -q security-analytics-web-server | grep -E 'security-analytics-web-server-[0-9]+\.[0-9]+'` || `rpm -q sa-server | grep -E 'sa-server-[0-9]+\.[0-9]+'` || `rpm -q sa | grep -E 'sa-[0-9]+\.[0-9]+'` ]]; then
				errcode=0
			else
				errcode=1
				errstr='missing application(s) detected'
			fi
		;;
		logcollector )
			if [[ `rpm -q nwlogcollector | grep -E 'nwlogcollector-[0-9]+\.[0-9]+'` ]] && ! [[ `rpm -q nwlogdecoder | grep -E 'nwlogdecoder-[0-9]+\.[0-9]+'` ]]; then
				errcode=0
			else
				errcode=1
				errstr='missing or additional application(s) detected'
			fi
		;;
		logdecoder )
			if [[ `rpm -q nwlogdecoder | grep -E 'nwlogdecoder-[0-9]+\.[0-9]+'` ]] && ! [[ `rpm -q nwconcentrator | grep -E 'nwconcentrator-[0-9]+\.[0-9]'` ]]; then
				errcode=0
			else
				errcode=1
				errstr='missing or additional application(s) detected'
			fi
		;;
		loghybrid )
			if [[ `rpm -q nwlogdecoder | grep -E 'nwlogdecoder-[0-9]+\.[0-9]+'` && `rpm -q nwlogcollector | grep -E 'nwlogcollector-[0-9]+\.[0-9]+'` && `rpm -q nwconcentrator | grep -E 'nwconcentrator-[0-9]+\.[0-9]+'` ]] && ! [[ `rpm -q nwbroker | grep -E 'nwbroker-[0-9]+\.[0-9]+'` ]] && ! [[ `rpm -q security-analytics-web-server | grep -E 'security-analytics-web-server-[0-9]+\.[0-9]+'` || `rpm -q sa-server | grep -E 'sa-server-[0-9]+\.[0-9]+'` || `rpm -q sa | grep -E 'sa-[0-9]+\.[0-9]+'` ]]; then
				errcode=0
			else
				errcode=1
				errstr='missing or additional application(s) detected'
			fi
		;;
		packetaio )
			if [[ `rpm -q nwdecoder | grep -E 'nwdecoder-[0-9]+\.[0-9]+'` && `rpm -q nwconcentrator | grep -E 'nwconcentrator-[0-9]+\.[0-9]+'` && `rpm -q nwbroker | grep -E 'nwbroker-[0-9]+\.[0-9]+'` ]] && [[ `rpm -q security-analytics-web-server | grep -E 'security-analytics-web-server-[0-9]+\.[0-9]+'` || `rpm -q sa-server | grep -E 'sa-server-[0-9]+\.[0-9]+'` || `rpm -q sa | grep -E 'sa-[0-9]+\.[0-9]+'` ]]; then
				errcode=0
			else
				errcode=1
				errstr='missing application(s) detected'
			fi
		;;
		packethybrid )
			if [[ `rpm -q nwdecoder | grep -E 'nwdecoder-[0-9]+\.[0-9]+'` && `rpm -q nwconcentrator | grep -E 'nwconcentrator-[0-9]+\.[0-9]+'` ]] && ! [[ `rpm -q nwbroker | grep -E 'nwbroker-[0-9]+\.[0-9]+'` ]] && ! [[ `rpm -q security-analytics-web-server | grep -E 'security-analytics-web-server-[0-9]+\.[0-9]+'` || `rpm -q sa-server | grep -E 'sa-server-[0-9]+\.[0-9]+'` || `rpm -q sa | grep -E 'sa-[0-9]+\.[0-9]+'` ]]; then
				errcode=0
			else
				errcode=1
				errstr='missing or additional application(s) detected'
			fi
		;;
		sabroker )
			if [[ `rpm -q nwbroker | grep -E 'nwbroker-[0-9]+\.[0-9]+'` ]] && [[ `rpm -q security-analytics-web-server | grep -E 'security-analytics-web-server-[0-9]+\.[0-9]+'` || `rpm -q sa-server | grep -E 'sa-server-[0-9]+\.[0-9]+'` || `rpm -q sa | grep -E 'sa-[0-9]+\.[0-9]+'` ]] && ! [[ `rpm -q nwconcentrator | grep -E 'nwconcentrator-[0-9]+\.[0-9]+'` ]]; then
				errcode=0
			else
				errcode=1
				errstr='missing or additional application(s) detected'
			fi
		;;
		maprwh )
			if [[ `rpm -q mapr-core | grep -E 'mapr-core-[0-9]+\.[0-9]+'` ]]; then
				errcode=0
			else
				errcode=1
				errstr='missing application(s) detected'
			fi
		;;
		spectrumbroker )
			if [[ `rpm -q nwbroker | grep -E 'nwbroker-[0-9]+\.[0-9]+'` ]] && [[ `rpm -q rsaMalwareDeivce | grep -E 'rsaMalwareDevice-[0-9]+\.[0-9]+'` ]]; then
				errcode=0
			elif [[ `rpm -q nwspectrum-server | grep -E 'nwspectrum-server-[0-9]+\.[0-9]+'` ]]; then
				errcode=1
				errstr='upgrade of spectrum appliances not supported'
			else
				errcode=1
				errstr='missing application(s) detected'
			fi
		;;
		spectrumdecoder )
			errcode=1
			errstr='malware prevention stand alone not supported'
		;; 
	esac
	
	# debug statement
	#echo "sleeping" > /dev/tty3
	#sleep 99999
	
	# restore image's rpm database 
	echo "restoring installer rpm database" >> /tmp/pre.log
	umount /tmp/mnt
	sleep 3
	rm -f /var/lib/rpm
	mv -f /var/lib/oldrpm /var/lib/rpm
	if ! [ $errcode = 0 ]; then
		chvt 3
		echo > /dev/tty3
		echo > /dev/tty3
		echo '-----------------------------------------------------' > /dev/tty3
		echo " Upgrade of $nwapptype has failed validation testing" > /dev/tty3
		echo " Reason: $errstr" > /dev/tty3
		echo ' Please verify menu selection, restart in 2 minutes' > /dev/tty3
		echo ' <CTRL><ALT><DEL> to restart now' > /dev/tty3
		echo '-----------------------------------------------------' > /dev/tty3 
		# debug statement	
		#sleep 99999 
		return 1
	else
		# debug statement
		#sleep 99999 
		return 0
	fi
}

function writeRaidScript {
	local volumeCommands="$1"
	local bootVol="$2"
	local SCRIPT=/tmp/initraid.sh
	
	echo "writing configure raid script: $SCRIPT" >> /tmp/pre.log
	echo "\$bootVol = $bootVol" >> /tmp/pre.log

	echo '#!/bin/bash
COMMAND_TOOL=/usr/bin/MegaCLI' > $SCRIPT

	# msdos partition <= 2.2 TiB
	if [[ `echo "$bootVol" | grep -i 'msdos'` || -z $2 ]]; then
		echo 'NEW_LD_OPTIONS="WB ADRA Cached CachedBadBBU -strpsz128"' | tee -a /tmp/pre.log >> $SCRIPT
	# gpt partition > 2.2 TiB, create separate boot volume
	elif [[ `echo "$bootVol" | grep -i 'gpt'` ]]; then 
		echo 'NEW_LD_OPTIONS_1="WB ADRA Cached CachedBadBBU -sz256 -strpsz128"' | tee -a /tmp/pre.log >> $SCRIPT
		echo 'NEW_LD_OPTIONS_2="WB ADRA Cached CachedBadBBU -strpsz128"' >> $SCRIPT
	else
		echo "error return 1, invalid parameter in writeRaidScript(): \$2 = $2" >> /tmp/pre.log
		return 1
	fi
	
	echo "\$volumeCommands = $volumeCommands" >> /tmp/pre.log 
	echo '
# if specified, set adapter ID
if [ -e /tmp/intAdapterId ]; then
	adpID=`cat /tmp/intAdapterId`' >> $SCRIPT
	echo '	ENCID=$("$COMMAND_TOOL" -pdlist -a$adpID | while read p1 p2 p3 p4; do if [ "$p1" == "Enclosure" ]; then echo $p4; break; fi; done)' >> $SCRIPT
	echo '	ADAPTER=$adpID
else' >> $SCRIPT
	echo '	ENCID=$("$COMMAND_TOOL" -pdlist -a0 | while read p1 p2 p3 p4; do if [ "$p1" == "Enclosure" ]; then echo $p4; break; fi; done)' >> $SCRIPT

	echo '	ADAPTER=0
fi
' >> $SCRIPT
	
	echo "	$volumeCommands" >> $SCRIPT
	
	
	echo '	# take a moment to be sure the new volumes show up.		
	sleep 8
	exit 0
fi
' >> $SCRIPT
	chmod u+x $SCRIPT
return 0
}

function invalid_hw {

		chvt 3
		echo > /dev/tty3
		echo > /dev/tty3
		echo "---------------------------------------------" > /dev/tty3
		echo " Unable to determine system hardware version" > /dev/tty3 
		echo " or non supported system hardware detected"  > /dev/tty3
		echo " No installation/upgrade method is available" > /dev/tty3
		echo " Installation cannot continue" > /dev/tty3
		echo "---------------------------------------------" > /dev/tty3
		echo > /dev/tty3
		promptReboot
		chvt 1
		return 1
}

function set_raid_packs_post {
	
	local megabin="$1"
	local volumesetup
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
	
	# determine install type
	if ! [ $installtype ]; then
		set_installtype
	fi

	# create %packages section
	local package
	for package in ${packagelist[@]}
	do
		echo $package >> /tmp/nwpack.txt
	done
	# if two hard drive tests are required for hw raid appliance, assign raid check to $drivetest2
	case $nwapptype in
		broker )
			case $nwsystem in
				# 100 series broker
				sm-s2-1u )
					drivetest=check_100_sm_decoder_drives
					echo -e 'make_device_map_sda\nvolumeGroupScan\ndoPost' >> /tmp/nwpost.txt
				;;
				# 200 series dell and sm broker
				sm-s3-1u-brok | dell-s3-1u-brok )
					echo -e '@rsa-sa-ipmi-tools\n@rsa-sa-lsi-megacli' >> /tmp/nwpack.txt
					hwraid=True
					drivetest=check_200_broker_raid
					volumesetup='# system is one drive in RAID 5 mode
					"$COMMAND_TOOL" -cfgldadd -R5[$ENCID:0,$ENCID:1,$ENCID:2] $NEW_LD_OPTIONS -a$ADAPTER
					# create hot spare
					"$COMMAND_TOOL" -pdhsp -set -EnclAffinity -PhysDrv [$ENCID:3] -a$ADAPTER        
					# make drive bootable
					"$COMMAND_TOOL" -AdpBootDrive -Set -L0 -a$ADAPTER'
					writeRaidScript "$volumesetup" msdos
					echo -e 'make_device_map_dell_200\nvolumeGroupScan\ndoPost' >> /tmp/nwpost.txt
				;;
				# 4 series broker
				dell-s4-1u )
					echo -e '@rsa-sa-ipmi-tools\n@rsa-sa-lsi-megacli\n@rsa-sa-san-tools' >> /tmp/nwpack.txt 
					hwraid=True
					drivetest=check_nwx_drives
					drivetest2=check_nwx_raid
					volumesetup='# system volume is 2 drives in RAID 1 mode
					"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:0,$ENCID:1] $NEW_LD_OPTIONS -a$ADAPTER
					# application volume is 2 drives in RAID 1 mode
					"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:2,$ENCID:3] $NEW_LD_OPTIONS -a$ADAPTER     
					# make drive bootable
					"$COMMAND_TOOL" -AdpBootDrive -Set -L0 -a$ADAPTER'
					writeRaidScript "$volumesetup" msdos
					echo -e 'make_device_map_dell_200\nvolumeGroupScan\ndoPost' >> /tmp/nwpost.txt
				;;
				# 4s series broker
				dell-s4s-1u )
					if check_for_newport_drives
					then	
						echo -e '@rsa-sa-ipmi-tools\n@rsa-sa-lsi-megacli\n@rsa-sa-san-tools' >> /tmp/nwpack.txt
						inewport=True
						hwraid=True
						drivetest=check_esa_raid
						volumesetup='# application volume is 9 drives in RAID 5 mode
						"$COMMAND_TOOL" -cfgldadd -R5[$ENCID:0,$ENCID:1,$ENCID:2,$ENCID:3,$ENCID:4,$ENCID:5,$ENCID:6,$ENCID:7,$ENCID:8] $NEW_LD_OPTIONS -a$ADAPTER
						# global hot spare
						"$COMMAND_TOOL" -pdhsp -set -EnclAffinity -PhysDrv [$ENCID:9] -a$ADAPTER'
						writeRaidScript "$volumesetup" msdos 
						echo -e 'make_device_map_esa\nvolumeGroupScan\ndoPost' >> /tmp/nwpost.txt
					else 
						echo -e '@rsa-sa-ipmi-tools\n@rsa-sa-lsi-megacli\n@rsa-sa-san-tools' >> /tmp/nwpack.txt
						hwraid=True
						#drivetest="check_nwx_drives 147 1000"
						drivetest="check_enc_drive_sizes 147 147 1000 1000"
						drivetest2=check_nwx_raid
						volumesetup='# system volume is 2 drives in RAID 1 mode
						"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:0,$ENCID:1] $NEW_LD_OPTIONS -a$ADAPTER
						# application volume is 2 drives in RAID 1 mode
						"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:2,$ENCID:3] $NEW_LD_OPTIONS -a$ADAPTER     
						# make drive bootable
						"$COMMAND_TOOL" -AdpBootDrive -Set -L0 -a$ADAPTER'
						writeRaidScript "$volumesetup" msdos
						echo -e 'make_device_map_dell_2400\nvolumeGroupScan\ndoPost' >> /tmp/nwpost.txt
					fi
				;;
				# 9 series broker
				dell-s9-1u )
					echo -e '@rsa-sa-ipmi-tools\n@rsa-sa-lsi-megacli\n@rsa-sa-san-tools' >> /tmp/nwpack.txt 
					hwraid=True
					#drivetest="check_nwx_drives 1000GB 2TB"
					drivetest="check_enc_drive_sizes 1000 1000 2000 2000"
					drivetest2=check_nwx_raid
					volumesetup='# system volume is 2 drives in RAID 1 mode
					"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:0,$ENCID:1] $NEW_LD_OPTIONS -a$ADAPTER
					# application volume is 2 drives in RAID 1 mode
					"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:2,$ENCID:3] $NEW_LD_OPTIONS -a$ADAPTER     
					# make drive bootable
					"$COMMAND_TOOL" -AdpBootDrive -Set -L0 -a$ADAPTER'
					writeRaidScript "$volumesetup" msdos
					echo -e 'make_device_map_dell_200\nvolumeGroupScan\ndoPost' >> /tmp/nwpost.txt
				;;
				# un-qualified hardware
				* )
					invalid_hw
				;;	
			esac
			echo '%end' >> /tmp/nwpack.txt
		;;
		concentrator )
				case $nwsystem in
					# 100 series concentrator
					sm-s2-1u-conc )
						drivetest=check_100_sm_concentrator_drives
						echo -e 'make_device_map_sdb\nvolumeGroupScan\ndoPost\ncheck_post_package' >> /tmp/nwpost.txt
					;;
					# 1200 series mckay creek concentrator
					mckaycreek )
						echo -e '@rsa-sa-ipmi-tools\n@rsa-sa-lsi-megacli' >> /tmp/nwpack.txt
						hwraid=True
						drivetest=check_1200_decoder_raid
						volumesetup='# concentrator volume is 8 drives in RAID 5 mode
						"$COMMAND_TOOL" -cfgldadd -R5[$ENCID:0,$ENCID:1,$ENCID:2,$ENCID:3,$ENCID:4,$ENCID:5,$ENCID:6,$ENCID:7] $NEW_LD_OPTIONS -a$ADAPTER
						# index volume is 3 drives in RAID 5 mode 
						"$COMMAND_TOOL" -cfgldadd -R5[$ENCID:8,$ENCID:9,$ENCID:10] $NEW_LD_OPTIONS -a$ADAPTER
						"$COMMAND_TOOL" -pdhsp -set -Dedicated -Array0 -PhysDrv [$ENCID:11] -a$ADAPTER'
						writeRaidScript "$volumesetup" msdos
						echo -e 'make_device_map_sdd\nvolumeGroupScan\ndoPost\ncheck_post_package' >> /tmp/nwpost.txt
					;;
					# 1200/2400 or 1200n/2400n series sm concentrator
					sm-s2-2u | sm-s3-2u )
						echo -e '@rsa-sa-ipmi-tools\n@rsa-sa-lsi-megacli' >> /tmp/nwpack.txt
						hwraid=True
						drivetest=check_2u_smconc_raid
						if check_2400_ssd_drives
						then
							volumesetup='# concentrator volume is 6 drives in RAID 5 mode
							"$COMMAND_TOOL" -cfgldadd -R5[$ENCID:0,$ENCID:1,$ENCID:2,$ENCID:3,$ENCID:4,$ENCID:5] $NEW_LD_OPTIONS -a$ADAPTER
							# index is 5 drives in RAID 5
							"$COMMAND_TOOL" -cfgldadd -R5[$ENCID:6,$ENCID:7,$ENCID:8,$ENCID:9,$ENCID:10] $NEW_LD_OPTIONS -a$ADAPTER
							"$COMMAND_TOOL" -pdhsp -set -Dedicated -Array0 -PhysDrv [$ENCID:11] -a$ADAPTER'	
						elif check_1200_ssd_drives
						then
							volumesetup='# concentrator volume is 8 drives in RAID 5 mode
							"$COMMAND_TOOL" -cfgldadd -R5[$ENCID:0,$ENCID:1,$ENCID:2,$ENCID:3,$ENCID:4,$ENCID:5,$ENCID:6,$ENCID:7] $NEW_LD_OPTIONS -a$ADAPTER
							# index is 3 drives in RAID 5
							"$COMMAND_TOOL" -cfgldadd -R5[$ENCID:8,$ENCID:9,$ENCID:10] $NEW_LD_OPTIONS -a$ADAPTER
							"$COMMAND_TOOL" -pdhsp -set -Dedicated -Array0 -PhysDrv [$ENCID:11] -a$ADAPTER'					
						fi
						writeRaidScript "$volumesetup" msdos
						echo -e 'make_device_map_sdc\nvolumeGroupScan\ndoPost\ncheck_post_package' >> /tmp/nwpost.txt
					;;
					# 1200/2400 series dell concentrator
					dell-s3-2u )
						echo -e '@rsa-sa-ipmi-tools\n@rsa-sa-lsi-megacli' >> /tmp/nwpack.txt
						hwraid=True
						drivetest=check_2u_dell_conc_raid 
						if check_2400_ssd_drives					
						then
							volumesetup='# concentrator volume is 6 drives in RAID 5 mode
							"$COMMAND_TOOL" -cfgldadd -R5[$ENCID:0,$ENCID:1,$ENCID:2,$ENCID:3,$ENCID:4,$ENCID:5] $NEW_LD_OPTIONS -a$ADAPTER
							# index is 5 drives in RAID 5
							"$COMMAND_TOOL" -cfgldadd -R5[$ENCID:6,$ENCID:7,$ENCID:8,$ENCID:9,$ENCID:10] $NEW_LD_OPTIONS -a$ADAPTER
							# hot spare for mechanical drives
							"$COMMAND_TOOL" -pdhsp -set -Dedicated -Array0 -PhysDrv [$ENCID:11] -a$ADAPTER
							# add mirrored system partition
							"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:12,$ENCID:13] $NEW_LD_OPTIONS -a$ADAPTER
							# make drive bootable
							"$COMMAND_TOOL" -AdpBootDrive -Set -L2 -a$ADAPTER'
						elif check_1200_ssd_drives
						then
							volumesetup='# concentrator volume is 8 drives in RAID 5 mode
							"$COMMAND_TOOL" -cfgldadd -R5[$ENCID:0,$ENCID:1,$ENCID:2,$ENCID:3,$ENCID:4,$ENCID:5,$ENCID:6,$ENCID:7] $NEW_LD_OPTIONS -a$ADAPTER
							# index is 3 drives in RAID 5
							"$COMMAND_TOOL" -cfgldadd -R5[$ENCID:8,$ENCID:9,$ENCID:10] $NEW_LD_OPTIONS -a$ADAPTER
							# hot spare for mechanical drives
							"$COMMAND_TOOL" -pdhsp -set -Dedicated -Array0 -PhysDrv [$ENCID:11] -a$ADAPTER
							# add mirrored system partition
							"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:12,$ENCID:13] $NEW_LD_OPTIONS -a$ADAPTER
							# make drive bootable
							"$COMMAND_TOOL" -AdpBootDrive -Set -L2 -a$ADAPTER'
						fi
						writeRaidScript "$volumesetup" msdos
						echo -e 'make_device_map_dell_2400\nvolumeGroupScan\ndoPost\ncheck_post_package' >> /tmp/nwpost.txt
					;;
					# series 4 dell concentrator
					dell-s4-1u )
						echo -e '@rsa-sa-ipmi-tools\n@rsa-sa-lsi-megacli\n@rsa-sa-san-tools' >> /tmp/nwpack.txt
						hwraid=True
						drivetest=check_nwx_drives
						drivetest2=check_nwx_raid
						volumesetup='# system volume is 2 drives in RAID 1 mode
						"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:0,$ENCID:1] $NEW_LD_OPTIONS -a$ADAPTER
						# application volume is 2 drives in RAID 1 mode
						"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:2,$ENCID:3] $NEW_LD_OPTIONS -a$ADAPTER     
						# make drive bootable
						"$COMMAND_TOOL" -AdpBootDrive -Set -L0 -a$ADAPTER'
						writeRaidScript "$volumesetup" msdos
						echo -e 'make_device_map_dell_200\nvolumeGroupScan\ndoPost\ncheck_post_package' >> /tmp/nwpost.txt
					;;
					# series 4s dell concentrator
					dell-s4s-1u )
						echo -e '@rsa-sa-ipmi-tools\n@rsa-sa-lsi-megacli\n@rsa-sa-san-tools' >> /tmp/nwpack.txt
						hwraid=True
						#drivetest="check_nwx_drives 147 1000"
						drivetest="check_enc_drive_sizes 147 147 1000 1000"
						drivetest2=check_nwx_raid
						volumesetup='# system volume is 2 drives in RAID 1 mode
						"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:0,$ENCID:1] $NEW_LD_OPTIONS -a$ADAPTER
						# application volume is 2 drives in RAID 1 mode
						"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:2,$ENCID:3] $NEW_LD_OPTIONS -a$ADAPTER     
						# make drive bootable
						"$COMMAND_TOOL" -AdpBootDrive -Set -L0 -a$ADAPTER'
						writeRaidScript "$volumesetup" msdos
						echo -e 'make_device_map_sda\nvolumeGroupScan\ndoPost\ncheck_post_package' >> /tmp/nwpost.txt
					;;			
					# series 9 dell concentrator
					dell-s9-1u )
						echo -e '@rsa-sa-ipmi-tools\n@rsa-sa-lsi-megacli\n@rsa-sa-san-tools' >> /tmp/nwpack.txt
						hwraid=True
						#drivetest="check_nwx_drives 1000GB 2TB"
						drivetest="check_enc_drive_sizes 1000 1000 2000 2000"
						drivetest2=check_nwx_raid
						volumesetup='# system volume is 2 drives in RAID 1 mode
						"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:0,$ENCID:1] $NEW_LD_OPTIONS -a$ADAPTER
						# application volume is 2 drives in RAID 1 mode
						"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:2,$ENCID:3] $NEW_LD_OPTIONS -a$ADAPTER     
						# make drive bootable
						"$COMMAND_TOOL" -AdpBootDrive -Set -L0 -a$ADAPTER'
						writeRaidScript "$volumesetup" msdos
						echo -e 'make_device_map_dell_200\nvolumeGroupScan\ndoPost\ncheck_post_package' >> /tmp/nwpost.txt
					;;
					# un-qualified hardware
					* )
						invalid_hw
					;;
				esac
				echo '%end' >> /tmp/nwpack.txt
		;;
		decoder )
				case $nwsystem in
					# 100 series decoder
					sm-s2-1u )
						drivetest=check_100_sm_decoder_drives
						echo -e 'make_device_map_sda\nvolumeGroupScan\ndoPost' >> /tmp/nwpost.txt
					;;
					# 1200/2400/1200n/2400n series mckay creek and sm decoders
					sm-s2-2u | sm-s3-2u | mckaycreek )
						echo -e '@rsa-sa-ipmi-tools\n@rsa-sa-lsi-megacli' >> /tmp/nwpack.txt
						hwraid=True
						drivetest=check_1200_decoder_raid
						volumesetup='"$COMMAND_TOOL" -pdhsp -set -EnclAffinity -PhysDrv [$ENCID:11] -a$ADAPTER
						# decoder volume is 8 drives in RAID 5 mode
						"$COMMAND_TOOL" -cfgldadd -R5[$ENCID:3,$ENCID:4,$ENCID:5,$ENCID:6,$ENCID:7,$ENCID:8,$ENCID:9,$ENCID:10] $NEW_LD_OPTIONS -a$ADAPTER
						# decodersmall volume is 3 drives in RAID 5 mode
						"$COMMAND_TOOL" -cfgldadd -R5[$ENCID:0,$ENCID:1,$ENCID:2] $NEW_LD_OPTIONS -a$ADAPTER'
						writeRaidScript "$volumesetup" msdos
						if [[ `echo $nwsystem | grep 'mckaycreek'` ]]; then
							echo -e 'make_device_map_sdd\nvolumeGroupScan' >> /tmp/nwpost.txt
						else
							echo -e 'make_device_map_sdc\nvolumeGroupScan' >> /tmp/nwpost.txt
						fi 
						echo 'doPost' >> /tmp/nwpost.txt
					;;
					# 1200/2400 series dell decoder
					dell-s3-2u )
						echo -e '@rsa-sa-ipmi-tools\n@rsa-sa-lsi-megacli' >> /tmp/nwpack.txt
						hwraid=True
						drivetest=check_2400_dell_decoder_raid
						volumesetup='"$COMMAND_TOOL" -pdhsp -set -EnclAffinity -PhysDrv [$ENCID:11] -a$ADAPTER
						# decoder volume is 8 drives in RAID 5 mode
						"$COMMAND_TOOL" -cfgldadd -R5[$ENCID:3,$ENCID:4,$ENCID:5,$ENCID:6,$ENCID:7,$ENCID:8,$ENCID:9,$ENCID:10] $NEW_LD_OPTIONS -a$ADAPTER
						# decodersmall volume is 3 drives in RAID 5 mode
						"$COMMAND_TOOL" -cfgldadd -R5[$ENCID:0,$ENCID:1,$ENCID:2] $NEW_LD_OPTIONS -a$ADAPTER 
						# add mirrored system partition
						"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:12,$ENCID:13] $NEW_LD_OPTIONS -a$ADAPTER 
						# make drive bootable
						"$COMMAND_TOOL" -AdpBootDrive -Set -L2 -a$ADAPTER'
						writeRaidScript "$volumesetup" msdos
						echo -e 'make_device_map_dell_2400\nvolumeGroupScan\ndoPost' >> /tmp/nwpost.txt
					;;
					# series 4 dell decoder
					dell-s4-1u )
						echo -e '@rsa-sa-ipmi-tools\n@rsa-sa-lsi-megacli\n@rsa-sa-san-tools' >> /tmp/nwpack.txt
						hwraid=True
						drivetest=check_nwx_drives
						drivetest2=check_nwx_raid
						volumesetup='# system volume is 2 drives in RAID 1 mode
						"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:0,$ENCID:1] $NEW_LD_OPTIONS -a$ADAPTER
						# application volume is 2 drives in RAID 1 mode
						"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:2,$ENCID:3] $NEW_LD_OPTIONS -a$ADAPTER     
						# make drive bootable
						"$COMMAND_TOOL" -AdpBootDrive -Set -L0 -a$ADAPTER'
						writeRaidScript "$volumesetup" msdos
						echo -e 'make_device_map_dell_200\nvolumeGroupScan\ndoPost' >> /tmp/nwpost.txt
					;;
					# series 4s dell decoder
					dell-s4s-1u )
						echo -e '@rsa-sa-ipmi-tools\n@rsa-sa-lsi-megacli\n@rsa-sa-san-tools' >> /tmp/nwpack.txt
						hwraid=True
						#drivetest="check_nwx_drives 147 1000"
						drivetest="check_enc_drive_sizes 147 147 1000 1000"
						drivetest2=check_nwx_raid
						volumesetup='# system volume is 2 drives in RAID 1 mode
						"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:0,$ENCID:1] $NEW_LD_OPTIONS -a$ADAPTER
						# application volume is 2 drives in RAID 1 mode
						"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:2,$ENCID:3] $NEW_LD_OPTIONS -a$ADAPTER     
						# make drive bootable
						"$COMMAND_TOOL" -AdpBootDrive -Set -L0 -a$ADAPTER'
						writeRaidScript "$volumesetup" msdos
						echo -e 'make_device_map_dell_2400\nvolumeGroupScan\ndoPost\nsetupwarec\nconfigure_colowarec' >> /tmp/nwpost.txt 
					;;	
					# series 9 dell decoder
					dell-s9-1u )
						echo -e '@rsa-sa-ipmi-tools\n@rsa-sa-lsi-megacli\n@rsa-sa-san-tools' >> /tmp/nwpack.txt
						hwraid=True
						#drivetest="check_nwx_drives 1000GB 2TB"
						drivetest="check_enc_drive_sizes 1000 1000 2000 2000"
						drivetest2=check_nwx_raid
						volumesetup='# system volume is 2 drives in RAID 1 mode
						"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:0,$ENCID:1] $NEW_LD_OPTIONS -a$ADAPTER
						# application volume is 2 drives in RAID 1 mode
						"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:2,$ENCID:3] $NEW_LD_OPTIONS -a$ADAPTER     
						# make drive bootable
						"$COMMAND_TOOL" -AdpBootDrive -Set -L0 -a$ADAPTER'
						writeRaidScript "$volumesetup" msdos
						echo -e 'make_device_map_dell_2400\nvolumeGroupScan\ndoPost\nsetupwarec\nconfigure_colowarec' >> /tmp/nwpost.txt 
					;;
					# un-qualified hardware
					* )
						invalid_hw
					;;
				esac
				echo '%end' >> /tmp/nwpack.txt
		;;
		packethybrid )
			echo -e '@rsa-sa-ipmi-tools\n@rsa-sa-lsi-megacli' >> /tmp/nwpack.txt
			case $nwsystem in
				# 1200 mckay creek and sm packet hybrid
				sm-s2-2u | mckaycreek )
					hwraid=True
					drivetest=check_1200_hybrid_raid
					volumesetup='"$COMMAND_TOOL" -pdhsp -set -EnclAffinity -PhysDrv [$ENCID:11] -a$ADAPTER
					# concentrator volume is 4 drives in RAID 5 mode
					"$COMMAND_TOOL" -cfgldadd -R5[$ENCID:0,$ENCID:1,$ENCID:2,$ENCID:3] $NEW_LD_OPTIONS -a$ADAPTER
					# decoder volume is 7 drives in RAID 5 mode
					"$COMMAND_TOOL" -cfgldadd -R5[$ENCID:4,$ENCID:5,$ENCID:6,$ENCID:7,$ENCID:8,$ENCID:9,$ENCID:10] $NEW_LD_OPTIONS -a$ADAPTER'
					writeRaidScript "$volumesetup" msdos
					if [[ `echo $nwsystem | grep 'mckaycreek'` ]]; then
						echo -e 'make_device_map_sdd\nvolumeGroupScan' >> /tmp/nwpost.txt
					else
						echo -e 'make_device_map_sda\nvolumeGroupScan' >> /tmp/nwpost.txt
					fi
					echo 'doPost\ncheck_post_package' >> /tmp/nwpost.txt
				;;
				# series 200 sm packet hybrid
				sm-s3-1u )
					hwraid=True
					drivetest=check_200_smhybrid_raid
					volumesetup='# system mirrors, concentrator and decoder volumes will be SW RAID0
					"$COMMAND_TOOL" -cfgldadd -R0[$ENCID:0] $NEW_LD_OPTIONS -a$ADAPTER
					"$COMMAND_TOOL" -cfgldadd -R0[$ENCID:1] $NEW_LD_OPTIONS -a$ADAPTER
					"$COMMAND_TOOL" -cfgldadd -R0[$ENCID:2] $NEW_LD_OPTIONS -a$ADAPTER
					"$COMMAND_TOOL" -cfgldadd -R0[$ENCID:3] $NEW_LD_OPTIONS -a$ADAPTER
					# make drive bootable
					"$COMMAND_TOOL" -AdpBootDrive -Set -L0 -a$ADAPTER'
					writeRaidScript "$volumesetup" msdos
					echo -e 'make_device_map_sda\nvolumeGroupScan\ndoPost\ncheck_post_package' >> /tmp/nwpost.txt
				;;
				# series 200 dell packet hybrid
				dell-s3-2u )
					hwraid=True
					drivetest=check_200_ssd_drive
					drivetest2=check_200_dellhybrid_raid
					volumesetup='# system mirrors, concentrator and decoder volumes will be SW RAID0
					"$COMMAND_TOOL" -cfgldadd -R0[$ENCID:0] $NEW_LD_OPTIONS -a$ADAPTER
					"$COMMAND_TOOL" -cfgldadd -R0[$ENCID:1] $NEW_LD_OPTIONS -a$ADAPTER
					"$COMMAND_TOOL" -cfgldadd -R0[$ENCID:2] $NEW_LD_OPTIONS -a$ADAPTER
					"$COMMAND_TOOL" -cfgldadd -R0[$ENCID:3] $NEW_LD_OPTIONS -a$ADAPTER 
					"$COMMAND_TOOL" -cfgldadd -R0[$ENCID:4] $NEW_LD_OPTIONS -a$ADAPTER 
					# make drive bootable
			                "$COMMAND_TOOL" -AdpBootDrive -Set -L0 -a$ADAPTER'
					writeRaidScript "$volumesetup" msdos
					echo -e 'make_device_map_sda\nvolumeGroupScan\ndoPost\ncheck_post_package' >> /tmp/nwpost.txt
				;;
				# series 4s packet hybrid
				dell-s4s-1u )
					echo '@rsa-sa-san-tools' >> /tmp/nwpack.txt
					hwraid=True
					drivetest=check_hbdeco_raid
					volumesetup='# decoder volume is 6 drives in RAID5 mode
					"$COMMAND_TOOL" -cfgldadd -R5[$ENCID:0,$ENCID:1,$ENCID:2,$ENCID:3,$ENCID:4,$ENCID:5] $NEW_LD_OPTIONS -a$ADAPTER
					# concentrator volume is 3 drives in RAID5 mode
					"$COMMAND_TOOL" -cfgldadd -R5[$ENCID:6,$ENCID:7,$ENCID:8] $NEW_LD_OPTIONS -a$ADAPTER
					# concentrator index volume is 1 drive in RAID0 mode
					"$COMMAND_TOOL" -cfgldadd -R0[$ENCID:9] $NEW_LD_OPTIONS -a$ADAPTER'
					writeRaidScript "$volumesetup" msdos
					echo -e 'make_device_map_dell_2400\nvolumeGroupScan\ndoPost\nsetupwarec\nconfigure_colowarec\ncheck_post_package' > /tmp/nwpost.txt
				;;
				# series 5 packet hybrid
				dell-s5-2u )
					echo '@rsa-sa-san-tools' >> /tmp/nwpack.txt
					hwraid=True
					drivetest=check_s5_hybrid_raid
					volumesetup='# os volume is 2 drives in RAID1
					"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:0,$ENCID:1] $NEW_LD_OPTIONS -a$ADAPTER
					# decoder meta volume is 2 drives in RAID1 mode
					"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:2,$ENCID:3] $NEW_LD_OPTIONS -a$ADAPTER
					# decoder volume is 4 drives in RAID5 mode
					"$COMMAND_TOOL" -cfgldadd -R5[$ENCID:4,$ENCID:5,$ENCID:6,$ENCID:7] $NEW_LD_OPTIONS -a$ADAPTER
					# concentrator volume is 3 drives in RAID5 mode
					"$COMMAND_TOOL" -cfgldadd -R5[$ENCID:8,$ENCID:9,$ENCID:10] $NEW_LD_OPTIONS -a$ADAPTER
					# concentrator index volume is 2 drives in RAID1 mode
					"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:12,$ENCID:13] $NEW_LD_OPTIONS -a$ADAPTER
					# dedicated hot spare for logdecoder and concentrator volumes
					"$COMMAND_TOOL" -PDHSP -Set -Dedicated -Array2,3 -PhysDrv[$ENCID:11] -a$ADAPTER'
					writeRaidScript "$volumesetup" msdos
					echo -e 'make_device_map_dell_2400\nvolumeGroupScan\ndoPost\nsetupwarec\nconfigure_colowarec\ncheck_post_package' > /tmp/nwpost.txt
				;;
				# un-qualified hardware
				* )
					invalid_hw
				;;
			esac
			echo '%end' >> /tmp/nwpack.txt
		;; 
		spectrumbroker )
			echo -e '@rsa-sa-ipmi-tools\n@rsa-sa-lsi-megacli' >> /tmp/nwpack.txt
			case $nwsystem in 
				# series 200 dell and sm spectrum enterprise 
				sm-s3-1u | dell-s3-1u )
					hwraid=True
					drivetest=check_200_mp_raid
					volumesetup='# HW RAID5 boot and system/application logical drives 
					"$COMMAND_TOOL" -cfgldadd -R5[$ENCID:0,$ENCID:1,$ENCID:2,$ENCID:3] $NEW_LD_OPTIONS_1 -a$ADAPTER
					"$COMMAND_TOOL" -cfgldadd -R5[$ENCID:0,$ENCID:1,$ENCID:2,$ENCID:3] $NEW_LD_OPTIONS_2 -a$ADAPTER 
					# make drive bootable
					"$COMMAND_TOOL" -AdpBootDrive -Set -L0 -a$ADAPTER'
					writeRaidScript "$volumesetup" gpt
					echo -e 'make_device_map_sda\nconfig_spectrum\nsetSpectrumTunables\nspecFileService\nvolumeGroupScan\ndoPost\ncheck_post_package' >> /tmp/nwpost.txt
				;;
				# series 2400n sm spectrum enterprise
				sm-s3-2u )
					hwraid=True
					drivetest=check_1200_decoder_raid
					volumesetup='"$COMMAND_TOOL" -pdhsp -set -EnclAffinity -PhysDrv [$ENCID:11] -a$ADAPTER
					# spectrum volume is 8 drives in RAID 5 mode
					"$COMMAND_TOOL" -cfgldadd -R5[$ENCID:3,$ENCID:4,$ENCID:5,$ENCID:6,$ENCID:7,$ENCID:8,$ENCID:9,$ENCID:10] $NEW_LD_OPTIONS -a$ADAPTER
					# decoder volume is 3 drives in RAID 5 mode
					"$COMMAND_TOOL" -cfgldadd -R5[$ENCID:0,$ENCID:1,$ENCID:2] $NEW_LD_OPTIONS -a$ADAPTER'
					writeRaidScript "$volumesetup" msdos
					echo -e 'make_device_map_sdc\nconfig_spectrum\nsetSpectrumTunables\nspecFileService\nvolumeGroupScan\ndoPost\ncheck_post_package' >> /tmp/nwpost.txt
				;;
				# series 2400 dell spectrum enterprise
				dell-s3-2u )
					hwraid=True
					drivetest=check_2400_dell_decoder_raid
					volumesetup='"$COMMAND_TOOL" -pdhsp -set -EnclAffinity -PhysDrv [$ENCID:11] -a$ADAPTER
					# spectrum volume is 8 drives in RAID 5 mode
					"$COMMAND_TOOL" -cfgldadd -R5[$ENCID:3,$ENCID:4,$ENCID:5,$ENCID:6,$ENCID:7,$ENCID:8,$ENCID:9,$ENCID:10] $NEW_LD_OPTIONS -a$ADAPTER
					# broker volume is 3 drives in RAID 5 mode
					"$COMMAND_TOOL" -cfgldadd -R5[$ENCID:0,$ENCID:1,$ENCID:2] $NEW_LD_OPTIONS -a$ADAPTER
					# add mirrored system partition
					"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:12,$ENCID:13] $NEW_LD_OPTIONS -a$ADAPTER   
					# make drive bootable
					"$COMMAND_TOOL" -AdpBootDrive -Set -L2 -a$ADAPTER'
					writeRaidScript "$volumesetup" msdos
					echo -e 'make_device_map_dell_2400\nconfig_spectrum\nsetSpectrumTunables\nspecFileService\nvolumeGroupScan\ndoPost\ncheck_post_package' >> /tmp/nwpost.txt
				;;
				# series 4s spectrum enterprise
				dell-s4s-1u )
					echo '@rsa-sa-san-tools' >> /tmp/nwpack.txt
					hwraid=True
					drivetest=check_mpbrok_raid
					volumesetup='# broker volume is 3 drives in RAID5 mode
					"$COMMAND_TOOL" -cfgldadd -R5[$ENCID:0,$ENCID:1,$ENCID:2] $NEW_LD_OPTIONS -a$ADAPTER
					# application volume is 6 drives in RAID5 mode
					"$COMMAND_TOOL" -cfgldadd -R5[$ENCID:3,$ENCID:4,$ENCID:5,$ENCID:6,$ENCID:7,$ENCID:8] $NEW_LD_OPTIONS -a$ADAPTER 
					"$COMMAND_TOOL" -pdhsp -set -EnclAffinity -PhysDrv [$ENCID:09] -a$ADAPTER'
					writeRaidScript "$volumesetup" msdos
					echo -e 'make_device_map_dell_2400\nconfig_spectrum\nsetSpectrumTunables\nspecFileService\nvolumeGroupScan\ndoPost\ncheck_post_package' >> /tmp/nwpost.txt 
				;;
				# series 9 spectrum enterprise 
				dell-s9-1u )
					echo '@rsa-sa-san-tools' >> /tmp/nwpack.txt
					hwraid=True
					#drivetest="check_nwx_drives 1000GB 2TB"
					drivetest="check_enc_drive_sizes 1000 1000 2000 2000"
					drivetest2=check_nwx_raid
					volumesetup='# system volume is 2 drives in RAID 1 mode
					"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:0,$ENCID:1] $NEW_LD_OPTIONS -a$ADAPTER
					# application volume is 2 drives in RAID 1 mode
					"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:2,$ENCID:3] $NEW_LD_OPTIONS -a$ADAPTER     
					# make drive bootable
					"$COMMAND_TOOL" -AdpBootDrive -Set -L0 -a$ADAPTER'
					writeRaidScript "$volumesetup" msdos
					echo -e 'make_device_map_dell_2400\nconfig_spectrum\nsetSpectrumTunables\nspecFileService\nvolumeGroupScan\ndoPost\ncheck_post_package' >> /tmp/nwpost.txt
				;;
				# un-qualified hardware
				* )
					invalid_hw
				;;
			esac
			echo '%end' >> /tmp/nwpack.txt
		;;
		logdecoder )
			echo -e '@rsa-sa-ipmi-tools\n@rsa-sa-lsi-megacli\n@rsa-sa-san-tools' >> /tmp/nwpack.txt
			case $nwsystem in
				# series 4 dell log collector/decoder
				dell-s4-1u )
					hwraid=True
					drivetest=check_nwx_drives
					drivetest2=check_nwx_raid
					volumesetup='# system volume is 2 drives in RAID 1 mode
					"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:0,$ENCID:1] $NEW_LD_OPTIONS -a$ADAPTER
					# application volume is 2 drives in RAID 1 mode
					"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:2,$ENCID:3] $NEW_LD_OPTIONS -a$ADAPTER     
					# make drive bootable
					"$COMMAND_TOOL" -AdpBootDrive -Set -L0 -a$ADAPTER'
					writeRaidScript "$volumesetup" msdos
					echo -e 'make_device_map_dell_200\nvolumeGroupScan\nsetuplogcoll\ndoPost\ncheck_post_package' >> /tmp/nwpost.txt
				;;
				# series 4s dell log collector/decoder
				dell-s4s-1u )
					hwraid=True
					#drivetest="check_nwx_drives 147 1000"
					drivetest="check_enc_drive_sizes 147 147 1000 1000"
					drivetest2=check_nwx_raid
					volumesetup='# system volume is 2 drives in RAID 1 mode
					"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:0,$ENCID:1] $NEW_LD_OPTIONS -a$ADAPTER
					# application volume is 2 drives in RAID 1 mode
					"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:2,$ENCID:3] $NEW_LD_OPTIONS -a$ADAPTER     
					# make drive bootable
					"$COMMAND_TOOL" -AdpBootDrive -Set -L0 -a$ADAPTER'
					writeRaidScript "$volumesetup" msdos
					echo -e 'make_device_map_dell_2400\nvolumeGroupScan\nsetuplogcoll\ndoPost\nsetupwarec\nconfigure_colowarec\ncheck_post_package' >> /tmp/nwpost.txt 
				;;	
				# series 9 dell log collector/decoder
				dell-s9-1u )
					hwraid=True
					#drivetest="check_nwx_drives 1000GB 2TB"
					drivetest="check_enc_drive_sizes 1000 1000 2000 2000"
					drivetest2=check_nwx_raid
					volumesetup='# system volume is 2 drives in RAID 1 mode
					"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:0,$ENCID:1] $NEW_LD_OPTIONS -a$ADAPTER
					# application volume is 2 drives in RAID 1 mode
					"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:2,$ENCID:3] $NEW_LD_OPTIONS -a$ADAPTER     
					# make drive bootable
					"$COMMAND_TOOL" -AdpBootDrive -Set -L0 -a$ADAPTER'
					writeRaidScript "$volumesetup" msdos
					echo -e 'make_device_map_dell_2400\nvolumeGroupScan\nsetuplogcoll\ndoPost\nsetupwarec\nconfigure_colowarec\ncheck_post_package' >> /tmp/nwpost.txt 
				;;
				# un-qualified hardware
				* )
					invalid_hw
				;;
			esac
			echo '%end' >> /tmp/nwpack.txt
		;;
		logcollector )
			echo -e '@rsa-sa-ipmi-tools\n@rsa-sa-lsi-megacli' >> /tmp/nwpack.txt
			case $nwsystem in
				# series 4 dell logcollector, R710
				dell-s4-2u )
					hwraid=True
					drivetest=check_R710LC_raid
					volumesetup='# system/application volume is 2 drives in RAID 1 mode
					"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:0,$ENCID:1] $NEW_LD_OPTIONS -a$ADAPTER
					# make drive bootable
					"$COMMAND_TOOL" -AdpBootDrive -Set -L0 -a$ADAPTER'
					writeRaidScript "$volumesetup" msdos
					echo -e 'make_device_map_sda\nvolumeGroupScan\nsetuplogcoll\ndoPost\ncheck_post_package' >> /tmp/nwpost.txt
				;;
				# un-qualified hardware
				* )
					invalid_hw
				;;
			esac
			echo '%end' >> /tmp/nwpack.txt
		;;
		loghybrid )
			echo -e '@rsa-sa-ipmi-tools\n@rsa-sa-lsi-megacli\n@rsa-sa-san-tools' >> /tmp/nwpack.txt
			case $nwsystem in
				# series 4s logs hybrid
				dell-s4s-1u )
					hwraid=True
					drivetest=check_hbldec_raid
					volumesetup='# decoder volume is 5 drives in RAID5 mode
					"$COMMAND_TOOL" -cfgldadd -R5[$ENCID:0,$ENCID:1,$ENCID:2,$ENCID:3,$ENCID:4] $NEW_LD_OPTIONS -a$ADAPTER
					# concentrator volume is 4 drives in RAID5 mode
					"$COMMAND_TOOL" -cfgldadd -R5[$ENCID:5,$ENCID:6,$ENCID:7,$ENCID:8] $NEW_LD_OPTIONS -a$ADAPTER
					# concentrator index volume is 1 drive in RAID0 mode
					"$COMMAND_TOOL" -cfgldadd -R0[$ENCID:9] $NEW_LD_OPTIONS -a$ADAPTER'
					writeRaidScript "$volumesetup" msdos
					echo -e 'make_device_map_dell_2400\nvolumeGroupScan\nsetuplogcoll\ndoPost\nsetupwarec\nconfigure_colowarec\ncheck_post_package' >> /tmp/nwpost.txt
				;;
 				# series 5 log hybrid
				dell-s5-2u )
					hwraid=True
					drivetest="check_s5_hybrid_raid log"
					volumesetup='# os volume is 2 drives in RAID1
					"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:0,$ENCID:1] $NEW_LD_OPTIONS -a$ADAPTER
					# logdecoder meta volume is 2 drives in RAID1 mode
					"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:2,$ENCID:3] $NEW_LD_OPTIONS -a$ADAPTER
					# logdecoder volume is 4 drives in RAID5 mode
					"$COMMAND_TOOL" -cfgldadd -R5[$ENCID:4,$ENCID:5,$ENCID:6,$ENCID:7] $NEW_LD_OPTIONS -a$ADAPTER
					# concentrator volume is 4 drives in RAID5 mode
					"$COMMAND_TOOL" -cfgldadd -R5[$ENCID:8,$ENCID:9,$ENCID:10,$ENCID:11] $NEW_LD_OPTIONS -a$ADAPTER
					# concentrator index volume is 2 drives in RAID1 mode
					"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:12,$ENCID:13] $NEW_LD_OPTIONS -a$ADAPTER'
					writeRaidScript "$volumesetup" msdos
					echo -e 'make_device_map_dell_2400\nvolumeGroupScan\nsetuplogcoll\ndoPost\nsetupwarec\nconfigure_colowarec\ncheck_post_package' > /tmp/nwpost.txt
				;;
				# un-qualified hardware
				* )
					invalid_hw
				;;
			esac
			echo '%end' >> /tmp/nwpack.txt
		;; 
		logaio )
			echo -e '@rsa-sa-ipmi-tools\n@rsa-sa-lsi-megacli\n@rsa-sa-san-tools' >> /tmp/nwpack.txt
			case $nwsystem in
				# series 4s logs hybrid
				dell-s4s-1u )
					hwraid=True
					drivetest=check_hbldec_raid
					volumesetup='# decoder volume is 5 drives in RAID5 mode
					"$COMMAND_TOOL" -cfgldadd -R5[$ENCID:0,$ENCID:1,$ENCID:2,$ENCID:3,$ENCID:4] $NEW_LD_OPTIONS -a$ADAPTER
					# concentrator volume is 4 drives in RAID5 mode
					"$COMMAND_TOOL" -cfgldadd -R5[$ENCID:5,$ENCID:6,$ENCID:7,$ENCID:8] $NEW_LD_OPTIONS -a$ADAPTER
					# concentrator index volume is 1 drive in RAID0 mode
					"$COMMAND_TOOL" -cfgldadd -R0[$ENCID:9] $NEW_LD_OPTIONS -a$ADAPTER'
					writeRaidScript "$volumesetup" msdos
					echo -e 'make_device_map_dell_2400\nvolumeGroupScan\nsetuplogcoll\nconfig_uax colo\nsetSpectrumTunables\nspecFileService colo\ndoPost\nconfig_postgres_re\nconfig_ipdbextractor\ncheck_post_package' >> /tmp/nwpost.txt
				;;
				# un-qualified hardware
				* )
					invalid_hw
				;;
			esac
			echo '%end' >> /tmp/nwpack.txt
		;;
		packetaio )
			echo -e '@rsa-sa-ipmi-tools\n@rsa-sa-lsi-megacli\n@rsa-sa-san-tools' >> /tmp/nwpack.txt
			case $nwsystem in
				# series 4s logs hybrid
				dell-s4s-1u )
					hwraid=True
					drivetest=check_hbdeco_raid
					volumesetup='# decoder volume is 6 drives in RAID5 mode
					"$COMMAND_TOOL" -cfgldadd -R5[$ENCID:0,$ENCID:1,$ENCID:2,$ENCID:3,$ENCID:4,$ENCID:5] $NEW_LD_OPTIONS -a$ADAPTER
					# concentrator volume is 3 drives in RAID5 mode
					"$COMMAND_TOOL" -cfgldadd -R5[$ENCID:6,$ENCID:7,$ENCID:8] $NEW_LD_OPTIONS -a$ADAPTER
					# concentrator index volume is 1 drive in RAID0 mode
					"$COMMAND_TOOL" -cfgldadd -R0[$ENCID:9] $NEW_LD_OPTIONS -a$ADAPTER'
					writeRaidScript "$volumesetup" msdos
					echo -e 'make_device_map_dell_2400\nvolumeGroupScan\nconfig_uax colo\nsetSpectrumTunables\nspecFileService colo\ndoPost\nconfig_postgres_re\nconfig_ipdbextractor\ncheck_post_package' >> /tmp/nwpost.txt
				;;
				# un-qualified hardware
				* )
					invalid_hw
				;;
			esac
			echo '%end' >> /tmp/nwpack.txt
		;;
		maprwh )
			echo -e 'java-1.8.0-openjdk-devel\nsamba-common\nsamba-winbind-clients\nsamba-winbind\nsamba\n@rsa-sa-ipmi-tools\n@rsa-sa-lsi-megacli\n@rsa-sa-san-tools' >> /tmp/nwpack.txt
			case $nwsystem in
				# series 4s SAW 
				dell-s4s-1u )
					hwraid=True
					drivetest=check_hadoop_raid
					volumesetup='# hadoop cluster is 10 drives in RAID0 mode
					"$COMMAND_TOOL" -cfgldadd -R0[$ENCID:0] $NEW_LD_OPTIONS -a$ADAPTER
					"$COMMAND_TOOL" -cfgldadd -R0[$ENCID:1] $NEW_LD_OPTIONS -a$ADAPTER
					"$COMMAND_TOOL" -cfgldadd -R0[$ENCID:2] $NEW_LD_OPTIONS -a$ADAPTER
					"$COMMAND_TOOL" -cfgldadd -R0[$ENCID:3] $NEW_LD_OPTIONS -a$ADAPTER
					"$COMMAND_TOOL" -cfgldadd -R0[$ENCID:4] $NEW_LD_OPTIONS -a$ADAPTER
					"$COMMAND_TOOL" -cfgldadd -R0[$ENCID:5] $NEW_LD_OPTIONS -a$ADAPTER
					"$COMMAND_TOOL" -cfgldadd -R0[$ENCID:6] $NEW_LD_OPTIONS -a$ADAPTER
					"$COMMAND_TOOL" -cfgldadd -R0[$ENCID:7] $NEW_LD_OPTIONS -a$ADAPTER
					"$COMMAND_TOOL" -cfgldadd -R0[$ENCID:8] $NEW_LD_OPTIONS -a$ADAPTER
					"$COMMAND_TOOL" -cfgldadd -R0[$ENCID:9] $NEW_LD_OPTIONS -a$ADAPTER'
					writeRaidScript "$volumesetup" msdos
					echo -e 'make_device_map_dell_2400\nvolumeGroupScan\ndoPost\nconfig_maprwh\ncheck_post_package' >> /tmp/nwpost.txt 
				;; 
				# un-qualified hardware
				* )
					invalid_hw
				;;
			esac
			echo '%end' >> /tmp/nwpack.txt
		;;
		ipdbextractor )
			echo -e '@rsa-sa-ipmi-tools\n@rsa-sa-lsi-megacli' >> /tmp/nwpack.txt
			case $nwsystem in
				# series 4 dell ipdbextractor, R710
				dell-s4-2u )
					hwraid=True
					drivetest=check_R710LC_raid
					volumesetup='# system/application volume is 2 drives in RAID 1 mode
					"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:0,$ENCID:1] $NEW_LD_OPTIONS -a$ADAPTER
					# make drive bootable
					"$COMMAND_TOOL" -AdpBootDrive -Set -L0 -a$ADAPTER'
					writeRaidScript "$volumesetup" msdos
					echo -e 'make_device_map_sda\nvolumeGroupScan\ndoPost\nconfig_ipdbextractor' >> /tmp/nwpost.txt
				;;
				# un-qualified hardware
				* )
					invalid_hw
				;;
			esac
			echo '%end' >> /tmp/nwpack.txt
		;;
		sabroker )
			echo -e '@rsa-sa-ipmi-tools\n@rsa-sa-lsi-megacli\n@rsa-sa-san-tools' >> /tmp/nwpack.txt
			# series 4 sabroker, dell R610
			case $nwsystem in
				dell-s4-1u )
					hwraid=True
					drivetest=check_nwx_drives
					drivetest2=check_nwx_raid
					volumesetup='# system volume is 2 drives in RAID 1 mode
					"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:0,$ENCID:1] $NEW_LD_OPTIONS -a$ADAPTER
					# application volume is 2 drives in RAID 1 mode
					"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:2,$ENCID:3] $NEW_LD_OPTIONS -a$ADAPTER     
					# make drive bootable
					"$COMMAND_TOOL" -AdpBootDrive -Set -L0 -a$ADAPTER'
					writeRaidScript "$volumesetup" msdos
					echo -e 'make_device_map_dell_2400\nvolumeGroupScan\nsetSpectrumTunables\nspecFileService colo\ndoPost\nconfig_postgres_re\nconfig_ipdbextractor\nconfig_uax colo\ncheck_post_package' >> /tmp/nwpost.txt 
				;;
				# series 4s sabroker, dell R620
				dell-s4s-1u )
					hwraid=True
					#drivetest="check_nwx_drives 147 1000"
					drivetest="check_enc_drive_sizes 147 147 1000 1000"
					drivetest2=check_nwx_raid
					volumesetup='# system volume is 2 drives in RAID 1 mode
					"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:0,$ENCID:1] $NEW_LD_OPTIONS -a$ADAPTER
					# application volume is 2 drives in RAID 1 mode
					"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:2,$ENCID:3] $NEW_LD_OPTIONS -a$ADAPTER     
					# make drive bootable
					"$COMMAND_TOOL" -AdpBootDrive -Set -L0 -a$ADAPTER'
					writeRaidScript "$volumesetup" msdos 
					echo -e 'make_device_map_dell_2400\nvolumeGroupScan\nsetSpectrumTunables\nspecFileService colo\ndoPost\nconfig_postgres_re\nconfig_ipdbextractor\nconfig_uax colo\ncheck_post_package' >> /tmp/nwpost.txt
				;;
				# series 9 sabroker, dell R630
				dell-s9-1u )
					hwraid=True
					#drivetest="check_nwx_drives 1000GB 2TB"
					drivetest="check_enc_drive_sizes 1000 1000 2000 2000"
					drivetest2=check_nwx_raid
					volumesetup='# system volume is 2 drives in RAID 1 mode
					"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:0,$ENCID:1] $NEW_LD_OPTIONS -a$ADAPTER
					# application volume is 2 drives in RAID 1 mode
					"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:2,$ENCID:3] $NEW_LD_OPTIONS -a$ADAPTER     
					# make drive bootable
					"$COMMAND_TOOL" -AdpBootDrive -Set -L0 -a$ADAPTER'
					writeRaidScript "$volumesetup" msdos 
					echo -e 'make_device_map_dell_2400\nvolumeGroupScan\nsetSpectrumTunables\nspecFileService colo\ndoPost\nconfig_postgres_re\nconfig_ipdbextractor\nconfig_uax colo\ncheck_post_package' >> /tmp/nwpost.txt
				;;
				# un-qualified hardware
				* )
					invalid_hw
				;;
			esac
			echo '%end' >> /tmp/nwpack.txt
		;;
		archiver ) 
			echo -e 'nwworkbench\n@rsa-sa-ipmi-tools\n@rsa-sa-lsi-megacli\n@rsa-sa-san-tools' >> /tmp/nwpack.txt
			case $nwsystem in				
				# series 4s archiver, dell R620
				dell-s4s-1u )
					if check_for_newport_drives
					then	
						inewport=True
						hwraid=True
						drivetest=check_esa_raid
						volumesetup='# application volume is 9 drives in RAID 5 mode
						"$COMMAND_TOOL" -cfgldadd -R5[$ENCID:0,$ENCID:1,$ENCID:2,$ENCID:3,$ENCID:4,$ENCID:5,$ENCID:6,$ENCID:7,$ENCID:8] $NEW_LD_OPTIONS -a$ADAPTER
						# global hot spare
						"$COMMAND_TOOL" -pdhsp -set -EnclAffinity -PhysDrv [$ENCID:9] -a$ADAPTER'
						writeRaidScript "$volumesetup" msdos 
						echo -e 'make_device_map_esa\nvolumeGroupScan\ndoPost\nworkbench_nice' >> /tmp/nwpost.txt

					else 
						hwraid=True
						#drivetest="check_nwx_drives 147 1000"
						drivetest="check_enc_drive_sizes 147 147 1000 1000"
						drivetest2=check_nwx_raid
						volumesetup='# system volume is 2 drives in RAID 1 mode
						"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:0,$ENCID:1] $NEW_LD_OPTIONS -a$ADAPTER
						# application volume is 2 drives in RAID 1 mode
						"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:2,$ENCID:3] $NEW_LD_OPTIONS -a$ADAPTER'
						writeRaidScript "$volumesetup" msdos 
						echo -e 'make_device_map_dell_2400\nvolumeGroupScan\ndoPost\nworkbench_nice' >> /tmp/nwpost.txt
					fi
				;;
				# series 9 archiver, dell R630
				dell-s9-1u )
					hwraid=True
					#drivetest="check_nwx_drives 1000GB 2TB"
					drivetest="check_enc_drive_sizes 1000 1000 2000 2000"
					drivetest2=check_nwx_raid
					volumesetup='# system volume is 2 drives in RAID 1 mode
					"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:0,$ENCID:1] $NEW_LD_OPTIONS -a$ADAPTER
					# application volume is 2 drives in RAID 1 mode
					"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:2,$ENCID:3] $NEW_LD_OPTIONS -a$ADAPTER'
					writeRaidScript "$volumesetup" msdos 
					echo -e 'make_device_map_dell_2400\nvolumeGroupScan\ndoPost\nworkbench_nice' >> /tmp/nwpost.txt
				;;
				# un-qualified hardware
				* )
					invalid_hw
				;;
			esac
			echo '%end' >> /tmp/nwpack.txt
		;;
		connector )
			echo -e '@rsa-sa-ipmi-tools\n@rsa-sa-lsi-megacli\n@rsa-sa-san-tools' >> /tmp/nwpack.txt
			case $nwsystem in
				# series 4s connector, dell R620
				dell-s4s-1u )
					hwraid=True
					drivetest="check_nwx_drives 147 1000"
					drivetest2=check_nwx_raid
					volumesetup='# system volume is 2 drives in RAID 1 mode
					"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:0,$ENCID:1] $NEW_LD_OPTIONS -a$ADAPTER
					# application volume is 2 drives in RAID 1 mode
					"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:2,$ENCID:3] $NEW_LD_OPTIONS -a$ADAPTER     
					# make drive bootable
					"$COMMAND_TOOL" -AdpBootDrive -Set -L0 -a$ADAPTER'
					writeRaidScript "$volumesetup" msdos 
					echo -e 'make_device_map_dell_2400\nvolumeGroupScan\ndoPost\nsetupwarec' >> /tmp/nwpost.txt
				;;
				# un-qualified hardware
				* )
					invalid_hw
				;;
			esac
			echo '%end' >> /tmp/nwpack.txt
		;;
		esa )
			echo -e '@rsa-sa-ipmi-tools\n@rsa-sa-lsi-megacli\n@rsa-sa-san-tools' >> /tmp/nwpack.txt
			case $nwsystem in
				# series 4s event stream analytics, dell R620
				dell-s4s-1u )
					hwraid=True
					drivetest=check_esa_raid
					volumesetup='# application volume is 9 drives in RAID 5 mode
					"$COMMAND_TOOL" -cfgldadd -R5[$ENCID:0,$ENCID:1,$ENCID:2,$ENCID:3,$ENCID:4,$ENCID:5,$ENCID:6,$ENCID:7,$ENCID:8] $NEW_LD_OPTIONS -a$ADAPTER
					# global hot spare
					"$COMMAND_TOOL" -pdhsp -set -EnclAffinity -PhysDrv [$ENCID:9] -a$ADAPTER'
					writeRaidScript "$volumesetup" msdos 
					echo -e 'make_device_map_esa\nvolumeGroupScan\ndoPost\nconfig_esa\ncheck_post_package' >> /tmp/nwpost.txt
				;;
				# series S7 event stream analytics, dell R630
				dell-s9-1u )
					hwraid=True
					drivetest=check_s7_esa_raid
					volumesetup='# system volume is 2 drives in RAID 1 mode
					"$COMMAND_TOOL" -cfgldadd -R1[$ENCID:0,$ENCID:1] $NEW_LD_OPTIONS -a$ADAPTER
					# application volume is 3 drives in RAID 5 mode
					"$COMMAND_TOOL" -cfgldadd -R5[$ENCID:2,$ENCID:3,$ENCID:4] $NEW_LD_OPTIONS -a$ADAPTER
					# dedicated hot spare for ESA DB volume
					"$COMMAND_TOOL" -PDHSP -Set -Dedicated -Array1 -PhysDrv[$ENCID:5] -a$ADAPTER'
					writeRaidScript "$volumesetup" msdos 
					echo -e 'make_device_map_esa\nvolumeGroupScan\ndoPost\nconfig_esa\ncheck_post_package' >> /tmp/nwpost.txt
				;;
				# un-qualified hardware
				* )
					invalid_hw
				;;
			esac
			echo '%end' >> /tmp/nwpack.txt
		;;
	esac
}

function set_installtype {
	# determine install method
	if [[ `dmesg | grep -i 'kernel command line' | grep 'ks=hd'` ]]; then
		installtype='usb'
		echo "installtype = usb" >> /tmp/pre.log
	else
		echo "installtype = cdrom/url" >> /tmp/pre.log
	fi
}

function usenwhome {
	# delete, re-create netwitness volume for config backup, ultimately resize and grow filesystem in %post

	# as netwitness home, i.e. /var/netwitness, volume sizes have changed over time
	# remove netwitness volume and recreate 4GB volume	
	if [[ `ls /dev/mapper/VolGroup00-home` ]]; then
		echo "deleting logical volume: /dev/VolGroup00/home" | tee -a /tmp/pre.log > /dev/tty3
		lvremove -f /dev/VolGroup00/home
	elif [[ `ls /dev/mapper/VolGroup00-nwhome` ]]; then
		echo "deleting logical volume: /dev/VolGroup00/nwhome" | tee -a /tmp/pre.log > /dev/tty3
		lvremove -f /dev/VolGroup00/nwhome
	fi
	lvcreate -n nwhome -L 4096M /dev/VolGroup00
	lvchange -ay /dev/VolGroup00/nwhome
	mkfs.xfs /dev/VolGroup00/nwhome
	echo 'true' > /tmp/baknwhome 
}

function detect_install_devices {
# create list of valid install block devices, filtering DRAC virtual devices
	unset installdev
	unset installmodel
	local count
	local item
	local i
	local blockdev=( `ls /sys/block | grep 'sd[a-z]'` )
	let count=0
	for item in ${blockdev[@]}
	do
		# check for planar block devices, i.e. not on raid bus
		if [[ `grep -i 'ATA' /sys/block/$item/device/vendor` ]]; then
			installdev[$count]=$item
			installmodel[$count]=`cat /sys/block/$item/device/model`
			atablkdev=$count
			let count=$count+1
		fi
		cat /sys/block/$item/device/model > /tmp/out.txt
		#echo "item = $item"
		for i in "${raid_models_list[@]}"
		do
			if [[ `grep -is "$i" /tmp/out.txt` ]]; then
				installdev[$count]=$item
				installmodel[$count]=`cat /sys/block/$item/device/model`
				let count=$count+1
			fi
		done
	done
}

function upgrade_recovery {
# attempt to restore system back to a upgradeable, not running,  state
	mkdir -p /tmp/mnt
	mount -t ext4 /dev/mapper/VolGroup00-rsaupgdtry /tmp/mnt
	local rootfsuuid=`cat /tmp/mnt/rootfsuuid.txt`
	local bkuproot=`cat /tmp/mnt/bkuproot.txt`
	umount /tmp/mnt
	mount $bkuproot /tmp/mnt
	rm -Rf /dev/cfgbak/
	cp -Rp /tmp/mnt/cfgbak/ /dev/
	umount /tmp/mnt
	if ! [[ `ls /dev/VolGroup00 | grep -i '^root'` ]]; then
		lvcreate -n root -L 10240M /dev/mapper/VolGroup00
		lvchange -ay /dev/mapper/VolGroup00-root
	fi
	mkfs.ext4 -F /dev/mapper/VolGroup00-root
	tune2fs -U $rootfsuuid /dev/mapper/VolGroup00-root
	if ! [[ `ls /dev/VolGroup00 | grep -i '^var'` ]]; then
		lvcreate -n var -L 4096M /dev/mapper/VolGroup00
		lvchange -ay /dev/mapper/VolGroup00-var
	fi
	mkfs.ext4 -F /dev/mapper/VolGroup00-var
	mount /dev/mapper/VolGroup00-var /tmp/mnt
	mkdir -p /tmp/mnt/lib
	tar -C /tmp/mnt/lib -xjf /tmp/cfgbak/rpm.tbz
	umount /tmp/mnt
	mount /dev/mapper/VolGroup00-root /tmp/mnt
	mkdir -p /tmp/mnt/etc/sysconfig/network-scripts /tmp/mnt/etc/lvm /tmp/mnt/root
	cp -p /tmp/cfgbak/fstab /tmp/mnt/etc/
	cp -p /tmp/cfgbak/passwd /tmp/mnt/etc/
	cp -p /tmp/cfgbak/shadow /tmp/mnt/etc/
	cp -p /tmp/cfgbak/group /tmp/mnt/etc/
	if [ -s /tmp/cfgbak/mdadm.conf ]; then
		cp -p /tmp/cfgbak/mdadm.conf /tmp/mnt/etc/
	fi
	cp -p /tmp/cfgbak/lvm.conf /tmp/mnt/etc/lvm/
	cp -p /tmp/cfgbak/hosts /tmp/mnt/etc/ 
	cp -p /tmp/cfgbak/resolv.conf /tmp/mnt/etc/
	cp -p /tmp/cfgbak/network /tmp/mnt/etc/sysconfig/
	cp -p /tmp/cfgbak/ifcfg-* /tmp/mnt/etc/sysconfig/network-scripts/
	if [ -d /tmp/cfgbak/.ssh ]; then
		cp -Rp /tmp/cfgbak/.ssh /tmp/mnt/root/
	fi	
	tar -C /tmp/mnt/etc -xjf /tmp/cfgbak/nw.tbz
	umount /tmp/mnt
}

function check_upgrade { 
	local SYSPARTS='/tmp/nwpart.txt'
	local APPMNTS='/tmp/nwvols.txt' 
	local errcode
	local baknwhome
	local usrChoice=q
	local mntfail
	local exitcode
	local vgfreemb
	local item
	local i
	local rootlv
	local rootfsuuid
	local size
	local count
	local varlv
	local nwlv
	local warecbkup
	# presence of rsa home logical volume, i.e. /opt/rsa, not in volume group "VolGroup00"
	local rabmqvol
	local vg00lv
	
	if ! [ $nwapptype ]; then
		set_nwapptype
	fi
	if ! [ $nwsystem ]; then
		set_nwsystem
	fi
	
	if ! [ $installtype ]; then
		set_installtype
	fi 
	
	# copy fips compliant openssl package to /tmp
	#copy_openssl_fips
	
	chvt 3
	echo > /dev/tty3
	echo > /dev/tty3
	echo "examining system storage ..." > /dev/tty3
	echo > /dev/tty3	
	# activate SW RAID devices
	echo 'detecting linux raid devices' > /dev/tty3
	detect_mdraid
	
	# rescan/activate VGs', LVs' 
	echo 'performing volume group scan' > /dev/tty3 
	vgscan --mknodes > /dev/tty3 2>&1
	echo 'running volume group check' > /dev/tty3
	vgck -v > /dev/tty3 2>&1
	echo 'activating volume groups' > /dev/tty3
	vgchange -ay --ignorelockingfailure > /dev/tty3 2>&1
	sleep 10	
	
	# new in centos 6.5 /tmp is only 250MB, /dev is 48GB or 50% of RAM 
	# create a ram disk or just use /dev ?
	mkdir -p /tmp/mnt /tmp/mpoint
	mkdir -p /dev/cfgbak 
	cd /tmp 
	ln -s ../dev/cfgbak cfgbak

	if [ -d /dev/VolGroup00 ]; then
		# get listing of VolGroup00 logical volumes
		vg00lv=( `ls /dev/VolGroup00` )
	
		# check for previous upgrade attempt and prompt to continue
		for item in ${vg00lv[@]} 
		do
			if [[ `echo $item | grep 'rsaupgdtry'` ]]; then
				unset usrChoice
				echo > /dev/tty3
				echo > /dev/tty3
				echo '-----------------------------------' > /dev/tty3
				echo ' Previous upgrade attempt detected' > /dev/tty3
				echo ' Performing a subsequent upgrade' > /dev/tty3
				echo ' operation may cause loss of data' > /dev/tty3
				echo ' Please contact product support' > /dev/tty3
				echo ' before attempting another upgrade' > /dev/tty3
				echo ' ---------------------------------' > /dev/tty3
				exec < /dev/tty3 > /dev/tty3 2>&1	
				read -t 120 -p "Enter (y/Y) to continue upgrade, defaults to Quit? " usrChoice
				if [[ $usrChoice = y || $usrChoice = Y ]]; then
					# add upgrade recovery function call here
					echo ' restoring persistent backup' > /dev/tty3	
					upgrade_recovery
					### debug statements ###
					#echo 'sleeping indefinitely' > /dev/tty3
					#sleep 99999	
				else	
					exit 1
				fi
			fi
		done
		unset vg00lv
	fi

	# check if system could be upgraded
	if [[ -e /dev/mapper/VolGroup00-root ]]; then 
		
		mount /dev/VolGroup00/root /tmp/mnt > /dev/tty3 2>&1
		
		# check OS level, only allow upgrade of CentOS 5.x appliances
		# testing el6 upgrade partitioning
		#if [[ `grep -E '[[:space:]]5\.[0-9][[:space:]]' /tmp/mnt/etc/redhat-release` ]]; then
		if ! [[ `grep -E '[[:space:]]5\.[0-9][[:space:]]' /tmp/mnt/etc/redhat-release` ]]; then
			echo > /dev/tty3
			echo -n ' Detected OS Level: ' > /dev/tty3
			cat /tmp/mnt/etc/redhat-release > /dev/tty3
			echo '--------------------------------------------------' > /dev/tty3
			echo ' Same OS major version upgrades are not supported' > /dev/tty3
			echo ' For example upgrading CentOS 6.3 -> CentOS 6.5' > /dev/tty3
			echo ' If you had intended to upgrade please quit and' > /dev/tty3
			echo ' contact support, <CTRL><ALT><DEL> to restart' > /dev/tty3
			echo ' Prompting for install/reinstall in 120 seconds' > /dev/tty3
			echo '--------------------------------------------------' > /dev/tty3
			echo > /dev/tty3
			sleep 120
			make_install_parts $nwsystem
		fi
		
		if ! [ -s /tmp/mnt/etc/fstab ]; then
			echo > /dev/tty3
			echo '---------------------------------------------------' > /dev/tty3
			echo ' Unable to open existing system /etc/fstab file' > /dev/tty3
			echo ' Possible Cause: mount failure of logical volume' > /dev/tty3 
			echo ' VolGroup00-root, missing/corrupted fstab file' > /dev/tty3
			echo ' Error is unrecoverable, upgrade not possible' > /dev/tty3 
			echo ' If you had intended to upgrade please disconnect' > /dev/tty3
			echo ' install media, reboot and contact product support' > /dev/tty3 
			echo ' Re-install or Quit, re-installs delete all data' > /dev/tty3
			echo '---------------------------------------------------' > /dev/tty3
			exec < /dev/tty3 > /dev/tty3 2>&1
			read -t 120 -p " Re-install?, defaults to Quit in 120 seconds R/Q? " usrChoice
			if [[ "$usrChoice" = 'q' || "$usrChoice" = 'Q' ]]; then
				exit 1
			else
				make_install_parts $nwsystem $usrChoice 
			fi
		fi
		
		# back up configuration files
		usrchoice=q
		echo 'backing up system configuration ...' > /dev/tty3
		if [ -s /tmp/mnt/etc/mdadm.conf ]; then
			echo "backing up /etc/mdadm.conf" | tee -a /tmp/pre.log > /dev/tty3		
			cp /tmp/mnt/etc/mdadm.conf /tmp/cfgbak/mdadm.conf.orig
		fi
		if [ -d /tmp/mnt/root/.ssh ]; then
			echo "backing up root's .ssh/ folder" | tee -a /tmp/pre.log > /dev/tty3
			cp -Rp /tmp/mnt/root/.ssh /tmp/cfgbak/
		fi
		cp /tmp/mnt/etc/fstab /tmp/cfgbak/ &&
		sync && 
		# backup network configuration
		cp /tmp/mnt/etc/hosts /tmp/cfgbak/ &&
		cp /tmp/mnt/etc/sysconfig/network /tmp/cfgbak/ &&
		cp /tmp/mnt/etc/sysconfig/network-scripts/ifcfg-* /tmp/cfgbak/ &&
		cp /tmp/mnt/etc/resolv.conf /tmp/cfgbak/ &&
		cp /tmp/mnt/etc/passwd /tmp/cfgbak/ &&
		cp /tmp/mnt/etc/shadow /tmp/cfgbak/ &&
 		cp /tmp/mnt/etc/group /tmp/cfgbak/ &&
 		cp /tmp/mdadm.conf /tmp/cfgbak/ &&
 		cp /tmp/mnt/etc/lvm/lvm.conf /tmp/cfgbak/ &&
		rm -f /tmp/mnt/etc/sysconfig/network-scripts/ifcfg-lo ||
		{ backupprompt; exec < /dev/tty3 > /dev/tty3 2>&1; read -t 120 -p " Continue?, defaults to Quit in 120 seconds C/Q? " usrChoice; if [[ "$usrChoice" = 'q' || "$usrChoice" = 'Q' ]]; then exit 1; fi }
		
		# read contents of fstab
		let count=0
		while read line
		do
			sysmounts[$count]="$line"
			let count=$count+1
		done < /tmp/mnt/etc/fstab
		
		# save nw appliance configurations
		usrChoice=q
		if [ -d /tmp/mnt/etc/netwitness ]; then
			echo "archiving /etc/netwitness ..." > /dev/tty3
			tar -cjf /tmp/cfgbak/nw.tbz -C /tmp/mnt/etc netwitness/ --exclude='index-*.xml'
			errcode=$?
			if [ "$errcode" != '0' ]; then
				backupprompt
				exec < /dev/tty3 > /dev/tty3 2>&1	
				read -t 120 -p " Continue?, defaults to Quit in 120 seconds C/Q? " usrChoice
				if [[ "$usrChoice" = 'q' || "$usrChoice" = 'Q' ]]; then
					exit 1
				fi
			fi
		else
			backupprompt
			exec < /dev/tty3 > /dev/tty3 2>&1
			read -t 120 -p " Continue?, defaults to Quit in 120 seconds C/Q? " usrChoice
			if [[ "$usrChoice" = 'q' || "$usrChoice" = 'Q' ]]; then
				exit 1
			fi
		fi
		
		# backup root's crontab file from directory root, or mount /var for crontab backup
		if [[ `grep -E '[[:space:]]/var[[:space:]]' /tmp/cfgbak/fstab` ]]; then
			varlv=`grep -E '[[:space:]]/var[[:space:]]' /tmp/cfgbak/fstab | awk '{print $1}'`
		else
			if [ -s /tmp/mnt/var/spool/cron/root ]; then
				echo "backing up root's crontab file" | tee -a /tmp/pre.log > /dev/tty3
				cp -P /tmp/mnt/var/spool/cron/root /tmp/cfgbak/root.cron
			fi
			
			# back up any fneserver trusted store data
			if [ -d /tmp/mnt/var/lib/fneserver ]; then
				cd /tmp/mnt/var/lib/fneserver
				tar -czf /tmp/cfgbak/fnetruststore.tgz --exclude='properties.xml' --exclude='FNEServer' *
				cd /
			fi
		fi
		
		umount /tmp/mnt
		sleep 2
	
		if [ $varlv ]; then
			mount $varlv /tmp/mnt
			sleep 2
			if [ -s /tmp/mnt/spool/cron/root ]; then
				echo "backing up root's crontab file" | tee -a /tmp/pre.log > /dev/tty3
				cp -P /tmp/mnt/spool/cron/root /tmp/cfgbak/root.cron
			fi
			
			# back up any fneserver trusted store data
			if [ -d /tmp/mnt/lib/fneserver ]; then
				cd /tmp/mnt/lib/fneserver
				tar -czf /tmp/cfgbak/fnetruststore.tgz --exclude='properties.xml' --exclude='FNEServer' *
				cd /
			fi
			umount /tmp/mnt
			sleep 2
		fi

		# make sure user didn't select the worng menu item
		if ! verify_upgrade_path
		then 
			sleep 120
			chvt 1
			exit 1
		fi

		# if warehouseconnector was retro installed attempt backup		
		if [ $warehouseconn ] && ! [[ `grep -E '[[:space:]]+/var/netwitness/warehouseconnector[[:space:]]+' /tmp/cfgbak/fstab` ]]; then
			nwlv=`grep -E '[[:space:]]+/var/netwitness[[:space:]]+' /tmp/cfgbak/fstab | awk '{print $1}'`
			echo "\$nwlv = $nwlv" | tee -a /tmp/pre.log > /dev/tty3
			echo "mounting $nwlv on /tmp/mpoint for warehouseconnector application folder backup" | tee -a /tmp/pre.log > /dev/tty3
			mount $nwlv /tmp/mpoint
			errcode=$?
			sleep 2
			if [ $errcode != 0 ]; then
				{ backupprompt "/tmp/cfgbak/warec.tgz"; exec < /dev/tty3 > /dev/tty3 2>&1; read -t 120 -p " Continue?, defaults to Quit in 120 seconds C/Q? " usrChoice; if [[ "$usrChoice" = 'q' || "$usrChoice" = 'Q' ]]; then exit 1; fi }
			fi
			echo 'backing up warehouseconnector folder to /tmp/cfgbak/warec.tgz, this may take a while ...' | tee -a /tmp/pre.log > /dev/tty3
			tar -czf /tmp/cfgbak/warec.tgz -C /tmp/mpoint warehouseconnector/ ||
			{ backupprompt "/tmp/cfgbak/warec.tgz"; exec < /dev/tty3 > /dev/tty3 2>&1; read -t 120 -p " Continue?, defaults to Quit in 120 seconds C/Q? " usrChoice; if [[ "$usrChoice" = 'q' || "$usrChoice" = 'Q' ]]; then exit 1; fi }
			umount /tmp/mpoint
			sleep 2
		fi

		# attempt local backup of /etc/fstab and /etc/netwitness incase of upgrade failure 
		local bkuproot
		case $nwapptype in
			# dell-s4s-1u: /var/netwitness not in VolGroup00
			archiver )
				bkuproot=`grep -E '[[:space:]]+/var/netwitness[[:space:]]+' /tmp/cfgbak/fstab | awk '{print $1}'`
			;;
			# broker volumes should exist in s3 - s4s hw
			broker | sabroker | spectrumbroker )
				bkuproot=`grep -E '[[:space:]]+/var/netwitness/broker[[:space:]]+' /tmp/cfgbak/fstab | awk '{print $1}'`
			;;
			# concentrator volumes won't exist in s4 - s4s hw without external storage
			concentrator )
				bkuproot=`grep -E '[[:space:]]+/var/netwitness/concentrator/metadb[[:space:]]+' /tmp/cfgbak/fstab | awk '{print $1}'`		
			;;
			# decoder volumes won't exist on s4 - s4s hw without external storage
			decoder | packethybrid | packetaio | spectrumdecoder )
				bkuproot=`grep -E '[[:space:]]+/var/netwitness/decoder/packetdb[[:space:]]+' /tmp/cfgbak/fstab | awk '{print $1}'`
			;;	
			# logdecoder volumes won't exist on s4 - s4s hw without external storage
			logdecoder | loghybrid | logaio )
				bkuproot=`grep -E '[[:space:]]+/var/netwitness/logdecoder/packetdb[[:space:]]+' /tmp/cfgbak/fstab | awk '{print $1}'`
			;;
			# dell-s4s-1u newport
			maprwh | esa )
				bkuproot=`grep -E '[[:space:]]+/opt[[:space:]]+' /tmp/cfgbak/fstab | awk '{print $1}'`		
			;;
			# remote logcollector: dell-s4-2u
			logcollector )
				bkuproot=`grep -E '[[:space:]]+/var/netwitness/logcollector[[:space:]]+' /tmp/cfgbak/fstab | awk '{print $1}'`
			;;
			# remote ipdbextractor: dell-s4-2u
			ipdbextractor )
				bkuproot=`grep -E '[[:space:]]+/var/netwitness/nwipdbextractor[[:space:]]+' /tmp/cfgbak/fstab | awk '{print $1}'`
			;;
		esac
		
		# series 4 and 4S nwx systems without an attached and configured JBOD enclosure
		if ! [[ `echo "$bkuproot" | grep -E '[[:alnum:]]'` ]]; then
			# nwhome on S4S not in VolGroup00
			if [ $nwsystem = dell-s4s-1u ]; then
				bkuproot=`grep -E '[[:space:]]+/var/netwitness[[:space:]]+' /tmp/cfgbak/fstab | awk '{print $1}'`
			# re-purpose nwhome in VolGroup00
			elif [ $nwsystem = dell-s4-1u ]; then
				usenwhome
				bkuproot=/dev/mapper/VolGroup00-nwhome
				baknwhome=true
			fi
		fi
		
		usrChoice=q 
		echo "attempting local disk backup of /tmp/cfgbak in: $bkuproot" | tee -a /tmp/pre.log > /dev/tty3 
		mount $bkuproot /tmp/mnt | tee -a /tmp/pre.log > /dev/tty3
		if ! [[ `mount -l | grep '/tmp/mnt'` ]]; then
			mntfail=true
		fi
		# Series 4 and 4S nwx systems with JBOD enclosure disconnected
		if [ $mntfail ] && [[ $nwsystem = dell-s4-1u || $nwsystem = dell-s4s-1u ]]; then
			# nwhome on S4S not in VolGroup00
			if [ $nwsystem = dell-s4s-1u ]; then
				bkuproot=`grep -E '[[:space:]]+/var/netwitness[[:space:]]+' /tmp/cfgbak/fstab | awk '{print $1}'`
				echo "attempting local disk backup of /tmp/cfgbak in: $bkuproot" | tee -a /tmp/pre.log > /dev/tty3 
				mount $bkuproot /tmp/mnt | tee -a /tmp/pre.log > /dev/tty3
				if [[ `mount -l | grep '/tmp/mnt'` ]]; then
					unset mntfail
				fi
			# re-purpose nwhome in VolGroup00
			elif [ $nwsystem = dell-s4-1u ] && ! [ $baknwhome ]; then
				usenwhome
				baknwhome=true 
				bkuproot=/dev/mapper/VolGroup00-nwhome
				echo "attempting local disk backup of /tmp/cfgbak in: $bkuproot" | tee -a /tmp/pre.log > /dev/tty3 
				mount $bkuproot /tmp/mnt | tee -a /tmp/pre.log > /dev/tty3
				if [[ `mount -l | grep '/tmp/mnt'` ]]; then
					unset mntfail
				fi
			fi
		fi
	
		if ! [ $mntfail ]; then
			cp -R /tmp/cfgbak/ /tmp/mnt/
			exitcode=$?
		fi
		if [[ $mntfail || $exitcode != 0 ]]; then 
			backupprompt "/tmp/cfgbak"
			exec < /dev/tty3 > /dev/tty3 2>&1
			read -t 120 -p " Continue?, defaults to Quit in 120 seconds C/Q? " usrChoice
			if [[ "$usrChoice" = 'q' || "$usrChoice" = 'Q' ]]; then
				exit 1
			fi
		else
			umount /tmp/mnt
			sleep 2
		fi

		# parse mount components from existing /etc/fstab
		local index
		local numlines
		local mydevices
		local mymounts
		local myformats
		local myoptions
		local symlink
		local uuid
		local label
		local numloops
		local devname
		local deverr
	
		# set default to Install/Re-install
		#usrChoice='R'
				
		let count=0
		let index=0
		let numlines=${#sysmounts[@]}
		while [ $count -lt $numlines ]
		do 
			if [[ `echo "${sysmounts[$count]}" | grep -E '^[[:space:]]*#'` ]]; then
				let count=$count+1
				continue
			elif [[ `echo "${sysmounts[$count]}" | grep -E '^[[:space:]]*$'` ]]; then
				let count=$count+1
				continue
			# netwitness logical volume and block devices
			elif [[ `echo "${sysmounts[$count]}" | awk '{print $2}' | grep 'netwitness'` && `echo "${sysmounts[$count]}" | awk '{print $1}' | grep '/dev/'` ]]; then 
				mydevices[$index]=`echo "${sysmounts[$count]}" | awk '{print $1}'`
				mymounts[$index]=`echo "${sysmounts[$count]}" | awk '{print $2}'`
				myformats[$index]=`echo "${sysmounts[$count]}" | awk '{print $3}'` 
				#myoptions[$index]=`echo "${sysmounts[$count]}" | awk '{print $4}'`
				let index=$index+1
			elif [[ `echo "${sysmounts[$count]}" | awk '{print $2}' | grep '/var/lib/rabbitmq'` ]]; then 
				# if rabmqvol exists in a volume group other than VolGroup00 don't create it as it will be deleted and recreated
				if ! [[ `echo "${sysmounts[$count]}" | awk '{print $1}' | grep 'VolGroup00'` ]]; then
					mydevices[$index]=`echo "${sysmounts[$count]}" | awk '{print $1}'`
					mymounts[$index]=`echo "${sysmounts[$count]}" | awk '{print $2}'`
					myformats[$index]=`echo "${sysmounts[$count]}" | awk '{print $3}'` 
					#myoptions[$index]=`echo "${sysmounts[$count]}" | awk '{print $4}'`
					rabmqvol=true
					let index=$index+1
				fi
			elif [[ `echo "${sysmounts[$count]}" | awk '{print $1}' | grep '/dev/mapper'` ]]; then
				mydevices[$index]=`echo "${sysmounts[$count]}" | awk '{print $1}'`
				mymounts[$index]=`echo "${sysmounts[$count]}" | awk '{print $2}'`
				myformats[$index]=`echo "${sysmounts[$count]}" | awk '{print $3}'`
				let index=$index+1
			elif [[ `echo "${sysmounts[$count]}" | awk '{print $1}' | grep '/dev/md[0-9]'` || `echo "${sysmounts[$count]}" | awk '{print $1}' | grep '/dev/[hs]d[a-z][0-9]'` ]]; then
				mydevices[$index]=`echo "${sysmounts[$count]}" | awk '{print $1}'`
				mymounts[$index]=`echo "${sysmounts[$count]}" | awk '{print $2}'`
				myformats[$index]=`echo "${sysmounts[$count]}" | awk '{print $3}'`
				let index=$index+1
			elif [[ `echo "${sysmounts[$count]}" | awk '{print $1}' | grep -i 'VolGroup0'` ]]; then 
				mydevices[$index]=`echo "${sysmounts[$count]}" | awk '{print $1}'`
				mymounts[$index]=`echo "${sysmounts[$count]}" | awk '{print $2}'`
				myformats[$index]=`echo "${sysmounts[$count]}" | awk '{print $3}'`
				let index=$index+1
			# cifs/nfs mounts
			elif [[ `echo "${sysmounts[$count]}" | awk '{print $3}' | grep -i 'cifs'` || `echo "${sysmounts[$count]}" | awk '{print $3}' | grep -i 'nfs'` ]]; then 
				mydevices[$index]=`echo "${sysmounts[$count]}" | awk '{print $1}'`
				mymounts[$index]=`echo "${sysmounts[$count]}" | awk '{print $2}'`
				myformats[$index]=`echo "${sysmounts[$count]}" | awk '{print $3}'`
				myoptions[$index]=`echo "${sysmounts[$count]}" | awk '{print $4}'`			
				let index=$index+1		
			elif [[ `echo "${sysmounts[$count]}" | awk '{print $1}' | grep -i 'UUID'` ]]; then 
				# deference boot mounts for reuse by installer
				if [[ `echo "${sysmounts[$count]}" | awk '{print $2}' | grep -i '/boot'` ]]; then
					uuid=`echo "${sysmounts[$count]}" | awk -F= '{print $2}' | awk '{print $1}'`
					symlink=`ls -l /dev/disk/by-uuid | grep "$uuid"`
					symlink=`echo "$symlink" | awk -F\> '{print $2}' | awk '{print $1}'`
					symlink=${symlink#\.\./\.\./}
					mydevices[$index]="/dev/$symlink"
					mymounts[$index]=`echo "${sysmounts[$count]}" | awk '{print $2}'`
					myformats[$index]=`echo "${sysmounts[$count]}" | awk '{print $3}'`
					let index=$index+1
				else	
					mydevices[$index]=`echo "${sysmounts[$count]}" | awk '{print $1}'`
					mymounts[$index]=`echo "${sysmounts[$count]}" | awk '{print $2}'`
					myformats[$index]=`echo "${sysmounts[$count]}" | awk '{print $3}'`		
					let index=$index+1
				fi
			elif [[ `echo "${sysmounts[$count]}" | awk '{print $1}' | grep -i 'LABEL'` ]]; then 
				# deference boot mounts for reuse by installer
				if [[ `echo "${sysmounts[$count]}" | awk '{print $2}' | grep -i '/boot'` ]]; then 
					label=`echo "${sysmounts[$count]}" | awk -F= '{print $2}' | awk '{print $1}'`
					label=${label/\/}
					symlink=`ls -l /dev/disk/by-label | grep "$label"`
					symlink=`echo "$symlink" | awk -F\> '{print $2}' | awk '{print $1}'`
					symlink=${symlink#\.\./\.\./}
					mydevices[$index]="/dev/$symlink"
					mymounts[$index]=`echo "${sysmounts[$count]}" | awk '{print $2}'`
					myformats[$index]=`echo "${sysmounts[$count]}" | awk '{print $3}'`		
					let index=$index+1
				else
					mydevices[$index]=`echo "${sysmounts[$count]}" | awk '{print $1}'`
					mymounts[$index]=`echo "${sysmounts[$count]}" | awk '{print $2}'`
					myformats[$index]=`echo "${sysmounts[$count]}" | awk '{print $3}'`		
					let index=$index+1
				fi
			fi
			let count=$count+1	
		done
	        
		### debug statements ###
		#size=${#mydevices[@]}
		#let count=0
		#while [ $count -lt $size ]
		#do
		#	echo "${mydevices[$count]} ${mymounts[$count]} ${myformats[$count]}" > /dev/tty3
		#	let count=$count+1	
		#done
		#sleep 30
		#exit 1 

 		# get uuid of directory root, i.e. '/'
		let count=0
		let size=${#mymounts[@]}
		while [ $count -lt $size ]
		do
			if [[ `echo ${mymounts[$count]} | grep '/'` ]] && ! [[ `echo ${mymounts[$count]} | grep -E '/[[:alnum:]]+'` ]]; then
				rootlv=${mydevices[$count]}
				break
			fi
			let count=$count+1
		done	
		echo "determining uuid of $rootlv" >> /tmp/pre.log
		blkid $rootlv >> /tmp/pre.log
		# some commands don't work with idrac, seems to be some rpc latency going on?
		rootfsuuid=( `blkid $rootlv` )
		# spilt return string
		for i in ${rootfsuuid[@]}
		do
			if [[ `echo $i | grep -i 'UUID'` ]]; then
				rootfsuuid=$i
				echo "rootfsuuid = $rootfsuuid" >> /tmp/pre.log
				rootfsuuid=${rootfsuuid#UUID=\"}
				rootfsuuid=${rootfsuuid%\"}
				echo "rootfsuuid = $rootfsuuid" >> /tmp/pre.log
				break
			fi
		done
		echo "\$rootfsuuid = $rootfsuuid" >> /tmp/pre.log
		echo -n "$rootfsuuid" > /tmp/rootfsuuid.txt
		
		# verify devices 
		echo 'verifying block devices, volume groups and logical volumes ...' > /dev/tty3
		let numloops=${#mydevices[@]}
		let count=0
		echo
		while [ $count -lt $numloops ]
		do 
			if [[ `echo "${myformats[$count]}" | grep -i 'cifs'` || `echo "${myformats[$count]}" | grep -i 'nfs'` ]]; then
				echo "skipping cifs/nfs mount(s): ${mydevices[$count]}" > /dev/tty3
			elif [[ `echo "${mydevices[$count]}" | grep '/dev/[hs]d[a-z][0-9]'` || `echo "${mydevices[$count]}" | grep '/dev/md[0-9]'` ]]; then
				if ! [ -b  "${mydevices[$count]}" ]; then
					echo "device not found ${mydevices[$count]}" > /dev/tty3
					let deverr=1
				else
					echo "found: ${mydevices[$count]}" > /dev/tty3
				fi 
			elif [[ `echo "${mydevices[$count]}" | grep -i 'UUID'` ]]; then
				# deference device uuid
				uuid=`echo "${sysmounts[$count]}" | awk -F= '{print $2}' | awk '{print $1}'`
				symlink=`ls -l /dev/disk/by-uuid | grep "$uuid"`
				symlink=`echo "$symlink" | awk -F\> '{print $2}' | awk '{print $1}'`
				symlink=${symlink#\.\./\.\./}
				# block devices
				if ! [[ `echo $symlink | grep -i 'dm-'` ]]; then
					if ! [ -b  "/dev/$symlink" ]; then
						echo "device not found ${mydevices[$count]}" > /dev/tty3
						let deverr=1
					else
						echo "found: ${mydevices[$count]}" > /dev/tty3
					fi
				# logical devices
				else
					if ! [[ `ls -l /dev/mapper | grep "$symlink"` ]]; then
						echo "device not found ${mydevices[$count]}" > /dev/tty3
						let deverr=1
					fi
				fi 
			elif [[ `echo "${mydevices[$count]}" | grep '/dev/mapper'` ]]; then
				if ! [ -b  "${mydevices[$count]}" ]; then
					echo "device not found ${mydevices[$count]}" > /dev/tty3
					let deverr=1
				else
					echo "found: ${mydevices[$count]}" > /dev/tty3 
				fi 
			else 
				if ! [ -h "${mydevices[$count]}" ]; then
					echo "device not found ${mydevices[$count]}" > /dev/tty3
					let deverr=1
				else
					echo "found: ${mydevices[$count]}" > /dev/tty3
				fi
			fi       	       
			let count=$count+1
		done
		
		### debug statements ###
		#echo 'sleeping indefinitely' > /dev/tty3
		#sleep 99999
		
		if [ $deverr ]; then
			# prompt for upgrade error
			echo > /dev/tty3
			echo "----------------------------------------------------------" > /dev/tty3
			echo " Dectection of all listed storage devices has failed" > /dev/tty3
			echo " Continuing with a upgrade may cause unexpected results" > /dev/tty3
			echo " Please quit and contact product support if upgrading" > /dev/tty3
			echo " Re-installs will delete all storage partitions and data" > /dev/tty3
			echo " Please quit and backup any needed data before proceeding" > /dev/tty3 
			echo " Enter U to Upgrade, R to Re-Install, Q to Quit" > /dev/tty3
			echo "----------------------------------------------------------" > /dev/tty3 
			usrChoice='Q'		
			exec < /dev/tty3 > /dev/tty3 2>&1	
			read -t 120 -p " Upgrade/Re-install/Quit, defaults to Quit in 120 seconds U/R/Q? " usrChoice 
	
		else	
			# prompt for upgrade
			echo > /dev/tty3
			echo "-----------------------------------------------------" > /dev/tty3
			echo " This system appears to be eligble for an upgrade" > /dev/tty3
			echo " For upgrades only application data will be saved" > /dev/tty3
			echo " Any OS level volumes in VolGroup00 will be erased" > /dev/tty3
			echo " E.G. /etc, /home, /lib, /root, /usr, /var, etc." > /dev/tty3
			echo " Re-installs will delete all partitions and data" > /dev/tty3
			echo " Please quit and backup any data before proceeding" > /dev/tty3 
			echo " Enter U to Upgrade, R to Re-Install, Q to Quit" > /dev/tty3
			echo "-----------------------------------------------------" > /dev/tty3
			usrChoice='U'
			exec < /dev/tty3 > /dev/tty3 2>&1	
			read -t 120 -p " Upgrade/Re-install/Quit, defaults to Upgrade in 120 seconds U/R/Q? " usrChoice 
		fi

		if [[ "$usrChoice" = 'q' || "$usrChoice" = 'Q' ]]; then
			exit 1
		elif [[ "$usrChoice" = 'r' || "$usrChoice" = 'R' ]]; then 	
			#vgremove -f /dev/VolGroup00
			vgchange --monitor n > /dev/tty3 2>&1
			vgchange -a n > /dev/tty3 2>&1
			if [[ `grep '/dev/md[0-9]' /tmp/mdadm.conf` ]]; then
				local mdarray=( `grep '/dev/md[0-9]' /tmp/mdadm.conf | awk '{print $2}'` )
				for item in ${mdarray[@]}
				do
					mdadm -S $item | tee -a /tmp/pre.log > /dev/tty3 2>&1
				done
			fi
			make_install_parts $nwsystem $usrChoice
		fi
		
		# add install of WC if installed previously, remove otherwise as it was only installed on SA 10.3+ s4s non aio capture appliances
		if [ $warehouseconn ]; then
			if ! [[ `grep 'nwwarehouseconnector' /tmp/nwpack.txt` ]]; then
				sed -r 's/(^[[:space:]]*%end.*$)/nwwarehouseconnector\n\1/' < /tmp/nwpack.txt > /tmp/nwpack.txt.tmp
				mv -f /tmp/nwpack.txt.tmp /tmp/nwpack.txt
			fi
		else
			if [[ `grep 'nwwarehouseconnector' /tmp/nwpack.txt` ]]; then
				sed -r 's/(^[[:space:]]*nwwarehouseconnector.*$)/#\1/' < /tmp/nwpack.txt > /tmp/nwpack.txt.tmp
				mv -f /tmp/nwpack.txt.tmp /tmp/nwpack.txt
			fi
		fi
		
		# add install of LC if installed previously, remove otherwise as it was only installed on NG 9.8+ s4 and s4s logdecoder appliances
		if [ $logcoll ]; then
			if ! [[ `grep 'setuplogcoll' /tmp/nwpost.txt` ]]; then
				sed -r 's/(^[[:space:]]*%end.*$)/setuplogcoll\n\1/' < /tmp/nwpost.txt > /tmp/nwpost.txt.tmp
				mv -f /tmp/nwpost.txt.tmp /tmp/nwpost.txt
			fi
		else
			if [[ `grep 'setuplogcoll' /tmp/nwpost.txt` ]]; then
				sed -r 's/(^[[:space:]]*setuplogcoll.*$)/#\1/' < /tmp/nwpost.txt > /tmp/nwpost.txt.tmp
				mv -f /tmp/nwpost.txt.tmp /tmp/nwpost.txt
				sed -r 's/^[[:space:]]*vsftpd.*$/-vsftpd/' < /tmp/nwpack.txt > /tmp/nwpack.txt.tmp
				mv -f /tmp/nwpack.txt.tmp /tmp/nwpack.txt 
				sed -r 's/^[[:space:]]*rssh.*$/-rssh/' < /tmp/nwpack.txt > /tmp/nwpack.txt.tmp
				mv -f /tmp/nwpack.txt.tmp /tmp/nwpack.txt
			fi
		fi

		echo "volgroup VolGroup00 --useexisting" >> $SYSPARTS
		
		# get list of logical volumes in VolGroup00
		vg00lv=( `ls /dev/VolGroup00` )
	
		### debug statements ###
		echo "logical volumes in VolGroup00: ${vg00lv[@]}" | tee -a /tmp/pre.log > /dev/tty3
		sleep 5
		#echo 'sleeping indefinitely' > /dev/tty3
		#sleep 99999 
		
		local lvdev
		local mpoint
		local blkdev
		local devfs
		local nospace
		local freespace
		local newrabmq
		local startfree
		local endfree
		local partnum
		local counter
		local mysize 
		for lvdev in "${vg00lv[@]}"
		do
			# delete os logical volumes from VolGroup00
			if ! [[ `echo $lvdev | grep -i 'concentrator'` ]] && ! [[ `echo $lvdev | grep -i 'ipdbext'` ]] && ! [[ `echo $lvdev | grep -i 'lchome'` ]] && ! [[ `echo $lvdev | grep -i '^home'` ]] && ! [[ `echo $lvdev | grep -i '^nwhome'` ]]; then
				
				### debug statement ###
				echo "deleting logical volume: $lvdev" | tee -a /tmp/pre.log > /dev/tty3
				lvremove -f /dev/VolGroup00/$lvdev
			# preserve nwhome on all models for now, delete later if not needed 
			# preserve other per appliance non os volumes in VolGroup00, 100 series concentrator, R710 logcollector and ipdbextractor, asus mini decoder no longer supported
			elif [[ `echo "$lvdev" | grep -i '^concentrator'` ]] || [[ `echo "$lvdev" | grep -i 'lchome'` ]] || [[ `echo "$lvdev" | grep -i 'ipdbext'` ]]; then
				let mysize=${#mydevices[@]}
				let counter=0
				while [ $counter -lt $mysize ]
				do
					if [[ `echo "${mydevices[$counter]}" | grep "/dev/VolGroup00/$lvdev"` || `echo "${mydevices[$counter]}" | grep "/dev/mapper/VolGroup00-$lvdev"` ]]; then
						echo "${mydevices[$counter]} ${mymounts[$counter]} ${myformats[$counter]}" >> $APPMNTS
					fi
					let counter=counter+1
				done
			fi
		done
		
		### debug statements ###
		#echo > /dev/tty3
		#echo 'sleeping indefinitely' > /dev/tty3
		#sleep 99999	
		
		
		# if series s4s check for newport configuration 
		if [ $nwsystem = dell-s4s-1u ]; then
			if check_for_newport_drives
			then	
				inewport=True
			fi
		fi	
		
		# create upgrade lv for user prompt flag and disaster recovery, remove in %post
		lvcreate -n rsaupgdtry -L 2048k /dev/mapper/VolGroup00
		lvchange -ay /dev/mapper/VolGroup00-rsaupgdtry
		mkfs.ext4 /dev/mapper/VolGroup00-rsaupgdtry
		mount -t ext4 /dev/mapper/VolGroup00-rsaupgdtry /tmp/mnt
		echo -n "$bkuproot" > /tmp/mnt/bkuproot.txt
		echo -n "$rootfsuuid" > /tmp/mnt/rootfsuuid.txt
		umount /tmp/mnt

		# get physical volume size
		vgsize=`pvs --units g -o vg_name,pv_size | grep 'VolGroup00' | awk '{print $2}'`
		let vgsize=${vgsize%%\.[0-9]*[gG]}
		# not a dell r610 or r710
		if [ $vgsize -gt 100 ] && ! [[ $nwsystem = dell-s4-1u || $nwsystem = dell-s4-2U ]] ; then
			# remove netwitness volume, i.e. /var/netwitness	
			if [[ `ls /dev/mapper/VolGroup00-home` ]]; then
				echo "deleting logical volume: /dev/Volgroup00/home" | tee -a /tmp/pre.log > /dev/tty3
				lvremove -f /dev/VolGroup00/home
			elif [[ `ls /dev/mapper/VolGroup00-nwhome` ]]; then
				echo "deleting logical volume: /dev/Volgroup00/nwhome" | tee -a /tmp/pre.log > /dev/tty3
				lvremove -f /dev/VolGroup00/nwhome
			fi 
			echo "$upsz_root_volumes" >> $SYSPARTS
		# dell r610 nwx
		elif [[ $vgsize -gt 100 && $nwsystem = dell-s4-1u ]]; then
			if ! [ $baknwhome ]; then
				# remove netwitness volume, i.e. /var/netwitness	
				if [[ `ls /dev/mapper/VolGroup00-home` ]]; then
					echo "deleting logical volume: /dev/Volgroup00/home" | tee -a /tmp/pre.log > /dev/tty3 
					lvremove -f /dev/VolGroup00/home
				elif [[ `ls /dev/mapper/VolGroup00-nwhome` ]]; then
					echo "deleting logical volume: /dev/Volgroup00/nwhome" | tee -a /tmp/pre.log > /dev/tty3
					lvremove -f /dev/VolGroup00/nwhome
				fi
				echo "$upsz_root_volumes" >> $SYSPARTS
			else
				echo '# OS partitions on the RAID 1 volume on the internal drives
logvol / --fstype=ext4 --name=root --vgname=VolGroup00 --size=16384
logvol swap --fstype=swap --name=swap --vgname=VolGroup00 --size=20480
logvol /tmp --fstype=ext4 --name=tmp --vgname=VolGroup00 --size=20480 --fsoptions="nosuid"
logvol /var --fstype=ext4 --name=var --vgname=VolGroup00 --size=12288
logvol /var/tmp --fstype=ext4 --name=vartmp --vgname=VolGroup00 --size=6144 --fsoptions="nosuid" 
logvol /home --fstype=ext4 --name=usrhome --vgname=VolGroup00 --size=2048 --fsoptions="nosuid"
logvol /var/lib/rabbitmq --fstype=xfs --name=rabmq --vgname=VolGroup00 --size=20480 --fsoptions="nosuid,noatime"' >> $SYSPARTS
			fi
		# series s4s non newport: r620 w/4 hdd, netwitness volume not in VolGroup00, i.e. sa core or sa server series 4s appliance
		elif [ $vgsize -lt 100 ] && [ $nwsystem = dell-s4s-1u ] && ! [ $inewport ]; then
			if ! [ $rabmqvol ]; then
				# check for free space in VolGroup01, first mirrored pair approximately 147 GB
				vgfreemb=`vgs --units m -o vg_name,vg_free | grep VolGroup01 | awk '{print $2}'`
				vgfreemb=${vgfreemb%%\.*}
				let vgfreemb=${vgfreemb%m}
				if [ $vgfreemb -ge 20480 ]; then
					echo 'logvol /var/lib/rabbitmq --vgname=VolGroup01 --size=20480 --fstype=xfs --name=rabmq --fsoptions="nosuid"' >> $SYSPARTS
				else
					nospace=true
				fi
			fi
			# move SD card /tmp volume to disk
			if [[ `grep -E 'VolGroup00.*[[:space:]]+/tmp[[:space:]]+' /tmp/cfgbak/fstab` ]]; then
				# check for free space in VolGroup01, first mirrored pair approximately 147 GB
				vgfreemb=`vgs --units m -o vg_name,vg_free | grep VolGroup01 | awk '{print $2}'`
				vgfreemb=${vgfreemb%%\.*}
				let vgfreemb=${vgfreemb%m}
				if [ $vgfreemb -ge 20480 ]; then
					echo 'logvol /tmp --vgname=VolGroup01 --size=20480 --fstype=xfs --name=tmp --fsoptions="nosuid"' >> $SYSPARTS
				else
					nospace=true
				fi
			fi
			# create non existing disk log volume
			if ! [[ `grep -E 'VolGroup01.*[[:space:]]+/var/log[[:space:]]+' /tmp/cfgbak/fstab` ]]; then
				# check for free space in VolGroup01, first mirrored pair approximately 147 GB
				vgfreemb=`vgs --units m -o vg_name,vg_free | grep VolGroup01 | awk '{print $2}'`
				vgfreemb=${vgfreemb%%\.*}
				let vgfreemb=${vgfreemb%m}
				if [ $vgfreemb -ge 10240 ]; then
					echo 'logvol /var/log --vgname=VolGroup01 --size=10240 --fstype=xfs --name=varlog --fsoptions="nosuid"' >> $SYSPARTS		
				else
					nospace=true
				fi			
			fi
			if [ $nospace ]; then
				echo "$old_eusb_root_volumes" >> $SYSPARTS
			else
				echo "$eusb_root_volumes" >> $SYSPARTS
                        fi
		# series s4s aio or hybrid and newport, i.e. r620 w/10 hdd, only available space is in VolGroup03 
		elif [ $vgsize -lt 100 ] && [ $nwsystem = dell-s4s-1u ] && [ $inewport ] && [[  $nwapptype = logaio || $nwapptype = loghybrid || $nwapptype = packetaio ]] || [ $nwapptype = packethybrid ]; then
			echo "$old_eusb_root_volumes" >> $SYSPARTS
			if ! [ $rabmqvol ]; then
				# check for free space in VolGroup03, single HW RAID0 volume approximatelt 933 GB
				vgfreemb=`vgs --units m -o vg_name,vg_free | grep VolGroup03 | awk '{print $2}'`
				vgfreemb=${vgfreemb%%\.*}
				let vgfreemb=${vgfreemb%m}
				if [ $vgfreemb -ge 20480 ]; then
					echo 'logvol /var/lib/rabbitmq --vgname=VolGroup03 --size=20480 --fstype=xfs --name=rabmq --fsoptions="nosuid"' >> $SYSPARTS		
				fi
			fi	
		# series s4s non aio, hybrid or maprwh and newport: r620 w/10 hdd, i.e. esa and possible archiver or broker on maprwh reinstalls
		elif [ $vgsize -lt 100 ] && [ $nwsystem = dell-s4s-1u ] && [ $inewport ] && ! [[  $nwapptype = logaio || $nwapptype = loghybrid || $nwapptype = packetaio ]] && ! [[ $nwapptype = packethybrid || $nwapptype = maprwh ]]; then
			# possible free space available in VolGroup01 physical volume
			echo "$eusb_root_volumes" >> $SYSPARTS 
			if ! [ $rabmqvol ]; then
				# check for free space in VolGroup01, HW RAID5 volume 
				vgfreemb=`vgs --units m -o vg_name,vg_free | grep VolGroup01 | awk '{print $2}'`
				vgfreemb=${vgfreemb%%\.*}
				let vgfreemb=${vgfreemb%m}
				if [ $vgfreemb -ge 20480 ]; then
					echo 'logvol /var/lib/rabbitmq --vgname=VolGroup01 --size=20480 --fstype=xfs --name=rabmq --fsoptions="nosuid"' >> $SYSPARTS
					newrabmq=true
				fi
				if ! [ $newrabmq ]; then 
					# check for free pv space
					freespace=`parted -s unit s "/dev/${installdev[1]}" print free | grep -i -E 'Free[[:space:]]+Space' | tail -n1 | awk '{print $3}'`
					let freespace=${freespace%s} 
					if [ $freespace -gt 41943040 ]; then
						startspace=`parted -s unit s "/dev/${installdev[1]}" print free | grep -i -E 'Free[[:space:]]+Space' | tail -n1 | awk '{print $2}'`
						let startspace=${startspace%s}
						endspace=`expr $startspace+41943040`
						parted -s /dev/${installdev[1]} unit s mkpart primary ext2 "$startspace"s "$endspace"s
						partnum=`parted -s /dev/${installdev[1]} print | grep -E '[[:digit:]]' | tail -n1 | awk '{print $1}'`
						parted -s /dev/${installdev[1]} set $partnum lvm on
						pvcreate -ff /dev/"${installdev[1]}$partnum"
						vgextend VolGroup01 /dev/"${installdev[1]}$partnum"
						echo 'logvol /var/lib/rabbitmq --vgname=VolGroup01 --size=1 --grow --fstype=xfs --name=rabmq --fsoptions="nosuid"' >> $SYSPARTS
						newrabmq=true
					fi
 				fi	
				
			fi	
		# series 100 supermicro, except series 100 supermicro concentrator and all of series 4, which had 100GB+ hdd
		elif [ $vgsize -lt 100 ] && ! [[ $nwsystem = dell-s4-2u || $nwsystem = dell-s4s-1u || $nwapptype = concentrator ]]; then 
			# remove netwitness volume, i.e. /var/netwitness	
			if [[ `ls /dev/mapper/VolGroup00-home` ]]; then
				echo "deleting logical volume: /dev/Volgroup00/home" | tee -a /tmp/pre.log > /dev/tty3 
				lvremove -f /dev/VolGroup00/home
			elif [[ `ls /dev/mapper/VolGroup00-nwhome` ]]; then
				echo "deleting logical volume: /dev/Volgroup00/nwhome" | tee -a /tmp/pre.log > /dev/tty3
				lvremove -f /dev/VolGroup00/nwhome
			fi 
			echo "$root_volumes" >> $SYSPARTS
			if [ $rabmqvol ]; then
				echo 'logvol /var/netwitness --fstype=xfs --name=nwhome --vgname=VolGroup00 --size=1 --grow --fsoptions="nosuid,noatime"' >> $SYSPARTS
			else
				echo 'logvol /var/netwitness --fstype=xfs --name=nwhome --vgname=VolGroup00 --size=12288 --fsoptions="nosuid,noatime"
logvol /var/lib/rabbitmq --fstype=xfs --name=rabmq --vgname=VolGroup00 --size=1 --grow --fsoptions="nosuid,noatime"' >> $SYSPARTS
			fi
		# series 100 sm concentrator	
		elif [ $vgsize -lt 100 ] && ! [[ $nwsystem = dell-s4-2u || $nwsystem = dell-s4s-1u ]] && [ $nwapptype = concentrator ]; then 
			# remove netwitness volume, i.e. /var/netwitness	
			if [[ `ls /dev/mapper/VolGroup00-home` ]]; then
				echo "deleting logical volume: /dev/Volgroup00/home" | tee -a /tmp/pre.log > /dev/tty3 
				lvremove -f /dev/VolGroup00/home
			elif [[ `ls /dev/mapper/VolGroup00-nwhome` ]]; then
				echo "deleting logical volume: /dev/Volgroup00/nwhome" | tee -a /tmp/pre.log > /dev/tty3
				lvremove -f /dev/VolGroup00/nwhome
			fi
			echo "$root_volumes" >> $SYSPARTS
			if [ $rabmqvol ]; then
				echo 'logvol /var/netwitness --fstype=xfs --name=nwhome --vgname=VolGroup00 --size=1 --grow --fsoptions="nosuid,noatime"' >> $SYSPARTS
			else
				echo 'logvol /var/netwitness --fstype=xfs --name=nwhome --vgname=VolGroup00 --size=12288 --fsoptions="nosuid,noatime"
logvol /var/lib/rabbitmq --fstype=xfs --name=rabmq --vgname=VolGroup00 --size=1 --grow --fsoptions="nosuid,noatime"' >> $SYSPARTS
			fi		 
		# Dell R710 logcollector
		elif [ $vgsize -lt 100 ] && [ $nwsystem = dell-s4-2u ] && [ $nwapptype = logcollector ]; then 
			# remove netwitness volume, i.e. /var/netwitness	
			if [[ `ls /dev/mapper/VolGroup00-home` ]]; then
				echo "deleting logical volume: /dev/Volgroup00/home" | tee -a /tmp/pre.log > /dev/tty3 
				lvremove -f /dev/VolGroup00/home
			elif [[ `ls /dev/mapper/VolGroup00-nwhome` ]]; then
				echo "deleting logical volume: /dev/Volgroup00/nwhome" | tee -a /tmp/pre.log > /dev/tty3
				lvremove -f /dev/VolGroup00/nwhome
			fi 		
			# no space left to create rabbitmq volume
			echo 'logvol / --fstype=ext4 --name=root --vgname=VolGroup00 --size=8192
logvol swap --fstype=swap --name=swap --vgname=VolGroup00 --size=16384
logvol /tmp --fstype=ext4 --name=tmp --vgname=VolGroup00 --size=8192 --fsoptions="nosuid"
logvol /var --fstype=ext4 --name=var --vgname=VolGroup00 --size=4096
logvol /var/tmp --fstype=ext4 --name=vartmp --vgname=VolGroup00 --size=4096 --fsoptions="nosuid"
logvol /home --fstype=ext4 --name=usrhome --vgname=VolGroup00 --size=2048 --fsoptions="nosuid"
logvol /var/netwitness --fstype=xfs --name=nwhome --vgname=VolGroup00 --size=1 --grow --fsoptions="nosuid,noatime"' >> $SYSPARTS
		# Dell R710 ipdbextractor
		elif [ $vgsize -lt 100 ] && [ $nwsystem = dell-s4-2u ] && [ $nwapptype = ipdbextractor ]; then	
			# remove netwitness volume, i.e. /var/netwitness	
			if [[ `ls /dev/mapper/VolGroup00-home` ]]; then
				echo "deleting logical volume: /dev/Volgroup00/home" | tee -a /tmp/pre.log > /dev/tty3 
				lvremove -f /dev/VolGroup00/home
			elif [[ `ls /dev/mapper/VolGroup00-nwhome` ]]; then
				echo "deleting logical volume: /dev/Volgroup00/nwhome" | tee -a /tmp/pre.log > /dev/tty3
				lvremove -f /dev/VolGroup00/nwhome
			fi
			# only one volume group VolGroup00 
			echo 'logvol / --fstype=ext4 --name=root --vgname=VolGroup00 --size=16384
ogvol swap --fstype=swap --name=swap --vgname=VolGroup00 --size=16384
logvol /tmp --fstype=ext4 --name=tmp --vgname=VolGroup00 --size=8192 --fsoptions="nosuid"
logvol /var --fstype=ext4 --name=var --vgname=VolGroup00 --size=12288
logvol /var/tmp --fstype=ext4 --name=vartmp --vgname=VolGroup00 --size=4096 --fsoptions="nosuid"
logvol /home --fstype=ext4 --name=usrhome --vgname=VolGroup00 --size=2048 --fsoptions="nosuid"
logvol /var/netwitness --fstype=xfs --name=nwhome --vgname=VolGroup00 --size=30720  --fsoptions="nosuid,noatime"
logvol /var/lib/rabbitmq --fstype=xfs --name=rabmq --vgname=VolGroup00 --size=20480  --fsoptions="nosuid,noatime"' >> $SYSPARTS
		fi
		
		# get installation logical block devices list
		detect_install_devices
		echo -n "installdev = " >> /tmp/pre.log
		echo "${installdev[@]}" >> /tmp/pre.log
		echo -n "installmodel = " >> /tmp/pre.log
		echo "${installmodel[@]}" >> /tmp/pre.log

		# generate upgrade partitioning schema 
		let numloops=${#mydevices[@]}
		let count=0
		# ignore all volumes other than VolGroup00, add mounts in %post
		while [ $count -lt $numloops ]
		do
			# standard partition
			# boot labels
			if [[ `echo "${mydevices[$count]}" | grep -i '/dev/[hs]d[a-z][0-9]'` ]]; then
				if [[ `echo  "${mymounts[$count]}" | grep -i '/boot'` ]]; then
					# incase /boot is not mounted as LABEL or UUID set by hardware and install method
					if [[ "$nwsystem" = 'dell-s4s-1u' || "$nwsystem" = 'dell-s4-1u' ]]; then
						devname="${installdev[0]}1"
					elif [ "$nwsystem" = 'dell-s3-2u' ]; then
						devname="${installdev[2]}1"
					elif [[ "$nwsystem" = 'dell-s3-1u' || "$nwsystem" = 'dell-s3-1u-brok' ]]; then
						devname="${installdev[0]}1"
					elif [[ "$nwsystem" = 'sm-s3-1u' || "$nwsystem" = 'sm-s3-1u-brok' ]] && [ $installtype ]; then
						devname=sdb1
					elif [[ "$nwsystem" = 'sm-s3-1u' || "$nwsystem" = 'sm-s3-1u-brok' ]] && ! [ $installtype ]; then
						devname=sda1				
					fi	
					if [[ `echo "${myformats[$count]}" | grep 'ext[2-3]'` ]]; then
						echo "part ${mymounts[$count]} --onpart=$devname --fstype=ext4" >> $SYSPARTS
						#echo "part ${mymounts[$count]} --onpart=$devname --fstype=ext4" > /dev/tty3
						#sleep 10
					else
						echo "part ${mymounts[$count]} --onpart=$devname --fstype=${myformats[$count]}" >> $SYSPARTS
						#echo "part ${mymounts[$count]} --onpart=$devname --fstype=${myformats[$count]}" > /dev/tty3
						#sleep 10
					fi
				else
					echo "${mydevices[$count]} ${mymounts[$count]} ${myformats[$count]}" >> $APPMNTS
				fi
			# label mounts
			elif [[ `echo "${mydevices[$count]}" | grep -i 'LABEL'` ]]; then
				echo "${mydevices[$count]} ${mymounts[$count]} ${myformats[$count]}" >> $APPMNTS 
			# uuid mounts
			elif [[ `echo "${mydevices[$count]}" | grep -i 'UUID'` ]]; then
				echo "${mydevices[$count]} ${mymounts[$count]} ${myformats[$count]}" >> $APPMNTS
			# software raid
			elif [[ `echo "${mydevices[$count]}" | grep -i '/dev/md[0-9]'` ]]; then
				# re-use linux raid boot mirror
				if [[ `echo  "${mymounts[$count]}" | grep -i 'boot'` ]]; then
					devname="${mydevices[$count]}"
					devname=${devname#/dev/}
					# /boot should always be a mirror
					local partone=`cat /proc/mdstat | grep "$devname" | awk '{print $5}'`
					partone=${partone%\[[0-9]\]}
					local parttwo=`cat /proc/mdstat | grep "$devname" | awk '{print $6}'`
					parttwo=${parttwo%\[[0-9]\]}
					if [[ `echo "${myformats[$count]}" | grep 'ext[2-3]'` ]]; then 
						#echo "raid ${mymounts[$count]} --device=$devname --useexisting $partone $parttwo --fstype=ext4" >> $SYSPARTS
						echo "raid ${mymounts[$count]} --device=$devname --useexisting --fstype=ext4" >> $SYSPARTS
					else
						#echo "raid ${mymounts[$count]} --device=$devname --useexisting $partone $parttwo --fstype=${myformats[$count]}" >> $SYSPARTS
						echo "raid ${mymounts[$count]} --device=$devname --useexisting --fstype=${myformats[$count]}" >> $SYSPARTS
					fi
				else
					echo "${mydevices[$count]} ${mymounts[$count]} ${myformats[$count]}" >> $APPMNTS
				
				fi
			# cifs/nfs	
			elif [[ `echo "${myformats[$count]}" | grep -i 'cifs'` || `echo "${myformats[$count]}" | grep -i 'nfs'` ]]; then 
				echo "${mydevices[$count]} ${mymounts[$count]} ${myformats[$count]} ${myoptions[$count]}" >> $APPMNTS
			# swap 	
			elif [[ `echo "${myformats[$count]}" | grep -i 'swap'` ]] && ! [[ `echo "${mydevices[$count]}" | grep -i 'VolGroup00'` ]]; then
				echo "${mydevices[$count]} ${mymounts[$count]} ${myformats[$count]}" >> $APPMNTS		
			# logical volume
			else
				# skip system volumes, VolGrouop00, unless using netwitness home as backup device
				if [[ `echo ${mydevices[$count]} | grep 'VolGroup00.nwhome'` && $baknwhome ]]; then
					echo "${mydevices[$count]} ${mymounts[$count]} xfs" >> $APPMNTS
				elif ! [[ `echo ${mydevices[$count]} | grep 'VolGroup00'` ]]; then
					echo "${mydevices[$count]} ${mymounts[$count]} ${myformats[$count]}" >> $APPMNTS
				else
					let count=$count+1
					continue
				fi
			fi

			let count=$count+1
		done
		
		# debug statements
		# verify /tmp/nwpart.txt
		#echo "completed upgrade function, sleeping indefinitely" > /dev/tty3
		#sleep 99999
		#exit 1
		
		chvt 1

	else
		# install/re-install system
		make_install_parts $nwsystem
	fi 
}

function sysreboot {
	echo > /dev/tty3
	echo > /dev/tty3
	echo "-------------------------------------------------" > /dev/tty3
	echo " System reboot required to continue installation" > /dev/tty3
	echo " Please run installation again on next restart" > /dev/tty3
	echo " Rebooting system in 15 seconds ..." > /dev/tty3
	echo "-------------------------------------------------" > /dev/tty3
	echo > /dev/tty3
	sleep 15
	exit 1
}

function getnumld {
	if [ -z $1 ]; then
		echo "raid adapter id parameter required, exiting"
		return 1
	fi
	local ADPID=$1
	local MEGACLI='/usr/bin/MegaCLI'
	numld=`$MEGACLI -ldgetnum -a$ADPID | grep -i 'number' | awk -F: '{print $2}' | awk '{print $1}'`
	echo "number of vd on raid controller $ADPID: $numld" >> /tmp/pre.log
	return 0
}

function getoshddsize {
# determine size of sata planar internal drives	
	local blockdev
	local item
	local size
	local planarATA
	
	blockdev=( `ls /sys/block | grep 'sd[a-z]'` )
	for item in ${blockdev[@]}
	do
		if [[ `cat /sys/block/$item/device/vendor | grep -i 'ATA'` ]]; then
			planarATA=true
			break
		fi
	done
	if [ $planarATA ]; then
		size=`parted -s /dev/$item print | grep -i -E "^[[:space:]]*Disk[[:space:]]+/dev/$item" | awk '{print $3}'`
		let size=${size%%[a-zA-Z]*}
		if [ $size -ge 140 ]; then
			return 0
		else
			return 1
		fi
	fi	
	return 1
}

function make_install_parts {
# create anaconda partition script for installs
	if [ -z $2 ]; then
		local usrChoice
		chvt 3
		echo "-----------------------------------------------------" > /dev/tty3
		echo " This system is eligble for an Install or Re-install" > /dev/tty3
		echo " Installs/Re-installs clear all partitions and data" > /dev/tty3
		echo " If upgrading please quit and retry, if the problem" > /dev/tty3
		echo " persists quit again and contact product support" > /dev/tty3 	
		echo " Please quit and backup any data before proceeding" > /dev/tty3 
		echo " Enter Y to Install/Re-install, Q to Quit" > /dev/tty3
		echo "-----------------------------------------------------" > /dev/tty3 
		exec < /dev/tty3 > /dev/tty3 2>&1	
		#read -p " Proceed or Quit, defaults to Yes in 120 seconds Y/Q? " usrChoice 
		read -t 120 -p " Proceed or Quit, defaults to Yes in 120 seconds Y/Q? " usrChoice
		if [[ "$usrChoice" = 'q' || "$usrChoice" = 'Q' ]]; then
			exit 1
		fi
	fi
	
	# determine if any lvm volume groups resident on internal storage have been detected by the installer kernel, requires restart
	local uselvm=true
	vgs > /tmp/vgs.txt 2>&1
	if ! [[ `grep -E 'VolGroup0[[:digit:]]+' /tmp/vgs.txt` ]]; then
		unset uselvm
	fi

        # get installation logical block devices list
	detect_install_devices
	echo -n "installdev = " >> /tmp/pre.log
	echo "${installdev[@]}" >> /tmp/pre.log
	echo -n "installmodel = " >> /tmp/pre.log
	echo "${installmodel[@]}" >> /tmp/pre.log
	
	# define partition script file
	local SYSPARTS='/tmp/nwpart.txt'
	
	if [ -z $1 ]; then
		echo "invalid install parameter provided" > /dev/tty3
		echo "install cannot continue, exiting"	> /dev/tty3
		sleep 30
		exit 1
	fi
	
	local nwsystype="$1"
	
	if ! [ $numld ]; then
		if [ "$nwsystype" = 'dell-s4-1u' ]; then
			getnumld 1
		else
			getnumld 0
		fi
	fi

	# get os hdd size for intel mckay creek/sm 1200/1200n/2400/2400n appliances
	# planar ATA disks, sizes vary from 73 GB - 160 GB
	local upsizeos
	if getoshddsize 
	then
		upsizeos=true
	fi	
	
	# create install/re-install partitioning schema
	
	### Archiver: S4S - S9 ###
	
	### dell S4S Archiver appliance Dell R620 w/IDSDM ###
        # overloaded image for both S4S and S4S Newport
        # 3 hardware RAID1, 2 @ 32 GB SD Card, 2 @ 147 GB and 2 @ 1 TB
        # 1 hardware RAID1 and 1 hardware RAID5, 2 @ 32 GB SD Card, 9 @ 1 TB w/hotspare
        if [[ "$nwsystype" = 'dell-s4s-1u' && "$nwapptype" = 'archiver' ]]; then
                echo "creating partition script for s4s archiver" >> /tmp/pre.log
                # one SD Card RAID1 Device: 0 and either two HW RAID1 Devices: 1, 2 or one HW RAID5 Device: 1
                mk_disk_labels ${installdev[@]}
                if [ $uselvm ]; then
                        sysreboot
                fi
                # check for idsdm device
                let index4s=0
                if [[ `echo "${installmodel[$index4s]}" | grep -i 'Internal Dual SD'` ]]; then
                        #echo "part pv.idsdm --size=1 --grow --ondisk=${installdev[$index4s]}
#volgroup VolGroup09 pv.idsdm" >> $SYSPARTS
                #echo "$idsdm_volumes" >> $SYSPARTS
                        let index4s=$index4s+1
                fi
                writeBootRaid ${installdev[$index4s]}
                local psize
                local tenprcnt
                if [ $inewport ]; then
                        psize=`parted -s /dev/${installdev[$index4s]} unit s print | grep -i -E "Disk[[:space:]]+/dev/${installdev[$index4s]}" | awk -F: '{print $2}' | awk '{print $1}'`
                        let psize=${psize%s}
                        let psize=`expr $psize / 2 / 1024`
                        tenprcnt=`python -c "myvar=$psize; print myvar * 0.1"`
                        let tenprcnt=${tenprcnt%\.*}
                        let psize=$psize-$tenprcnt
                        echo "part pv.nwsto --size=$psize --ondisk=${installdev[$index4s]}
volgroup VolGroup00 pv.nwsto" >> $SYSPARTS
                        echo  'logvol / --vgname=VolGroup00 --size=8192 --fstype=ext4 --name=root
logvol swap --vgname=VolGroup00 --size=4096 --fstype=swap --name=swap00
logvol /home --vgname=VolGroup00 --size=4096 --fstype=ext4 --name=usrhome --fsoptions="nosuid"
logvol /opt --vgname=VolGroup00 --size=10240 --fstype=ext4 --name=opt --fsoptions="nosuid"
logvol /var --vgname=VolGroup00 --size=8192 --fstype=ext4 --name=var
logvol /var/log --vgname=VolGroup00 --size=10240 --fstype=ext4 --name=varlog
logvol /var/tmp --vgname=VolGroup00 --size=4096 --fstype=ext4 --name=vartmp --fsoptions="nosuid"
logvol /tmp --vgname=VolGroup00 --size=20480 --fstype=ext4 --name=tmp --fsoptions="nosuid"
logvol /var/netwitness --vgname=VolGroup00 --size=30720 --fstype=xfs --name=nwhome --fsoptions="nosuid,noatime"
logvol /var/lib/rabbitmq --vgname=VolGroup00 --size=20480 --fstype=xfs --name=rabmq --fsoptions="nosuid"
logvol /var/netwitness/workbench --vgname=VolGroup00 --size=1048576 --fstype=xfs --name=workbench --fsoptions="nosuid,noatime"
logvol /var/netwitness/archiver --vgname=VolGroup00 --size=1 --grow --fstype=xfs --name=archiver --fsoptions="nosuid,noatime"' >> $SYSPARTS
                else
                        psize=`parted -s /dev/${installdev[$index4s+1]} unit s print | grep -i -E "Disk[[:space:]]+/dev/${installdev[$index4s+1]}" | awk -F: '{print $2}' | awk '{print $1}'`
                        let psize=${psize%s}
                        let psize=`expr $psize / 2 / 1024`
                        tenprcnt=`python -c "myvar=$psize; print myvar * 0.1"`
                        let tenprcnt=${tenprcnt%\.*}
                        let psize=$psize-$tenprcnt
                        echo "part pv.nwsto --size=1 --grow --ondisk=${installdev[$index4s]}
part pv.nwsto2 --size=$psize --ondisk=${installdev[$index4s+1]}
volgroup VolGroup00 pv.nwsto
volgroup VolGroup01 pv.nwsto2" >> $SYSPARTS
                        echo  'logvol / --vgname=VolGroup00 --size=8192 --fstype=ext4 --name=root
logvol swap --vgname=VolGroup00 --size=2048 --fstype=swap --name=swap00
logvol /home --vgname=VolGroup00 --size=4096 --fstype=ext4 --name=usrhome --fsoptions="nosuid"
logvol /opt --vgname=VolGroup00 --size=10240 --fstype=ext4 --name=opt --fsoptions="nosuid"
logvol /var --vgname=VolGroup00 --size=8192 --fstype=ext4 --name=var
logvol /var/lib/rabbitmq --vgname=VolGroup00 --size=20480 --fstype=xfs --name=rabmq --fsoptions="nosuid"
logvol /var/log --vgname=VolGroup00 --size=10240 --fstype=ext4 --name=varlog
logvol /var/netwitness --vgname=VolGroup00 --size=30720 --fstype=xfs --name=nwhome --fsoptions="nosuid,noatime"
logvol /var/tmp --vgname=VolGroup00 --size=4096 --fstype=ext4 --name=vartmp --fsoptions="nosuid"
logvol /tmp --vgname=VolGroup00 --size=20480 --fstype=ext4 --name=tmp --fsoptions="nosuid"
logvol swap --vgname=VolGroup01 --size=2048 --fstype=swap --name=swap01
logvol /var/netwitness/workbench --vgname=VolGroup01 --size=512000 --fstype=xfs --name=workbench --fsoptions="nosuid,noatime"
logvol /var/netwitness/archiver --vgname=VolGroup01 --size=1 --grow --fstype=xfs --name=archiver --fsoptions="nosuid,noatime"' >> $SYSPARTS
                fi

	### dell nwx series 9 archiver, Dell R630 ###
	# 2 hardware RAID1, 2 @ 1 TB and 2 @ 2 TB
	elif [[ "$nwsystype" = 'dell-s9-1u' ]] && [[ "$nwapptype" = 'archiver' ]]; then
		echo "creating partition script for s9 archiver" >> /tmp/pre.log
		# two HW RAID1 Devices: VD0, VD1
		mk_disk_labels ${installdev[@]}
		if [ $uselvm ]; then
			sysreboot
		fi
		writeBootRaid ${installdev[0]} 
		echo "part pv.root --size=262144 --ondisk=${installdev[0]}
part pv.apps --size=1 --grow --ondisk=${installdev[1]}
volgroup VolGroup00 pv.root
volgroup VolGroup01 pv.apps" >> $SYSPARTS
		echo "$sv_root_volumes" >> $SYSPARTS
		echo 'logvol /var/netwitness/archiver --vgname=VolGroup01 --size=1048576 --fstype=xfs --name=archiver --fsoptions="nosuid,noatime"
logvol /var/netwitness/workbench --vgname=VolGroup01 --size=1 --grow --fstype=xfs --name=workbench --fsoptions="nosuid,noatime"' >> $SYSPARTS

	### Broker: S2 - S9 ###	

	### sm 100 series broker ###
	# multiple software RAID1, 4 @ 1 TB drives, no hardware RAID
	elif [[ "$nwsystype" = 'sm-s2-1u' && "$nwapptype" = 'broker' ]]; then
		echo "creating partition script for 100 broker" >> /tmp/pre.log
		if [ $installtype ]; then
			mk_disk_labels sdb sdc
			if [ $uselvm ]; then
				sysreboot
			fi
			writeBootRaid sdb sdc
			echo 'part raid.8 --size=71680 --ondisk=sdb
part raid.7 --size=71680 --ondisk=sdc
part raid.13 --size=1 --grow --ondisk=sdb
part raid.12 --size=1 --grow --ondisk=sdc' >> $SYSPARTS 
		else
			mk_disk_labels sda sdb
			if [ $uselvm ]; then
				sysreboot
			fi
			writeBootRaid sda sdb
			echo 'part raid.8 --size=71680 --ondisk=sda
part raid.7 --size=71680 --ondisk=sdb
part raid.13 --size=1 --grow --ondisk=sda
part raid.12 --size=1 --grow --ondisk=sdb' >> $SYSPARTS
		fi	
		echo '# The second partition on each internal drive also holds a mirror.  This will be used
## for a big volume group to hold the remainder of the data.
raid pv.1 --fstype "physical volume (LVM)" --level=RAID1 --device=md1 raid.8 raid.7
raid pv.2 --fstype "physical volume (LVM)" --level=RAID1 --device=md2 raid.13 raid.12
## the OS Mirror becomes a LVM PV
volgroup VolGroup00 pv.1
volgroup VolGroup01 pv.2' >> $SYSPARTS 
		echo "$root_volumes" >> $SYSPARTS 
		echo 'logvol /var/netwitness --vgname=VolGroup00 --size=1 --grow --fstype=xfs --name=nwhome --fsoptions="nosuid"
logvol /var/lib/rabbitmq --vgname=VolGroup01 --size=20480 --fstype=xfs --name=rabmq --fsoptions="nosuid"
logvol /var/netwitness/broker --vgname=VolGroup01 --size=204800 --fstype=xfs --name=broker --fsoptions="nosuid,noatime"' >> $SYSPARTS 
	
	### dell 200 & supermicro 200 series broker ###
	# single hardware RAID5 volume: 3 @ 1TB w/hotspare
	elif [[ "$nwsystype" = 'dell-s3-1u-brok' || "$nwsystype" = 'sm-s3-1u-brok' ]] && [[ "$nwapptype" = 'broker' ]]; then
		cho "creating partition script for 200 broker" >> /tmp/pre.log
		# one HW RAID5 Device: 0
		mk_disk_labels ${installdev[@]} 
		if [ $uselvm ]; then
			sysreboot
		fi
		writeBootRaid ${installdev[0]}
		echo "part pv.root --size=143360 --ondisk=${installdev[0]}
part pv.1 --size=1 --grow --ondisk=${installdev[0]}" >> $SYSPARTS
		echo 'volgroup VolGroup00 pv.root
volgroup VolGroup01 pv.1' >> $SYSPARTS 
		echo "$upsz_root_volumes" >> $SYSPARTS 
		echo 'logvol /var/netwitness/broker --vgname=VolGroup01 --size=204800 --fstype=xfs --name=broker --fsoptions="nosuid,noatime"' >> $SYSPARTS
	
	### dell nwx series 4 broker, Dell R610 ###
	# 2 hardware RAID1, 2 @ 160 GB and 2 @ 1 TB
	elif [[ "$nwsystype" = 'dell-s4-1u' ]] && [[ "$nwapptype" = 'broker' ]]; then
		echo "creating partition script for s4 broker" >> /tmp/pre.log 
		# two HW RAID1 Devices: 0, 1 
		mk_disk_labels ${installdev[@]} 
		if [ $uselvm ]; then
			sysreboot
		fi
		writeBootRaid ${installdev[0]} 
		echo "part pv.root --size=1 --grow --ondisk=${installdev[0]}
part pv.apps --size=1 --grow --ondisk=${installdev[1]}
volgroup VolGroup00 pv.root
volgroup VolGroup01 pv.apps" >> $SYSPARTS
		echo "$upsz_root_volumes" >> $SYSPARTS
		echo 'logvol /var/netwitness/broker --vgname=VolGroup01 --size=204800 --fstype=xfs --name=broker --fsoptions="nosuid,noatime"' >> $SYSPARTS

        ### dell nwx series 4S broker, Dell R620 ###
        # overloaded image for both the S4S and S4S Newport
        # 3 hardware RAID1, 2 @ 32 GB SD Card, 2 @ 147 GB and 2 @ 1 TB
        # 1 hardware RAID1 and 1 hardware RAID5, 2 @ 32 GB SD Card, 9 @ 1 TB w/hotspare
        elif [[ "$nwsystype" = 'dell-s4s-1u' ]] && [[ "$nwapptype" = 'broker' ]]; then
                echo "creating partition script for s4s broker" >> /tmp/pre.log
                # one SD Card RAID Device: 0, either two HW RAID1 Devices: 1, 2 or one HW RAID5 device: 1
                mk_disk_labels ${installdev[@]}
                if [ $uselvm ]; then
                        sysreboot
                fi
                # check for idsdm device
                let index4s=0
                if [[ `echo "${installmodel[$index4s]}" | grep -i 'Internal Dual SD'` ]]; then
                        #echo "part pv.idsdm --size=1 --grow --ondisk=${installdev[$index4s]}
#volgroup VolGroup09 pv.idsdm" >> $SYSPARTS
                        #echo "$idsdm_volumes" >> $SYSPARTS
                        let index4s=$index4s+1
                fi
                writeBootRaid ${installdev[$index4s]}
                if [ $inewport ]; then
                        local psize
                        local tenprcnt
                        psize=`parted -s /dev/${installdev[$index4s]} unit s print | grep -i -E "Disk[[:space:]]+/dev/${installdev[$index4s]}" | awk -F: '{print $2}' | awk '{print $1}'`
                        let psize=${psize%s}
                        let psize=`expr $psize / 2 / 1024`
                        tenprcnt=`python -c "myvar=$psize; print myvar * 0.1"`
                        let tenprcnt=${tenprcnt%\.*}
                        let psize=$psize-$tenprcnt
                        echo  "part pv.nwsto --size=$psize --ondisk=${installdev[$index4s]}" >> $SYSPARTS
                        echo 'volgroup VolGroup00 pv.nwsto
logvol / --vgname=VolGroup00 --size=8192 --fstype=ext4 --name=root
logvol swap --vgname=VolGroup00 --size=4096 --fstype=swap --name=swap00
logvol /home --vgname=VolGroup00 --size=4096 --fstype=ext4 --name=usrhome --fsoptions="nosuid"
logvol /opt --vgname=VolGroup00 --size=10240 --fstype=ext4 --name=opt --fsoptions="nosuid"
logvol /var --vgname=VolGroup00 --size=8192 --fstype=ext4 --name=var
logvol /var/tmp --vgname=VolGroup00 --size=4096 --fstype=ext4 --name=vartmp --fsoptions="nosuid"
logvol /var/netwitness --vgname=VolGroup00 --size=30720 --fstype=xfs --name=nwhome --fsoptions="nosuid,noatime"
logvol /var/log --vgname=VolGroup00 --size=10240 --fstype=ext4 --name=varlog
logvol /tmp --vgname=VolGroup00 --size=20480 --fstype=ext4 --name=tmp --fsoptions="nosuid"
logvol /var/netwitness/broker --vgname=VolGroup00 --size=204800 --fstype=xfs --name=broker --fsoptions="nosuid,noatime"
logvol /var/lib/rabbitmq --vgname=VolGroup00 --size=20480 --fstype=xfs --name=rabmq --fsoptions="nosuid"' >> $SYSPARTS
                else
                        echo "part pv.nwsto --size=1 --grow --ondisk=${installdev[$index4s]}
part pv.nwsto2 --size=1 --grow --ondisk=${installdev[$index4s+1]}" >> $SYSPARTS
                        echo 'volgroup VolGroup00 pv.nwsto
volgroup VolGroup01 pv.nwsto2
logvol / --vgname=VolGroup00 --size=8192 --fstype=ext4 --name=root
logvol /home --vgname=VolGroup00 --size=4096 --fstype=ext4 --name=usrhome --fsoptions="nosuid"
logvol /opt --vgname=VolGroup00 --size=10240 --fstype=ext4 --name=opt --fsoptions="nosuid"
logvol /var --vgname=VolGroup00 --size=8192 --fstype=ext4 --name=var
logvol /var/tmp --vgname=VolGroup00 --size=4096 --fstype=ext4 --name=vartmp --fsoptions="nosuid"
logvol swap --vgname=VolGroup00 --size=2048 --fstype=swap --name=swap00
logvol /var/netwitness --vgname=VolGroup00 --size=30720 --fstype=xfs --name=nwhome --fsoptions="nosuid,noatime"
logvol /var/log --vgname=VolGroup00 --size=10240 --fstype=ext4 --name=varlog
logvol /tmp --vgname=VolGroup00 --size=20480 --fstype=ext4 --name=tmp --fsoptions="nosuid"
logvol /var/lib/rabbitmq --vgname=VolGroup00 --size=20480 --fstype=xfs --name=rabmq --fsoptions="nosuid"
logvol swap --vgname=VolGroup01 --size=2048 --fstype=swap --name=swap01
logvol /var/netwitness/broker --vgname=VolGroup01 --size=204800 --fstype=xfs --name=broker --fsoptions="nosuid,noatime"' >> $SYSPARTS
                fi
	
	### dell nwx series 9 broker, Dell R630 ###
	# 2 hardware RAID1, 2 @ 1 TB and 2 @ 2 TB
	elif [[ "$nwsystype" = 'dell-s9-1u' ]] && [[ "$nwapptype" = 'broker' ]]; then
		echo "creating partition script for s9 broker" >> /tmp/pre.log 
		# two HW RAID1 Devices: VD0, VD1 
		mk_disk_labels ${installdev[@]} 
		if [ $uselvm ]; then
			sysreboot
		fi
		writeBootRaid ${installdev[0]} 
		echo "part pv.root --size=262144 --ondisk=${installdev[0]}
part pv.apps --size=106496 --ondisk=${installdev[1]}
volgroup VolGroup00 pv.root
volgroup VolGroup01 pv.apps" >> $SYSPARTS
		echo "$sv_root_volumes" >> $SYSPARTS
		echo 'logvol /var/netwitness/broker --vgname=VolGroup01 --size=1 --grow --fstype=xfs --name=broker --fsoptions="nosuid,noatime"' >> $SYSPARTS
	
	### Concentrator: S2 - S9 ###	

	### sm 100 series concentrator ###
	# multiple software RAID1 and standard partitions, 4 @ 1 TB, no hardware RAID
	elif [[ "$nwsystype" = 'sm-s2-1u-conc' && "$nwapptype" = 'concentrator' ]]; then
		echo "creating partiton script for 100 concentrator" >> /tmp/pre.log
		if [ $installtype ]; then
			mk_disk_labels sdb sdc sdd sde
			writeBootRaid sdb sdc
			echo 'part raid.20 --size=71680 --ondisk=sdb
part raid.21 --size=71680 --ondisk=sdc
part raid.30 --size=1 --grow --ondisk=sdb
part raid.31 --size=1 --grow --ondisk=sdc
# next two internal drives
# one dedicated to databases, the other to sessionDB
part /var/lib/rabbitmq --size=20480 --ondisk=sdd --fstype=xfs --fsoptions="nosuid"
part /var/netwitness/concentrator/sessiondb --size=1 --grow --ondisk=sdd --fstype=xfs --fsoptions="nosuid,noatime"
part /var/netwitness/concentrator/index --size=1 --grow --ondisk=sde --fstype=xfs --fsoptions="nosuid,noatime"' >> $SYSPARTS
		else
			mk_disk_labels sda sdb sdc sdd
			writeBootRaid sda sdb
			echo 'part raid.20 --size=71680 --ondisk=sda
part raid.21 --size=71680 --ondisk=sdb
part raid.30 --size=1 --grow --ondisk=sda
part raid.31 --size=1 --grow --ondisk=sdb
# next two internal drives
# one dedicated to databases, the other to sessionDB
part /var/lib/rabbitmq --size=20480 --ondisk=sdc --fstype=xfs --fsoptions="nosuid"
part /var/netwitness/concentrator/sessiondb --size=1 --grow --ondisk=sdc --fstype=xfs --fsoptions="nosuid,noatime"
part /var/netwitness/concentrator/index --size=1 --grow --ondisk=sdd --fstype=xfs --fsoptions="nosuid,noatime"' >> $SYSPARTS
		fi 

		echo '# The second partition on each internal drive also holds a mirror.  This will be used
# for a big volume group to hold the remainder of the data.
raid pv.1 --fstype "physical volume (LVM)" --level=RAID1 --device=md1 raid.20 raid.21
raid /var/netwitness/concentrator/metadb --fstype xfs --fsoptions="nosuid,noatime" --level=RAID0 --device=md2 raid.30 raid.31
# the OS Mirror becomes a LVM PV
volgroup VolGroup00 pv.1
logvol /var/netwitness/concentrator --vgname=VolGroup00 --size=30720 --name=concentrator --fstype=xfs --fsoptions="nosuid,noatime"
logvol /var/netwitness --vgname=VolGroup00 --size=1 --grow --fstype=xfs --name=nwhome --fsoptions="nosuid"' >> $SYSPARTS
		echo "$root_volumes" >> $SYSPARTS

	### intel mckay creek 1200 and supermicro 1200/1200n/2400/2400n series concentrator ###
	# 1 hardware RAID1 and 2 hardware RAID 5
	# mckay creek: 2 @ 73 GB - 160 GB, 8 @ 1 TB, 3 @ 1 TB w/global hot spare 
	elif [[ "$nwsystype" = 'mckaycreek' || "$nwsystype" = 'sm-s2-2u' || "$nwsystype" = 'sm-s3-2u' ]] && [[ "$nwapptype" = 'concentrator' ]]; then
		echo "creating partition script for 1200/1200n/2400/2400n concentrator" >> /tmp/pre.log
		if [ $installtype ]; then 
			mk_disk_labels sdb sdc sdd sde
			if [ $uselvm ]; then
				sysreboot
			fi
			writeBootRaid sdd sde
			echo '# root partition raid:  root fs is mirrored for safety, but is in a LVM group
# for flexibility
part raid.20 --size=1 --grow --ondisk=sdd
part raid.21 --size=1 --grow --ondisk=sde
part pv.01 --size=1 --grow --ondisk=sdb
part pv.02 --size=1 --grow --ondisk=sdc' >> $SYSPARTS 
		else
			mk_disk_labels sda sdb sdc sdd
			if [ $uselvm ]; then
				sysreboot
			fi
			writeBootRaid sdc sdd
			echo '# root partition raid:  root fs is mirrored for safety, but is in a LVM group
# for flexibility
part raid.20 --size=1 --grow --ondisk=sdc
part raid.21 --size=1 --grow --ondisk=sdd
part pv.01 --size=1 --grow --ondisk=sda
part pv.02 --size=1 --grow --ondisk=sdb' >> $SYSPARTS 
		fi 
		echo '# second mirror is a LVM physical volume
raid pv.root --fstype "physical volume (LVM)" --level=RAID1 --device=md1 raid.20 raid.21
# ... and it is the only member of the VolGroup00 volume group
volgroup VolGroup00 pv.root' >> $SYSPARTS 
		if [ $upsizeos ]; then
			echo "$upsz_root_volumes" >> $SYSPARTS
		else 
			echo "$root_volumes" >> $SYSPARTS
		fi
		echo 'volgroup concentrator pv.01
volgroup index pv.02' >> $SYSPARTS  
		if ! [ $$upsizeos ]; then
			echo 'logvol /var/netwitness --vgname=VolGroup00 --size=1 --grow --fstype=xfs --name=nwhome --fsoptions="nosuid" 
logvol /var/lib/rabbitmq --vgname=concentrator --size=20480 --fstype=xfs --name=rabmq --fsoptions="nosuid"' >> $SYSPARTS
		fi	
		echo 'logvol /var/netwitness/concentrator --vgname=concentrator --size=30720 --name=concroot --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/concentrator/sessiondb --vgname=concentrator --size=368640 --name=concsess --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/concentrator/metadb --vgname=concentrator --size=1 --grow --name=concmeta --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/concentrator/index --vgname=index --size=1 --grow --name=concinde --fstype=xfs --fsoptions="noatime,nosuid"' >> $SYSPARTS

	### dell 2400 series concentrator ###
	# 1 hardware RAID1 and 2 hardware RAID5: 2 @ 136 GB, 6 @ 2 TB w/hotspare, 5 @ 160 GB SSD
	elif [[ "$nwsystype" = 'dell-s3-2u' ]] && [[ "$nwapptype" = 'concentrator' ]]; then 
		echo "creating partition script for dell 2400 concentrator" >> /tmp/pre.log
		# application is two HW RAID5 Devices: 0, 1 and system is one HW RAID1 Device: 2
		mk_disk_labels ${installdev[@]}
		if [ $uselvm ]; then
			sysreboot
		fi
		writeBootRaid ${installdev[2]} 
		echo "part pv.root --size=1 --grow --ondisk=${installdev[2]}
part pv.conc --size=1 --grow --ondisk=${installdev[0]} --asprimary
part pv.concinde --size=1 --grow --ondisk=${installdev[1]} --asprimary
volgroup VolGroup00 pv.root" >> $SYSPARTS
		echo "$upsz_root_volumes" >> $SYSPARTS
		echo 'volgroup concentrator pv.conc
volgroup index pv.concinde
logvol /var/netwitness/concentrator --vgname=concentrator --size=30720 --name=concroot --fstype=xfs --fsoptions="nosuid,noatime" 
logvol /var/netwitness/concentrator/index --vgname=index --size=1 --grow --name=concinde --fstype=xfs --fsoptions="nosuid,noatime" 
logvol /var/netwitness/concentrator/sessiondb --vgname=concentrator --size=368640  --name=concsess --fstype=xfs --fsoptions="nosuid,noatime" 
logvol /var/netwitness/decoder --vgname=concentrator --size=20480 --name=decoroot --fstype=ext4 --fsoptions="nosuid,noatime" 
logvol /var/netwitness/concentrator/metadb --vgname=concentrator --size=1 --grow --name=concmeta --fstype=xfs --fsoptions="nosuid,noatime"' >> $SYSPARTS

	### dell series 4s concentrator, Dell R620 ###
        # three hardware RAID1, 2 @ 32 GB SD Card, 2 @ 147 GB and 2 @ 1 TB
        elif [[ "$nwsystype" = 'dell-s4s-1u' ]] && [[ "$nwapptype" = 'concentrator' ]]; then
                echo "creating partition script for s4s nwx concentrator" >> /tmp/pre.log
                # one SD Card RAID1 Device: 0, two HW RAID1 Devices: 1, 2
                mk_disk_labels ${installdev[@]}
                if [ $uselvm ]; then
                        sysreboot
                fi
                # check for idsdm device
                let index4s=0
                if [[ `echo "${installmodel[$index4s]}" | grep -i 'Internal Dual SD'` ]]; then
                        #echo "part pv.idsdm --size=1 --grow --ondisk=${installdev[$index4s]}
#volgroup VolGroup09 pv.idsdm" >> $SYSPARTS
                #echo "$idsdm_volumes" >> $SYSPARTS
                        let index4s=$index4s+1
                fi
                writeBootRaid ${installdev[$index4s]}
                echo "part pv.nwsto --size=1 --grow --ondisk=${installdev[$index4s]}
part pv.nwsto2 --size=1 --grow --ondisk=${installdev[$index4s+1]}
volgroup VolGroup00 pv.nwsto
volgroup VolGroup01 pv.nwsto2" >> $SYSPARTS
                echo 'logvol / --vgname=VolGroup00 --size=8192 --fstype=ext4 --name=root
logvol swap --vgname=VolGroup00 --size=2048 --fstype=swap --name=swap00
logvol /home --vgname=VolGroup00 --size=4096 --fstype=ext4 --name=usrhome --fsoptions="nosuid"
logvol /opt --vgname=VolGroup00 --size=10240 --fstype=ext4 --name=opt --fsoptions="nosuid"
logvol /var --vgname=VolGroup00 --size=8192 --fstype=ext4 --name=var
logvol /var/lib/rabbitmq --vgname=VolGroup00 --size=20480 --fstype=xfs --name=rabmq --fsoptions="nosuid"
logvol /var/log --vgname=VolGroup00 --size=10240 --fstype=ext4 --name=varlog
logvol /var/netwitness --vgname=VolGroup00 --size=30720 --fstype=xfs --name=nwhome --fsoptions="nosuid,noatime"
logvol /var/tmp --vgname=VolGroup00 --size=4096 --fstype=ext4 --name=vartmp --fsoptions="nosuid"
logvol /tmp --vgname=VolGroup00 --size=20480 --fstype=ext4 --name=tmp --fsoptions="nosuid"
logvol swap --vgname=VolGroup01 --size=2048 --fstype=swap --name=swap01' >> $SYSPARTS

	### dell nwx series 9 concentrator, Dell R630 ###
	# 2 hardware RAID1, 2 @ 1 TB and 2 @ 2 TB
	elif [[ "$nwsystype" = 'dell-s9-1u' ]] && [[ "$nwapptype" = 'concentrator' ]]; then
		echo "creating partition script for s9 nwx concentrator" >> /tmp/pre.log
		# two HW RAID1 Devices: VD0, VD1
		mk_disk_labels ${installdev[@]}
		if [ $uselvm ]; then
			sysreboot
		fi
		writeBootRaid ${installdev[0]} 
		echo "part pv.root --size=262144 --ondisk=${installdev[0]}
volgroup VolGroup00 pv.root" >> $SYSPARTS 
		echo "$sv_root_volumes" >> $SYSPARTS

	### Concentrator/Decoder Head Unit: S4 ###

	### dell nwx series 4 concentrator or decoder, Dell R610 ###
	# 2 hardware RAID1, 2 @ 160 GB and 2 @ 1 TB
	elif [[ "$nwsystype" = 'dell-s4-1u' ]] && [[ "$nwapptype" = 'concentrator' || "$nwapptype" = 'decoder' ]]; then
		echo "creating partition script for s4 nwx concentrator/decoder" >> /tmp/pre.log
		# two HW RAID1 Devices: 0, 1
		mk_disk_labels ${installdev[@]}
		if [ $uselvm ]; then
			sysreboot
		fi
		writeBootRaid ${installdev[0]} 
		echo "part pv.root --size=1 --grow --ondisk=${installdev[0]}
volgroup VolGroup00 pv.root" >> $SYSPARTS 
		echo "$upsz_root_volumes" >> $SYSPARTS 

	### Decoder: S2 - S9 ###

	### sm 100 series decoder ###
	# multiple software RAID1, 4 @ 1 TB, no hardware RAID
	elif [[ "$nwsystype" = 'sm-s2-1u' && "$nwapptype" = 'decoder' ]]; then
		echo "creating partiton script for 100 decoder" >> /tmp/pre.log
		if [ $installtype ]; then
			mk_disk_labels sdb sdc
			if [ $uselvm ]; then
				sysreboot
			fi
			writeBootRaid sdb sdc
			echo 'part raid.8 --size=71680 --ondisk=sdb
part raid.7 --size=71680 --ondisk=sdc
part raid.13 --size=1 --grow --ondisk=sdb
part raid.12 --size=1 --grow --ondisk=sdc' >> $SYSPARTS 
		else
			mk_disk_labels sda sdb
			if [ $uselvm ]; then
				sysreboot
			fi
			writeBootRaid sda sdb
			echo 'part raid.8 --size=71680 --ondisk=sda
part raid.7 --size=71680 --ondisk=sdb
part raid.13 --size=1 --grow --ondisk=sda
part raid.12 --size=1 --grow --ondisk=sdb' >> $SYSPARTS
		fi	
		echo '# The second partition on each internal drive also holds a mirror.  This will be used
## for a big volume group to hold the remainder of the data.
raid pv.1 --fstype "physical volume (LVM)" --level=RAID1 --device=md1 raid.8 raid.7
raid pv.2 --fstype "physical volume (LVM)" --level=RAID1 --device=md2 raid.13 raid.12
## the OS Mirror becomes a LVM PV
volgroup VolGroup00 pv.1
volgroup VolGroup01 pv.2' >> $SYSPARTS 
		echo "$root_volumes" >> $SYSPARTS 
		echo 'logvol /var/netwitness --vgname=VolGroup00 --size=1 --grow --fstype=xfs --name=nwhome --fsoptions="nosuid"
logvol /var/lib/rabbitmq --vgname=VolGroup01 --size=20480 --fstype=xfs --name=rabmq --fsoptions="nosuid"
logvol /var/netwitness/decoder --vgname=VolGroup01 --size=30720 --name=decoroot --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/decoder/metadb --vgname=VolGroup01 --size=204800 --name=decometa --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/decoder/sessiondb --vgname=VolGroup01 --size=102400 --name=decosess --fstype=xfs --fsoptions="noatime,nosuid" 
logvol /var/netwitness/decoder/index --vgname=VolGroup01 --size=102400 --name=decoinde --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/decoder/packetdb --vgname=VolGroup01 --size=1 --grow --name=decopack --fstype=xfs --fsoptions="noatime,nosuid"' >> $SYSPARTS

	### intel mckay creek 1200 and supermicro 1200/2400n series decoder ###
	# 2 hardware RAID5 and 1 software RAID1 
	elif [[ "$nwsystype" = 'mckaycreek' || "$nwsystype" = 'sm-s3-2u' || "$nwsystype" = 'sm-s2-2u' ]] && [[ "$nwapptype" = 'decoder' ]]; then
		echo "creating partition script for 1200/1200n/2400/2400n decoder" >> /tmp/pre.log
		if [ $installtype ]; then
			mk_disk_labels sdb sdc sdd sde
			if [ $uselvm ]; then
				sysreboot
			fi
			writeBootRaid sdd sde
			echo '# root partition raid:  root fs is mirrored for safety, but is in a LVM group
# for flexibility
part raid.20 --size=1 --grow --ondisk=sdd
part raid.21 --size=1 --grow --ondisk=sde
part pv.01 --size=1 --ondisk=sdb --grow
part pv.02 --size=1 --ondisk=sdc --grow' >> $SYSPARTS
		else
			mk_disk_labels sda sdb sdc sdd
			if [ $uselvm ]; then
				sysreboot
			fi
			writeBootRaid sdc sdd
			echo '# root partition raid:  root fs is mirrored for safety, but is in a LVM group
# for flexibility
part raid.20 --size=1 --grow --ondisk=sdc
part raid.21 --size=1 --grow --ondisk=sdd
part pv.01 --size=1 --ondisk=sda --grow
part pv.02 --size=1 --ondisk=sdb --grow' >> $SYSPARTS
		fi
		echo '# second mirror is a LVM physical volume
raid pv.root --fstype "physical volume (LVM)" --level=RAID1 --device=md1 raid.20 raid.21
# ... and it is the only member of the VolGroup00 volume group
volgroup VolGroup00 pv.root' >> $SYSPARTS 
		 if [ $upsizeos ]; then
			echo "$upsz_root_volumes" >> $SYSPARTS
		else 
			echo "$root_volumes" >> $SYSPARTS
		fi
		echo 'volgroup decodersmall pv.02
volgroup decoder pv.01' >>  $SYSPARTS
		if ! [ $upsizeos ]; then
			echo 'logvol /var/netwitness --vgname=VolGroup00 --size=1 --grow --fstype=xfs --name=nwhome --fsoptions="nosuid"
logvol /var/lib/rabbitmq --vgname=decodersmall --size=20480 --fstype=xfs --name=rabmq --fsoptions="nosuid"' >> $SYSPARTS
		fi
echo 'logvol /var/netwitness/decoder --vgname=decodersmall --size=30720 --name=decoroot --fstype=xfs --fsoptions="nosuid,noatime"
logvol /var/netwitness/decoder/index --vgname=decodersmall --size=30720 --name=decoinde --fstype=xfs --fsoptions="nosuid,noatime"
logvol /var/netwitness/decoder/sessiondb --vgname=decodersmall --size=256000 --name=decosess --fstype=xfs --fsoptions="nosuid,noatime"
logvol /var/netwitness/decoder/metadb --vgname=decodersmall --size=1 --grow --name=decometa --fstype=xfs --fsoptions="nosuid,noatime" 
logvol /var/netwitness/decoder/packetdb --vgname=decoder --size=1 --grow --name=decopack --fstype=xfs  --fsoptions="nosuid,noatime"' >> $SYSPARTS

 	### dell 1200/2400 series decoder ###
	# 1 hardware RAID1 and 2 hardware RAID5, 2 @ 136 GB, 8 @ 1 TB - 2 TB, 3 @ 1 TB - 2 TB w/global hot spare
	elif [[  "$nwsystype" = 'dell-s3-2u' ]] && [[ "$nwapptype" = 'decoder' ]]; then
		echo "creating partition script for dell 1200/2400 decoder" >> /tmp/pre.log
		# application is two HW RAID5 Devices: 0, 1 and system is one HW RAID1 Device: 2
		mk_disk_labels ${installdev[@]} 
		if [ $uselvm ]; then
			sysreboot
		fi
		writeBootRaid ${installdev[2]}
		echo "part pv.root --size=1 --grow --ondisk=${installdev[2]}
part pv.decosmall --size=1 --grow --ondisk=${installdev[1]} --asprimary
part pv.deco --size=1 --grow --ondisk=${installdev[0]} --asprimary 
volgroup VolGroup00 pv.root" >> $SYSPARTS
		echo "$upsz_root_volumes" >> $SYSPARTS
		echo 'volgroup decodersmall pv.decosmall
volgroup decoder pv.deco
logvol /var/netwitness/decoder --vgname=decodersmall --size=30720 --name=decoroot --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/decoder/index --vgname=decodersmall --size=30720 --name=index --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/decoder/sessiondb --vgname=decodersmall --size=256000 --name=sessiondb --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/decoder/metadb --vgname=decodersmall --size=100 --grow --name=metadb --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/decoder/packetdb --vgname=decoder --size=100 --grow --name=packetdb --fstype=xfs --fsoptions="noatime,nosuid"' >> $SYSPARTS

	### dell series 4s decoder, Dell R620 ###
        # three hardware RAID1, 2 @ 32 GB SD Card, 2 @ 147 GB and 2 @ 1 TB
        elif [[ "$nwsystype" = 'dell-s4s-1u' ]] && [[ "$nwapptype" = 'decoder' ]]; then
                echo "creating partition script for s4s nwx decoder" >> /tmp/pre.log
                # one SD Card RAID1 Device: 0, two HW RAID1 Devices: 1, 2
                mk_disk_labels ${installdev[@]}
                if [ $uselvm ]; then
                        sysreboot
                fi
                # check for idsdm device
                let index4s=0
                if [[ `echo "${installmodel[$index4s]}" | grep -i 'Internal Dual SD'` ]]; then
                        #echo "part pv.idsdm --size=1 --grow --ondisk=${installdev[$index4s]}
#volgroup VolGroup09 pv.idsdm" >> $SYSPARTS
                #echo "$idsdm_volumes" >> $SYSPARTS
                        let index4s=$index4s+1
                fi
                writeBootRaid ${installdev[$index4s]}
                echo "part pv.nwsto --size=1 --grow --ondisk=${installdev[$index4s]}
part pv.nwsto2 --size=1 --grow --ondisk=${installdev[$index4s+1]}
volgroup VolGroup00 pv.nwsto
volgroup VolGroup01 pv.nwsto2" >> $SYSPARTS
                echo 'logvol / --vgname=VolGroup00 --size=8192 --fstype=ext4 --name=root
logvol swap --vgname=VolGroup00 --size=2048 --fstype=swap --name=swap00
logvol /home --vgname=VolGroup00 --size=4096 --fstype=ext4 --name=usrhome --fsoptions="nosuid"
logvol /opt --vgname=VolGroup00 --size=10240 --fstype=ext4 --name=opt --fsoptions="nosuid"
logvol /var --vgname=VolGroup00 --size=8192 --fstype=ext4 --name=var
logvol /var/netwitness --vgname=VolGroup00 --size=30720 --fstype=xfs --name=nwhome --fsoptions="nosuid,noatime"
logvol /var/tmp --vgname=VolGroup00 --size=4096 --fstype=ext4 --name=vartmp --fsoptions="nosuid"
logvol /var/log --vgname=VolGroup00 --size=10240 --fstype=ext4 --name=varlog
logvol /tmp --vgname=VolGroup00 --size=20480 --fstype=ext4 --name=tmp --fsoptions="nosuid"
logvol /var/lib/rabbitmq --vgname=VolGroup00 --size=20480 --fstype=xfs --name=rabmq --fsoptions="nosuid"
logvol swap --vgname=VolGroup01 --size=2048 --fstype=swap --name=swap01
logvol /var/netwitness/warehouseconnector --vgname=VolGroup01 --size=409600 --fstype=xfs --name=warec --fsoptions="nosuid,noatime"' >> $SYSPARTS

	### dell nwx series 9 decoder R630 ###
	# 2 hardware RAID1, 2 @ 1 TB and 2 @ 2 TB
	elif [[ "$nwsystype" = 'dell-s9-1u' ]] && [[ "$nwapptype" = 'decoder' ]]; then
		echo "creating partition script for s9 nwx decoder" >> /tmp/pre.log
		# two HW RAID1 Devices: VD0, VD1
		mk_disk_labels ${installdev[@]}
		if [ $uselvm ]; then
			sysreboot
		fi
		writeBootRaid ${installdev[0]} 
		echo "part pv.root --size=262144 --ondisk=${installdev[0]}
volgroup VolGroup00 pv.root
part pv.apps --size=409600 --ondisk=${installdev[1]}
volgroup VolGroup01 pv.apps" >> $SYSPARTS 
		echo "$sv_root_volumes" >> $SYSPARTS	
		echo 'logvol /var/netwitness/warehouseconnector --vgname=VolGroup01 --size=1 --grow --fstype=xfs --name=warec --fsoptions="nosuid,noatime"' >> $SYSPARTS 
	
	### ESA: S4S - S7 ###

        ### dell S4S ESA appliance Dell R620 w/IDSDM ###
        # 1 hardware RAID1, 1 hardware RAID5: 2 @ 32 GB SD Card, 9 @ 1 TB w/hot spare
        elif [[ "$nwsystype" = 'dell-s4s-1u' && "$nwapptype" = 'esa' ]]; then
                echo "creating partition script for s4s esa appliance" >> /tmp/pre.log
                # one SD Card RAID1 Device: 0 and one HW RAID5 Device: 1
                mk_disk_labels ${installdev[@]}
                if [ $uselvm ]; then
                        sysreboot
                fi
                # check for idsdm device
                let index4s=0
                if [[ `echo "${installmodel[$index4s]}" | grep -i 'Internal Dual SD'` ]]; then
                        #echo "part pv.idsdm --size=1 --grow --ondisk=${installdev[$index4s]}
#volgroup VolGroup09 pv.idsdm" >> $SYSPARTS
                #echo "$idsdm_volumes" >> $SYSPARTS
                        let index4s=$index4s+1
                fi
                writeBootRaid ${installdev[$index4s]}

                # leave 10% of 7+ TiB volume un-allocated
                local psize
                local tenprcnt
                psize=`parted -s /dev/${installdev[$index4s]} unit s print | grep -i -E "Disk[[:space:]]+/dev/${installdev[$index4s]}" | awk -F: '{print $2}' | awk '{print $1}'`
                let psize=${psize%s}
                let psize=`expr $psize / 2 / 1024`
                tenprcnt=`python -c "myvar=$psize; print myvar * 0.1"`
                let tenprcnt=${tenprcnt%\.*}
                let psize=$psize-$tenprcnt

                echo "part pv.nwsto --size=$psize --ondisk=${installdev[$index4s]}
volgroup VolGroup00 pv.nwsto" >> $SYSPARTS
                echo 'logvol / --vgname=VolGroup00 --size=8192 --fstype=ext4 --name=root
logvol swap --vgname=VolGroup00 --size=8192 --fstype=swap --name=swap00
logvol /home --vgname=VolGroup00 --size=4096 --fstype=ext4 --name=usrhome --fsoptions="nosuid"
logvol /var --vgname=VolGroup00 --size=8192 --fstype=ext4 --name=var
logvol /var/lib/rabbitmq --vgname=VolGroup00 --size=20480 --fstype=xfs --name=rabmq --fsoptions="nosuid"
logvol /var/tmp --vgname=VolGroup00 --size=4096 --fstype=ext4 --name=vartmp --fsoptions="nosuid"
logvol /var/log --vgname=VolGroup00 --size=10240 --fstype=ext4 --name=varlog
logvol /tmp --vgname=VolGroup00 --size=20480 --fstype=ext4 --name=tmp --fsoptions="nosuid"
logvol /opt --vgname=VolGroup00 --size=10240 --fstype=ext4 --name=opt
logvol /opt/rsa --vgname=VolGroup00 --size=1 --grow --fstype=xfs --name=rsaapps' >> $SYSPARTS

	### dell S9 ESA appliance Dell R630 ###
        # 1 hardware RAID1: 2 @ 1TB, 1 hardware RAID5: 3 @2TB w/hot spare
        elif [[ "$nwsystype" = 'dell-s9-1u' && "$nwapptype" = 'esa' ]]; then
                echo "creating partition script for s9 esa appliance" >> /tmp/pre.log
                # HW RAID1 Device: VD0 and HW RAID5 Device: VD1
                mk_disk_labels ${installdev[@]}
                if [ $uselvm ]; then
                        sysreboot
                fi
		writeBootRaid ${installdev[0]}
		# leave 10% of 4 TiB volume un-allocated
                local psize
                local tenprcnt
                psize=`parted -s /dev/${installdev[1]} unit s print | grep -i -E "Disk[[:space:]]+/dev/${installdev[1]}" | awk -F: '{print $2}' | awk '{print $1}'`
                let psize=${psize%s}
                let psize=`expr $psize / 2 / 1024`
                tenprcnt=`python -c "myvar=$psize; print myvar * 0.1"`
                let tenprcnt=${tenprcnt%\.*}
                let psize=$psize-$tenprcnt 
		echo "part pv.root --size=262144 --ondisk=${installdev[0]}
volgroup VolGroup00 pv.root
part pv.apps --size=$psize --ondisk=${installdev[1]}
volgroup VolGroup01 pv.apps" >> $SYSPARTS 
		echo 'logvol swap --fstype=swap --name=swap --vgname=VolGroup00 --size=4096
logvol / --fstype=ext4 --name=root --vgname=VolGroup00 --size=20480 
logvol /home --fstype=ext4 --name=usrhome --vgname=VolGroup00 --size=4096 --fsoptions="nosuid"
logvol /opt --fstype=xfs --name=opt --vgname=VolGroup00 --size=20480
logvol /var --fstype=xfs --name=var --vgname=VolGroup00 --size=20480
logvol /var/lib/rabbitmq --fstype=xfs --name=rabmq --vgname=VolGroup00 --size=20480 --fsoptions="nosuid,noatime"
logvol /var/log --fstype=xfs --name=varlog --vgname=VolGroup00 --size=16384
logvol /var/tmp --fstype=xfs --name=vartmp --vgname=VolGroup00 --size=4096 --fsoptions="nosuid"
logvol /tmp --fstype=xfs --name=tmp --vgname=VolGroup00 --size=20480 --fsoptions="nosuid"' >> $SYSPARTS 
                echo 'logvol /opt/rsa --vgname=VolGroup01 --size=1 --grow --fstype=xfs --name=rsaapps' >> $SYSPARTS

	### Logdecoder: S4 - S9 ###

	### dell nwx series 4 logdecoder, Dell R610 ###
	# 2 hardware RAID1, 2 @ 160 GB and 2 @ 1 TB
	elif [[ "$nwsystype" = 'dell-s4-1u' ]] && [[ "$nwapptype" = 'logdecoder' ]]; then
		echo "creating partition script for s4 nwx logdecoder" >> /tmp/pre.log
		# two HW RAID1 Devices: 0, 1
		mk_disk_labels ${installdev[@]} 
		if [ $uselvm ]; then
			sysreboot
		fi
		writeBootRaid ${installdev[0]} 
		echo "part pv.root --size=1 --grow --ondisk=${installdev[0]}
part pv.apps --size=1 --grow --ondisk=${installdev[1]}
volgroup VolGroup00 pv.root
volgroup VolGroup01 pv.apps" >> $SYSPARTS 
		echo "$upsz_root_volumes" >> $SYSPARTS 
		echo 'logvol /var/netwitness/warehouseconnector --vgname=VolGroup01 --size=400000 --fstype=xfs --name=warec --fsoptions="nosuid,noatime"
logvol /var/lib/rabbitmq --vgname=VolGroup01 --name=rabmq --size=250000 --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/logcollector --vgname=VolGroup01 --name=lcol --size=1 --grow --fstype=xfs --fsoptions="noatime,nosuid"' >> $SYSPARTS

	### dell S4S log decoder appliance, Dell R620 w/IDSDM ###
        # three hardware RAID1, 2 @ 32 GB SD Card, 2 @ 147 GB and 2 @ 1 TB
        elif [[ "$nwsystype" = 'dell-s4s-1u' ]] && [[ "$nwapptype" = 'logdecoder' ]]; then
                echo "creating partition script for s4s nwx logdecoder" >> /tmp/pre.log
                # one SD Card RAID1 Device: 0 and two HW RAID1 Devices: 1, 2
                mk_disk_labels ${installdev[@]}
                if [ $uselvm ]; then
                        sysreboot
                fi
                # check for idsdm device
                let index4s=0
                if [[ `echo "${installmodel[$index4s]}" | grep -i 'Internal Dual SD'` ]]; then
                        #echo "part pv.idsdm --size=1 --grow --ondisk=${installdev[$index4s]}
#volgroup VolGroup09 pv.idsdm" >> $SYSPARTS
                #echo "$idsdm_volumes" >> $SYSPARTS
                        let index4s=$index4s+1
                fi
                writeBootRaid ${installdev[$index4s]}
                echo "part pv.nwsto --size=1 --grow --ondisk=${installdev[$index4s]}
part pv.nwsto2 --size=1 --grow --ondisk=${installdev[$index4s+1]}
volgroup VolGroup00 pv.nwsto
volgroup VolGroup01 pv.nwsto2" >> $SYSPARTS
                echo 'logvol / --vgname=VolGroup00 --size=8192 --fstype=ext4 --name=root
logvol swap --vgname=VolGroup00 --size=2048 --fstype=swap --name=swap00
logvol /home --vgname=VolGroup00 --size=4096 --fstype=ext4 --name=usrhome --fsoptions="nosuid"
logvol /opt --vgname=VolGroup00 --size=10240 --fstype=ext4 --name=opt --fsoptions="nosuid"
logvol /var --vgname=VolGroup00 --size=8192 --fstype=ext4 --name=var
logvol /var/log --vgname=VolGroup00 --size=10240 --fstype=ext4 --name=varlog
logvol /var/netwitness --vgname=VolGroup00 --size=30720 --fstype=xfs --name=nwhome --fsoptions="nosuid,noatime"
logvol /var/tmp --vgname=VolGroup00 --size=4096 --fstype=ext4 --name=vartmp --fsoptions="nosuid"
logvol /tmp --vgname=VolGroup00 --size=20480 --fstype=ext4 --name=tmp --fsoptions="nosuid"
logvol swap --vgname=VolGroup01 --size=2048 --fstype=swap --name=swap01
logvol /var/netwitness/warehouseconnector --vgname=VolGroup01 --size=400000  --fstype=xfs --name=warec --fsoptions="nosuid,noatime"
logvol /var/lib/rabbitmq --vgname=VolGroup01 --size=250000 --fstype=xfs --name=rabmq --fsoptions="nosuid"
logvol /var/netwitness/logcollector --vgname=VolGroup01 --size=1 --grow --fstype=xfs --name=lcol --fsoptions="nosuid,noatime"' >> $SYSPARTS

	### dell nwx series 9 logdecoder, Dell R630 ###
	# 2 hardware RAID1, 2 @ 1TB and 2 @ 2TB
	elif [[ "$nwsystype" = 'dell-s9-1u' ]] && [[ "$nwapptype" = 'logdecoder' ]]; then
		echo "creating partition script for s9 nwx logdecoder" >> /tmp/pre.log
		# two HW RAID1 Devices: VD0, VD1
		mk_disk_labels ${installdev[@]} 
		if [ $uselvm ]; then
			sysreboot
		fi
		writeBootRaid ${installdev[0]} 
		echo "part pv.root --size=262144 --ondisk=${installdev[0]}
part pv.apps --size=1048576 --ondisk=${installdev[1]}
volgroup VolGroup00 pv.root
volgroup VolGroup01 pv.apps" >> $SYSPARTS 
		echo 'logvol swap --fstype=swap --name=swap --vgname=VolGroup00 --size=4096
logvol / --fstype=ext4 --name=root --vgname=VolGroup00 --size=20480 
logvol /home --fstype=ext4 --name=usrhome --vgname=VolGroup00 --size=4096 --fsoptions="nosuid"
logvol /opt --fstype=xfs --name=opt --vgname=VolGroup00 --size=20480 --fsoptions="nosuid"
logvol /opt/rsa --fstype=xfs --name=rsaroot --vgname=VolGroup00 --size=10240 --fsoptions="nosuid"
logvol /var --fstype=xfs --name=var --vgname=VolGroup00 --size=20480
logvol /var/log --fstype=xfs --name=varlog --vgname=VolGroup00 --size=16384
logvol /var/tmp --fstype=xfs --name=vartmp --vgname=VolGroup00 --size=4096 --fsoptions="nosuid"
logvol /tmp --fstype=xfs --name=tmp --vgname=VolGroup00 --size=20480 --fsoptions="nosuid"
logvol /var/netwitness --fstype=xfs --name=nwhome --vgname=VolGroup00 --size=30720 --fsoptions="nosuid,noatime"' >> $SYSPARTS 
		echo 'logvol /var/netwitness/warehouseconnector --vgname=VolGroup01 --size=409600 --fstype=xfs --name=warec --fsoptions="nosuid,noatime"
logvol /var/netwitness/logcollector --vgname=VolGroup01 --name=lcol --size=307200 --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/lib/rabbitmq --vgname=VolGroup01 --name=rabmq --size=1 --grow --fstype=xfs --fsoptions="noatime,nosuid"' >> $SYSPARTS

	### Log AIO: S4S ###
  
	### dell S4S Logs AIO Appliance Dell R620 w/iDSDM ###
        # 1 hardware RAID1, 2 hardware RAID5, 1 hardware RAID0: 2 @ 32 GB SD Card, 5 @ 2 TB, 4 @ 2 TB, 1 @ 1 TB
        elif [[ "$nwsystype" = 'dell-s4s-1u' && "$nwapptype" = 'logaio' ]]; then
                echo "creating partition script for s4s logaio" >> /tmp/pre.log
                # one SD Card RAID1 Device: 0, two HW RAID5 Devices: 1, 2 and one HW RAID0 Device: 3
                mk_disk_labels ${installdev[@]}
                if [ $uselvm ]; then
                        sysreboot
                fi
                # check for idsdm device
                let index4s=0
                if [[ `echo "${installmodel[$index4s]}" | grep -i 'Internal Dual SD'` ]]; then
                        #echo "part pv.idsdm --size=1 --grow --ondisk=${installdev[$index4s]}
#volgroup VolGroup09 pv.idsdm" >> $SYSPARTS
                #echo "$idsdm_volumes" >> $SYSPARTS
                        let index4s=$index4s+1
                fi
                writeBootRaid ${installdev[$index4s]}
                echo "part pv.nwsto --size=1 --grow --ondisk=${installdev[$index4s]}
part pv.nwsto2 --size=1 --grow --ondisk=${installdev[$index4s+1]}
part pv.nwsto3 --size=1 --grow --ondisk=${installdev[$index4s+2]}
volgroup VolGroup00 pv.nwsto
volgroup VolGroup01 pv.nwsto2
volgroup VolGroup02 pv.nwsto3" >> $SYSPARTS
                echo 'logvol / --vgname=VolGroup00 --size=8192 --fstype=ext4 --name=root
logvol swap --vgname=VolGroup00 --size=2048 --name=swap00 --fstype=swap
logvol /home --vgname=VolGroup00 --size=4096 --fstype=ext4 --name=usrhome --fsoptions="nosuid"
logvol /opt --vgname=VolGroup00 --size=10240 --fstype=ext4 --name=opt --fsoptions="nosuid"
logvol /var --vgname=VolGroup00 --size=8192 --fstype=ext4 --name=var
logvol /var/tmp --vgname=VolGroup00 --size=4096 --fstype=ext4 --name=vartmp --fsoptions="nosuid"
logvol /var/netwitness --vgname=VolGroup00 --size=10240 --fstype=xfs --name=nwhome --fsoptions="nosuid,noatime"
logvol /var/netwitness/broker --vgname=VolGroup00 --size=51200 --fstype=xfs --name=brokroot --fsoptions="nosuid,noatime"
logvol /var/netwitness/database --vgname=VolGroup00 --size=102400 --fstype=xfs --name=redb --fsoptions="nosuid,noatime"
logvol /var/lib/rabbitmq --vgname=VolGroup00 --size=250000 --fstype=xfs --name=rabmq --fsoptions="nosuid,noatime"
logvol /var/netwitness/logcollector --vgname=VolGroup00 --size=250000 --fstype=xfs --name=lcol --fsoptions="nosuid,noatime"
logvol /var/netwitness/logdecoder --vgname=VolGroup00 --size=30720 --name=ldecroot --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/logdecoder/index --vgname=VolGroup00 --size=10240 --name=ldecinde --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/logdecoder/metadb --vgname=VolGroup00 --size=307200 --name=ldecmeta --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/logdecoder/sessiondb --vgname=VolGroup00 --size=30720 --name=ldecsess --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/logdecoder/packetdb --vgname=VolGroup00 --size=1 --grow --name=ldecpack --fstype=xfs --fsoptions="noatime,nosuid"
#
logvol swap --vgname=VolGroup01 --size=2048 --name=swap01 --fstype=swap
logvol /var/log --vgname=VolGroup01 --size=10240 --name=varlog --fstype=ext4
logvol /tmp --vgname=VolGroup01 --size=20480 --name=tmp --fstype=ext4 --fsoptions="nosuid"
logvol /var/lib/netwitness --vgname=VolGroup01 --size=51200 --name=sahome --fstype=xfs --fsoptions="noatime,nosuid"
logvol /home/rsasoc --vgname=VolGroup01 --size=102400 --name=rsahome --fstype=ext4 --fsoptions="nosuid"
logvol /var/netwitness/nwipdbextractor --vgname=VolGroup01 --size=30720 --name=ipdbext --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/concentrator --vgname=VolGroup01 --size=30720 --name=concroot --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/concentrator/sessiondb --vgname=VolGroup01 --size=307200 --name=concsess --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/concentrator/metadb --vgname=VolGroup01 --size=1 --grow --name=concmeta --fstype=xfs --fsoptions="noatime,nosuid"
#
logvol /var/netwitness/concentrator/index --vgname=VolGroup02 --size=307200 --name=concinde --fstype=xfs --fsoptions="noatime,nosuid"' >> $SYSPARTS

	### Log Hybrid: S4S - S5 ###
        
	### dell S4S log hybrid appliance Dell R620 w/IDSDM ###
        # 1 hardware RAID1, 2 hardware RAID5, 1 hardware RAID0: 2 @ 32 GB SD Card, 5 @ 1 TB, 4 @ 1 TB, 1 @ 1 TB
        elif [[ "$nwsystype" = 'dell-s4s-1u' && "$nwapptype" = 'loghybrid' ]]; then
                echo "creating partition script for s4s log hybrid 2@RAID5" >> /tmp/pre.log
                # one SD Card RAID1 Device: 0, two HW RAID5 Devices: 2, 3 and one HW RAID0 Device: 3
                mk_disk_labels ${installdev[@]}
                if [ $uselvm ]; then
                        sysreboot
                fi
                # check for idsdm device
                let index4s=0
                if [[ `echo "${installmodel[$index4s]}" | grep -i 'Internal Dual SD'` ]]; then
                        #echo "part pv.idsdm --size=1 --grow --ondisk=${installdev[$index4s]}
#volgroup VolGroup09 pv.idsdm" >> $SYSPARTS
                #echo "$idsdm_volumes" >> $SYSPARTS
                        let index4s=$index4s+1
                fi
                writeBootRaid ${installdev[$index4s]}
                echo "part pv.nwsto --size=1 --grow --ondisk=${installdev[$index4s]}
part pv.nwsto2 --size=1 --grow --ondisk=${installdev[$index4s+1]}
part pv.nwsto3 --size=1 --grow  --ondisk=${installdev[$index4s+2]}
volgroup VolGroup00 pv.nwsto
volgroup VolGroup01 pv.nwsto2
volgroup VolGroup02 pv.nwsto3" >> $SYSPARTS
                echo 'logvol / --vgname=VolGroup00 --size=8192 --fstype=ext4 --name=root
logvol swap --vgname=VolGroup00 --size=2048 --name=swap00 --fstype=swap
logvol /home --vgname=VolGroup00 --size=4096 --fstype=ext4 --name=usrhome --fsoptions="nosuid"
logvol /opt --vgname=VolGroup00 --size=10240 --fstype=ext4 --name=opt --fsoptions="nosuid"
logvol /var --vgname=VolGroup00 --size=8192 --fstype=ext4 --name=var
logvol /var/tmp --vgname=VolGroup00 --size=4096 --fstype=ext4 --name=vartmp --fsoptions="nosuid"
logvol /var/netwitness --vgname=VolGroup00 --size=10240 --fstype=xfs --name=nwhome --fsoptions="nosuid,noatime"
logvol /var/lib/rabbitmq --vgname=VolGroup00 --size=250000 --fstype=xfs --name=rabmq --fsoptions="nosuid,noatime"
logvol /var/netwitness/logcollector --vgname=VolGroup00 --size=250000 --fstype=xfs --name=lcol --fsoptions="nosuid,noatime"
logvol /var/netwitness/logdecoder --vgname=VolGroup00 --size=30720 --name=ldecroot --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/logdecoder/index --vgname=VolGroup00 --size=10240 --name=ldecinde --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/logdecoder/metadb --vgname=VolGroup00 --size=307200 --name=ldecmeta --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/logdecoder/sessiondb --vgname=VolGroup00 --size=30720 --name=ldecsess --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/logdecoder/packetdb --vgname=VolGroup00 --size=1 --grow --name=ldecpack --fstype=xfs --fsoptions="noatime,nosuid"
#
logvol swap --vgname=VolGroup01 --size=2048 --name=swap01 --fstype=swap
logvol /var/log --vgname=VolGroup01 --size=10240 --name=varlog --fstype=ext4
logvol /tmp --vgname=VolGroup01 --size=20480 --name=tmp --fstype=ext4 --fsoptions="nosuid"
logvol /var/netwitness/concentrator --vgname=VolGroup01 --size=30720 --name=concroot --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/concentrator/sessiondb --vgname=VolGroup01 --size=307200 --name=concsess --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/concentrator/metadb --vgname=VolGroup01 --size=1 --grow --name=concmeta --fstype=xfs --fsoptions="noatime,nosuid"
#
logvol /var/netwitness/concentrator/index --vgname=VolGroup02 --size=307200 --name=concinde --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/warehouseconnector --vgname=VolGroup02 --size=400000 --name=warec --fstype=xfs --fsoptions="noatime,nosuid"' >> $SYSPARTS

	### dell S5 log hybrid appliance Dell R730 ###
        elif [[ "$nwsystype" = 'dell-s5-2u' && "$nwapptype" = 'loghybrid' ]]; then
                echo "creating partition script for s5 log hybrid" >> /tmp/pre.log
		# VD0: HW RAID1 2 @ 1TB, VD1: HW RAID1 2 @ 1TB, VD2: HW RAID5 4 @ 6TB, VD3: HW RAID5 3 @ 6TB, w/VD3:VD4 dedicated hotspare, VD4: HW RAID1 2 @ 800GB SSD 
                mk_disk_labels ${installdev[@]}
                if [ $uselvm ]; then
                        sysreboot
                fi
                writeBootRaid ${installdev[0]}
                echo "part pv.root --size=1 --grow --ondisk=${installdev[0]}
part pv.apps1 --size=1 --grow --ondisk=${installdev[1]}
part pv.apps2 --size=1 --grow --ondisk=${installdev[2]}
part pv.apps3 --size=1 --grow  --ondisk=${installdev[3]}
part pv.apps4 --size=1 --grow  --ondisk=${installdev[4]}
volgroup VolGroup00 pv.root
volgroup VolGroup01 pv.apps1
volgroup VolGroup02 pv.apps2
volgroup VolGroup03 pv.apps3
volgroup VolGroup04 pv.apps4" >> $SYSPARTS
                echo '	# VolGroup00
logvol swap --fstype=swap --name=swap --vgname=VolGroup00 --size=4096
logvol / --fstype=ext4 --name=root --vgname=VolGroup00 --size=20480
logvol /home --fstype=ext4 --name=usrhome --vgname=VolGroup00 --size=4096 --fsoptions="nosuid"
logvol /opt --fstype=xfs --name=opt --vgname=VolGroup00 --size=20480 --fsoptions="nosuid"
logvol /opt/rsa --fstype=xfs --name=rsaroot --vgname=VolGroup00 --size=10240 --fsoptions="nosuid"
logvol /var --fstype=xfs --name=var --vgname=VolGroup00 --size=20480
logvol /var/log --fstype=xfs --name=varlog --vgname=VolGroup00 --size=16384
logvol /var/tmp --fstype=xfs --name=vartmp --vgname=VolGroup00 --size=4096 --fsoptions="nosuid"
logvol /tmp --fstype=xfs --name=tmp --vgname=VolGroup00 --size=20480 --fsoptions="nosuid"
logvol /var/netwitness --fstype=xfs --name=nwhome --vgname=VolGroup00 --size=30720 --fsoptions="nosuid,noatime"
logvol /var/netwitness/logcollector --vgname=VolGroup00 --size=200000 --fstype=xfs --name=lcol --fsoptions="nosuid,noatime"
logvol /var/lib/rabbitmq --fstype=xfs --name=rabmq --vgname=VolGroup00 --size=200000 --fsoptions="nosuid,noatime"
logvol /var/netwitness/warehouseconnector --vgname=VolGroup00 --size=1 --grow --name=warec --fstype=xfs --fsoptions="noatime,nosuid"
	# VolGroup01
logvol /var/netwitness/logdecoder/metadb --vgname=VolGroup01 --size=1 --grow --name=ldecmeta --fstype=xfs --fsoptions="noatime,nosuid"
	# VolGroup02
logvol /var/netwitness/logdecoder --vgname=VolGroup02 --size=30720 --name=ldecroot --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/logdecoder/index --vgname=VolGroup02 --size=30720 --name=ldecinde --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/logdecoder/sessiondb --vgname=VolGroup02 --size=102400 --name=ldecsess --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/logdecoder/packetdb --vgname=VolGroup02 --size=1 --grow --name=ldecpack --fstype=xfs --fsoptions="noatime,nosuid"
	# VolGroup03
logvol /var/netwitness/concentrator --vgname=VolGroup03 --size=30720 --name=concroot --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/concentrator/sessiondb --vgname=VolGroup03 --size=1572864 --name=concsess --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/concentrator/metadb --vgname=VolGroup03 --size=1 --grow --name=concmeta --fstype=xfs --fsoptions="noatime,nosuid"
	# VolGroup04
logvol /var/netwitness/concentrator/index --vgname=VolGroup04 --size=1 --grow --name=concinde --fstype=xfs --fsoptions="noatime,nosuid"' >> $SYSPARTS

	### Packet AIO: S4S ###

        ### dell S4S Packet AIO appliance Dell R620 w/IDSDM ###
        # 1 hardware RAID1, 2 hardware RAID5, 1 hardware RAID0: 2 @ 32 GB SD Card, 6 @ 2 TB, 3 @ 2 TB, 1 @ 1 TB
        elif [[ "$nwsystype" = 'dell-s4s-1u' && "$nwapptype" = 'packetaio' ]]; then
                echo "creating partition script for s4s packetaio" >> /tmp/pre.log
                # one SD Card RAID1 Device: 0, two HW RAID5 Devices: 1, 2 and one HW RAID0 Device: 3
                mk_disk_labels ${installdev[@]}
                if [ $uselvm ]; then
                        sysreboot
                fi
                # check for idsdm device
                let index4s=0
                if [[ `echo "${installmodel[$index4s]}" | grep -i 'Internal Dual SD'` ]]; then
                        #echo "part pv.idsdm --size=1 --grow --ondisk=${installdev[$index4s]}
#volgroup VolGroup09 pv.idsdm" >> $SYSPARTS
                #echo "$idsdm_volumes" >> $SYSPARTS
                        let index4s=$index4s+1
                fi
                writeBootRaid ${installdev[$index4s]}
                echo "part pv.nwsto --size=1 --grow --ondisk=${installdev[$index4s]}
part pv.nwsto2 --size=1 --grow --ondisk=${installdev[$index4s+1]}
part pv.nwsto3 --size=1 --grow --ondisk=${installdev[$index4s+2]}
volgroup VolGroup00 pv.nwsto
volgroup VolGroup01 pv.nwsto2
volgroup VolGroup02 pv.nwsto3" >> $SYSPARTS
                echo 'logvol / --vgname=VolGroup00 --size=8192 --fstype=ext4 --name=root
logvol swap --vgname=VolGroup00 --size=2048 --name=swap00 --fstype=swap
logvol /home --vgname=VolGroup00 --size=4096 --fstype=ext4 --name=usrhome --fsoptions="nosuid"
logvol /opt --vgname=VolGroup00 --size=10240 --fstype=ext4 --name=opt --fsoptions="nosuid"
logvol /var --vgname=VolGroup00 --size=8192 --fstype=ext4 --name=var
logvol /var/tmp --vgname=VolGroup00 --size=4096 --fstype=ext4 --name=vartmp --fsoptions="nosuid"
logvol /var/netwitness --vgname=VolGroup00 --size=10240 --fstype=xfs --name=nwhome --fsoptions="nosuid,noatime"
logvol /var/netwitness/broker --vgname=VolGroup00 --size=51200 --name=brokroot --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/database --vgname=VolGroup00 --size=102400 --name=redb --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/decoder --vgname=VolGroup00 --size=30720 --name=decoroot --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/decoder/index --vgname=VolGroup00 --size=30720 --name=decoinde --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/decoder/metadb --vgname=VolGroup00 --size=307200 --name=decometa --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/decoder/sessiondb --vgname=VolGroup00 --size=10240 --name=decosess --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/decoder/packetdb --vgname=VolGroup00 --size=1 --grow --name=decopack --fstype=xfs --fsoptions="noatime,nosuid"
#
logvol swap --vgname=VolGroup01 --size=2048 --name=swap01 --fstype=swap
logvol /var/log --vgname=VolGroup01 --size=10240 --name=varlog --fstype=ext4
logvol /tmp --vgname=VolGroup01 --size=20480 --name=tmp --fstype=ext4 --fsoptions="nosuid"
logvol /var/lib/rabbitmq --vgname=VolGroup01 --size=20480 --fstype=xfs --name=rabmq --fsoptions="nosuid"
logvol /home/rsasoc --vgname=VolGroup01 --size=102400 --name=rehome --fstype=ext4 --fsoptions="nosuid"
logvol /var/lib/netwitness --vgname=VolGroup01 --size=51200 --name=sahome --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/nwipdbextractor --vgname=VolGroup01 --size=30720 --name=ipdbext --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/concentrator --vgname=VolGroup01 --size=30720 --name=concroot --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/concentrator/sessiondb --vgname=VolGroup01 --size=204800 --name=concsess --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/concentrator/metadb --vgname=VolGroup01 --size=1 --grow --name=concmeta --fstype=xfs --fsoptions="noatime,nosuid"
#
logvol /var/netwitness/concentrator/index --vgname=VolGroup02 --size=307200 --name=concinde --fstype=xfs --fsoptions="noatime,nosuid"' >> $SYSPARTS

	### Packet Hybrid: S2 - S5 ###
	
	### dell 200 series packet hybrid ###
	# 5 hardware RAID0 and multiple software RAID devices, 4 RAID0 - 1 @ 2 TB, 1 RAID0 - 1 @ 100 GB - 160 GB SSD
	elif [[ "$nwsystype" = 'dell-s3-2u' && "$nwapptype" = 'packethybrid' ]]; then
		echo "creating parttion script for dell 200 packet hybrid" >> /tmp/pre.log
		# five HW RAID0 Devices: 0, 1, 2, 3, 4
		mk_disk_labels ${installdev[@]} 
		if [ $uselvm ]; then
			sysreboot
		fi
	       	writeBootRaid ${installdev[0]} ${installdev[1]}
		echo "part raid.20 --size=143360 --ondisk=${installdev[0]}
part raid.21 --size=143360 --ondisk=${installdev[1]}
part pv.conc --size=1 --grow --ondisk=${installdev[0]}
part pv.index --size=1 --grow --ondisk=${installdev[4]}
# decoder stripe set is in a volume group
part raid.01 --size=1 --grow --ondisk=${installdev[1]}
part raid.02 --size=1 --grow --ondisk=${installdev[2]}
part raid.03 --size=1 --grow --ondisk=${installdev[3]}" >> $SYSPARTS 
		echo 'raid pv.root --fstype "physical volume (LVM)" --level=RAID1 --device=md1 raid.20 raid.21
# ... and it is the only member of the VolGroup00 volume group
volgroup VolGroup00 pv.root' >> $SYSPARTS 
	echo "$upsz_root_volumes" >> $SYSPARTS 
	echo 'volgroup decodersmall pv.conc 
logvol /var/netwitness/concentrator --vgname=decodersmall --size=30720 --name=concroot --fstype=xfs --fsoptions="nosuid,noatime"
logvol /var/netwitness/concentrator/sessiondb --vgname=decodersmall --size=409600 --name=concsess  --fstype=xfs --fsoptions="nosuid,noatime"
logvol /var/netwitness/concentrator/metadb --vgname=decodersmall --size=1 --grow --percent=100 --name=concmeta --fstype=xfs --fsoptions="nosuid,noatime"
volgroup index pv.index
logvol /var/netwitness/concentrator/index --vgname=index --size=1 --grow --name=concinde --fstype=xfs --fsoptions="nosuid,noatime" 
raid pv.deco --fstype "physical volume (LVM)" --level=RAID0 --device=md2 raid.01 raid.02 raid.03
volgroup decoder pv.deco
logvol /var/netwitness/decoder --vgname=decoder --size=30720 --name=decoroot --fstype=xfs --fsoptions="nosuid,noatime"
logvol /var/netwitness/decoder/metadb --vgname=decoder --size=819200 --name=decometa --fstype=xfs --fsoptions="nosuid,noatime"
logvol /var/netwitness/decoder/index --vgname=decoder --size=30720 --name=decoinde --fstype=xfs --fsoptions="nosuid,noatime"
logvol /var/netwitness/decoder/sessiondb --vgname=decoder --size=40960 --name=decosess --fstype=xfs --fsoptions="nosuid,noatime"
logvol /var/netwitness/decoder/packetdb --vgname=decoder --size=1 --grow --name=decopack --fstype=xfs --fsoptions="nosuid,noatime"' >> $SYSPARTS
	
	### supermicro 200 series packet hybrid ###
	# 4 hardware RAID0 and multiple software RAID devices, 4 RAID0 - 1 @ 2 TB, 1 @ 100 GB - 160 GB SSD planar ATA
	elif [[ "$nwsystype" = 'sm-s3-1u' && "$nwapptype" = 'packethybrid' ]]; then
		echo "creating parttion script for 200 packet hybrid" >> /tmp/pre.log
		if [ $installtype ]; then
			mk_disk_labels sdb sdc sdd sde sdf
			if [ $uselvm ]; then
				sysreboot
			fi
			writeBootRaid sdb sdc
			echo '# root partition raid:  root fs is SW mirrored for safety, but is in a LVM group
# for flexibility 
# second mirror is a LVM physical volume
part raid.20 --size=143360 --ondisk=sdb
part raid.21 --size=143360 --ondisk=sdc
# concentrator stripe set is in a volume group 
part pv.conc --size=100 --grow --ondisk=sdb
# index stripe set is also in a volume group
part pv.index --size=100 --grow --ondisk=sdf
# decoder stripe set is in a volume group
part raid.01 --size=100 --grow --ondisk=sdc
part raid.02 --size=100 --grow --ondisk=sdd
part raid.03 --size=100 --grow --ondisk=sde' >> $SYSPARTS 
		else
			mk_disk_labels sda sdb sdc sdd sde
			if [ $uselvm ]; then
				sysreboot
			fi
		       	writeBootRaid sda sdb
			echo '# root partition raid:  root fs is SW mirrored for safety, but is in a LVM group
# for flexibility 
# second mirror is a LVM physical volume
part raid.20 --size=143360 --ondisk=sda
part raid.21 --size=143360 --ondisk=sdb
# concentrator stripe set is in a volume group 
part pv.conc --size=100 --grow --ondisk=sda
# index stripe set is also in a volume group
part pv.index --size=100 --grow --ondisk=sde
# decoder stripe set is in a volume group
part raid.01 --size=100 --grow --ondisk=sdb
part raid.02 --size=100 --grow --ondisk=sdc
part raid.03 --size=100 --grow --ondisk=sdd' >> $SYSPARTS 
		fi
		echo 'raid pv.root --fstype "physical volume (LVM)" --level=RAID1 --device=md1 raid.20 raid.21
# ... and it is the only member of the VolGroup00 volume group
volgroup VolGroup00 pv.root' >> $SYSPARTS 
	echo "$upsz_root_volumes" >> $SYSPARTS 
	echo 'volgroup decodersmall pv.conc 
logvol /var/netwitness/concentrator --vgname=decodersmall --size=30720 --name=concroot --fstype=xfs --fsoptions="nosuid,noatime"
logvol /var/netwitness/concentrator/sessiondb --vgname=decodersmall --size=409600 --name=concsess  --fstype=xfs --fsoptions="nosuid,noatime"
logvol /var/netwitness/concentrator/metadb --vgname=decodersmall --size=1 --grow --percent=100 --name=concmeta --fstype=xfs --fsoptions="nosuid,noatime"
volgroup index pv.index
logvol /var/netwitness/concentrator/index --vgname=index --size=1 --grow --name=concinde --fstype=xfs --fsoptions="nosuid,noatime" 
raid pv.deco --fstype "physical volume (LVM)" --level=RAID0 --device=md2 raid.01 raid.02 raid.03
volgroup decoder pv.deco
logvol /var/netwitness/decoder --vgname=decoder --size=30720 --name=decoroot --fstype=xfs --fsoptions="nosuid,noatime"
logvol /var/netwitness/decoder/metadb --vgname=decoder --size=819200 --name=decometa --fstype=xfs --fsoptions="nosuid,noatime"
logvol /var/netwitness/decoder/index --vgname=decoder --size=30720 --name=decoinde --fstype=xfs --fsoptions="nosuid,noatime"
logvol /var/netwitness/decoder/sessiondb --vgname=decoder --size=40960 --name=decosess --fstype=xfs --fsoptions="nosuid,noatime"
logvol /var/netwitness/decoder/packetdb --vgname=decoder --size=1 --grow --name=decopack --fstype=xfs --fsoptions="nosuid,noatime"' >> $SYSPARTS

	### intel mckay creek 1200 and supermicro 1200 series packet hybrid ###
	# 1 hardware RAID1 and 2 hardware RAID5, 2 @ 73 GB - 146 GB, 4 @ 1 TB, 7 @ 1 TB w/global hot spare
	elif [[ "$nwsystype" = 'mckaycreek' || "$nwsystype" = 'sm-s2-2u' ]] && [[ "$nwapptype" = 'packethybrid' ]]; then
		echo "creating partition script for 1200 hybrid" >> /tmp/pre.log
		if [ $installtype ]; then
			mk_disk_labels sdb sdc sdd sde
			if [ $uselvm ]; then
				sysreboot
			fi
			writeBootRaid sdd sde
			echo '# root partition raid:  root fs is mirrored for safety, but is in a LVM group
# for flexibility
part raid.20 --size=1 --grow --ondisk=sdd
part raid.21 --size=1 --grow --ondisk=sde
part pv.01 --size=1 --grow --ondisk=sdb
part pv.02 --size=1 --grow --ondisk=sdc' >> $SYSPARTS 
		else
			mk_disk_labels sda sdb sdc sdd
			if [ $uselvm ]; then
				sysreboot
			fi
			writeBootRaid sdc sdd
			echo '# root partition raid:  root fs is mirrored for safety, but is in a LVM group
# for flexibility
part raid.20 --size=1 --grow --ondisk=sdc
part raid.21 --size=1 --grow --ondisk=sdd
part pv.01 --size=1 --grow --ondisk=sda
part pv.02 --size=1 --grow --ondisk=sdb' >> $SYSPARTS 
		fi 
		echo '# second mirror is a LVM physical volume
raid pv.root --fstype "physical volume (LVM)" --level=RAID1 --device=md1 raid.20 raid.21
# ... and it is the only member of the VolGroup00 volume group
volgroup VolGroup00 pv.root
volgroup concentrator pv.01
volgroup decoder pv.02' >> $SYSPARTS
		if [ $upsizeos ]; then 
			echo "$upsz_root_volumes" >> $SYSPARTS
		else
			echo "$root_volumes" >> $SYSPARTS 
			echo 'logvol /var/netwitness --vgname=VolGroup00 --size=1 --grow --fstype=xfs --name=nwhome --fsoptions="nosuid"
logvol /var/lib/rabbitmq --vgname=concentrator --size=20480 --fstype=xfs --name=rabmq --fsoptions="nosuid"' >> $SYSPARTS		
		fi
		echo "$hybrid_volumes" >> $SYSPARTS
	
        ### dell S4S packet hybrid appliance 2@RAID5 6/3 hdd, Dell R620 w/IDSDM ###
        # 1 hardware RAID1, 2 hardware RAID5, 1 hardware RAID0: 2 @ 32 GB SD Card, 6 @ 1 TB, 3 @ 1 TB, 1 @ 1 TB
        elif [[ "$nwsystype" = 'dell-s4s-1u' && "$nwapptype" = 'packethybrid' ]]; then
                echo "creating partition script for s4s packet hybrid 2@RAID5" >> /tmp/pre.log
                # one SD Card RAID1 Device: 0, two HW RAID5 Devices: 2, 3 and one HW RAID0 Device: 3
                mk_disk_labels ${installdev[@]}
                if [ $uselvm ]; then
                        sysreboot
                fi
                # check for idsdm device
                let index4s=0
                if [[ `echo "${installmodel[$index4s]}" | grep -i 'Internal Dual SD'` ]]; then
                        #echo "part pv.idsdm --size=1 --grow --ondisk=${installdev[$index4s]}
#volgroup VolGroup09 pv.idsdm" >> $SYSPARTS
                #echo "$idsdm_volumes" >> $SYSPARTS
                        let index4s=$index4s+1
                fi
                writeBootRaid ${installdev[$index4s]}
                echo "part pv.nwsto --size=1 --grow --ondisk=${installdev[$index4s]}
part pv.nwsto2 --size=1 --grow --ondisk=${installdev[$index4s+1]}
part pv.nwsto3 --size=1 --grow --ondisk=${installdev[$index4s+2]}
volgroup VolGroup00 pv.nwsto
volgroup VolGroup01 pv.nwsto2
volgroup VolGroup02 pv.nwsto3" >> $SYSPARTS
                echo 'logvol / --vgname=VolGroup00 --size=8192 --fstype=ext4 --name=root
logvol swap --vgname=VolGroup00 --size=2048 --name=swap00 --fstype=swap
logvol /home --vgname=VolGroup00 --size=4096 --fstype=ext4 --name=usrhome --fsoptions="nosuid"
logvol /opt --vgname=VolGroup00 --size=10240 --fstype=ext4 --name=opt --fsoptions="nosuid"
logvol /var --vgname=VolGroup00 --size=8192 --fstype=ext4 --name=var
logvol /var/tmp --vgname=VolGroup00 --size=4096 --fstype=ext4 --name=vartmp --fsoptions="nosuid"
logvol /var/netwitness --vgname=VolGroup00 --size=10240 --fstype=xfs --name=nwhome --fsoptions="nosuid,noatime"
logvol /var/netwitness/decoder --vgname=VolGroup00 --size=30720 --name=decoroot --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/decoder/index --vgname=VolGroup00 --size=30720 --name=decoinde --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/decoder/metadb --vgname=VolGroup00 --size=307200 --name=decometa --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/decoder/sessiondb --vgname=VolGroup00 --size=10240 --name=decosess --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/decoder/packetdb --vgname=VolGroup00 --size=1 --grow --name=decopack --fstype=xfs --fsoptions="noatime,nosuid"
#
logvol swap --vgname=VolGroup01 --size=2048 --name=swap01 --fstype=swap
logvol /var/log --vgname=VolGroup01 --size=10240 --name=varlog --fstype=ext4
logvol /tmp --vgname=VolGroup01 --size=20480 --name=tmp --fstype=ext4 --fsoptions="nosuid"
logvol /var/lib/rabbitmq --vgname=VolGroup01 --size=20480 --fstype=xfs --name=rabmq --fsoptions="nosuid"
logvol /var/netwitness/concentrator --vgname=VolGroup01 --size=30720 --name=concroot --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/concentrator/sessiondb --vgname=VolGroup01 --size=204800 --name=concsess --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/concentrator/metadb --vgname=VolGroup01 --size=1 --grow --name=concmeta --fstype=xfs --fsoptions="noatime,nosuid"
#
logvol /var/netwitness/concentrator/index --vgname=VolGroup02 --size=307200 --name=concinde --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/warehouseconnector --vgname=VolGroup02 --size=409600 --name=warec --fstype=xfs --fsoptions="noatime,nosuid"' >> $SYSPARTS
	
	### dell S5 packet hybrid appliance Dell R730 ###
        elif [[ "$nwsystype" = 'dell-s5-2u' && "$nwapptype" = 'packethybrid' ]]; then
                echo "creating partition script for s5 packethybrid" >> /tmp/pre.log
		# VD0: HW RAID1 2 @ 1TB, VD1: HW RAID1 2 @ 2TB, VD2: HW RAID5 4 @ 6TB, VD3: HW RAID5 3 @ 6TB, w/VD3:VD4 dedicated hotspare, VD4: HW RAID1 2 @ 800GB SSD
                mk_disk_labels ${installdev[@]}
                if [ $uselvm ]; then
                        sysreboot
                fi
                writeBootRaid ${installdev[0]}
                echo "part pv.root --size=1 --grow --ondisk=${installdev[0]}
part pv.apps1 --size=1 --grow --ondisk=${installdev[1]}
part pv.apps2 --size=1 --grow --ondisk=${installdev[2]}
part pv.apps3 --size=1 --grow --ondisk=${installdev[3]}
part pv.apps4 --size=1 --grow --ondisk=${installdev[4]}
volgroup VolGroup00 pv.root
volgroup VolGroup01 pv.apps1
volgroup VolGroup02 pv.apps2
volgroup VolGroup03 pv.apps3
volgroup VolGroup04 pv.apps4" >> $SYSPARTS
	        echo '	# VolGroup00' >> $SYSPARTS
		echo "${sv_root_volumes}" >> $SYSPARTS
		echo 'logvol /var/netwitness/warehouseconnector --vgname=VolGroup00 --size=400000 --name=warec --fstype=xfs --fsoptions="noatime,nosuid"' >> $SYSPARTS
		echo '	# VolGroup01
logvol /var/netwitness/decoder/metadb --vgname=VolGroup01 --size=1 --grow --name=decometa --fstype=xfs --fsoptions="noatime,nosuid"
	# VolGroup02
logvol /var/netwitness/decoder --vgname=VolGroup02 --size=30720 --name=decoroot --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/decoder/index --vgname=VolGroup02 --size=30720 --name=decoinde --fstype=xfs --fsoptions="noatime,nosuid" 
logvol /var/netwitness/decoder/sessiondb --vgname=VolGroup02 --size=102400 --name=decosess --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/decoder/packetdb --vgname=VolGroup02 --size=1 --grow --name=decopack --fstype=xfs --fsoptions="noatime,nosuid"
	# VolGroup03
logvol /var/netwitness/concentrator --vgname=VolGroup03 --size=30720 --name=concroot --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/concentrator/sessiondb --vgname=VolGroup03 --size=1048576 --name=concsess --fstype=xfs --fsoptions="noatime,nosuid"
logvol /var/netwitness/concentrator/metadb --vgname=VolGroup03 --size=1 --grow --name=concmeta --fstype=xfs --fsoptions="noatime,nosuid"
	# VolGroup04 
logvol /var/netwitness/concentrator/index --vgname=VolGroup04 --size=1 --grow --name=concinde --fstype=xfs --fsoptions="noatime,nosuid"' >> $SYSPARTS

	### MA: S3 - S9 ###

	### dell 200 and supermicro 200 series spectrum enterprise, spectrum w/broker ###
	# 1 hardware RAID5 with two slices, 4 @ 2 TB, 256 MB slice for boot and 6 TB slice for OS and apps   
	elif [[ "$nwsystype" = 'dell-s3-1u' || "$nwsystype" = 'sm-s3-1u' ]] && [[ "$nwapptype" = 'spectrumbroker' ]]; then
		echo "creating partition script for 200 spectrum enterprise" >> /tmp/pre.log
		# two HW RAID5 Devices: 0, 1
		mk_disk_labels ${installdev[@]} 
		if [ $uselvm ]; then
			sysreboot
		fi
		writeBootRaid ${installdev[0]}
		echo "part pv.root --size=143360 --ondisk=${installdev[1]}
part pv.apps --size=5110694 --ondisk=${installdev[1]}
volgroup VolGroup00 pv.root" >> $SYSPARTS 
		echo "$upsz_root_volumes" >> $SYSPARTS 
		echo 'volgroup VolGroup01 pv.apps
logvol /var/netwitness/broker --vgname=VolGroup01 --size=557842 --name=broker --fstype=xfs --fsoptions="noatime"
logvol /var/lib/rsamalware --vgname=VolGroup01 --size=2737036 --name=apps --fstype=xfs --fsoptions="noatime"
logvol /var/lib/pgsql --vgname=VolGroup01 --size=1 --grow --name=apdb --fstype=xfs --fsoptions="noatime"' >> $SYSPARTS

	### dell 2400 series MA enterprise, MA w/broker ###
	# 1 hardware RAID1 and 2 hardware RAID5, 2 @ 136 GB, 8 @ 2 TB, 3 @ 2 TB
	elif [[ "$nwsystype" = 'dell-s3-2u' ]] && [[ "$nwapptype" = 'spectrumbroker' ]]; then
		echo "creating partition script for dell 2400 spectrum enterprise" >> /tmp/pre.log
		# two HW RAID5 Devices: 0, 1 and one HW RAID1 Device: 2
			mk_disk_labels ${installdev[@]} 
			if [ $uselvm ]; then
				sysreboot
			fi
			writeBootRaid ${installdev[2]}
			echo "part pv.root --size=1 --grow --ondisk=${installdev[2]}
part pv.brok --size=2404352 --ondisk=${installdev[1]} --asprimary
part pv.spec --size=100 --grow --ondisk=${installdev[0]} --asprimary
volgroup VolGroup00 pv.root" >> $SYSPARTS
		echo "$upsz_root_volumes" >> $SYSPARTS
		echo 'volgroup VolGroup01 pv.brok
logvol /var/netwitness/broker --vgname=VolGroup01 --size=100 --grow --name=broker --fstype=xfs --fsoptions="noatime,nosuid"
volgroup VolGroup02 pv.spec
logvol /var/lib/rsamalware --vgname=VolGroup02 --size=8009024 --name=apps --fstype=xfs --fsoptions="noatime"
logvol /var/lib/pgsql --vgname=VolGroup02 --size=1 --grow --name=apdb --fstype=xfs --fsoptions="noatime"' >> $SYSPARTS

	### supermicro 2400n series MA enterprise, spectrum w/broker ###
	# 1 software RAID1 and 2 two hardware RAID5, 2 @ 160 GB, 8 @ 2 TB, 3 @ 2 TB
	elif [[ "$nwsystype" = 'sm-s3-2u' ]] && [[ "$nwapptype" = 'spectrumbroker' ]]; then
		echo "creating partition script for sm 2400n spectrum enterprise" >> /tmp/pre.log
		if [ $installtype ]; then
			mk_disk_labels sdb sdc sdd sde
			if [ $uselvm ]; then
				sysreboot
			fi
			writeBootRaid sdd sde
			echo '# root partition raid:  root fs is mirrored for safety, but is in a LVM group
# for flexibility
part raid.20 --size=100 --grow --ondisk=sdd
part raid.21 --size=100 --grow --ondisk=sde
part pv.brok --size=2404352 --ondisk=sdc --asprimary
part pv.spec --size=100 --grow --ondisk=sdb --asprimary' >> $SYSPARTS
		else
			mk_disk_labels sda sdb sdc sdd
			if [ $uselvm ]; then
				sysreboot
			fi
			writeBootRaid sdc sdd
			echo '# root partition raid:  root fs is mirrored for safety, but is in a LVM group
# for flexibility
part raid.20 --size=100 --grow --ondisk=sdc
part raid.21 --size=100 --grow --ondisk=sdd
part pv.brok --size=2404352 --ondisk=sdb --asprimary
part pv.spec --size=100 --grow --ondisk=sda --asprimary' >> $SYSPARTS
		fi 
		echo '# second mirror is a LVM physical volume
raid pv.root --fstype "physical volume (LVM)" --level=RAID1 --device=md1 raid.20 raid.21
# ... and it is the only member of the VolGroup00 volume group
volgroup VolGroup00 pv.root
volgroup VolGroup01 pv.brok' >> $SYSPARTS
		if [ $upsizeos ]; then
			echo "$upsz_root_volumes" >> $SYSPARTS
		else
			echo "$root_volumes" >> $SYSPARTS 
			echo 'logvol /var/netwitness --vgname=VolGroup00 --size=1 --grow --fstype=xfs --name=nwhome --fsoptions="nosuid"
logvol /var/lib/rabbitmq --vgname=VolGroup01 --size=20480 --fstype=xfs --name=rabmq --fsoptions="nosuid"' >> $SYSPARTS	
		fi
		echo 'logvol /var/netwitness/broker --vgname=VolGroup01 --size=100 --grow --name=broker --fstype=xfs --fsoptions="noatime,nosuid"
volgroup VolGroup02 pv.spec
logvol /var/lib/rsamalware --vgname=VolGroup02 --size=8009024 --name=apps --fstype=xfs --fsoptions="noatime"
logvol /var/lib/pgsql --vgname=VolGroup02 --size=1 --grow --name=apdb --fstype=xfs --fsoptions="noatime"' >> $SYSPARTS

	### dell S4S MA Enterprise appliance Dell R620 w/IDSDM ###
        # 1 hardware RAID1, 2 hardware RAID5, 1 HotSpare: 2 @ 32 GB SD Card, 3 @ 2 TB, 6 @ 2 TB, 1 @ 1 TB HotSpare
        elif [[ "$nwsystype" = 'dell-s4s-1u' && "$nwapptype" = 'spectrumbroker' ]]; then
                echo "creating partition script for s4s mp enterprise" >> /tmp/pre.log
                # one SD Card RAID1 Device: 0 and two HW RAID5 Devices: 1, 2
                mk_disk_labels ${installdev[@]}
                if [ $uselvm ]; then
                        sysreboot
                fi
                # check for idsdm device
                let index4s=0
                if [[ `echo "${installmodel[$index4s]}" | grep -i 'Internal Dual SD'` ]]; then
                        #echo "part pv.idsdm --size=1 --grow --ondisk=${installdev[$index4s]}
#volgroup VolGroup09 pv.idsdm" >> $SYSPARTS
                #echo "$idsdm_volumes" >> $SYSPARTS
                        let index4s=$index4s+1
                fi
                writeBootRaid ${installdev[$index4s]}
                echo "part pv.nwsto --size=1 --grow --ondisk=${installdev[$index4s]}
part pv.nwsto2 --size=1 --grow --ondisk=${installdev[$index4s+1]}
volgroup VolGroup00 pv.nwsto
volgroup VolGroup01 pv.nwsto2" >> $SYSPARTS
                echo 'logvol / --vgname=VolGroup00 --size=8192 --fstype=ext4 --name=root
logvol swap --vgname=VolGroup00 --size=2048 --fstype=swap --name=swap00
logvol /home --vgname=VolGroup00 --size=4096 --fstype=ext4 --name=usrhome --fsoptions="nosuid"
logvol /opt --vgname=VolGroup00 --size=10240 --fstype=ext4 --name=opt --fsoptions="nosuid"
logvol /var --vgname=VolGroup00 --size=8192 --fstype=ext4 --name=var
logvol /var/lib/rabbitmq --vgname=VolGroup00 --size=20480 --fstype=xfs --name=rabmq --fsoptions="nosuid"
logvol /var/log --vgname=VolGroup00 --size=10240 --fstype=ext4 --name=varlog
logvol /var/netwitness --vgname=VolGroup00 --size=30720 --fstype=xfs --name=nwhome --fsoptions="nosuid,noatime"
logvol /var/netwitness/broker --vgname=VolGroup00 --size=204800 --fstype=xfs --name=broker --fsoptions="nosuid,noatime"
logvol /var/tmp --vgname=VolGroup00 --size=4096 --fstype=ext4 --name=vartmp --fsoptions="nosuid"
logvol /tmp --vgname=VolGroup00 --size=20480 --fstype=ext4 --name=tmp --fsoptions="nosuid"
logvol swap --vgname=VolGroup01 --size=2048 --fstype=swap --name=swap01
logvol /var/lib/rsamalware --vgname=VolGroup01 --size=2673869 --fstype=xfs --name=specfile --fsoptions="nosuid,noatime"
logvol /var/lib/pgsql --vgname=VolGroup01 --size=1 --grow --fstype=xfs --name=specdb --fsoptions="nosuid,noatime"' >> $SYSPARTS

	### dell nwx series 9 MA Enterprise, Dell R630 ###
	# 2 hardware RAID1, 2 @ 1 TB and 2 @ 2 TB
	elif [[ "$nwsystype" = 'dell-s9-1u' ]] && [[ "$nwapptype" = 'spectrumbroker' ]]; then
		echo "creating partition script for s9 spectrumbroker" >> /tmp/pre.log
		# two HW RAID1 Devices: VD0, VD1
		mk_disk_labels ${installdev[@]}
		if [ $uselvm ]; then
			sysreboot
		fi
		writeBootRaid ${installdev[0]} 
		# leave 10% of 2 TiB volume un-allocated
                local psize
                local tenprcnt
                psize=`parted -s /dev/${installdev[1]} unit s print | grep -i -E "Disk[[:space:]]+/dev/${installdev[1]}" | awk -F: '{print $2}' | awk '{print $1}'`
                let psize=${psize%s}
                let psize=`expr $psize / 2 / 1024`
                tenprcnt=`python -c "myvar=$psize; print myvar * 0.1"`
                let tenprcnt=${tenprcnt%\.*}
                let psize=$psize-$tenprcnt
		echo "part pv.root --size=262144 --ondisk=${installdev[0]}
part pv.apps --size=$psize --ondisk=${installdev[1]}
volgroup VolGroup00 pv.root
volgroup VolGroup01 pv.apps" >> $SYSPARTS
		echo "$sv_root_volumes" >> $SYSPARTS
		echo 'logvol /var/netwitness/broker --vgname=VolGroup00 --size=1 --grow --fstype=xfs --name=broker --fsoptions="nosuid,noatime"
logvol /var/lib/pgsql --vgname=VolGroup01 --size=409600 --fstype=xfs --name=madb --fsoptions="nosuid,noatime"
logvol /var/lib/rsamalware --vgname=VolGroup01 --size=1 --grow --fstype=xfs --name=mafile --fsoptions="nosuid,noatime"' >> $SYSPARTS
	
	### SA Server: S4 - S9 ###

	### dell nwx series 4 sabroker, Dell R610 ###
	# 2 hardware RAID1, 2 @ 160 GB and 2 @ 1 TB
	elif [[ "$nwsystype" = 'dell-s4-1u' ]] && [[ "$nwapptype" = 'sabroker' ]]; then
		echo "creating partition script for s4 sa & broker" >> /tmp/pre.log
		# two HW RAID1 Devices: 0, 1 
		mk_disk_labels ${installdev[@]} 
		if [ $uselvm ]; then
			sysreboot
		fi
		writeBootRaid ${installdev[0]}
		echo "part pv.root --size=1 --grow --ondisk=${installdev[0]}
part pv.apps --size=1 --grow --ondisk=${installdev[1]}" >> $SYSPARTS
		echo 'volgroup VolGroup00 pv.root
volgroup VolGroup01 pv.apps
logvol /home/rsasoc --vgname=VolGroup01 --size=204800  --fstype=xfs --name=rsasoc --fsoptions="nosuid,noatime"
logvol /var/netwitness/ipdbextractor --vgname=VolGroup01 --size=30720  --fstype=xfs --name=ipdbext --fsoptions="nosuid,noatime"
logvol /var/netwitness/database --vgname=VolGroup01 --size=102400  --fstype=xfs --name=redb --fsoptions="nosuid,noatime"
logvol /var/netwitness/broker --vgname=VolGroup01 --size=204800  --fstype=xfs --name=broker --fsoptions="nosuid,noatime"
logvol /var/lib/netwitness --vgname=VolGroup01 --size=204800  --fstype=xfs --name=uax --fsoptions="nosuid,noatime"' >> $SYSPARTS
		echo "$upsz_root_volumes" >> $SYSPARTS

	### dell nwx series S4S sabroker, Dell R620 w/IDSDM ###
	# three hardware RAID1, 2 @ 32 GB SD Card, 2 @ 147 GB and 2 @ 1 TB
        elif [[ "$nwsystype" = 'dell-s4s-1u' ]] && [[ "$nwapptype" = 'sabroker' ]]; then
                echo "creating partition script for s4s sa & broker" >> /tmp/pre.log
                # one SD Card RAID1 Device: 0 and two HW RAID1 Devices: 1, 2
                mk_disk_labels ${installdev[@]}
                if [ $uselvm ]; then
                        sysreboot
                fi
                # check for idsdm device
                let index4s=0
                if [[ `echo "${installmodel[$index4s]}" | grep -i 'Internal Dual SD'` ]]; then
                        #echo "part pv.idsdm --size=1 --grow --ondisk=${installdev[$index4s]}
#volgroup VolGroup09 pv.idsdm" >> $SYSPARTS
                #echo "$idsdm_volumes" >> $SYSPARTS
                        let index4s=$index4s+1
                fi
                writeBootRaid ${installdev[$index4s]}
echo "part pv.nwsto --size=1 --grow --ondisk=${installdev[$index4s]}
part pv.nwsto2 --size=1 --grow --ondisk=${installdev[$index4s+1]}
volgroup VolGroup00 pv.nwsto
volgroup VolGroup01 pv.nwsto2" >> $SYSPARTS
echo 'logvol / --vgname=VolGroup00 --size=8192 --fstype=ext4 --name=root
logvol swap --vgname=VolGroup00 --size=2048 --fstype=swap --name=swap00
logvol /home --vgname=VolGroup00 --size=4096 --fstype=ext4 --name=usrhome --fsoptions="nosuid"
logvol /opt --vgname=VolGroup00 --size=10240 --fstype=ext4 --name=opt --fsoptions="nosuid"
logvol /var --vgname=VolGroup00 --size=8192 --fstype=ext4 --name=var
logvol /var/lib/rabbitmq --vgname=VolGroup00 --size=20480 --fstype=xfs --name=rabmq --fsoptions="nosuid"
logvol /var/log --vgname=VolGroup00 --size=10240 --fstype=ext4 --name=varlog
logvol /var/tmp --vgname=VolGroup00 --size=4096 --fstype=ext4 --name=vartmp --fsoptions="nosuid"
logvol /tmp --vgname=VolGroup00 --size=20480 --fstype=ext4 --name=tmp --fsoptions="nosuid"
logvol /var/netwitness/ipdbextractor --vgname=VolGroup00 --size=30720 --fstype=xfs --name=ipdbext --fsoptions="nosuid,noatime"
logvol /var/netwitness --vgname=VolGroup00 --size=1 --grow --fstype=xfs --name=nwhome --fsoptions="nosuid,noatime"
logvol swap --vgname=VolGroup01 --size=2048 --fstype=swap --name=swap01
logvol /var/netwitness/database --vgname=VolGroup01 --size=204800 --fstype=xfs --name=redb --fsoptions="nosuid,noatime"
logvol /home/rsasoc --vgname=VolGroup01 --size=204800 --fstype=xfs --name=rsasoc --fsoptions="nosuid,noatime"
logvol /var/netwitness/broker --vgname=VolGroup01 --size=204800 --fstype=xfs --name=broker --fsoptions="nosuid,noatime"
logvol /var/lib/netwitness --vgname=VolGroup01 --size=204800 --fstype=xfs --name=uax --fsoptions="nosuid,noatime"' >> $SYSPARTS

	### dell nwx series 9 sabroker, Dell R630 ###
	# 2 hardware RAID1, 2 @ 1 TB and 2 @ 2 TB
	elif [[ "$nwsystype" = 'dell-s9-1u' ]] && [[ "$nwapptype" = 'sabroker' ]]; then
		echo "creating partition script for s9 sabroker" >> /tmp/pre.log
		# two HW RAID1 Devices: VD0, VD1 
		mk_disk_labels ${installdev[@]} 
		if [ $uselvm ]; then
			sysreboot
		fi
		writeBootRaid ${installdev[0]}
		echo "part pv.root --size=262144 --ondisk=${installdev[0]}
part pv.apps --size=720896 --ondisk=${installdev[1]}" >> $SYSPARTS
		echo 'volgroup VolGroup00 pv.root
volgroup VolGroup01 pv.apps
logvol /home/rsasoc --vgname=VolGroup01 --size=204800  --fstype=xfs --name=rsasoc --fsoptions="nosuid,noatime"
logvol /var/netwitness/ipdbextractor --vgname=VolGroup00 --size=30720  --fstype=xfs --name=ipdbext --fsoptions="nosuid,noatime"
logvol /var/netwitness/database --vgname=VolGroup01 --size=204800  --fstype=xfs --name=redb --fsoptions="nosuid,noatime"
logvol /var/netwitness/broker --vgname=VolGroup01 --size=102400  --fstype=xfs --name=broker --fsoptions="nosuid,noatime"
logvol /var/lib/netwitness --vgname=VolGroup01 --size=1 --grow --fstype=xfs --name=uax --fsoptions="nosuid,noatime"' >> $SYSPARTS
		echo "$sv_root_volumes" >> $SYSPARTS

	### Discontinued Appliances ### 

	### dell S4S Connector appliance Dell R620 w/IDSDM ###
        # three hardware RAID1, 2 @ 32 GB SD Card, 2 @ 147 GB and 2 @ 1 TB
        elif [[ "$nwsystype" = 'dell-s4s-1u' && "$nwapptype" = 'connector' ]]; then
                echo "creating partition script for s4s connector" >> /tmp/pre.log
                # one SD Card RAID1 Device: 0 and two HW RAID1 Devices: 1, 2
                mk_disk_labels ${installdev[@]}
                if [ $uselvm ]; then
                        sysreboot
                fi
                # check for idsdm device
                let index4s=0
                if [[ `echo "${installmodel[$index4s]}" | grep -i 'Internal Dual SD'` ]]; then
                        #echo "part pv.idsdm --size=1 --grow --ondisk=${installdev[$index4s]}
#volgroup VolGroup09 pv.idsdm" >> $SYSPARTS
                #echo "$idsdm_volumes" >> $SYSPARTS
                        let index4s=$index4s+1
                fi
                writeBootRaid ${installdev[$index4s]}
                echo "part pv.nwsto --size=1 --grow --ondisk=${installdev[$index4s]}
part pv.nwsto2 --size=1 --grow --ondisk=${installdev[$index4s+1]}
volgroup VolGroup00 pv.nwsto
volgroup VolGroup01 pv.nwsto2" >> $SYSPARTS
                echo  'logvol / --vgname=VolGroup00 --size=8192 --fstype=ext4 --name=root
logvol swap --vgname=VolGroup00 --size=2048 --fstype=swap --name=swap00
logvol /home --vgname=VolGroup00 --size=4096 --fstype=ext4 --name=usrhome --fsoptions="nosuid"
logvol /opt --vgname=VolGroup00 --size=10240 --fstype=ext4 --name=opt --fsoptions="nosuid"
logvol /var --vgname=VolGroup00 --size=8192 --fstype=ext4 --name=var
logvol /var/lib/rabbitmq --vgname=VolGroup00 --size=20480 --fstype=xfs --name=rabmq --fsoptions="nosuid"
logvol /var/log --vgname=VolGroup00 --size=10240 --fstype=ext4 --name=varlog
logvol /var/netwitness --vgname=VolGroup00 --size=30720 --fstype=xfs --name=nwhome --fsoptions="nosuid,noatime"
logvol /var/tmp --vgname=VolGroup00 --size=4096 --fstype=ext4 --name=vartmp --fsoptions="nosuid"
logvol /tmp --vgname=VolGroup00 --size=20480 --fstype=ext4 --name=tmp --fsoptions="nosuid"
logvol swap --vgname=VolGroup01 --size=2048 --fstype=swap --name=swap01
logvol /var/netwitness/warehouseconnector --vgname=VolGroup01 --size=512000 --fstype=xfs --name=ccroot --fsoptions="nosuid,noatime"' >> $SYSPARTS

	### dell S4S MapR Warehouse appliance Dell R620 w/IDSDM ###
        # 1 hardware RAID1 and 10 hardware RAID0: 2 @ 32 GB SD Card, 10 RAID 0 - 1 @ 1 TB
        elif [[ "$nwsystype" = 'dell-s4s-1u' && "$nwapptype" = 'maprwh' ]]; then
                echo "creating partition script for s4s maprwh" >> /tmp/pre.log
                # one SD Card RAID1 Device: 0 and ten HW RAID0 Devices: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
                mk_disk_labels ${installdev[@]}
                if [ $uselvm ]; then
                        sysreboot
                fi
                # check for idsdm device
                let index4s=0
                if [[ `echo "${installmodel[$index4s]}" | grep -i 'Internal Dual SD'` ]]; then
                        #echo "part pv.idsdm --size=1 --grow --ondisk=${installdev[$index4s]}
#volgroup VolGroup09 pv.idsdm" >> $SYSPARTS
                #echo "$idsdm_volumes" >> $SYSPARTS
                        let index4s=$index4s+1
                fi
                writeBootRaid ${installdev[$index4s]}
                echo "part pv.nwsto --size=1 --grow --ondisk=${installdev[$index4s]}
volgroup VolGroup00 pv.nwsto" >> $SYSPARTS
                echo 'logvol / --vgname=VolGroup00 --size=8192 --fstype=ext4 --name=root
logvol swap --vgname=VolGroup00 --size=98304 --name=swaplv --fstype=swap
logvol /home --vgname=VolGroup00 --size=4096 --fstype=ext4 --name=usrhome --fsoptions="nosuid"
logvol /tmp --vgname=VolGroup00 --size=106496 --name=tmp --fstype=ext4
logvol /var --vgname=VolGroup00 --size=24576  --name=var --fstype=ext4
logvol /var/lib/rabbitmq --vgname=VolGroup00 --size=8192 --fstype=xfs --name=rabmq
logvol /var/log --vgname=VolGroup00 --size=10240 --name=varlog --fstype=ext4
logvol /var/tmp --vgname=VolGroup00 --size=4096 --fstype=ext4 --name=vartmp --fsoptions="nosuid"
logvol /opt --vgname=VolGroup00 --size=1 --grow --name=opt --fstype=ext4' >> $SYSPARTS	
      
		### dell S4 2U Remote IPDB Extractor Appliance, Dell R710 ###
	# 1 hardware RAID1: 2 @ 300 GB
	elif [[ "$nwsystype" = 'dell-s4-2u' && "$nwapptype" = 'ipdbextractor' ]]; then
		echo "creating partition script for s4 2u ipdbextractor appliance" >> /tmp/pre.log
		# one HW RAID1 Device: 0
		mk_disk_labels ${installdev[@]}
		if [ $uselvm ]; then
			sysreboot
		fi	
		writebootraid ${installdev[0]} 
		echo "part pv.root --size=1 --grow --ondisk=${installdev[0]}" >> $SYSPARTS
		echo 'volgroup VolGroup00 pv.root 
logvol / --fstype=ext4 --name=root --vgname=VolGroup00 --size=16384
logvol swap --fstype=swap --name=swap --vgname=VolGroup00 --size=16384
logvol /tmp --fstype=ext4 --name=tmp --vgname=VolGroup00 --size=8192 --fsoptions="nosuid"
logvol /var --fstype=ext4 --name=var --vgname=VolGroup00 --size=12288
logvol /var/tmp --fstype=ext4 --name=vartmp --vgname=VolGroup00 --size=4096 --fsoptions="nosuid" 
logvol /home --fstype=ext4 --name=usrhome --vgname=VolGroup00 --size=2048 --fsoptions="nosuid"
logvol /opt --vgname=VolGroup00 --size=4096 --fstype=ext4 --name=opt --fsoptions="nosuid"
logvol /var/netwitness --fstype=xfs --name=nwhome --vgname=VolGroup00 --size=12288 --fsoptions="nosuid,noatime"
logvol /var/lib/rabbitmq --vgname=VolGroup00 --size=20480 --fstype=xfs --name=rabmq --fsoptions="nosuid"
logvol /var/netwitness/ipdbextractor --fstype=xfs --name=ipdbext --vgname=VolGroup00 --size=32768 --fsoptions="nosuid,noatime"' >> $SYSPARTS
	
	### dell S4 2U Remote Log Collector Appliance, Dell R710 ###
	# 1 hardware RAID1: 2 @ 300 GB
	elif [[ "$nwsystype" = 'dell-s4-2u' && "$nwapptype" = 'logcollector' ]]; then
		echo "creating partition script for S4 2u remote logcollector appliance" >> /tmp/pre.log
		# one HW RAID1 Device: 0		
		mk_disk_labels ${installdev[@]} 
		if [ $uselvm ]; then
			sysreboot
		fi
		writebootraid ${installdev[0]} 
		echo "part pv.root --size=1 --grow --ondisk=${installdev[0]}" >> $SYSPARTS
		echo 'volgroup VolGroup00 pv.root
logvol / --fstype=ext4 --name=root --vgname=VolGroup00 --size=8192
logvol swap --fstype=swap --name=swap --vgname=VolGroup00 --size=16384
logvol /tmp --fstype=ext4 --name=tmp --vgname=VolGroup00 --size=8192 --fsoptions="nosuid"
logvol /var --fstype=ext4 --name=var --vgname=VolGroup00 --size=4096
logvol /var/tmp --fstype=ext4 --name=vartmp --vgname=VolGroup00 --size=4096 --fsoptions="nosuid" 
logvol /home --fstype=ext4 --name=usrhome --vgname=VolGroup00 --size=2048 --fsoptions="nosuid"
logvol /opt --vgname=VolGroup00 --size=4096 --fstype=ext4 --name=opt --fsoptions="nosuid"
logvol /var/netwitness --fstype=xfs --name=nwhome --vgname=VolGroup00 --size=6144 --fsoptions="nosuid,noatime"
logvol /var/lib/rabbitmq --vgname=VolGroup00 --size=102400 --fstype=xfs --name=rabmq --fsoptions="nosuid"
logvol /var/netwitness/logcollector --fstype=xfs --name=lchome --vgname=VolGroup00 --size=1 --grow --fsoptions="nosuid,noatime"' >> $SYSPARTS
	
	### un-qualified appliance type ###
	else
		chvt 3
		echo -e " %pre install error: make_install_parts()\n unable to create partition script for $nwapptype on $nwsystype hardware\n no installation/upgrade method available" > /dev/tty3
		promptReboot
	fi
	chvt 1
}

function check_200_ssd_drive
{
	local ENCID=$("$COMMAND_TOOL" -pdlist -a0 | while read p1 p2 p3 p4; do if [ "$p1" == "Enclosure" ]; then echo $p4; break; fi; done)
        local ADAPTER=0	
	local let count=4
	local let ssdError=0
	while [[ $count -le 4 ]]
	do
	    if ! [[ `$COMMAND_TOOL -pdinfo -physdrv[$ENCID:$count] -a$ADAPTER | grep -i 'Media Type: Solid State Device'` ]]; then
                let ssdError=$ssdError+1
	    fi
            let count=$count+1
        done
	if [[ $ssdError -gt 0 ]]; then
		local usrInput
		echo "No solid state device found in slot 4 of RAID bus" >> /tmp/pre.log
		chvt 3
		echo > /dev/tty3
		echo "-------------------------------------------------------------------------" > /dev/tty3
		echo " No solid state device was found in slot 4 of the RAID bus" > /dev/tty3
		echo " Please check system hardware, the resulting configuration maybe invalid" > /dev/tty3
		echo " Canceling installation in 20 seconds, enter any character to continue" > /dev/tty3
		echo "-------------------------------------------------------------------------" > /dev/tty3
		exec < /dev/tty3 > /dev/tty3 2>&1 
		read -t 20 -p "continue? " usrInput
		if [ $usrInput ]; then
			chvt 1
			return 0
		else
			chvt 1
			return 1
		fi
	fi
	return 0
}

function check_1200_ssd_drives
{
	local ENCID=$("$COMMAND_TOOL" -pdlist -a0 | while read p1 p2 p3 p4; do if [ "$p1" == "Enclosure" ]; then echo $p4; break; fi; done)
        local ADAPTER=0	
	local let count=8
	local let ssdError=0
	while [[ $count -lt 11 ]]
	do
	    if ! [[ `$COMMAND_TOOL -pdinfo -physdrv[$ENCID:$count] -a$ADAPTER | grep -i 'Media Type: Solid State Device'` ]]; then
                let ssdError=$ssdError+1
	    fi
            let count=$count+1
        done
	if [[ $ssdError -gt 0 ]]; then

	
		return 1

	else
	       	return 0
	fi
}

function check_2400_ssd_drives
{
	local ENCID=$("$COMMAND_TOOL" -pdlist -a0 | while read p1 p2 p3 p4; do if [ "$p1" == "Enclosure" ]; then echo $p4; break; fi; done)
        local ADAPTER=0	
	local let count=6
	local let ssdError=0
	while [[ $count -lt 11 ]]
	do
	    if ! [[ `$COMMAND_TOOL -pdinfo -physdrv[$ENCID:$count] -a$ADAPTER | grep -i 'Media Type: Solid State Device'` ]]; then
                let ssdError=$ssdError+1
	    fi
            let count=$count+1
        done
	if [[ $ssdError -gt 0 ]]; then
		return 1
	else
		return 0
	fi
}

function check_for_ssd_drives
{
	local ENCID=$("$COMMAND_TOOL" -pdlist -a0 | while read p1 p2 p3 p4; do if [ "$p1" == "Enclosure" ]; then echo $p4; break; fi; done)
        local ADAPTER=0	
	local let count=0
	local let ssdError=0
	while [[ $count -lt 12 ]]
	do
	    if [[ `$COMMAND_TOOL -pdinfo -physdrv[$ENCID:$count] -a$ADAPTER | grep -i 'Media Type: Solid State Device'` ]]; then
                let ssdError=$ssdError+1
	    fi
            let count=$count+1
        done
	if [[ $ssdError -gt 0 ]]; then
		echo "Solid state devices were found on the RAID bus, this system is likely a concentrator" >> /tmp/pre.log
		chvt 3
		local usrInput
		echo > /dev/tty3
		echo "------------------------------------------------------------------------" > /dev/tty3
		echo " Solid state hard disk devices were found on the RAID controller bus" > /dev/tty3
		echo " Please check system hardware, the resulting configuration maybe invalid" > /dev/tty3 
		echo " Canceling installation in 20 seconds, enter any character to continue" > /dev/tty3
		echo "------------------------------------------------------------------------" > /dev/tty3
		exec < /dev/tty3 > /dev/tty3 2>&1 
		read -t 20 -p "continue? " usrInput
		if [ $usrInput ]; then
			chvt 1
			return 0
		else
			chvt 1
			return 1
		fi
        fi 
	return 0	
}

function check_nwx_drives
{
     	# make sure the drive pairs are installed in the correct slots
	# internal drive sizes in decimal GB/TB, i.e. marketed sizes
	# e.g. 160GB, 1000GB, 1TB, 2TB, etc. these sizes must be based 
	# on the drive scales determined by the controller,
	# i.e. MegaCli -pdlist -aall
	# 1TB ~= 1000GB 
	local sysDriveSize
	if [ -z $1 ]; then
		sysDriveSize='160GB'
	else
		sysDriveSize=$1
	fi 
	local appDriveSize
	if [ -z $2 ]; then
		appDriveSize='1000GB'
	else
		appDriveSize=$2
	fi

	# get size scale 
	local sysDrvScale=`expr "$sysDriveSize" : '.*\(.[bB]\)'`
	local appDrvScale=`expr "$appDriveSize" : '.*\(.[bB]\)'`
	# strip off scale
	sysDriveSize="${sysDriveSize%%[[:alpha:]]*}"
	appDriveSize="${appDriveSize%%[[:alpha:]]*}"

	# get raid adapter count
	local numadp=`$COMMAND_TOOL -adpcount  | grep -i 'Controller Count:' | awk -F: '{print $2}'`
	let numadp="${numadp%.}"
	# if more than one get PERC ID
	if [[ $numadp -gt 1 ]]; then
		local count
		local percID
		let count=0
		while [[ $count -lt $numadp ]]
		do
			if [[ `$COMMAND_TOOL -adpallinfo -a$count | grep -i 'Product Name' | grep -i 'PERC H700 Integrated'` ]]; then
				echo "$count" > /tmp/intAdapterId
				percID=$count
				break
			fi
		let count=$count+1
		done
		# Intel NWX has integrated controller at ID: 0
		if ! [ $percID ]; then
			percID='0'
		fi	
	else
		percID='0' 
	fi 
	
	# check number of physical drives on PERC
	local numPD
	let numPD=`$COMMAND_TOOL -pdlist -a$percID | grep -ic 'PD Type:'`
	if [[ $numPD -lt 4 ]]; then 
		echo "Only $numPD of 4 required physical disks were found, install cannot continue"
		return 1		
	fi
	
	# check slot numbers of populated physical disks 
	let count=0
	local encID
	local errorCount
	local pdStat
	local pdSize
	local pdScale
	let errorCount=0
	encID=$("$COMMAND_TOOL" -pdlist -a$percID | while read p1 p2 p3 p4; do if [ "$p1" == "Enclosure" ]; then echo $p4; break; fi; done)

	while [ $count -lt 4 ]
	do
		if ! [[ `$COMMAND_TOOL -pdinfo -physdrv [$encID:$count] -a$percID | grep -i 'PD Type:'` ]]; then 
			let errorCount=$errorCount+1
			break
		else
			pdSize=`$COMMAND_TOOL -pdinfo -physdrv [$encID:$count] -a$percID | grep -i 'Raw Size:'`
			pdScale=`echo $pdSize | awk '{print $4}'`
			pdSize=`echo $pdSize | awk '{print $3}'`
			pdSize="$pdSize$pdScale"
			pdStat[$count]=$pdSize
			
		fi
		let count=$count+1
	done 
	
	if [[ $errorCount -gt 0 ]]; then
		#echo "encID = $encID percID = $percID"
		echo "Drives missing or not populated in slots 0 - 3, installation cannot continue"
	       	return 1
	fi

	# check that drive sizes are in pairs for slots: 0 - 1 & 2 - 3
        if [[ "${pdStat[0]}" != "${pdStat[1]}" || "${pdStat[2]}" != "${pdStat[3]}" ]]; then
		echo "Drive sizes in slots 0 - 1 or 2 - 3 do not match, installation cannot continue"
		return 1
	fi
	
	# strip scale specifier from raw drive size
	local pairSize1="${pdStat[0]%%[(A-Z|a-z)]*}"
	local pairSize2="${pdStat[2]%%[(A-Z|a-z)]*}" 
	
	# round off sizes	
	let pairSize1=`printf %.0f $pairSize1`
	let pairSize2=`printf %.0f $pairSize2`

	# convert advertized hard drive decimal sizes to GiB/TiB sizes	
	local gibSize1=`python -c "var = $sysDriveSize - $sysDriveSize * 0.074; print var"`
	let gibSize1=`printf %.0f $gibSize1`
	local gibSize2=`python -c "var = $appDriveSize - $appDriveSize * 0.074; print var"`
	let gibSize2=`printf %.0f $gibSize2`
	
	# check if drives sizes are within specifications
	
	# compute error percentage, +/- 5%
	local percentErr1=`python -c "var = $sysDriveSize * 0.05; print var"`
	local percentErr2=`python -c "var = $appDriveSize * 0.05; print var"`
	let percentErr1=`printf %.0f $percentErr1`
	let percentErr2=`printf %.0f $percentErr2`
	local pdSizeDelta1
	local pdSizeDelta2
	let pdSizeDelta1=$pairSize1-$gibSize1
	let pdSizeDelta2=$pairSize2-$gibSize2

	# convert any negative differences to positive
	if [[ $pdSizeDelta1 -lt 0 ]]; then
		let pdSizeDelta1=$pdSizeDelta1*-1
	elif [[ $pdSizeDelta2 -lt 0 ]]; then
		let pdSizeDelta2=$pdSizeDelta2*-1 
	fi
	
	# check approximate drive sizes 
	local gibDiff
	# mirror 0, system
	if ! [[ $pdSizeDelta1 -le $percentErr1 ]]; then
		gibDiff=`python -c "var = $pairSize1 * 0.074; print var"`
		gibDiff=`printf %.0f $gibDiff`
		let pairSize1=$pairSize1+$gibDiff
		pdScale=`expr "${pdStat[0]}" : '.*\(.[bB]\)'`
		echo "Drives in slots 0 - 1 are not $sysDriveSize $sysDrvScale they are $pairSize1 $pdScale models, installation cannot continue" 
		return 1
	fi
	# mirror 1, application
	if ! [[ $pdSizeDelta2 -le $percentErr2 ]]; then
		gibDiff=`python -c "var = $pairSize2 * 0.074; print var"`
		gibDiff=`printf %.0f $gibDiff`
		let pairSize2=$pairSize2+$gibDiff
		pdScale=`expr "${pdStat[2]}" : '.*\(.[bB]\)'` 
		echo "Drives in slots 2 - 3 are not $appDriveSize $appDrvScale they are $pairSize2 $pdScale models, installation cannot continue" 
		return 1
	fi
	
	return 0
}

function check_enc_drive_sizes
{
     	# make sure the specified drive sizes are installed in the correct slots
	# paramter drive sizes i.e. marketed sizes are specified in decimal
	# e.g. 160GB, 1000GB, 1TB, 2TB, etc. these sizes must match the binary
	# drive sizes as determined by the controller within (+/-) 5% after the
	# size conversion: 1000GB Base10 ~= 931GB Base2, if not provided`the
	# parmeter scale is assumed to be GB
	local errorstr
	local mylog='/tmp/pre.log'
	local driveSizes
	local driveScales
	local encSizes
	local encScales
	declare -a driveSizes
	declare -a driveScales
	declare -a encSizes
	declare -a encScales
	local drvsize
	local drvscale
	local count
	local numparam
	local paramsize
	local usrin='N'
	local gb2gib
	local percentErr
	local pdSizeDelta
	local encID
	local errorCount
	local pdSize
	local pdScale
	let count=0
	while ! [ -z $1 ]
	do
		drvscale=`expr "$1" : '.*\([A-Za-z][A-Za-z]\)'`
		if [ -z $drvscale ]; then
			drvscale='GB'
		fi
		drvscale=`echo ${drvscale} | tr [a-z] [A-Z]`
		drvsize="${1%%[[:alpha:]]*}"
		driveSizes[$count]=$drvsize
		driveScales[$count]=$drvscale
		#echo "get param $1"
		shift
		let count=$count+1
	done

	let numparam=${#driveSizes[@]}
	# Series 4, R610
	if [ $numparam -lt 4 ]; then
		driveSizes[0]='160'
		driveScales[0]='GB'
		driveSizes[1]='160'
		driveScales[1]='GB'
		driveSizes[2]='1000'
		driveScales[2]='GB'
		driveSizes[3]='1000'
		driveScales[3]='GB'
	fi
	let numparam=${#driveSizes[@]}

	# get raid adapter count
	local numadp=`$COMMAND_TOOL -adpcount  | grep -i 'Controller Count:' | awk -F: '{print $2}'`
	let numadp="${numadp%.}"
	# if more than one get PERC ID
	if [[ $numadp -gt 1 ]]; then
		local percID
		let count=0
		while [[ $count -lt $numadp ]]
		do
			if [[ `$COMMAND_TOOL -adpallinfo -a$count | grep -i 'Product Name' | grep -i 'PERC H700 Integrated'` ]]; then
				percID=$count
				break
			fi
		let count=$count+1
		done
		# Intel NWX has integrated controller at ID: 0
		if ! [ $percID ]; then
			percID='0'
		fi
	else
		percID='0'
	fi

	# check number of physical drives on PERC
	local numPD
	let numPD=`$COMMAND_TOOL -pdlist -a$percID | grep -ic 'PD Type:'`
	if [[ $numPD -lt $numparam ]]; then
		errorstr="Only $numPD of $paramsize required physical disks were found"
		echo > /dev/tty3
		echo > /dev/tty3
		echo 'calling %pre function: check_nwx_drives()' | tee -a $mylog > /dev/tty3
		echo "$errorstr" | tee -a $mylog
	fi

	# get stats of populated physical disks
	let count=0
	let errorCount=0
	encID=$("$COMMAND_TOOL" -pdlist -a$percID | while read p1 p2 p3 p4; do if [ "$p1" == "Enclosure" ]; then echo $p4; break; fi; done)

	while [ $count -lt $numparam ]
	do
		if ! [[ `$COMMAND_TOOL -pdinfo -physdrv [$encID:$count] -a$percID | grep -i 'PD Type:'` ]]; then
			let errorCount=$errorCount+1
			break
		else
			pdSize=`$COMMAND_TOOL -pdinfo -physdrv [$encID:$count] -a$percID | grep -i 'Raw Size:'`
			pdScale=`echo $pdSize | awk '{print $4}'`
			pdScale=`echo ${pdScale} | tr [a-z] [A-Z]`
			pdSize=`echo $pdSize | awk '{print $3}'`
			encSizes[$count]=$pdSize
			encScales[$count]=$pdScale
		fi
		let count=$count+1
	done
	
	if [[ $errorCount -gt 0 ]]; then
		#echo "encID = $encID percID = $percID"
		if [ $errorstr ]; then
			errorstr="${errorstr}\nMissing Drive, slot: $count not populated"
		else
			errorstr="Missing Drive, slot: $count not populated"
		fi
	fi

	if [ $numparam -eq 4 ]; then
		# check that drive sizes are in pairs for slots: 0 - 1
		if [[ "${encSizes[0]}${encScales[0]}" != "${encSizes[1]}${encScales[1]}" ]]; then
			if [ $errorstr ]; then
				errorstr="${errorstr}\nDrive sizes in slots 0 - 1 do not match"
			else
				errorstr="Drive sizes in slots 0 - 1 do not match"
			fi
		fi
		# check that drive sizes are in pairs for slots: 2 - 3
		if [[ "${encSizes[2]}${encScales[2]}" != "${encSizes[3]}${encScales[3]}" ]]; then
			if [ $errorstr ]; then
				errorstr="${errorstr}\nDrive sizes in slots 2 - 3 do not match"
			else
				errorstr="Drive sizes in slots 2 - 3 do not match"
			fi
		fi
	elif [ $numparam -eq 6 ]; then
		# check that drive sizes are in pairs for slots: 0 - 1
		if [[ "${encSizes[0]}${encScales[0]}" != "${encSizes[1]}${encScales[1]}" ]]; then
			if [ $errorstr ]; then
				errorstr="${errorstr}\nDrive sizes in slots 0 - 1 do not match"
			else
				errorstr="Drive sizes in slots 0 - 1 do not match"
			fi
		fi
		# check that drive sizes are in pairs for slots: 2 - 5
		if [ "${encSizes[2]}${encScales[2]}" != "${encSizes[3]}${encScales[3]}" ] && [ "${encSizes[3]}${encScales[3]}" != "${encSizes[4]}${encScales[4]}" ] && [ "${encSizes[4]}${encScales[4]}" != "${encSizes[5]}${encScales[5]}" ]; then
			if [ $errorstr ]; then
				errorstr="${errorstr}\nDrive sizes in slots 2 - 5 do not match"
			else
				errorstr="Drive sizes in slots 2 - 5 do not match"
			fi
		fi
	fi

	# validate drive size parameters
	let count=0
	while [ $count -lt $numparam ]
	do
		paramsize="${driveSizes[$count]}"
		encsize="${encSizes[$count]}"
		# check drive scales
		if [ "${driveScales[$count]}" != "${encScales[$count]}" ]; then
			if [[ "${driveScales[$count]}" = 'TB' && "${encScales[$count]}" = 'GB' ]]; then
				encsize=`python -c "myvar = $encsize; print myvar / 1024"`
			elif [[ "${driveScales[$count]}" = 'GB' && "${encScales[$count]}" = 'TB' ]]; then
				encsize=`python -c "myvar = $encsize; print myvar * 1024"`
			fi
		fi

		# round off sizes
		let paramsize=`printf %.0f $paramsize`
		let encsize=`printf %.0f $encsize`

		if [ "${driveScales[$count]}" = 'GB' ]; then
			gb2gib=`python -c "var = $paramsize; print var * 1000**3 / 1024**3"`
		elif [ "${driveScales[$count]}" = 'TB' ]; then
			gb2gib=`python -c "var = $paramsize; print var * 1000**3 / 1024**3"`
		fi
		let gb2gib=`printf %.0f $gb2gib`
		#echo "gb2gib = $gb2gib"
		# check if drives sizes are within specifications
		# compute error percentage, (+/-) 5%
		percentErr=`python -c "var = ${gb2gib}; print var * 0.05"`
		let percentErr=`printf %.0f $percentErr`
		if [ $encsize -lt $gb2gib ];then
			let pdSizeDelta=$encsize-$gb2gib
			# convert any negative differences to positive
			if [[ $pdSizeDelta -lt 0 ]]; then
				let pdSizeDelta=$pdSizeDelta*-1
			fi
			#echo "percentErr = $percentErr"
			#echo "pdSizeDelta = $pdSizeDelta"
			# verify approximate drive size
			if ! [ $pdSizeDelta -le $percentErr ]; then
				if [[ $errorstr ]]; then
					errorstr="${errorstr}\nDrive size in slot: $count ${encSizes[$count]}${encScales[$count]} is smaller than specified ${driveSizes[$count]}${driveScales[$count]}"
				else
					errorstr="Drive size in slot: $count ${encSizes[$count]}${encScales[$count]} is smaller than specified ${driveSizes[$count]}${driveScales[$count]}"
				fi
			fi
		fi
		let count=$count+1
	done

	# on error prompt to continue
	if  [[ $errorstr ]]; then
		if [[ `dmesg | grep -E -i 'Kernel[[:space:]]+command[[:space:]]+line:' | grep "ks=http://${pxetesthost}"` ]]; then
			echo 'Drive Errors Detected: continuing may cause unexpected results' | tee -a $mylog > /dev/tty3
			echo -e "${errorstr}" | tee -a $mylog > /dev/tty3		
			return 0
		else
			exec < /dev/tty3 > /dev/tty3 2>&1
			chvt 3
			echo > /dev/tty3
			echo > /dev/tty3
			echo 'Drive Errors Detected: continuing may cause unexpected results' | tee -a $mylog > /dev/tty3
			echo -e "${errorstr}" | tee -a $mylog > /dev/tty3
			read -t 120 -p 'Enter (c/C) to continue install, Defaults to No in 120 seconds? ' usrin
			if [[ "${usrin}" = 'c' || "${usrin}" = 'C' ]]; then
				return 0
			else
				return 1
			fi
		fi
	fi

	return 0
}

function check_all_raid
{
	local deviceCount
	let deviceCount=$1
	shift 1
	local variantCount
	let variantCount=$1
	shift 1
	local device_index
	let device_index=0 
	local variant_index
	local -a raid_devices
	local -a raid_vendors
	local -a raid_models
	let variant_index=0
	while [ $variant_index -lt $variantCount ]
	do
		let device_index=0
		while [ $device_index -lt $deviceCount ]
		do
			raid_devices[$device_index]=$1
			shift 1
			let device_index=$device_index+1
		done
		
		let device_index=0
		while [ $device_index -lt $deviceCount ]
		do
			raid_vendors[$device_index]=$1
			shift 1
			let device_index=$device_index+1
		done
	
		let device_index=0 
		while [ $device_index -lt $deviceCount ]
		do
			raid_models[$device_index]=$1
			shift 1
			let device_index=$device_index+1
		done
		let variant_index=$variant_index+1
	done

	local -a raid_device_vendors
	local -a raid_device_models
	
	let device_index=0
	
	local raid_device

	#device_index=0
        while [ $device_index -lt $deviceCount ]
	do
		local vendorPath=/sys/block/${raid_devices[$device_index]}/device/vendor
		local modelPath=/sys/block/${raid_devices[$device_index]}/device/model
		
		if [ -f $vendorPath ]
		then
			raid_device_vendors[$device_index]=$(<$vendorPath)
			# strip trailing space
			raid_device_vendors[$device_index]=$(echo ${raid_device_vendors[$device_index]})
		else
			raid_device_vendors[$device_index]=unknown
		fi
		
		if [ -f $modelPath ]
		then
			raid_device_models[$device_index]=$(<$modelPath)
			raid_device_models[$device_index]=$(echo ${raid_device_models[$device_index]})
		else
			raid_device_models[$device_index]=unknown
		fi
		let device_index=$device_index+1
	done

	
	let device_index=0
	while [ $device_index -lt $variantCount ]

	do
		local vendor_found=0
		local model_found=0

		let variant_index=0
		while [ $variant_index -lt $variantCount ]
		do
			if [ "${raid_device_vendors[$device_index]}" == "${raid_vendors[$deviceCount*$variant_index+$device_index]}" ]
			then
				vendor_found=1
			fi
			let variant_index=$variant_index+1
		done

		if ! (( $vendor_found ))
		then
			echo -n "Device ${raid_devices[$device_index]} is not one of ( " >&2
			for (( variant_index=0; variant_index < $variantCount; variant_index=$variant_index+1 ))
			do
				echo -n "${raid_vendors[$deviceCount*$variant_index+$device_index]} " >&2
			done
			echo " ), it is ${raid_device_vendors[$device_index]}" >&2
			return 1
		fi

		let variant_index=0
                while [ $variant_index -lt $variantCount ]
		do
			if [ "${raid_device_models[$device_index]}" == "${raid_models[$deviceCount*$variant_index+$device_index]}" ]
			then
				model_found=1
			fi
			let variant_index=$variant_index+1
		done

		if ! (( $model_found ))
		then
			echo -n "Device ${raid_devices[$device_index]} is not one of ( " >&2
			let variant_index=0
			while [ $variant_index -lt $variantCount ]
			do
				echo -n "${raid_models[$deviceCount*$variant_index+$device_index]} " >&2
				let variant_index=$variant_index+1
			done
			echo " ), it is ${raid_device_models[$device_index]}" >&2
			return 1
		fi
		let device_index=$device_index+1
	done
	
	return 0
}

function check_eagle_raid
{
	local MR="MegaRAID 8888ELP"
	local ST="ST9160411AS"
	local HT="Hitachi HTE72321"
	local H3="Hitachi HTE72323"
	check_all_raid 5 3 sda sdb sdc sdd sde ATA ATA LSI LSI LSI "$ST"              "$ST"              "$MR" "$MR" "$MR" \
	                   sda sdb sdc sdd sde ""  ""  ""  ""  ""  "$HT"              "$HT"              ""    ""    "" \
	                   sda sdb sdc sdd sde ""  ""  ""  ""  ""  "Hitachi HTE72323" "Hitachi HTE72323" ""    ""    ""
}

function check_eagle_sm_raid
{
	local MR="MR9260DE-8i"
	local MR2="MR9260-8i" 
	local HT="Hitachi HTE72502"
        local ST="ST9160511NS"
	check_all_raid 5 8 sdb sdc sdd sde sdf LSI LSI LSI ATA ATA "$MR" "$MR" "$MR" "$ST" "$ST" \
 	                   sdb sdc sdd sde sdf LSI LSI LSI ATA ATA "$MR" "$MR" "$MR" "$HT" "$HT" \
  	                   sdb sdc sdd sde sdf LSI LSI LSI ATA ATA "$MR2" "$MR2" "$MR2" "$HT" "$HT" \
			   sdb sdc sdd sde sdf LSI LSI LSI ATA ATA "$MR2" "$MR2" "$MR2" "$ST" "$ST" \
  	                   sda sdb sdc sdd sde LSI LSI LSI ATA ATA "$MR" "$MR" "$MR" "$ST" "$ST" \
 	                   sda sdb sdc sdd sde LSI LSI LSI ATA ATA "$MR" "$MR" "$MR" "$HT" "$HT" \
  	                   sda sdb sdc sdd sde LSI LSI LSI ATA ATA "$MR2" "$MR2" "$MR2" "$HT" "$HT" \
			   sda sdb sdc sdd sde LSI LSI LSI ATA ATA "$MR2" "$MR2" "$MR2" "$ST" "$ST"
}

function check_hbldec_raid
{
	# check RAID configuration
	local numLD=`$COMMAND_TOOL -adpallinfo -a0 | grep -i 'Virtual *Drives' | awk '{print $4}'`
	if [ "$numLD" != 3 ]
	then
		echo "Invalid or no RAID configuration found: #LD = $numLD" >> /dev/tty3
                echo "Applying new RAID configuration" >> /dev/tty3 
		return 1
        fi

	local count
	let count=0
	local raidLevel
	local numDrives
	while [ $count -lt 3 ]
	do
		if [ $count -lt 1 ]; then
			raidLevel=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'RAID Level:' | awk '{print $3}'`
			numDrives=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'Number Of Drives:' | awk -F: '{print $2}'` 
			if ! [[ `echo $raidLevel | grep -i 'Primary-5'` &&  "$numDrives" = '5' ]]
			then
				echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
				echo "Applying new RAID configuration" >> /dev/tty3 
				return 1
			fi
		elif [ $count -lt 2 ]; then
			raidLevel=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'RAID Level:' | awk '{print $3}'`
			numDrives=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'Number Of Drives:' | awk -F: '{print $2}'` 
			if ! [[ `echo $raidLevel | grep -i 'Primary-5'` &&  "$numDrives" = '4' ]]
			then
				echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
				echo "Applying new RAID configuration" >> /dev/tty3 
				return 1
			fi 
		else
			raidLevel=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'RAID Level:' | awk '{print $3}'`
			numDrives=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'Number Of Drives:' | awk -F: '{print $2}'` 
			if ! [[ `echo $raidLevel | grep -i 'Primary-0'` &&  "$numDrives" = '1' ]]
			then
				echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
				echo "Applying new RAID configuration" >> /dev/tty3 
				return 1
			fi 	
		fi
		let count=$count+1
	done 
	
	return 0
}

function check_R710LC_raid
{
	# check RAID configuration
	local numLD=`$COMMAND_TOOL -adpallinfo -a0 | grep -i 'Virtual *Drives' | awk '{print $4}'`
	if [ "$numLD" != 1 ]
	then
		echo "Invalid or no RAID configuration found: #LD = $numLD" >> /dev/tty3
                echo "Applying new RAID configuration" >> /dev/tty3 
		return 1
        fi

	local count
	let count=0
	local raidLevel
	local numDrives
	while [ $count -lt 1 ]
	do
		raidLevel=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'RAID Level:' | awk '{print $3}'`
		numDrives=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'Number Of Drives:' | awk -F: '{print $2}'` 
		if ! [[ `echo $raidLevel | grep -i 'Primary-1'` &&  "$numDrives" = '2' ]]
		then
			echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
			echo "Applying new RAID configuration" >> /dev/tty3 
			return 1
		fi
		let count=$count+1
	done 
	
	return 0
}

function check_100_sm_concentrator_drives
{
	check_all_raid 4 2 sda sdb sdc sdd ATA ATA ATA ATA "Hitachi HUA72101" "Hitachi HUA72101" "Hitachi HUA72101" "Hitachi HUA72101" \
                           sdb sdc sdd sde ATA ATA ATA ATA "Hitachi HUA72101" "Hitachi HUA72101" "Hitachi HUA72101" "Hitachi HUA72101"
}

function check_100_sm_decoder_drives
{
	# most decoder/brokers have the Ultrastar drives
	local ULTRA="Hitachi HUA72101"
	# but a few have these Dethstar drives
	local DESK="Hitachi HDE72101"
	check_all_raid 2 4 sdb sdc ATA ATA "$ULTRA" "$ULTRA" \
	                   sdb sdc ""  ""  "$DESK"  "$DESK" \
                           sda sdb ATA ATA "$ULTRA" "$ULTRA" \
	                   sda sdb ""  ""  "$DESK"  "$DESK"
}

function check_200_mp_raid
{
	local numLD=`$COMMAND_TOOL -adpallinfo -a0 | grep -i 'Virtual *Drives' | awk '{print $4}'`
	if [ "$numLD" !=  2 ]
	then
		echo "Invalid or no RAID configuration found: #LD = $numLD" >> /dev/tty3
                echo "Applying new RAID configuration" >> /dev/tty3 
		return 1
        fi

	local count
	let count=0
	local raidLevel
	local numDrives
	while [ $count -lt 2 ]
	do
		raidLevel=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'RAID Level:' | awk '{print $3}'`
		numDrives=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'Number Of Drives:' | awk -F: '{print $2}'` 
		if ! [[ `echo $raidLevel | grep -i 'Primary-5'` &&  "$numDrives" = '4' ]]
		then
			echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
			echo "Applying new RAID configuration" >> /dev/tty3 
			return 1
		fi
		let count=$count+1
	done 
	
	return 0
} 

function check_1200_sm_mpdeco_raid
{
	# check that planar SATA drives are certified for nwappliance 
	local vendor
	local model
	local drive	
	local drives=( `ls -A /sys/block | grep '[hs]d[a-z]'` )
	for drive in ${drives[@]}	
	do
		# skip usb block devices
		if [[ `ls -l /sys/block/$drive | grep -E '/usb[[:digit:]]*/'` ]]; then
			continue
		fi
		vendor=`cat /sys/block/$drive/device/vendor` 
		chomp "$vendor" 
		if [[ -s /tmp/chompstr ]]; then
			vendor=`cat /tmp/chompstr`
		fi	
		model=`cat /sys/block/$drive/device/model`
		chomp "$model"	
		if [[ -s /tmp/chompstr ]]; then
			model=`cat /tmp/chompstr`
		fi	
		# skip raid block devices
		if [[ `echo "$raid_vendors" | grep -i "$vendor"` && `echo "$raid_models" | grep -i "$model"` ]]; then
			continue
		else 
			case $model in
				'ST973402SS' | 'ST9146802SS' | 'MBB2073RC' | 'ST9160511NS' | 'ST9146803SS' | 'INTEL SSDSA2CW16' )
					echo > /dev/null 
				;;
				* )	
					chvt 3
					echo "drive $vendor $model is not a supported device, exiting" > /dev/tty3
					return 1
				;; 
			esac
		fi
	done
	
	# check RAID configuration
	local numLD=`$COMMAND_TOOL -adpallinfo -a0 | grep -i 'Virtual *Drives' | awk '{print $4}'`
	if [ "$numLD" !=  2 ]
	then
		echo "Invalid or no RAID configuration found: #LD = $numLD" >> /dev/tty3
                echo "Applying new RAID configuration" >> /dev/tty3 
		return 1
        fi

	local count
	let count=0
	local raidLevel
	local numDrives
	while [ $count -lt 2 ]
	do
		raidLevel=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'RAID Level:' | awk '{print $3}'`
		numDrives=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'Number Of Drives:' | awk -F: '{print $2}'` 
		if [ $count -eq 0 ]; then
			if ! [[ `echo $raidLevel | grep -i 'Primary-5'` &&  "$numDrives" = '7' ]]
			then
				echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
				echo "Applying new RAID configuration" >> /dev/tty3 
				return 1
			fi
		else
			if ! [[ `echo $raidLevel | grep -i 'Primary-5'` &&  "$numDrives" = '4' ]]
			then
				echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
				echo "Applying new RAID configuration" >> /dev/tty3 
				return 1
			fi 
		fi
		let count=$count+1
	done 
	
	return 0
}

function check_2400_dell_mpdeco_raid
{
	# check RAID configuration
	local numLD=`$COMMAND_TOOL -adpallinfo -a0 | grep -i 'Virtual *Drives' | awk '{print $4}'`
	if [ "$numLD" !=  3 ]
	then
		echo "Invalid or no RAID configuration found: #LD = $numLD" >> /dev/tty3
                echo "Applying new RAID configuration" >> /dev/tty3 
		return 1
        fi

	local count
	let count=0
	local raidLevel
	local numDrives
	while [ $count -lt 3 ]
	do
		raidLevel=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'RAID Level:' | awk '{print $3}'`
		numDrives=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'Number Of Drives:' | awk -F: '{print $2}'` 
		if [ $count -eq 0 ]; then
			if ! [[ `echo $raidLevel | grep -i 'Primary-5'` &&  "$numDrives" = '7' ]]
			then
				echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
				echo "Applying new RAID configuration" >> /dev/tty3 
				return 1
			fi
		elif [ $count -eq 1 ]; then
			if ! [[ `echo $raidLevel | grep -i 'Primary-5'` &&  "$numDrives" = '4' ]]
			then
				echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
				echo "Applying new RAID configuration" >> /dev/tty3 
				return 1
			fi	
		else
			if ! [[ `echo $raidLevel | grep -i 'Primary-1'` &&  "$numDrives" = '2' ]]
			then
				echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
				echo "Applying new RAID configuration" >> /dev/tty3 
				return 1
			fi 
		fi
		let count=$count+1
	done 
	
	return 0
}

function check_for_newport_drives
{
	if ! [ "$nwsystem" = 'dell-s4s-1u' ]; then
		echo 'Can not run check_for_newport_drives() on non S4S HW' >> /tmp/pre.log
		return 1
	fi 
	local ENCID=$("$COMMAND_TOOL" -pdlist -a0 | while read p1 p2 p3 p4; do if [ "$p1" == "Enclosure" ]; then echo $p4; break; fi; done) 
        local pdisk=`$COMMAND_TOOL -adpallinfo -a0 | grep -A1 -i -E 'Physical[[:space:]]+Devices' | grep -i 'Disks' | awk -F: '{print $2}' | awk '{print $1}'`
	let pdisk=$pdisk
	if [ $pdisk -lt 10 ]; then
		echo 'Series 4S Non Newport configuration detected' >> /tmp/pre.log            	
		return 1
	fi
	local ADAPTER=0	
	local count
	local drvError
	local drvsize
	local givensize
	let givensize=931
	local sizelo
        percenterr=`python -c "var = $givensize * 0.05;print var"`
       	let percenterr=${percenterr%%\.*}
	let sizelo=$givensize-$percenterr
	let drvError=0
	let count=0
	while [ $count -lt 10 ]
	do
	     drvsize=`$COMMAND_TOOL -pdinfo -physdrv[$ENCID:$count] -a$ADAPTER | grep -i 'Raw Size:' | awk -F: '{print $2}' | awk '{print $1}'`
             drvsize=${drvsize%%\.*}
             let drvsize=$drvsize
	     if ! [ $drvsize -ge $sizelo ]; then 
                 let drvError=$drvError+1 
             fi 
             let count=$count+1
        done
	if [ $drvError -gt 0 ]; then
		echo 'Series 4S Non Newport configuration detected' >> /tmp/pre.log            	
		return 1
        fi 
	echo 'Series 4S Newport configuration detected' >> /tmp/pre.log
	return 0
}

function check_200_broker_raid
{
	local numLD=`$COMMAND_TOOL -adpallinfo -a0 | grep -i 'Virtual *Drives' | awk '{print $4}'`
	if [ "$numLD" != 1 ]
	then
		echo "Invalid or no RAID configuration found: #LD = $numLD" >> /dev/tty3
                echo "Applying new RAID configuration" >> /dev/tty3 
		return 1
        fi

	local count
	let count=0
	local raidLevel
	local numDrives
	while [ $count -lt 1 ]
	do
		raidLevel=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'RAID Level:' | awk '{print $3}'`
		numDrives=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'Number Of Drives:' | awk -F: '{print $2}'` 
		if ! [[ `echo $raidLevel | grep -i 'Primary-5'` &&  "$numDrives" = '3' ]]
		then
			echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
			echo "Applying new RAID configuration" >> /dev/tty3 
			return 1
		fi
		let count=$count+1
	done 
	
	return 0
} 

function check_200_dellhybrid_raid
{
	local numLD=`$COMMAND_TOOL -adpallinfo -a0 | grep -i 'Virtual *Drives' | awk '{print $4}'`
	if [ "$numLD" !=  5 ]
	then
		echo "Invalid or no RAID configuration found: #LD = $numLD" >> /dev/tty3
                echo "Applying new RAID configuration" >> /dev/tty3 
		return 1
        fi

	local count
	let count=0
	local raidLevel
	local numDrives
	while [ $count -lt 5 ]
	do
		raidLevel=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'RAID Level:' | awk '{print $3}'`
		numDrives=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'Number Of Drives:' | awk -F: '{print $2}'` 
		if ! [[ `echo $raidLevel | grep -i 'Primary-0'` &&  "$numDrives" = '1' ]]
		then
			echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
			echo "Applying new RAID configuration" >> /dev/tty3 
			return 1
		fi
		let count=$count+1
	done 
	
	return 0
} 

function check_200_smhybrid_raid {
 	# check that planar SATA drives are certified for nwappliance 
	local vendor
	local model
	local drive
	local drives=( `ls -A /sys/block | grep '[hs]d[a-z]'` )
	for drive in ${drives[@]}	
	do
		# skip usb block devices
		if [[ `ls -l /sys/block/$drive | grep -E '/usb[[:digit:]]*/'` ]]; then
			continue
		fi
		vendor=`cat /sys/block/$drive/device/vendor` 
		chomp "$vendor" 
		if [[ -s /tmp/chompstr ]]; then
			vendor=`cat /tmp/chompstr`
		fi	
		model=`cat /sys/block/$drive/device/model`
		chomp "$model"	
		if [[ -s /tmp/chompstr ]]; then
			model=`cat /tmp/chompstr`
		fi	
		# skip raid block devices
		if [[ `echo "$raid_vendors" | grep -i "$vendor"` && `echo "$raid_models" | grep -i "$model"` ]]; then
			continue
		else 
			case $model in
				'INTEL SSDSA2M160' | 'INTEL SSDSA2M080' | 'INTEL SSDSA2CW08' )
					echo > /dev/null 
				;;
				* )	
					chvt 3
					echo "drive $vendor $model is not a supported device, exiting" > /dev/tty3
					return 1
				;; 
			esac
		fi
	done 
	
	local numLD=`$COMMAND_TOOL -adpallinfo -a0 | grep -i 'Virtual *Drives' | awk '{print $4}'`
	if [ "$numLD" != 4 ]
	then
		echo "Invalid or no RAID configuration found: #LD = $numLD" >> /dev/tty3
                echo "Applying new RAID configuration" >> /dev/tty3 
		return 1
        fi

	local count
	let count=0
	local raidLevel
	local numDrives
	while [ $count -lt 4 ]
	do
		raidLevel=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'RAID Level:' | awk '{print $3}'`
		numDrives=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'Number Of Drives:' | awk -F: '{print $2}'` 
		if ! [[ `echo $raidLevel | grep -i 'Primary-0'` &&  "$numDrives" = '1' ]]
		then
			echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
			echo "Applying new RAID configuration" >> /dev/tty3 
			return 1
		fi
		let count=$count+1
	done 
	
	return 0
} 

function check_nwx_raid
{
     	# get raid adapter count
	local numadp=`$COMMAND_TOOL -adpcount  | grep -i 'Controller Count:' | awk -F: '{print $2}'`
	let numadp="${numadp%.}"
	# if more than one get PERC ID
	if [[ $numadp -gt 1 ]]; then
		local count
		local percID
		let count=0
		while [[ $count -lt $numadp ]]
		do
			if [[ `$COMMAND_TOOL -adpallinfo -a$count | grep -i 'Product Name' | grep -i 'PERC H700 Integrated'` ]]; then
				percID=$count
				echo "$count" > /tmp/intAdapterId
				break
			fi
		let count=$count+1
		done
		# Intel NWX has integrated RAID controller at ID: 0
		if ! [ $percID ]; then
			percID=0
		fi	
	else
		percID='0'
		echo "$percID" > /tmp/intAdapterId
	fi 
	
	# check number of virtual drives on PERC
	local numLD
	let numLD=`$COMMAND_TOOL -adpallinfo -a$percID | grep -i 'Virtual *Drives' | awk '{print $4}'`
	if [ $numLD -ne 2 ]
	then
		echo "Invalid or no RAID configuration found: #LD = $numLD" >> /dev/tty3
                echo "Applying new RAID configuration" >> /dev/tty3 
		return 1
        fi

	# verify virtual drive configuration
	let count=0
	local raidLevel
	local numDrives
	while [ $count -lt $numLD ]
	do
		raidLevel=`$COMMAND_TOOL -ldinfo -l$count -a$percID | grep -i 'RAID Level:' | awk '{print $3}'`
		numDrives=`$COMMAND_TOOL -ldinfo -l$count -a$percID | grep -i 'Number Of Drives:' | awk -F: '{print $2}'` 
		if ! [[ `echo $raidLevel | grep -i 'Primary-1'` ]] && [ "$numDrives" != '2' ]
		then
			echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
			echo "Applying new RAID configuration" >> /dev/tty3 
			return 1
		fi
		let count=$count+1
	done 
	
	return 0
} 

function check_1200_hybrid_raid
{
     	# check that planar SATA drives are certified for nwappliance 
	local vendor
	local model
	local drive	
	local drives=( `ls -A /sys/block | grep '[hs]d[a-z]'` )
	for drive in ${drives[@]}	
	do
		# skip usb block devices
		if [[ `ls -l /sys/block/$drive | grep -E '/usb[[:digit:]]*/'` ]]; then
			continue
		fi
		vendor=`cat /sys/block/$drive/device/vendor` 
		chomp "$vendor" 
		if [[ -s /tmp/chompstr ]]; then
			vendor=`cat /tmp/chompstr`
		fi	
		model=`cat /sys/block/$drive/device/model`
		chomp "$model"	
		if [[ -s /tmp/chompstr ]]; then
			model=`cat /tmp/chompstr`
		fi	
		# skip raid block devices
		if [[ `echo "$raid_vendors" | grep "$vendor"` && `echo "$raid_models" | grep "$model"` ]]; then
			continue
		else 

			case $model in
				'ST973402SS' | 'ST9146802SS' | 'MBB2073RC' | 'ST9160511NS' | 'ST9146803SS' )
					echo > /dev/null 
				;;
				* )	
					chvt 3
					echo "drive $vendor $model is not a supported device, exiting" > /dev/tty3
					return 1
				;; 
			esac
		fi
	done
	
	# check RAID configuration
	local numLD=`$COMMAND_TOOL -adpallinfo -a0 | grep -i 'Virtual *Drives' | awk '{print $4}'`
	if [ "$numLD" !=  2 ]
	then
		echo "Invalid or no RAID configuration found: #LD = $numLD" >> /dev/tty3
                echo "Applying new RAID configuration" >> /dev/tty3 
		return 1
        fi

	local count
	let count=0
	local raidLevel
	local numDrives
	while [ $count -lt 2 ]
	do
		raidLevel=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'RAID Level:' | awk '{print $3}'`
		numDrives=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'Number Of Drives:' | awk -F: '{print $2}'` 
		if [ $count -eq 0 ]; then
			if ! [[ `echo $raidLevel | grep -i 'Primary-5'` &&  "$numDrives" = '4' ]]
			then
				echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
				echo "Applying new RAID configuration" >> /dev/tty3 
				return 1
			fi
		else
			if ! [[ `echo $raidLevel | grep -i 'Primary-5'` &&  "$numDrives" = '7' ]]
			then
				echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
				echo "Applying new RAID configuration" >> /dev/tty3 
				return 1
			fi 
		fi
		let count=$count+1
	done 
	
	return 0
} 

function check_2u_smconc_raid
{
     	# check that planar SATA drives are certified for nwappliance 
	local vendor
	local model
	local drive	
	local drives=( `ls -A /sys/block | grep '[hs]d[a-z]'` )
	for drive in ${drives[@]}	
	do
		# skip usb block devices
		if [[ `ls -l /sys/block/$drive | grep -E '/usb[[:digit:]]*/'` ]]; then
			continue
		fi
		vendor=`cat /sys/block/$drive/device/vendor` 
		chomp "$vendor" 
		if [[ -s /tmp/chompstr ]]; then
			vendor=`cat /tmp/chompstr`
		fi	
		model=`cat /sys/block/$drive/device/model`
		chomp "$model"	
		if [[ -s /tmp/chompstr ]]; then
			model=`cat /tmp/chompstr`
		fi	
		# skip raid block devices
		if [[ `echo "$raid_vendors" | grep "$vendor"` && `echo "$raid_models" | grep "$model"` ]]; then
			continue
		else
			case $model in
				'ST973402SS' | 'ST9146802SS' | 'MBB2073RC' | 'ST9160511NS' | 'ST9146803SS' | 'INTEL SSDSA2CW16' )
					echo > /dev/null 
				;;
				* )	
					chvt 3
					echo "drive $vendor $model is not a supported device, exiting" > /dev/tty3
					return 1
				;; 
			esac
		fi
	done
	
	# determine if i am a 1200 or 2400 series concentrator?	
	if check_2400_ssd_drives
	then	
		# 2400 series concentrator
		# check RAID configuration
		local numLD=`$COMMAND_TOOL -adpallinfo -a0 | grep -i 'Virtual *Drives' | awk '{print $4}'`
		if [ "$numLD" !=  2 ]
		then
			echo "Invalid or no RAID configuration found: #LD = $numLD" >> /dev/tty3
       	         echo "Applying new RAID configuration" >> /dev/tty3 
			return 1
       		 fi

		local count
		let count=0
		local raidLevel
		local numDrives
		while [ $count -lt 2 ]
		do
			raidLevel=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'RAID Level:' | awk '{print $3}'`
			numDrives=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'Number Of Drives:' | awk -F: '{print $2}'` 
			if [ $count -eq 0 ]; then
				if ! [[ `echo $raidLevel | grep -i 'Primary-5'` &&  "$numDrives" = '6' ]]
				then
					echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
					echo "Applying new RAID configuration" >> /dev/tty3 
					return 1
				fi
			else
				if ! [[ `echo $raidLevel | grep -i 'Primary-5'` &&  "$numDrives" = '5' ]]
				then
					echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
					echo "Applying new RAID configuration" >> /dev/tty3 
					return 1
				fi 
			fi
			let count=$count+1
		done 
	
		return 0
	elif check_1200_ssd_drives
	then
		# 1200 series concentrator	
		# check RAID configuration
		local numLD=`$COMMAND_TOOL -adpallinfo -a0 | grep -i 'Virtual *Drives' | awk '{print $4}'`
		if [ "$numLD" !=  2 ]
		then
			echo "Invalid or no RAID configuration found: #LD = $numLD" >> /dev/tty3
	                echo "Applying new RAID configuration" >> /dev/tty3 
			return 1
   	     fi

		local count
		let count=0
		local raidLevel
		local numDrives
		while [ $count -lt 2 ]
		do
			raidLevel=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'RAID Level:' | awk '{print $3}'`
			numDrives=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'Number Of Drives:' | awk -F: '{print $2}'` 
			if [ $count -eq 0 ]; then
				if ! [[ `echo $raidLevel | grep -i 'Primary-5'` &&  "$numDrives" = '8' ]]
				then
					echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
					echo "Applying new RAID configuration" >> /dev/tty3 
					return 1
				fi
			else
				if ! [[ `echo $raidLevel | grep -i 'Primary-5'` &&  "$numDrives" = '3' ]]
				then
					echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
					echo "Applying new RAID configuration" >> /dev/tty3 
					return 1
				fi 
			fi
			let count=$count+1
		done 
		return 0
	elif ! check_1200_ssd_drives && ! check_2400_ssd_drives
	then
		# neither 1200 or 2400 series concentrator
		echo > /dev/tty3
		echo "------------------------------------------------------------------------------------" > /dev/tty3
		echo " Either no solid state devices were found or they are not populated in slots 8 - 10" > /dev/tty3
		echo " for a 1200 series Concentrator or slots 6 - 10 for a 2400 series Concentrator" > /dev/tty3
		echo " Please check system hardware, the resulting configuration maybe invalid" > /dev/tty3
		echo "------------------------------------------------------------------------------------" > /dev/tty3
		echo > /dev/tty3 
		return 1
	fi	
}

function check_2u_dell_conc_raid
{
	# determine if i am a 1200 or 2400 series concentrator?	
	if check_2400_ssd_drives
	then	
		# 2400 series concentrator
		# check RAID configuration
		local numLD=`$COMMAND_TOOL -adpallinfo -a0 | grep -i 'Virtual *Drives' | awk '{print $4}'`
		if [ "$numLD" !=  3 ]
		then
			echo "Invalid or no RAID configuration found: #LD = $numLD" >> /dev/tty3
	                echo "Applying new RAID configuration" >> /dev/tty3 
			return 1
	        fi

		local count
		let count=0
		local raidLevel
		local numDrives
		while [ $count -lt 3 ]
		do
			raidLevel=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'RAID Level:' | awk '{print $3}'`
			numDrives=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'Number Of Drives:' | awk -F: '{print $2}'` 
			if [ $count -eq 0 ]; then
				if ! [[ `echo $raidLevel | grep -i 'Primary-5'` &&  "$numDrives" = '6' ]]
				then
					echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
					echo "Applying new RAID configuration" >> /dev/tty3 
					return 1
				fi
			elif [ $count -eq 1 ]; then
				if ! [[ `echo $raidLevel | grep -i 'Primary-5'` &&  "$numDrives" = '5' ]]
				then
					echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
					echo "Applying new RAID configuration" >> /dev/tty3 
					return 1
				fi	
			else
				if ! [[ `echo $raidLevel | grep -i 'Primary-1'` &&  "$numDrives" = '2' ]]
				then
					echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
					echo "Applying new RAID configuration" >> /dev/tty3 
					return 1
				fi 
			fi
			let count=$count+1
		done
		return 0
	elif check_1200_ssd_drives
	then
		# 1200 series concentrator	
		# check RAID configuration
		local numLD=`$COMMAND_TOOL -adpallinfo -a0 | grep -i 'Virtual *Drives' | awk '{print $4}'`
		if [ "$numLD" !=  3 ]
		then
			echo "Invalid or no RAID configuration found: #LD = $numLD" >> /dev/tty3
			echo "Applying new RAID configuration" >> /dev/tty3 
			return 1
		fi

		local count
		let count=0
		local raidLevel
		local numDrives
		while [ $count -lt 3 ]
		do
			raidLevel=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'RAID Level:' | awk '{print $3}'`
			numDrives=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'Number Of Drives:' | awk -F: '{print $2}'` 
			if [ $count -eq 0 ]; then
				if ! [[ `echo $raidLevel | grep -i 'Primary-5'` &&  "$numDrives" = '8' ]]
				then
					echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
					echo "Applying new RAID configuration" >> /dev/tty3 
					return 1
				fi
			elif [ $count -eq 1 ]; then
				if ! [[ `echo $raidLevel | grep -i 'Primary-5'` &&  "$numDrives" = '3' ]]
				then
					echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
					echo "Applying new RAID configuration" >> /dev/tty3 
					return 1
				fi	
			else
				if ! [[ `echo $raidLevel | grep -i 'Primary-1'` &&  "$numDrives" = '2' ]]
				then
					echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
					echo "Applying new RAID configuration" >> /dev/tty3 
					return 1
				fi 
			fi
		let count=$count+1
		done
		return 0
	elif ! check_1200_ssd_drives && ! check_2400_ssd_drives
	then
		# neither 1200 or 2400 series concentrator
		echo > /dev/tty3
		echo "------------------------------------------------------------------------------------" > /dev/tty3
		echo " Either no solid state devices were found or they are not populated in slots 8 - 10" > /dev/tty3
		echo " for a 1200 series Concentrator or slots 6 - 10 for a 2400 series Concentrator" > /dev/tty3
		echo " Please check system hardware, the resulting configuration maybe invalid" > /dev/tty3
		echo "------------------------------------------------------------------------------------" > /dev/tty3
		echo > /dev/tty3 
		return 1
	fi

} 

function check_2400_dell_decoder_raid
{
	# check RAID configuration
	local numLD=`$COMMAND_TOOL -adpallinfo -a0 | grep -i 'Virtual *Drives' | awk '{print $4}'`
	if [ "$numLD" !=  3 ]
	then
		echo "Invalid or no RAID configuration found: #LD = $numLD" >> /dev/tty3
                echo "Applying new RAID configuration" >> /dev/tty3 
		return 1
        fi

	local count
	let count=0
	local raidLevel
	local numDrives
	while [ $count -lt 3 ]
	do
		raidLevel=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'RAID Level:' | awk '{print $3}'`
		numDrives=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'Number Of Drives:' | awk -F: '{print $2}'` 
		if [ $count -eq 0 ]; then
			if ! [[ `echo $raidLevel | grep -i 'Primary-5'` &&  "$numDrives" = '8' ]]
			then
				echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
				echo "Applying new RAID configuration" >> /dev/tty3 
				return 1
			fi
		elif [ $count -eq 1 ]; then
			if ! [[ `echo $raidLevel | grep -i 'Primary-5'` &&  "$numDrives" = '3' ]]
			then
				echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
				echo "Applying new RAID configuration" >> /dev/tty3 
				return 1
			fi	
		else
			if ! [[ `echo $raidLevel | grep -i 'Primary-1'` &&  "$numDrives" = '2' ]]
			then
				echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
				echo "Applying new RAID configuration" >> /dev/tty3 
				return 1
			fi 
		fi
	let count=$count+1
	done 
	
	return 0
}

function check_hbdeco_raid
{
	# check RAID configuration
	local numLD=`$COMMAND_TOOL -adpallinfo -a0 | grep -i 'Virtual *Drives' | awk '{print $4}'`
	if [ "$numLD" != 3 ]
	then
		echo "Invalid or no RAID configuration found: #LD = $numLD" >> /dev/tty3
                echo "Applying new RAID configuration" >> /dev/tty3 
		return 1
        fi

	local count
	let count=0
	local raidLevel
	local numDrives
	while [ $count -lt 3 ]
	do
		if [ $count -lt 1 ]; then
			raidLevel=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'RAID Level:' | awk '{print $3}'`
			numDrives=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'Number Of Drives:' | awk -F: '{print $2}'` 
			if ! [[ `echo $raidLevel | grep -i 'Primary-5'` &&  "$numDrives" = '6' ]]
			then
				echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
				echo "Applying new RAID configuration" >> /dev/tty3 
				return 1
			fi
		elif [ $count -lt 2 ]; then
			raidLevel=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'RAID Level:' | awk '{print $3}'`
			numDrives=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'Number Of Drives:' | awk -F: '{print $2}'` 
			if ! [[ `echo $raidLevel | grep -i 'Primary-5'` &&  "$numDrives" = '3' ]]
			then
				echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
				echo "Applying new RAID configuration" >> /dev/tty3 
				return 1
			fi 
		else
			raidLevel=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'RAID Level:' | awk '{print $3}'`
			numDrives=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'Number Of Drives:' | awk -F: '{print $2}'` 
			if ! [[ `echo $raidLevel | grep -i 'Primary-0'` &&  "$numDrives" = '1' ]]
			then
				echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
				echo "Applying new RAID configuration" >> /dev/tty3 
				return 1
			fi 	
		fi
		let count=$count+1
	done 
	
	return 0
}

function check_s5_hybrid_raid
{
	# check RAID configuration
	local numLD=`$COMMAND_TOOL -adpallinfo -a0 | grep -i 'Virtual *Drives' | awk '{print $4}'`
	if [ "$numLD" != 5 ]
	then
		echo "Invalid or no RAID configuration found: #LD = $numLD" >> /dev/tty3
                echo "Applying new RAID configuration" >> /dev/tty3 
		return 1
        fi

	local count
	let count=0
	local raidLevel
	local numDrives
	while [ $count -lt 5 ]
	do
		if [ $count -eq 0 ]; then
			raidLevel=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'RAID Level:' | awk '{print $3}'`
			numDrives=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'Number Of Drives:' | awk -F: '{print $2}'` 
			if ! [[ `echo $raidLevel | grep -i 'Primary-1'` &&  "$numDrives" = '2' ]]
			then
				echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
				echo "Applying new RAID configuration" >> /dev/tty3 
				return 1
			fi

		elif [ $count -eq 1 ]; then
			raidLevel=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'RAID Level:' | awk '{print $3}'`
			numDrives=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'Number Of Drives:' | awk -F: '{print $2}'` 
			if ! [[ `echo $raidLevel | grep -i 'Primary-1'` &&  "$numDrives" = '2' ]]
			then
				echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
				echo "Applying new RAID configuration" >> /dev/tty3 
				return 1
			fi
		elif [ $count -eq 2 ]; then
			raidLevel=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'RAID Level:' | awk '{print $3}'`
			numDrives=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'Number Of Drives:' | awk -F: '{print $2}'` 
			if ! [[ `echo $raidLevel | grep -i 'Primary-5'` &&  "$numDrives" = '4' ]]
			then
				echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
				echo "Applying new RAID configuration" >> /dev/tty3 
				return 1
			fi 
		elif [ $count -eq 3 ]; then
			raidLevel=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'RAID Level:' | awk '{print $3}'`
			numDrives=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'Number Of Drives:' | awk -F: '{print $2}'` 
			if [ -z $1 ]; then
				if ! [[ `echo $raidLevel | grep -i 'Primary-5'` &&  "$numDrives" = '3' ]]
				then
					echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
					echo "Applying new RAID configuration" >> /dev/tty3 
					return 1
				fi
			else
				if ! [[ `echo $raidLevel | grep -i 'Primary-5'` &&  "$numDrives" = '4' ]]
				then
					echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
					echo "Applying new RAID configuration" >> /dev/tty3 
					return 1
				fi
			fi
 		else	
			raidLevel=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'RAID Level:' | awk '{print $3}'`
			numDrives=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'Number Of Drives:' | awk -F: '{print $2}'` 
			if ! [[ `echo $raidLevel | grep -i 'Primary-1'` &&  "$numDrives" = '2' ]]
			then
				echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
				echo "Applying new RAID configuration" >> /dev/tty3 
				return 1
			fi	
		fi
		let count=$count+1
	done 
	
	return 0
}

function check_2400_dell_conc_raid
{
	# check RAID configuration
	local numLD=`$COMMAND_TOOL -adpallinfo -a0 | grep -i 'Virtual *Drives' | awk '{print $4}'`
	if [ "$numLD" !=  3 ]
	then
		echo "Invalid or no RAID configuration found: #LD = $numLD" >> /dev/tty3
                echo "Applying new RAID configuration" >> /dev/tty3 
		return 1
        fi

	local count
	let count=0
	local raidLevel
	local numDrives
	while [ $count -lt 3 ]
	do
		raidLevel=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'RAID Level:' | awk '{print $3}'`
		numDrives=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'Number Of Drives:' | awk -F: '{print $2}'` 
		if [ $count -eq 0 ]; then
			if ! [[ `echo $raidLevel | grep -i 'Primary-5'` &&  "$numDrives" = '6' ]]
			then
				echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
				echo "Applying new RAID configuration" >> /dev/tty3 
				return 1
			fi
		elif [ $count -eq 1 ]; then
			if ! [[ `echo $raidLevel | grep -i 'Primary-5'` &&  "$numDrives" = '5' ]]
			then
				echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
				echo "Applying new RAID configuration" >> /dev/tty3 
				return 1
			fi	
		else
			if ! [[ `echo $raidLevel | grep -i 'Primary-1'` &&  "$numDrives" = '2' ]]
			then
				echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
				echo "Applying new RAID configuration" >> /dev/tty3 
				return 1
			fi 
		fi
		let count=$count+1
	done 
	
	return 0
}

function check_2400_dell_mpdeco_raid
{
	# check RAID configuration
	local numLD=`$COMMAND_TOOL -adpallinfo -a0 | grep -i 'Virtual *Drives' | awk '{print $4}'`
	if [ "$numLD" !=  3 ]
	then
		echo "Invalid or no RAID configuration found: #LD = $numLD" >> /dev/tty3
                echo "Applying new RAID configuration" >> /dev/tty3 
		return 1
        fi

	local count
	let count=0
	local raidLevel
	local numDrives
	while [ $count -lt 3 ]
	do
		raidLevel=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'RAID Level:' | awk '{print $3}'`
		numDrives=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'Number Of Drives:' | awk -F: '{print $2}'` 
		if [ $count -eq 0 ]; then
			if ! [[ `echo $raidLevel | grep -i 'Primary-5'` &&  "$numDrives" = '7' ]]
			then
				echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
				echo "Applying new RAID configuration" >> /dev/tty3 
				return 1
			fi
		elif [ $count -eq 1 ]; then
			if ! [[ `echo $raidLevel | grep -i 'Primary-5'` &&  "$numDrives" = '4' ]]
			then
				echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
				echo "Applying new RAID configuration" >> /dev/tty3 
				return 1
			fi	
		else
			if ! [[ `echo $raidLevel | grep -i 'Primary-1'` &&  "$numDrives" = '2' ]]
			then
				echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
				echo "Applying new RAID configuration" >> /dev/tty3 
				return 1
			fi 
		fi
		let count=$count+1
	done 
	
	return 0
} 

function check_hadoop_raid
{
	# check RAID configuration
	local numLD=`$COMMAND_TOOL -adpallinfo -a0 | grep -i 'Virtual *Drives' | awk '{print $4}'`
	if [ "$numLD" != 10 ]
	then
		echo "Invalid or no RAID configuration found: #LD = $numLD" >> /dev/tty3
                echo "Applying new RAID configuration" >> /dev/tty3 
		return 1
        fi

	local count
	let count=0
	local raidLevel
	local numDrives
	while [ $count -lt 10 ]
	do
		raidLevel=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'RAID Level:' | awk '{print $3}'`
		numDrives=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'Number Of Drives:' | awk -F: '{print $2}'` 
		if ! [[ `echo $raidLevel | grep -i 'Primary-0'` &&  "$numDrives" = '1' ]]
		then
			echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
			echo "Applying new RAID configuration" >> /dev/tty3 
			return 1
		fi
		let count=$count+1
	done 
	
	return 0
} 

function check_mpbrok_raid
{
	# check RAID configuration
	local numLD=`$COMMAND_TOOL -adpallinfo -a0 | grep -i 'Virtual *Drives' | awk '{print $4}'`
	if [ "$numLD" != 2 ]
	then
		echo "Invalid or no RAID configuration found: #LD = $numLD" >> /dev/tty3
                echo "Applying new RAID configuration" >> /dev/tty3 
		return 1
        fi

	local count
	let count=0
	local raidLevel
	local numDrives
	while [ $count -lt 2 ]
	do
		if [ $count -lt 1 ]; then
			raidLevel=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'RAID Level:' | awk '{print $3}'`
			numDrives=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'Number Of Drives:' | awk -F: '{print $2}'` 
			if ! [[ `echo $raidLevel | grep -i 'Primary-5'` &&  "$numDrives" = '3' ]]
			then
				echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
				echo "Applying new RAID configuration" >> /dev/tty3 
				return 1
			fi
		else
			raidLevel=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'RAID Level:' | awk '{print $3}'`
			numDrives=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'Number Of Drives:' | awk -F: '{print $2}'` 
			if ! [[ `echo $raidLevel | grep -i 'Primary-5'` &&  "$numDrives" = '6' ]]
			then
				echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
				echo "Applying new RAID configuration" >> /dev/tty3 
				return 1
			fi 	
		fi
		let count=$count+1
	done 
	
	return 0
}

function check_1200_decoder_raid
{
	# check that planar SATA drives are certified for nwappliance 
	local vendor
	local model
	local drive
	local drives=( `ls -A /sys/block | grep '[hs]d[a-z]'` )
	for drive in ${drives[@]}	
	do
		# skip usb block devices
		if [[ `ls -l /sys/block/$drive | grep -E '/usb[[:digit:]]*/'` ]]; then
			continue
		fi
		vendor=`cat /sys/block/$drive/device/vendor` 
		chomp "$vendor" 
		if [[ -s /tmp/chompstr ]]; then
			vendor=`cat /tmp/chompstr`
		fi	
		model=`cat /sys/block/$drive/device/model`
		chomp "$model"	
		if [[ -s /tmp/chompstr ]]; then
			model=`cat /tmp/chompstr`
		fi	
		# skip raid block devices
		if [[ `echo "$raid_vendors" | grep -i "$vendor"` && `echo "$raid_models" | grep -i "$model"` ]]; then
			continue
		else
			case $model in
				'ST973402SS' | 'ST9146802SS' | 'MBB2073RC' | 'ST9160511NS' | 'ST9146803SS' | 'INTEL SSDSA2CW16' )
					echo > /dev/null 
				;;
				* )	
					chvt 3
					echo "drive $vendor $model is not a supported device, exiting" > /dev/tty3
					return 1
				;; 
			esac
		fi
	done
	
	# check RAID configuration
	local numLD=`$COMMAND_TOOL -adpallinfo -a0 | grep -i 'Virtual *Drives' | awk '{print $4}'`
	if [ "$numLD" !=  2 ]
	then
		echo "Invalid or no RAID configuration found: #LD = $numLD" >> /dev/tty3
                echo "Applying new RAID configuration" >> /dev/tty3 
		return 1
        fi

	local count
	let count=0
	local raidLevel
	local numDrives
	while [ $count -lt 2 ]
	do
		raidLevel=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'RAID Level:' | awk '{print $3}'`
		numDrives=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'Number Of Drives:' | awk -F: '{print $2}'` 
		if [ $count -eq 0 ]; then
			if ! [[ `echo $raidLevel | grep -i 'Primary-5'` &&  "$numDrives" = '8' ]]
			then
				echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
				echo "Applying new RAID configuration" >> /dev/tty3 
				return 1
			fi
		else
			if ! [[ `echo $raidLevel | grep -i 'Primary-5'` &&  "$numDrives" = '3' ]]
			then
				echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
				echo "Applying new RAID configuration" >> /dev/tty3 
				return 1
			fi 
		fi
		let count=$count+1
	done 
	
	return 0
} 

function check_sm_eagle_raid
{
	# check that planar SATA drives are certified for nwappliance 
	local vendor
	local model 
	local drives=( `ls -A /sys/block | grep '[hs]d[a-z]'` )
	for drive in ${drives[@]}	
	do
		# skip usb block devices
		if [[ `ls -l /sys/block/$drive | grep -E '/usb[[:digit:]]*/'` ]]; then
			continue
		fi
		vendor=`cat /sys/block/$drive/device/vendor` 
		chomp "$vendor" 
		if [[ -s /tmp/chompstr ]]; then
			vendor=`cat /tmp/chompstr`
		fi	
		model=`cat /sys/block/$drive/device/model`
		chomp "$model"	
		if [[ -s /tmp/chompstr ]]; then
			model=`cat /tmp/chompstr`
		fi	
		# skip raid block devices
		if [[ `echo "$raid_vendors" | grep -i "$vendor"` && `echo "$raid_models" | grep -i "$model"` ]]; then
			continue
		else 
			case $model in
				"Hitachi HTE72502" | "ST9160511NS" )
					echo > /dev/null 
				;;
				* )	
					chvt 3
					echo "drive $vendor $model is not a supported device, exiting" > /dev/tty3
					return 1
				;; 
			esac
		fi
	done
	# check RAID configuration
	local numLD=`$COMMAND_TOOL -adpallinfo -a0 | grep -i 'Virtual *Drives' | awk '{print $4}'`
	if [ "$numLD" !=  3 ]
	then
		echo "Invalid or no RAID configuration found: #LD = $numLD" >> /dev/tty3
                echo "Applying new RAID configuration" >> /dev/tty3 
		return 1
        fi

	local count
	let count=0
	local raidLevel
	local numDrives
	while [ $count -lt 3 ]
	do
		raidLevel=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'RAID Level:' | awk '{print $3}'`
		numDrives=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'Number Of Drives:' | awk -F: '{print $2}'` 
		if [ $count -eq 0 ]; then
			if ! [[ `echo $raidLevel | grep -i 'Primary-5'` &&  "$numDrives" = '5' ]]
			then
				echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
				echo "Applying new RAID configuration" >> /dev/tty3 
				return 1
			fi
		elif [ $count -eq 1 ]; then
			if ! [[ `echo $raidLevel | grep -i 'Primary-1'` &&  "$numDrives" = '2' ]]
			then
				echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
				echo "Applying new RAID configuration" >> /dev/tty3 
				return 1
			fi 
		else
			if ! [[ `echo $raidLevel | grep -i 'Primary-0'` &&  "$numDrives" = '1' ]]
			then
				echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
				echo "Applying new RAID configuration" >> /dev/tty3 
				return 1
			fi 
		fi
		let count=$count+1
	done 
	
	return 0
} 

function check_1200_mpdeco_raid
{
	# check that planar SATA drives are certified for nwappliance 
	local vendor
	local model 
	local drives=( `ls -A /sys/block | grep '[hs]d[a-z]'` )
	for drive in ${drives[@]}	
	do
		# skip usb block devices
		if [[ `ls -l /sys/block/$drive | grep -E '/usb[[:digit:]]*/'` ]]; then
			continue
		fi
		vendor=`cat /sys/block/$drive/device/vendor` 
		chomp "$vendor" 
		if [[ -s /tmp/chompstr ]]; then
			vendor=`cat /tmp/chompstr`
		fi	
		model=`cat /sys/block/$drive/device/model`
		chomp "$model"	
		if [[ -s /tmp/chompstr ]]; then
			model=`cat /tmp/chompstr`
		fi	
		# skip raid block devices
		if [[ `echo "$raid_vendors" | grep -i "$vendor"` && `echo "$raid_models" | grep -i "$model"` ]]; then
			continue
		else 
			case $model in
				'ST973402SS' | 'ST9146802SS' | 'MBB2073RC' | 'ST9160511NS' | 'ST9146803SS' | 'INTEL SSDSA2CW16' )
					echo > /dev/null 
				;;
				* )	
					chvt 3
					echo "drive $vendor $model is not a supported device, exiting" > /dev/tty3
					return 1
				;; 
			esac
		fi
	done
	
	# check RAID configuration
	local numLD=`$COMMAND_TOOL -adpallinfo -a0 | grep -i 'Virtual *Drives' | awk '{print $4}'`
	if [ "$numLD" !=  2 ]
	then
		echo "Invalid or no RAID configuration found: #LD = $numLD" >> /dev/tty3
                echo "Applying new RAID configuration" >> /dev/tty3 
		return 1
        fi

	local count
	let count=0
	local raidLevel
	local numDrives
	while [ $count -lt 2 ]
	do
		raidLevel=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'RAID Level:' | awk '{print $3}'`
		numDrives=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'Number Of Drives:' | awk -F: '{print $2}'` 
		if [ $count -eq 0 ]; then
			if ! [[ `echo $raidLevel | grep -i 'Primary-5'` &&  "$numDrives" = '7' ]]
			then
				echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
				echo "Applying new RAID configuration" >> /dev/tty3 
				return 1
			fi
		else
			if ! [[ `echo $raidLevel | grep -i 'Primary-5'` &&  "$numDrives" = '4' ]]
			then
				echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
				echo "Applying new RAID configuration" >> /dev/tty3 
				return 1
			fi 
		fi
		let count=$count+1
	done 
	
	return 0
} 

function check_esa_raid
{
	# check RAID configuration
	local numLD=`$COMMAND_TOOL -adpallinfo -a0 | grep -i 'Virtual *Drives' | awk '{print $4}'`
	if [ "$numLD" != 1 ]
	then
		echo "Invalid or no RAID configuration found: #LD = $numLD" >> /dev/tty3
                echo "Applying new RAID configuration" >> /dev/tty3 
		return 1
        fi

	local count
	let count=0
	local raidLevel
	local numDrives
	while [ $count -lt 1 ]
	do
		raidLevel=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'RAID Level:' | awk '{print $3}'`
		numDrives=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'Number Of Drives:' | awk -F: '{print $2}'` 
		if ! [[ `echo $raidLevel | grep -i 'Primary-5'` &&  "$numDrives" = '9' ]]
		then
			echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
			echo "Applying new RAID configuration" >> /dev/tty3 
			return 1
		fi
		let count=$count+1
	done 
	
	return 0
}

function check_s7_esa_raid
{
	# check RAID configuration
	local numLD=`$COMMAND_TOOL -adpallinfo -a0 | grep -i 'Virtual *Drives' | awk '{print $4}'`
	if [ "$numLD" != 2 ]
	then
		echo "Invalid or no RAID configuration found: #LD = $numLD" >> /dev/tty3
                echo "Applying new RAID configuration" >> /dev/tty3 
		return 1
        fi

	local count
	let count=0
	local raidLevel
	local numDrives
	while [ $count -lt 2 ]
	do
		if [ $count -eq 0 ]; then
			raidLevel=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'RAID Level:' | awk '{print $3}'`
			numDrives=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'Number Of Drives:' | awk -F: '{print $2}'` 
			if ! [[ `echo $raidLevel | grep -i 'Primary-1'` &&  "$numDrives" = '2' ]]
			then
				echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
				echo "Applying new RAID configuration" >> /dev/tty3 
				return 1
			fi
		elif [ $count -eq 1 ]; then
			raidLevel=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'RAID Level:' | awk '{print $3}'`
			numDrives=`$COMMAND_TOOL -ldinfo -l$count -a0 | grep -i 'Number Of Drives:' | awk -F: '{print $2}'` 
			if ! [[ `echo $raidLevel | grep -i 'Primary-5'` &&  "$numDrives" = '3' ]]
			then
				echo "Invalid or no RAID configuration found: RAID Level = $raidLevel #HDD = $numDrives" >> /dev/tty3
				echo "Applying new RAID configuration" >> /dev/tty3 
				return 1
			fi	
		fi
		let count=$count+1
	done 
	
	return 0
}

function check_ata_label {
	# the el6 installer kernel tends to label usb flash drives as sda
	# in older 2U appliances the next logical hdd device can vary with
	# each reboot e.g. after RAID config, as RAID VD or SATA block device
	# enforce /dev/$1 as a planar SATA device
	if ! [ -z $1 ]; then
	  	local vendor=`cat /sys/block/$1/device/vendor`
		chomp "$vendor"
		if [ -s /tmp/chompstr ]; then
			vendor=`cat /tmp/chompstr`
		fi
		local model=`cat /sys/block/$1/device/model`
		chomp "$model"
		if [ -s /tmp/chompstr ]; then
			model=`cat /tmp/chompstr`
		fi
		if [[ `echo "$raid_vendors" | grep -i "$vendor"` && `echo "$raid_models" | grep -i "$model"` ]]; then
			chvt 3
			echo > /dev/tty3
			echo "disk device labeling error, run installation after reboot" > /dev/tty3
			echo "rebooting in 10 seconds ..." > /dev/tty3 
			echo "if condition persists try system halt and power disconnect" > /dev/tty3 
			sleep 10
			reboot
		fi
	fi
}

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

function chk4_nwx_intel_eusb {
	local eusb=
	if ! [ -z $1 ]; then
	       eusb=1
	fi	       
	local blockdev=( `ls /sys/block | grep 'sd[a-z]'` ) 
	local numusb
	local usbcount
	if [ $eusb ]; then
		if [[ `grep  -A1 '^ *install' /tmp/ks.cfg | grep 'harddrive'` ]]; then
			let numusb=2
		else
			let numusb=1
		fi 
	else
		if [[ `grep  -A1 '^ *install' /tmp/ks.cfg | grep 'harddrive'` ]]; then
			let numusb=1
		else
			let numusb=0
		fi 
	fi
	let usbcount=0        
	for device in ${blockdev[@]}
	do
		if [[ `ls -l /sys/block/$device | grep -i '/usb[0-9]*/'` ]]; then
			let usbcount=$usbcount+1
		fi
	done
	
	if [ $eusb ]; then
		if [ $usbcount -lt $numusb ]; then
			chvt 3
			echo > /dev/tty3
			echo " Only $usbcount of the $numusb required USB block devices found" > /dev/tty3
			echo " This kickstart is for intel nwx systems with a eUSB device" > /dev/tty3
	       		echo " Please install/verify the eUSB device and re-install" > /dev/tty3
			echo " Halting system in 60 seconds ..." > /dev/tty3
			sleep 60
			halt -p
		fi 
	else	
		if [ $usbcount -gt $numusb ]; then
			chvt 3
			echo > /dev/tty3
			echo " Found $usbcount USB block devices, only $numusb are allowed" > /dev/tty3
			echo " This kickstart is for intel nwx systems without a eUSB device" > /dev/tty3
	       		echo " Please remove the eUSB device and re-install" > /dev/tty3
			echo " Halting system in 60 seconds ..." > /dev/tty3
			sleep 60
			halt -p
		fi
	fi
} 

function check_return {
	return 0
}

# call raid hba configuration script
function initRaid {
	/tmp/initraid.sh
}

function clearRaidPrompt {
	local usrchoice
	echo > /dev/tty3
	echo '--------------------------------------------' > /dev/tty3
	echo ' The current drive configuration is invalid' > /dev/tty3
	echo " for the selected appliance: $nwapptype" > /dev/tty3
	echo ' The system will auto restart in 30 seconds' > /dev/tty3
	echo ' If upgrading please verify that you have' > /dev/tty3 
	echo ' selected the correct menu item' > /dev/tty3
	echo  > /dev/tty3
	echo ' Enter (y/Y) to continue the installation' > /dev/tty3
	echo ' NOTE: this will clear the existing disks' > /dev/tty3
	echo ' *Discarding All Data* and is Irreversible' > /dev/tty3       	
	echo '--------------------------------------------' > /dev/tty3
	exec < /dev/tty3 > /dev/tty3 2>&1
	read -t 30 -p 'Enter Y to Continue, Restart in 30 seconds? ' usrchoice
	if [[ $usrchoice = y || $usrchoice = Y ]]; then
	       return 0
	else
 		exit 1
	fi
}

function prehwimgsrv {
	# enable sshd daemon in %pre install if pxe image testing is detected
	
	local cfgpath='/etc/ssh'
	local keyfile="${cfgpath}/ssh_host_rsa_key"
	local keyfilepub="${cfgpath}/ssh_host_rsa_key.pub"
	local sshd_config="${cfgpath}/sshd_config"
	local mysshd_config='Port 22\nHostKey /etc/ssh/ssh_host_rsa_key\nPermitRootLogin yes\nIgnoreRhosts yes\nStrictModes yes\nX11Forwarding yes\nX11DisplayOffset 10\nPrintMotd yes\nXAuthLocation /sbin/xauth\nKeepAlive yes\nSyslogFacility AUTHPRIV\nRSAAuthentication yes\nPasswordAuthentication yes\nPermitEmptyPasswords yes\nPermitUserEnvironment yes' 
        local hostkey='-----BEGIN RSA PRIVATE KEY-----\nMIIEoAIBAAKCAQEAtRki+qm3GpRyJAfRRPekqmV2EKbm9P+ANZxUxyMAz6MGdXXV\nVU36JJ5HZ6fzIfMsj3sli0m2VzVmGtot3R+J0bOQX3z73l+13ApGafAke6sJXFMf\nrwgsP8P1FMNSE/ogjLYe6T9qcy0HwHd6SL8CwrWg00ezuyhAiFSNPlUKSD7HMg1S\ntZtYy/SC8k8a2yO4POj9zk+lk2Vggn9qvlctAaQfqxUfJs9jXO9/m4JYEgL2x4wO\nnzjK8Y+PEkKZRItGqjd1Vd2uIc7ko2PQwbw34/nJzYhjTEYutl5HEy8YsiyYJNtr\nBlBCLV9w+0vePrst6J0SsMZvPeUGm8b0+i5cGQIBIwKCAQApZNTLlIGfrObjqgPy\ngb884/26qc5j4qD2T55ZZxYg1M5Gu9j9jiqMBuu/69/NPuWdI3ZLuRO8KXZsiaQV\nSQmPBHjFXmV0qCmRYW8uKELacDynY3T0zqsHQrus+XHYrjNTXNPditaAudXi2XsJ\nUDslMNRNjLtd+pJoTdckMLHkoD/I9BcrQ1S6+i12RB24/F/Hnjmv/pmP8e3qOohp\nsPKNdDW06/Zu0BfYtMOYgv3AOZ/zjQpkrEJhZOAbiBknChXgL4SwwWKq1ER6nclH\n7RfaY/YGGvY4vDs+V/A8FiWu8u7wXPS3+oc8TW5Iqfn/+B0Acxkckmw4h+rHpXvm\n++nrAoGBAOoTj/iAetHjzCYr9sLZ+ykjOdyUFRhaBjrYa0dzagEd6oF4halPVMgp\n8s6RQZd0eN1KGnD+1+HkdDjA270FEt2g/OF5b6aRrpCG4Howun76bU9aptzZjJkY\ne4mN1XG+KBYdsntUNCAdB6pynBFojbvJ1eULr4HrpCqAt/n5QtDTAoGBAMYPUXTX\n2fQ2IdXg7lX32GwQWuTYQK1jnLTJVA58hwa43TM7Bx+yrDLe5dlPA6p0jf2z6JAn\n70ajAgHY8240rElUaq9XH/fkv6iEEQX2VHCOFyYYK5E6ghJtIgJ+eMIWnayrkkEN\nNBJohQQKyCcWT/M8z5/IFlPa7jjxmvzuXWvjAoGAFBBOKz42acMRf51eSzdBae0T\nlpBZlF984HjzQKN+HVpV7dchZkig3fT3jgxzVh/tGkguJvFFtEbIIh8oxw8QPuHp\nyi768QUsOEYTPaxnwb2xmRZmEu4TXZRiXD9bcCY980RfwW2eEWGS8VpH5DwpZ94Z\npesPCyLTjp1RmRVdf50CgYAy7f8AycpUvXZqMoZt4KVdnc462IWo7bqU41Ag+3Mt\nnUAxvriwYST3I1+s6G6oLJmKYXZQ9FN4kFD5KSinT1+AkgzOAHXvSXMctD7kRqf/\nr4JLn9CwUN+eVpO3f5tlG8IlFizsJ/dycqXcd80RXYJF3G/nQhRetKOoPiCKLqpO\n8QKBgCjfxkjN5/bAIVyP8YzPIY8yt2kFNC0uNNBQ3trWfvFnZsxh22uaWIPCTdyL\nU7CRxw/1t5u7gC3NHzLBiKATvBRvLEi9cOoSaNFJjEzhG7/07VrknJ/OFj2nGcIn\ncof3Np/4KH4z6j9D49HxLoHfzEiqcHdtFWjVCCdrG7ruYh1G\n-----END RSA PRIVATE KEY-----'	
	local hostkeypub='ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAtRki+qm3GpRyJAfRRPekqmV2EKbm9P+ANZxUxyMAz6MGdXXVVU36JJ5HZ6fzIfMsj3sli0m2VzVmGtot3R+J0bOQX3z73l+13ApGafAke6sJXFMfrwgsP8P1FMNSE/ogjLYe6T9qcy0HwHd6SL8CwrWg00ezuyhAiFSNPlUKSD7HMg1StZtYy/SC8k8a2yO4POj9zk+lk2Vggn9qvlctAaQfqxUfJs9jXO9/m4JYEgL2x4wOnzjK8Y+PEkKZRItGqjd1Vd2uIc7ko2PQwbw34/nJzYhjTEYutl5HEy8YsiyYJNtrBlBCLV9w+0vePrst6J0SsMZvPeUGm8b0+i5cGQ== root@localhost.localdomain'

	if [[ `dmesg | grep -E -i 'Kernel[[:space:]]+command[[:space:]]+line:' | grep "ks=http://${pxetesthost}"` ]]; then 
		echo "prehwimgsrv() enabling sshd daemon for pxe image testing" | tee -a /tmp/pre.log > /dev/ttyy3
		pxeimgtest='true'
		echo -e ${mysshd_config} > ${sshd_config}
		chmod 644 ${sshd_config}
		echo ${hostkeypub} > ${keyfilepub}
		chmod 644 ${keyfilepub} 
		echo -e ${hostkey} > ${keyfile}
		chmod 600 ${keyfile}
		/sbin/sshd | tee -a /tmp/pre.log > /dev/tty3
	fi
}

# run hardware verification tests
function doAllSeriesCheck
{ 
	echo "running doAllSeriesCheck" >> /tmp/pre.log
	
	local count
	
	# determine hardware type
	let count=0
	while ! [ $nwsystem ]
	do
		set_nwsystem
		let count=$count+1
		sleep 1
		if [ $count -gt 4 ]; then
			break
		fi
	done 
	
	# un-qualified hardware, exit
	if ! [ $nwsystem ]; then
		invalid_hw
	fi

	# determine appliance type
	let count=0
	while ! [ $nwapptype ]
	do
		set_nwapptype
		let count=$count+1
		sleep 1
		if [ $count -gt 4 ]; then
			break
		fi
	done
	
	# unknown appliance type, exit
	if ! [ $nwapptype ]; then 
		chvt 3
		echo "--------------------------------------------" > /dev/tty3
		echo " unable to determine appliance install type"  > /dev/tty3
		echo " no installation/upgrade method available" > /dev/tty3
		echo "--------------------------------------------" > /dev/tty3
		echo > /dev/tty3
		promptReboot
		chvt 1
		return 1
	fi
	
	# determine drive checks, package list and %post script per hardware and appliance type
	set_raid_packs_post
	sleep 5
	
	# run drive checks: $drivetest, test and configure raid: $drivetest2 
	# systems with no hardware raid
	if ! [ $hwraid ] && [ $drivetest ]; then
		echo 'running check option 1, no hw raid' >> /tmp/pre.log
		echo "\$drivetest = $drivetest" >> /tmp/pre.log
		if ! $drivetest
		then
			chvt 3
			promptReboot
			chvt 1
			exit 1
		fi 
	elif [[ $hwraid && $drivetest ]] && ! [ $drivetest2 ]; then
		echo 'running check option 2, with hw raid' >> /tmp/pre.log
		echo "\$drivetest = $drivetest" >> /tmp/pre.log	
		if ! $drivetest
		then
			if ! [ $pxeimgtest ]; then
				chvt 3
				if ! [ -e /tmp/nwusrclear ]; then
					clearRaidPrompt
					clrRaidCfg auto
				fi
				initRaid
				promptReboot cfgclr
				chvt 1
				return 1
			else
				clrRaidCfg auto
                                initRaid
                                echo 'rebooting system in 15 seconds' > /dev/tty3
                                sleep 15
                                reboot
			fi
		fi
	# if two drive tests are required, make raid config check second in order
	elif [[ $hwraid && $drivetest && $drivetest2 ]]; then
		echo 'running check option 3, with hw raid' >> /tmp/pre.log
		echo "\$drivetest = $drivetest" >> /tmp/pre.log	
		echo "\$drivetest2 = $drivetest2" >> /tmp/pre.log	
		if ! $drivetest
		then
			chvt 3
			promptReboot
			chvt 1
			return 1
		fi	
		if ! $drivetest2
		then
			if ! [ $pxeimgtest ]; then			
				chvt 3
				if ! [ -e /tmp/nwusrclear ]; then
					clearRaidPrompt
					clrRaidCfg auto
				fi
				initRaid
				promptReboot cfgclr
				chvt 1
				return 1
			else
				clrRaidCfg auto
                                initRaid
                                echo 'rebooting system in 15 seconds' > /dev/tty3
                                sleep 15
                                reboot
			fi
		fi 
	fi 
	return 0
}

function clrRaidCfg {
# re-label disks, clear raid hba configuration
	local devices
	local drive
	local drives 
	local automode
	local adpID 
	local count 
	local COMMAND_TOOL=/usr/bin/MegaCLI
	local adpNum=`$COMMAND_TOOL -adpcount | grep -i 'Controller Count' | awk -F: '{print $2}' | awk '{print $1}'`
	let adpNum=${adpNum%.}
	local ctrlname
	local vdisk
	local pdisk
	local usrInput
	if ! [ -z $1 ]; then
		automode=$1
	fi 
	
	# check for pxe image testing
	prehwimgsrv
	
	if [ $adpNum -gt 0 ]; then
		if ! [ $nwsystem ]; then
			set_nwsystem
		fi
		# on the dell r610 with dual raid adapters the integrated perc shows up as id: 1
		if [[ $nwsystem = dell-s4-1u  ]]; then
			# if more than one get PERC ID
			if [[ $adpNum -gt 1 ]]; then
				let count=0
				while [[ $count -lt $adpNum ]]
				do
					if [[ `$COMMAND_TOOL -adpallinfo -a$count | grep -i 'Product Name' | grep -i 'PERC H700 Integrated'` ]]; then
						adpID=$count
						break
					fi
					let count=$count+1
				done
			else
				adpID='0'
			fi
		else
			adpID='0'
		fi 
	fi
	
	# get block device list for relabeling, *Need to check for DRAC devices*
	detect_install_devices
	echo -n "installdev = " >> /tmp/pre.log
	echo "${installdev[@]}" >> /tmp/pre.log
	echo -n "installmodel = " >> /tmp/pre.log
	echo "${installmodel[@]}" >> /tmp/pre.log
	#drives=( `ls -A /sys/block | grep '[hs]d[a-z]'` )
	#let count=0
	#for drive in ${drives[@]}	
	#do
	#	# skip usb block devices other than dell r620 sd cards
	#	if [[ `ls -l /sys/block/$drive | grep -E -i '/usb[[:digit:]]*/'` ]] && ! [[ `cat /sys/block/$drive/device/model | grep -i -E 'Internal[[:space:]]+Dual[[:space:]]+SD'` ]]; then
	#		echo > /dev/null	
	#	else
	#		devices[$count]=$drive
	#		let count=$count+1
	#	fi
	#done

	if ! [ $automode ]; then
		ctrlname=`$COMMAND_TOOL -adpallinfo -a$adpID | grep -i -E 'Product[[:space:]]+Name' | awk -F: '{print $2}'`
		vdisk=`$COMMAND_TOOL -adpallinfo -a$adpID | grep -i -E 'Virtual[[:space:]]+Drives' | awk -F: '{print $2}'`
		pdisk=`$COMMAND_TOOL -adpallinfo -a$adpID | grep -A1 -i -E 'Physical[[:space:]]+Devices' | grep -i 'Disks' | awk -F: '{print $2}'`
		usrInput='n' 
		chvt 3
		echo '' > /dev/tty3
		echo '' > /dev/tty3
		if [ $adpNum -gt 0 ]; then
			echo '------------------------------------------------------------' > /dev/tty3
			echo "  Clear virtual drive configuration on RAID controller: $adpID ?" > /dev/tty3
			echo "  HBA:$ctrlname #VD:$vdisk #PD:$pdisk" > /dev/tty3 
			echo "  For Upgrades either ignore or answer No to this prompt" > /dev/tty3
			echo "  Recommended for new hardware or re-purposing **Warning**" > /dev/tty3
			echo "  data on all configured drives will be discarded, this" > /dev/tty3
			echo "  includes internal SATA/SCSI storage and attached external" > /dev/tty3
			echo "  RAID storage on applicable cards, i.e. JBOD enclosures" > /dev/tty3
			echo "  Enter (y/Y) to clear drives, defaults to No in 30 seconds" > /dev/tty3
			echo '------------------------------------------------------------' > /dev/tty3
		else
			echo '------------------------------------------------------------' > /dev/tty3
			echo "  Clear the drive contents from all physical disks ?" > /dev/tty3
			echo "  For Upgrades either ignore or answer No to this prompt" > /dev/tty3
			echo "  Recommended for new hardware or re-purposing" > /dev/tty3
			echo "  ** Warning ** data on all local disks will be discarded" > /dev/tty3
			echo "  Enter (y/Y) to clear drives, defaults to No in 30 seconds" > /dev/tty3
			echo '------------------------------------------------------------' > /dev/tty3
		fi
		exec < /dev/tty3 > /dev/tty3 2>&1 
		read -t 30 -p "? " usrInput
		if [[ $usrInput = "y" || $usrInput = "Y" ]]; then
			echo 'cleardrives=1' > /tmp/nwusrclear
			echo "  Clearing drive configuration in 15 seconds, <CTRL><ALT><DEL> to cancel" > /dev/tty3
			echo "  Ignore or answer no to this prompt after restarting" > /dev/tty3
			sleep 15 
			echo "  Re-labeling disks and virtual drives, clearing RAID configuration ..." > /dev/tty3
			# clear partition tables
			#mk_disk_labels ${devices[@]}
			mk_disk_labels ${installdev[@]}
			# clear raid configuration
			if [ $adpNum -gt 0 ]; then
				$COMMAND_TOOL -CfgClr -a$adpID 
				if [[ $? != 0 ]]; then
					echo " CfgClr returned non zero exit status, retry in 10 seconds" > /dev/tty3
					sleep 10 
					$COMMAND_TOOL -CfgClr -a$adpID
				fi
			fi
		else
			return 0	
		fi
	else
		echo "  Clearing drive configuration in 15 seconds, <CTRL><ALT><DEL> to cancel" > /dev/tty3
		echo "  Ignore or answer no to this prompt after restarting" > /dev/tty3
		sleep 15 
		echo "  Re-labeling disks and virtual drives, clearing RAID configuration ..." > /dev/tty3
		# clear partition tables
		#mk_disk_labels ${devices[@]}
		mk_disk_labels ${installdev[@]}	
		# clear raid configuration
		if [ $adpNum -gt 0 ]; then
			$COMMAND_TOOL -CfgClr -a$adpID 
			if [[ $? != 0 ]]; then
				echo " CfgClr returned non zero exit status, retry in 10 seconds" > /dev/tty3
				sleep 10 
				$COMMAND_TOOL -CfgClr -a$adpID
			fi
		fi

	fi 
	#chvt 1
}
