# ^^^^^^^^^^^^^^^^^^^^^^ global constants ^^^^^^^^^^^^^^^^^^^^^^^^^

raid_models_list=( "PERC H700" "PERC H710P" "SRCSAS144E" "MegaRAID 8888ELP" "MR9260DE-8i" "MR9260-8i" "MR9260-4i" "AOC-USAS2LP-H8iR" "Internal Dual SD" )

# list of common packages to install in %post
commpack=( "net-tools" )
pxetesthost='hwimgsrv.nw-xlabs'

# ^^^^^^^^^^^^^^^^^^^^^^ %post func defs ^^^^^^^^^^^^^^^^^^^^^^^^^^

# $1 = root prefix
function randomizeHostname
{
	local PREFIX=$1

	local hostname=NWAPPLIANCE$RANDOM
	
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

function volumeGroupScan {
# scan for volume groups, create missing device files and activate	

	chroot /mnt/sysimage /sbin/vgscan --mknodes | tee -a /tmp/post.log
	chroot /mnt/sysimage /sbin/vgck -v | tee -a /tmp/post.log
	chroot /mnt/sysimage /sbin/vgchange -a y --ignorelockingfailure | tee -a /tmp/post.log
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

function setup_bootstrap-repo {
	local opticalMedia
	local hddMedia
	local urlMedia
	local installUrl
	local strLen
	local lastChar
	local repoPath='/mnt/sysimage/opt/rsa/platform'
	local tarBall='bootstrap-repo.tgz'
	local sourcePath
	
	# destination of bootstrap-repo
	mkdir -p ${repoPath}

	if [[ `dmesg | grep -i 'Command Line:' | grep 'inst\.ks=cdrom'` ]]; then
		opticalMedia='true'
	elif [[ `dmesg | grep -i 'Command Line:' | grep 'inst\.ks=hd'` ]]; then
		hddMedia='true'
	elif [[ `dmesg | grep -i 'Command Line:' | grep 'inst\.ks=http'` ]]; then
		urlMedia='true'
		installUrl=`dmesg | grep -i 'Command Line:' | awk -F'inst.ks=' '{print $2}' | awk '{print $1}'`
		installUrl=${installUrl%/*}
		echo "installUrl = $installUrl" >> /tmp/post.log
		let strLen=${#installUrl}
		let strLen=$strLen-1
		lastChar=${installUrl:$strLen}
		if [[ "$lastChar" != '/' ]]; then
			lastChar='/'
			installUrl="$installUrl$lastChar"
		fi
	fi
	
	if [ $hddMedia ]; then
		sourcePath='/run/install/repo'
		cp ${sourcePath}/${tarBall} ${repoPath}
		cd ${repoPath}
		tar -xzf ${tarBall}
		chroot /mnt/sysimage /bin/chown -R root:root /opt/rsa/platform/bootstrap-repo/
		rm -f ${tarBall}
	elif [ $opticalMedia ]; then
		sourcePath='/run/install/repo'
		cp ${sourcePath}/${tarBall} ${repoPath}
		cd ${repoPath}
		tar -xzf ${tarBall}
		chroot /mnt/sysimage /bin/chown -R root:root /opt/rsa/platform/bootstrap-repo/
		rm -f ${tarBall}
	else
		cd ${repoPath}
		curl -O ${installUrl}/${tarBall}
		tar -xzf ${tarBall}
		chroot /mnt/sysimage /bin/chown -R root:root /opt/rsa/platform/bootstrap-repo/
		rm -f ${tarBall}	 
	fi
	cd /
	sync
	
}

# add mounts purposely ignored by system upgrade to /etc/fstab
function check_upgd_mounts { 
	if [ -s /tmp/nwvols.txt ]; then
		chvt 8 
		echo | tee -a /tmp/post.log
		echo ' validating system upgrade mounts' | tee -a /tmp/post.log
		
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
			echo 'checking for offline linux raid devices ...' | tee -a /tmp/post.log
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
					echo "assembling raid device $mdid" | tee -a /tmp/post.log
					mdadm -A -f -c /tmp/mdadm.conf $mddev | tee -a /tmp/post.log
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
					echo "re-building kernel ramdisk: $myinitrd" | tee -a /tmp/post.log
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
								echo " error mounting application root, see /root/post.log for details"
								echo " some application volume mount points maybe missing"
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
						echo ' error mounting application volume, check /root/post.log for details'
						echo ' leaving mount commented out in /etc/fstab'
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
				lvchange -ay /dev/mapper/VolGroup00-nwhome | tee -a /tmp/post.log
				mount /dev/mapper/VolGroup00-nwhome /mnt/sysimage/var/netwitness | tee -a /tmp/post.log
			fi
			lvresize -f -l +100%FREE /dev/mapper/VolGroup00-nwhome | tee -a /tmp/post.log
			chroot /mnt/sysimage /usr/sbin/xfs_growfs /dev/mapper/VolGroup00-nwhome | tee -a /tmp/post.log
		fi

		# restore directory root uuid
		rootlv=`mount -l | grep -E '[[:space:]]+/mnt/sysimage[[:space:]]+' | awk '{print $1}'`
		echo "\$rootlv = $rootlv" | tee -a /tmp/post.log
		rootfsuuid=`cat /tmp/rootfsuuid.txt`
		echo "restoring root fs uuid: $rootfsuuid" | tee -a /tmp/post.log
		#chroot /mnt/sysimage /sbin/tune2fs -U $rootfsuuid $rootlv
		tune2fs -U $rootfsuuid $rootlv
			
		# restore root's .ssh/ folder and crontab
		if [ -d /tmp/cfgbak/.ssh ]; then
			echo "restoring root's .ssh/ folder" | tee -a /tmp/post.log
			cp -Rp /tmp/cfgbak/.ssh /mnt/sysimage/root/
		fi
		if [ -s /tmp/cfgbak/root.cron ]; then
			echo "restoring root's crontab file" | tee -a /tmp/post.log
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

function install_post_package {
# install common %post image packages
	local opticalMedia
	local hddMedia
	local urlMedia
	local installUrl
	local strLen
	local lastChar
	local apptype=`cat /tmp/nwapptype | awk '{print $1}'`
	local MYPWD=`pwd | awk '{print $1}'`
	local item
	local myiso
	local mydvdrom

	if [[ `dmesg | grep -i 'Command Line:' | grep 'inst\.ks=cdrom'` ]]; then
		opticalMedia='true'
	elif [[ `dmesg | grep -i 'Command Line:' | grep 'inst\.ks=hd'` ]]; then
		hddMedia='true'
	elif [[ `dmesg | grep -i 'Command Line:' | grep 'inst\.ks=http'` ]]; then
		urlMedia='true'
		installUrl=`dmesg | grep -i 'Command Line:' | awk -F'inst.ks=' '{print $2}' | awk '{print $1}'`
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
	mkdir -p /mnt/sysimage/root/imagefiles
	YUMCFG='/mnt/sysimage/root/imagefiles/yum.conf.tmp'
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
	echo 'name=centos-7.x-x86_64-base' >> $YUMCFG 
	
	if [[ $opticalMedia || $hddMedia ]]; then
		echo 'baseurl=file:///mnt' >> $YUMCFG
		echo 'gpgcheck=0' >> $YUMCFG
		echo 'enabled=1' >> $YUMCFG
	elif [[ $urlMedia ]]; then
		echo "baseurl=$installUrl" >> $YUMCFG
		echo 'gpgcheck=0' >> $YUMCFG
		echo 'enabled=1' >> $YUMCFG 
	fi
	
	if [ $hddMedia ]; then
		umount /run/install/source >> /tmp/post.log 2>&1
		sleep 3
		myiso=`ls /run/install/isodir/*.iso | sed -r 's/.*\///' | awk '{print $1}'`	
		mount -o loop -t iso9660 /run/install/isodir/${myiso} /mnt/sysimage/mnt
	elif [ $opticalMedia ]; then
		mydvdrom=`mount | grep '/run/install/repo' | awk '{print $1}'`
		#lsof | grep '/run/install/repo' >> /tmp/post.log 2>&1
		#umount /run/install/repo >> /tmp/post.log 2>&1
		#umount ${mydvdrom} >> /tmp/post.log 2>&1
		mount -t iso9660 ${mydvdrom} /mnt/sysimage/mnt
		sleep 3
	fi

	chroot /mnt/sysimage /usr/bin/yum -c /root/imagefiles/yum.conf.tmp --disablerepo=\* --enablerepo=fbase -y install "${commpack[@]}"
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
	echo "nwsystem = $mysystem, nwappliance = $mytype" | tee -a /tmp/post.log
	blockdev=( `ls /sys/block | grep sd[a-z]` )
	echo "my block devices:" | tee -a /tmp/post.log
	for item in ${blockdev[@]}
	do
		vendor=`cat /sys/block/$item/device/vendor`
		model=`cat /sys/block/$item/device/model`
		echo "$item $vendor $model" | tee -a /tmp/post.log
	done

	# run common %post functions
#	check_upgd_mounts
	
	# enable system V serices to start on boot 
        #chroot /mnt/sysimage /sbin/chkconfig ntpd on
	#chroot /mnt/sysimage /sbin/chkconfig postfix off 
	#chroot /mnt/sysimage /sbin/chkconfig ipmi on
	#chroot /mnt/sysimage /sbin/chkconfig yum-updatesd off
	#chroot /mnt/sysimage /sbin/chkconfig kdump off
}

function doPost
{
    if [ -z $1 ]; then	
        doInstallKickstartLog "$@" >/mnt/sysimage/root/install_build.log 2>&1
    else
        doInstallKickstartLog "$1" "$@" >/mnt/sysimage/root/install_build.log 2>&1
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
		chvt 8
 		exec < /dev/tty8 > /dev/tty8 2> /dev/tty8
		echo
		echo '---------------------------------------'
		echo ' Install/Upgrade process has completed'
		echo ' Please disconnect any installation'
		echo ' media and boot to operating system'
		echo ' The system will restart in 30 seconds'
		echo
		echo ' Enter (y/Y) to terminate the anaconda'
		echo ' install process allowing access to a'
		echo ' bash shell. NOTE: this feature is for'
		echo ' for debugging purposes and may cause'
		echo ' unexpected results, defaults to No'
		echo '---------------------------------------'

		read -t 30 -p ' Enter (y/Y) to terminate anaconda, defaults to No? ' usrchoice
		if [[ $usrchoice = y || $usrchoice = Y ]]; then
			echo
			echo ' Press <ALT><F2> for Shell Access, <CTRL><ALT><DEL> to Reboot'
			echo ' Terminating anaconda in 10 seconds'
			echo
			sleep 10 
			kill -s 4 ${pslist[0]}
		fi
	fi
}

function runPostScript {
# run %post function calls in /tmp/nwpost.txt
	
	local POSTCALLS='/tmp/nwpost.txt'
	local calls
	local count
	local item
	local opticalMedia
	local hddMedia
	local urlMedia
	local installUrl
	local strLen
	local lastChar
	local imageLogs='/mnt/sysimage/root/imagefiles'
	local sourcePath
	local sourcePath2

	# determine install method
	if [[ `dmesg | grep -i 'Command Line:' | grep 'inst\.ks=cdrom'` ]]; then
		opticalMedia='true'
	elif [[ `dmesg | grep -i 'Command Line:' | grep 'inst\.ks=hd'` ]]; then
		hddMedia='true'
	elif [[ `dmesg | grep -i 'Command Line:' | grep 'inst\.ks=http'` ]]; then
		urlMedia='true'
		installUrl=`dmesg | grep -i 'Command Line:' | awk -F'inst.ks=' '{print $2}' | awk '{print $1}'`
		installUrl=${installUrl%/*}
		echo "installUrl = $installUrl" >> /tmp/post.log
		let strLen=${#installUrl}
		let strLen=$strLen-1
		lastChar=${installUrl:$strLen}
		if [[ "$lastChar" != '/' ]]; then
			lastChar='/'
			installUrl="$installUrl$lastChar"
		fi
	fi
	
	# create imaging artifact directory
	mkdir -p ${imageLogs}

	# log installation iso version(s)
	if [ $hddMedia ]; then
		sourcePath='/run/install/repo'
		sourcePath2='/run/install/source'
		cp ${sourcePath}/usbbootiso.txt ${imageLogs}
		cp ${sourcePath2}/usbiso.txt ${imageLogs} 
	elif [ $opticalMedia ]; then
		sourcePath='/run/install/repo'
		cp ${sourcePath}/dvdiso.txt ${imageLogs}
	else
		cd ${imageLogs}
		curl -O ${installUrl}/dvdiso.txt --insecure
	fi

	# insert common, read in and run %post function calls
	let count=0
	calls[$count]='setup_bootstrap-repo'
	let count=$count+1
	calls[$count]='install_post_package'
	let count=$count+1
	calls[$count]='doPost'
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
#	if ! [ -s $POSTCALLS ] || ! [[ `grep 'check_post_package' $POSTCALLS` ]]; then
#		calls[$count]='check_post_package'
#		let count=$count+1
#	fi
#	calls[$count]='posthwimgsrv'
#	let count=$count+1
#	calls[$count]='bakimagefiles'
#	let count=$count+1
#	calls[$count]='kill_installer'
	for item in "${calls[@]}"
	do
		echo "calling %post function: $item" | tee -a /tmp/post.log
		$item >> /tmp/post.log 2>&1
	done
	
	# backup imaging files for debug
	rsync -rL --exclude='mnt' --exclude='tmux-0' /tmp/ ${imageLogs} 
	rsync -r /root/ ${imageLogs}
	
	### debug ###
	#chvt 8
	#exec < /dev/tty8 > /dev/tty8 2> /dev/tty8
	#read -t 99999 -p 'sleeping indefinitely press enter to continue? ' usrin
	### end debug ###
}

