#!/bin/bash

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
		/usr/sbin/parted -s /dev/$1 mklabel msdos >> /tmp/pre.log 2>&1
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
		fi
		sleep 2 
		shift 
	done
} 

function getHDDsize {
	local opticalMedia=
	local flashMedia=
	local urlMedia=
	local hddsize=
	
	if [[ `dmesg | grep -i 'kernel command line' | grep 'ks=cdrom'` ]]; then
		opticalMedia='true'
	elif [[ `dmesg | grep -i 'kernel command line' | grep 'ks=hd'` ]]; then
		flashMedia='true'
	elif [[ `dmesg | grep -i 'kernel command line' | grep 'ks=http'` ]]; then
		urlMedia='true'
	fi

	if [ $flashMedia ]; then
		hddsize=`parted -s /dev/sdb unit MB print | grep -m1 ^Disk | awk '{print $3'}`
	else
		hddsize=`parted -s /dev/sda unit MB print | grep -m1 ^Disk | awk '{print $3'}`
	fi	
	
	let hddsize=${hddsize%MB}
	
	# set 20 GB as minimum hard drive size for /dev/sda
	if [ $hddsize -lt 20000 ]; then
		chvt 3
		echo > /dev/tty3
		echo ' a minimum disk size of 20 GB is required for installation, exiting in 10 seconds' > /dev/tty3
		sleep 10
		exit 1
	else
		echo 'logvol / --vgname=VolGroup00 --size=10240 --fstype=ext4 --name=root' > /tmp/nwpart.txt
		echo 'logvol /var --vgname=VolGroup00 --size=1 --grow --fstype=xfs --name=var' >> /tmp/nwpart.txt
	fi
		
	# former partitioning schema
	#if ! [[ `grep 'desktop' /tmp/swpacks.txt` ]]; then
	#	if [ $hddsize -lt 4000 ]; then
	#		chvt 3
	#		echo > /dev/tty3
	#		echo ' a minimum disk size of 4 GB is required for console installations, exiting in 10 seconds' > /dev/tty3
	#		sleep 10
	#		exit 1
	#	else
	#		echo 'logvol / --vgname=VolGroup00 --size=1536 --fstype=ext4 --name=root' > /tmp/nwpart.txt
	#		echo 'logvol /var --vgname=VolGroup00 --size=1 --grow --fstype=xfs --name=var' >> /tmp/nwpart.txt
	#	fi
	#else
	#	if [ $hddsize -lt 5500 ]; then
	#		chvt 3
	#		echo > /dev/tty3
	#		echo ' a minimum disk size of 5.5 GB is required for desktop installations, exiting in 10 seconds' > /dev/tty3
	#		sleep 10
	#		exit 1
	#	else
	#		echo 'logvol / --vgname=VolGroup00 --size=2560 --fstype=ext4 --name=root' > /tmp/nwpart.txt
	#		echo 'logvol /var --vgname=VolGroup00 --size=1 --grow --fstype=xfs --name=var' >> /tmp/nwpart.txt 
	#	fi
	#fi

	if [[ `grep 'config_maprwh' /tmp/post.txt` ]]; then
		if ! [[ `grep -i 'vmware' /sys/block/sdb/device/vendor` || `grep -i 'vmware' /sys/block/sdb/device/model` ]]; then
			chvt 3
			echo " a second virtual disk is required for saw installations, exiting in 10 seconds" >> /dev/tty3
			sleep 10
			exit 1
		fi
	fi
}

