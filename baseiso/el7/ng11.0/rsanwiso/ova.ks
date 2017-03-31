auth --enableshadow --passalgo=sha512
install
cdrom
firewall --enabled --port=22:tcp
firstboot --disable 
keyboard --vckeymap=us --xlayouts=us
lang en_US.UTF-8
network  --bootproto=static --ip=10.101.34.50 --netmask=255.255.255.0 --gateway=10.101.34.1 --nameserver=10.100.174.10 --ipv6=auto --onboot=yes --device=eth0
network  --hostname=localhost.localdomain
rootpw --iscrypted $6$tqtNpXgQOg$.nbG4utjtNhGZ1xUzQ/IiSvsGCbn538d5ca.eV1g27k7yKdXGrsInISwE6VvY8t4jeDwgPzftqCiPzbOTeJQW1
selinux --permissive
text
timezone Etc/UTC --utc
bootloader --location=mbr --iscrypted --password=grub.pbkdf2.sha512.10000.3F2CB2489D51B990EA87B49F3469BF8835848124D1CF54E94863EA20755BCE65BC3BCA6C9102DE26C00AFC3D3953E5E77A0442479B69E5CCFBE0833C05070715.88268F8C9BE839BF32B82CE38264DBB14B55DA166014B4F4A77F8AFB7107FA0759ABBBDC6DADAD15D79C76665ECBC671A6CA38A11D303847E91DB5198595C9B6
#autopart --type=plain
part swap --size=4096
part /home --fstype=xfs --size=4096 --fsoptions=nosuid
part / --fstype=xfs --size=1 --grow
zerombr
clearpart --all --initlabel
eula --agreed
reboot --eject
%packages --nocore
@Core --nodefaults
-@Base
perl
open-vm-tools
%end
%post --interpreter=/usr/bin/bash --nochroot --log=/tmp/post.log
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
		echo "setuplogcoll: installUrl = $installUrl" >> /tmp/post.log
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
	cd
	sync
	
}
setup_bootstrap-repo
# backup imaging files for debug
mkdir -p /mnt/sysimage/root/imagefiles
cp /run/install/repo/dvdiso.txt /mnt/sysimage/root/imagefiles
rsync -rL --exclude='mnt' --exclude='tmux-0' /tmp/ /mnt/sysimage/root/imagefiles
rsync -r /root/ /mnt/sysimage/root/imagefiles
### debug %post ###
#chvt 8
#exec < /dev/tty8 > /dev/tty8 2>/dev/tty8
#read -p 'Press Enter to Continue' usrIn
%end