function getSAapps {
chvt 3
exec < /dev/tty3 > /dev/tty3 2>&1

python -c "
def getapps( ):
	import curses, re, os 
	# current name of security analytics rpm
	saname='security-analytics-web-server'
	stdscr = curses.initscr()
	stdscr.border()
	stdscr.addstr( 1, 10, 'Please Select Security Analytics Software for Installation' )
	stdscr.addstr( 2, 3, '<Space> select, <Tab> move, <D> de-select, <S> save, <Q> quit install' ) 
	stdscr.addch( 4, 2, '(' )
	stdscr.addstr( 4, 4, ') archiver' )
	stdscr.addch( 5, 2, '(' )
	stdscr.addstr( 5, 4, ') broker' )
	stdscr.addch( 6, 2, '(' )
	stdscr.addstr( 6, 4, ') concentrator' )
	stdscr.addch( 7, 2, '(' )
	stdscr.addstr( 7, 4, ') warehouseConnector' )
	stdscr.addch( 8, 2, '(' )
	stdscr.addstr( 8, 4, ') packetDecoder' )
	stdscr.addch( 9, 2, '(' )
	stdscr.addstr( 9, 4, ') eventStreamAnalysis' )
	stdscr.addch( 10, 2, '(' )
	stdscr.addstr( 10, 4, ') logCollector' )
	stdscr.addch( 11, 2, '(' )
	stdscr.addstr( 11, 4, ') logDecoder' )
	stdscr.addch( 12, 2, '(' )
	stdscr.addstr( 12, 4, ') reportingEngine' )
	stdscr.addch( 13, 2, '(' )
	stdscr.addstr( 13, 4, ') rsaMalwareDevice' )
	stdscr.addch( 14, 2, '(' )
	stdscr.addstr( 14, 4, ') securityAnalyticsServer' )
	stdscr.addch( 15, 2, '(' )
	stdscr.addstr( 15, 4, ') rsaWarehousePoweredByMapR - ( do not combine with other products )' )
	stdscr.addch( 16, 2, '(' )
	stdscr.addstr( 16, 4, ') Minimal GNOME Desktop' )
	c = ''
	stdscr.move( 4, 3 )
	ypos = 4 
	curses.noecho()
	while ( c != 81  ) or ( c != 113 ): 
		mytup = stdscr.getyx()
		c = stdscr.getch()
		if ( c == 81  ) or ( c == 113 ):
			curses.endwin( ) 
			os.system( '/sbin/reboot' )
		elif ( c == 32 ):
			#curses.echo( )
			if ( mytup[0] < 17 and mytup[1] == 3 ):
				stdscr.addch( mytup[0], mytup[1], 88 )
				stdscr.move( ypos, 3 )
				stdscr.refresh( )
		elif ( c == 68 ) or ( c == 100 ):
			stdscr.addch( ypos, 3, 32 )
			stdscr.move( ypos, 3 )
			stdscr.refresh()
		elif ( c == 9 ):
			if ( ypos == 16 ):
				ypos = 4	
				stdscr.move( 4, 3 )
			else:
				ypos = ypos + 1
				stdscr.move( ypos, 3 )
		elif ( c == 83 ) or ( c == 115 ):
			ycount = 4
			swlist = [ ]
			while ( ycount < 17 ):
			
				d = stdscr.inch( ycount, 3 )
				if ( d != 88 ): 
					ycount = ycount + 1
					continue 
				if ( ycount == 4 ): 
					swlist.append( 'nwarchiver' )
				elif ( ycount == 5 ):
					swlist.append( 'nwbroker' )
				elif ( ycount == 6 ):
					swlist.append( 'nwconcentrator' )
				elif ( ycount == 7 ):
					swlist.append( 'nwwarehouseconnector' )
				elif ( ycount == 8 ):
					swlist.append( 'nwdecoder' )
				elif ( ycount == 9 ):
					swlist.append( 'rsa-esa-server' )
				elif ( ycount == 10 ):
					swlist.append( 'nwlogcollector' )
				elif ( ycount == 11 ):
					swlist.append( 'nwlogdecoder' )
				elif ( ycount == 12 ):
					swlist.append( 're-server' )
				elif ( ycount == 13 ):
					swlist.append( 'rsaMalwareDevice' )
				elif ( ycount == 14 ):
					swlist.append( saname )
				elif ( ycount == 15 ):
					swlist.append( '-rsa-saw-server' )
					maprwh = True
				elif ( ycount == 16 ):
					swlist.append( 'desktop' )
				ycount = ycount + 1
			break 
	curses.endwin( )

	# create software package list 
	fpacks = open( '/tmp/swpacks.txt', 'w' )
	fpacks.write( '%packages --nobase\n-sendmail\nntp\nsysstat\ntcpdump\nnet-snmp\nnet-snmp-utils\nlm_sensors\ndevice-mapper-multipath\ntcpdump\ntmpwatch\nparted\nopenssh-clients\nman\nman-pages\nlsof\nmlocate\nbind-utils\ntraceroute\nxfsprogs\nxfsdump\npciutils\nusbutils\nfile\nnfs-utils\nyum-utils\ngdb\ndracut-fips\nstrace\nopenscap\nopenscap-utils\nscap-security-guide\nAqueductSTIG\nerlang\nrabbitmq-server\n' )

	# create firewall rules
	frules = open( '/tmp/fwrules.txt', 'w' )
	# allow ingress ssh and puppet by default
	frules.write( 'firewall --enabled --port=22:tcp --port=8140:tcp ' ) 

	# create %post script function calls file 
	fpost = open( '/tmp/post.txt', 'w' )
	fpost.write( 'set_logrotate_param\ngenSNMPconf\nset_kernel_tunables\nrandomizeHostname\nconfigure_fips\n' )

	# create neccessary commands and script files
	# avoid providing duplicate packages to anaconda, doesn't really matter
	# install nwappliance and nwconsole, configure firewall
	nextgen = False
	logservice = False
	malware = False
	openjre = False
	openjdk = False
	postgresql91 = False
	samba = False
	vsftpd = False
	rabbitmq = False
	krb5ws = False 
	maprwh = False 

	index = 0
	count = len( swlist )
	while ( index < count ):
		if ( re.search( 'nwarchiver', swlist[ index ] ) ):
			nextgen = True
			fpacks.write( 'nwworkbench\nnwarchiver\n' )
			frules.write( '--port=50008:tcp --port=50108:tcp --port=56008:tcp ' )
		elif ( re.search( 'nwbroker', swlist[ index ] ) ):
			nextgen = True
			fpacks.write( 'nwbroker\n' )
			frules.write( '--port=50003:tcp --port=50103:tcp --port=56003:tcp ' )
		elif ( re.search( 'nwconcentrator', swlist[ index ] ) ):
			nextgen = True
			fpacks.write( 'nwconcentrator\n' )
			frules.write( '--port=50005:tcp --port=50105:tcp --port=56005:tcp ' )
		elif ( re.search( 'nwwarehouseconnector', swlist[ index ] ) ):
			nextgen = True
			fpacks.write( 'nwwarehouseconnector\n' )
			frules.write( '--port=50020:tcp --port=50120:tcp --port=56020:tcp ' )
		elif ( re.search( 'nwdecoder', swlist[ index ] ) ):
			nextgen = True
			fpacks.write( 'nwdecoder\n' )
			frules.write( '--port=50004:tcp --port=50104:tcp --port=56004:tcp ' ) 
		elif ( re.search( 'rsa-esa-server', swlist[ index ] ) ): 
			frules.write( '--port=50030:tcp --port=50035:tcp --port=50036:tcp --port=514:udp --port=514:tcp ' )
			logservice = True
			fpacks.write( 'java-1.7.0-openjdk\ntokumx-enterprise-common\ntokumx-enterprise\ntokumx-enterprise-server\nrsa-im-server\nrsa-esa-client\n' )
			openjre = True		
			fpost.write( 'config_esa\n' )
		elif ( re.search( 'nwlogcollector', swlist[ index ] ) ):
			nextgen = True 
			if ( logservice ):
				frules.write( '--port=5671:tcp --port=50001:tcp --port=50101:tcp --port=162:udp --port=21:tcp --port=9995:udp --port=6343:udp --port=4739:udp --port=2055:udp ' )
			else:
				frules.write( '--port=5671:tcp --port=50001:tcp --port=50101:tcp --port=514:udp --port=514:tcp --port=162:udp --port=21:tcp --port=9995:udp --port=6343:udp --port=4739:udp --port=2055:udp ' )
				logservice = True
			fpacks.write( 'krb5-workstation\nvsftpd\nrssh\n' )
			krb5ws = True
			vsftpd = True
			fpost.write ( 'setuplogcoll\n' )
		elif ( re.search( 'nwlogdecoder', swlist[ index ] ) ):
			nextgen = True
			fpacks.write( 'nwlogdecoder\n' )
			if ( logservice ):
				frules.write( '--port=50002:tcp --port=50102:tcp --port=56002:tcp ' )
			else:
				frules.write( '--port=50002:tcp --port=50102:tcp --port=56002:tcp --port=514:udp --port=514:tcp ' )
				logservice = True
		elif ( re.search( 're-server', swlist[ index ] ) ):
			if ( openjre ):
				fpacks.write( 'postgresql-server\nnwipdbextractor\ncifs-utils\nre-server\n' )
			else:
				fpacks.write( 'java-1.7.0-openjdk\npostgresql-server\nnwipdbextractor\ncifs-utils\nre-server\n' )		
				openjre = True 
			fpost.write ( 'config_postgres_re\nconfig_ipdbextractor\n' )	
		elif ( re.search( 'rsaMalwareDevice', swlist[ index ] ) ):
			if ( openjre ):
				fpacks.write( 'unzip\ngeoip-dat\nsamba\npostgresql91-server\n' )
				samba = True
			else:
				fpacks.write( 'unzip\ngeoip-dat\njava-1.7.0-openjdk\nsamba\npostgresql91-server\n' )
				openjre = True 
				samba = True
				postgresql91 = True
			if not ( vsftpd ):
				fpacks.write( 'vsftpd\n' )
				vsftpd = True
			frules.write( '--port=8443:tcp --port=60007:tcp --port=21:tcp --port=20:tcp --port=139:tcp --port=445:tcp --port=51024-51073:tcp --port=137:udp --port=138:udp ' )
			fpost.write( 'config_spectrum\nsetSpectrumTunables\nspecFileService\n' )
			malware = True
		elif ( re.search( saname, swlist[ index ] ) ):
			if ( openjre ):
				fpacks.write( 'puppet-server\nmcollective-client\nrsa-sms-server\njettyuax\nlighttpduax\ncreaterepo\nfneserver\nsalic\ntokumx-enterprise-common\ntokumx-enterprise\ntokumx-enterprise-server\nrrdtool\nPyYAML\npymongo\nrsa-im-server\npam_ldap\nopenldap-clients\npam_krb5\npam_radius_auth\n' + saname + '\n' )
			else:
				fpacks.write( 'puppet-server\nmcollective-client\nrsa-sms-server\njava-1.7.0-openjdk\njettyuax\nlighttpduax\ncreaterepo\nfneserver\nsalic\ntokumx-enterprise-common\ntokumx-enterprise\ntokumx-enterprise-server\nrrdtool\nPyYAML\npymongo\nrsa-im-server\npam_ldap\nopenldap-clients\npam_krb5\npam_radius_auth\n' + saname + '\n' )
				openjre = True
			if not ( postgresql91 ):
				fpacks.write( 'postgresql91-server\n' )
				postgresql91 = True		
			if not ( krb5ws ):
				fpacks.write( 'krb5-workstation\n' )
				krb5ws = True
			if not ( vsftpd ):
				fpacks.write( 'vsftpd\n' )
				vsftpd = True		
			if not ( samba ):
				fpacks.write( 'samba\n' )
				samba = True
			if ( malware ):
				frules.write( '--port=80:tcp --port=443:tcp ' )
			else:
				frules.write( '--port=80:tcp --port=443:tcp --port=8443:tcp --port=60007:tcp --port=21:tcp --port=20:tcp --port=139:tcp --port=445:tcp --port=51024-51073:tcp --port=137:udp --port=138:udp ' )
			fpost.write( 'config_uax colo\nconfig_spectrum colo\nsetSpectrumTunables\nspecFileService colo\n' )
		elif ( re.search( '-rsa-saw-server', swlist[ index ] ) ):
			maprwh = True
			fpacks.write( 'java-1.7.0-openjdk-devel\n' )
			openjdk = True
			if not ( samba ):
				fpacks.write( 'samba\n' ) 
				samba = True
			frules.write( '--port=2049:tcp --port=5181:tcp --port=5660:tcp --port=7221:tcp --port=7222:tcp --port=8080:tcp --port=8443:tcp --port=9001:tcp --port=9997:tcp --port=9998:tcp --port=10000:tcp --port=50030:tcp --port=50060:tcp --port=60000:tcp ' )
			fpost.write( 'config_maprwh\n' )	
		elif ( re.search( 'desktop', swlist[ index ] ) ):
			fpacks.write( '@x11\n@basic-desktop\n@desktop-platform\n@graphical-admin-tools\nsystem-config-lvm\n' ) 
		index = index + 1
		if ( index == count ):
			if ( nextgen ):
				fpacks.write( 'nwappliance\nnwconsole\n' )
				frules.write( '--port=50006:tcp --port=50106:tcp --port=56006:tcp ' )
			if not ( maprwh ):
				fpacks.write( 'mcollective\npuppet\nmcollective-package-agent\nmcollective-package-client\nmcollective-puppet-agent\nmcollective-puppet-client\nmcollective-iptables-agent\nmcollective-iptables-client\nrsa-collectd\nrsa-sms-runtime-rt\nrsa-carlos-rt\nrsa-protobufs-rt\nrsa-mcollective-agents\nrsa-puppet-scripts\n' )
				fpost.write( 'install_post_package\n' )
			fpacks.write( '%end' )
			fpacks.close( )
			frules.write( '\n' )
			frules.close( )
			fpost.write( '%end' )
			fpost.close( )
getapps()"

chvt 1
}

