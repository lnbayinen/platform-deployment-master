#!/bin/bash

# global jenkins workspace variable
workspace=

# delimit space characters in jenkins ${WORKSPACE} path 
if [[ `echo "${WORKSPACE}" | grep -r '[[:space:]]+'` ]]; then
	workspace=`echo "${WORKSPACE}" | sed -r 's/[[:space:]]+/\\\ /g'`
else
	workspace="${WORKSPACE}"
fi

echo "jenkins workspace = ${workspace}"

function refreshBuildEnv {
# add required artifacts to build workspace

	# set local variables from jenkins build parameters
	local fileurl=${BUILDBINURL}
	local megaclirpm=${MEGACLIRPM} 

	# define local variables
	megacli='CmdTool264'

	if ! [ -d ${workspace}/binaries ]; then
		mkdir ${workspace}/binaries
	fi
	
	if ! [ -e ${workspace}/binaries/${megacli} ]; then
		cd ${workspace}/binaries
		mkdir rpmextract
		cd rpmextract
		curl -k -O ${fileurl}/${megaclirpm}
		rpm2cpio ${megaclirpm} | cpio -idmv
		cp -p opt/MegaRAID/CmdTool2/${megacli} ${workspace}/binaries
		cd ..
		rm -Rf rpmextract
		cd ${workspace}
		if ! [ -e ${workspace}/binaries/${megacli} ]; then
			echo 'missing megaraid cli binary, exiting'
			exit 1
		fi
	fi

}

function getDistIso {
# update extracted iso directories in workspace

	# set local variables from jenkins build parameters
	local myiso=${CENTOSISO}
	local dvddir=${DVDISODIR}
	local usbdir=${USBISODIR}
	local bootdir=${BOOTISODIR}
	
	# define local variables
	local myisomnt
	local item
	local isolist
	declare -a isolist
	isolist=( "${dvddir}" "${usbdir}" "${bootdir}" )
	
	# check for local mount of iso and rsync to workspace
	if ! [[ `mount -l | grep "${myiso}"` ]]; then
		echo "local iso mount of ${myiso} not found, exiting"
		exit 1
	else
		myisomnt=`mount -l | grep "${myiso}" | awk '{print $3}'`
		echo "myisomnt = ${myisomnt}"
	fi

	for item in ${isolist[@]}
	do
		rm -rf ${workspace}/${item}
		sync
		mkdir -p ${workspace}/${item}
		rsync -r --exclude='Packages' ${myisomnt}/ ${workspace}/${item}
		sync
		if ! [[ `echo "${item}" | grep -i 'boot'` ]]; then 
			mkdir -p ${workspace}/${item}/Packages
		fi
		chmod -R u+w ${workspace}/${item}
	done

	# rename isolinux directory on usb boot media
	mv -f ${workspace}/${bootdir}/isolinux ${workspace}/${bootdir}/syslinux
}

function getRepo {
# copy os/application and bootstrap repos to iso image
	
	# set local variables from jenkins build parameters
	local dvddir=${DVDISODIR}
	local usbdir=${USBISODIR}
	local bootdir=${BOOTISODIR}
	local rsarepo=${RSAREPO}
	local bstraprepo=${BOOTSTRAPREPO}
	local keysrepo=${KEYSREPO}
	
	# define local variables
	local mycomps=`ls ${workspace}/${dvddir}/repodata/*-comps.xml | sed 's/^.*\///'`
	local isolist
	declare -a isolist 

	echo "mycomps = ${mycomps}"
	isolist=( "${dvddir}" "${usbdir}" "${bootdir}" )

	for item in ${isolist[@]}
	do
		if [[ `echo "${item}" | grep "${dvddir}"` || `echo "${item}" | grep "${usbdir}"` ]]; then
			# configure os/application repo
			cd ${workspace}/${item}/Packages
			cp ${rsarepo}/*.rpm .	
			cd ..
			createrepo -g ${workspace}/${item}/repodata/${mycomps} .
			sync
			cd ${workspace}
		fi
		if [[ `echo "${item}" | grep "${dvddir}"` || `echo "${item}" | grep "${bootdir}"` ]]; then
			# configure bootstrap repo
			cd ${workspace}/${item}
			mkdir bootstrap-repo
			rsync -rtv ${bstraprepo}/ bootstrap-repo
			cp -r ${keysrepo} bootstrap-repo 
			chmod 755 bootstrap-repo bootstrap-repo/repodata bootstrap-repo/keys
			chmod 644 bootstrap-repo/*.rpm bootstrap-repo/repodata/* bootstrap-repo/keys/*
			sync
			tar -czf bootstrap-repo.tgz bootstrap-repo/
			rm -rf bootstrap-repo/
			sync
			cd ${workspace}
		fi
		
	done
}

function customizeIso {
# add kickstarts and required binaries to iso	

	# set local variables from jenkins build parameters
	local dvddir=${DVDISODIR}
	local usbdir=${USBISODIR}
	local bootdir=${BOOTISODIR}
	local kscode=${CODEPATH}	
	echo "kscode = ${kscode}"
	# define local variables 
	local megacli='CmdTool264'
	local isolist
	local item
	declare -a isolist
 
	
	# add kickstart(s) to iso root and intel branded megraid cli to product.image 
	isolist=( "${dvddir}" "${bootdir}" )
	for item in "${isolist[@]}"
	do
		cd ${kscode}
		if [[ `echo "${item}" | grep -i 'dvd'` ]]; then
			./generateAllKickstarts.sh ${workspace}/${item} cdrom
		else
			./generateAllKickstarts.sh ${workspace}/${item} usb 
		fi 
		cd ${workspace}/${item}
		rm -rf product
		mkdir -p product/usr/bin
		cp ${workspace}/binaries/${megacli} product/usr/bin
		chmod 755 product/usr/bin/${megacli}
		#cp "${kscode}/getosdisk.py" product/usr/bin/
		#chmod 755 product/usr/bin/getosdisk.py
		#cp "${kscode}/optinstall.py" product/usr/bin/
		#chmod 755 product/usr/bin/optinstall.py
		cd product
		find . | cpio -c -o | gzip -9cv > ../product.img
		rm -f ../images/product.img
		mv -f ../product.img ../images
		cd ..
		rm -Rf product/
	done

	# remove unnecessary installation files from usb iso image
	cd ${workspace}/${usbdir}
	rm -rf EFI/ images/ LiveOS/
	rm -f isolinux/initrd.img isolinux/upgrade.img isolinux/vmlinuz

	cd ${workspace}
	# add ova kickstart to dvd image
	cp ${kscode}/ova.ks ${workspace}/${dvddir}
	
	# add custom install menus
	cd ${workspace}
	mv -f ${workspace}/${bootdir}/isolinux ${workspace}/${bootdir}/syslinux
	rm -f ${workspace}/${bootdir}/syslinux/isolinux.cfg ${workspace}/${dvddir}/isolinux/isolinux.cfg
	cp ${kscode}/syslinux.cfg ${workspace}/${bootdir}/syslinux
	cp ${kscode}/isolinux.cfg ${workspace}/${dvddir}/isolinux
	sync

}

function makeIso {
# create three iso images dvd and usb/usb boot for making usb flash drive media
	
	# set local variables from jenkins build parameters
	local dvddir=${DVDISODIR}
	local usbdir=${USBISODIR}
	local bootdir=${BOOTISODIR}
	local isoname=${ISONAMESTR}
	local buildnum=${TAG}

	cd ${workspace} 
	# add name of iso to image
	echo "${isoname}.${buildnum}.el7-dvd.iso" > ${dvddir}/dvdiso.txt
	echo "${isoname}.${buildnum}.el7-usb.iso" > ${usbdir}/usbiso.txt
	echo "${isoname}.${buildnum}.el7-usbboot.iso" > ${bootdir}/usbbootiso.txt

	# ceate iso images
	genisoimage -o "${isoname}.${buildnum}.el7-dvd.iso" -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -R -J -v -T -joliet-long -V "CentOS 7 x86_64" ${dvddir} 
	implantisomd5 ${isoname}.${buildnum}.el7-dvd.iso
	sha512sum "${isoname}.${buildnum}.el7-dvd.iso" > "${isoname}.${buildnum}.el7-dvd.iso.sha512sum"
	echo "UPSTREAMDVDISO=${isoname}.${buildnum}.el7-dvd.iso" > ${workspace}/DVD_ISO.txt
	genisoimage -o "${isoname}.${buildnum}.el7-usb.iso" -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -R -J -v -T -joliet-long -V "CentOS 7 x86_64" ${usbdir} 
	implantisomd5 ${isoname}.${buildnum}.el7-usb.iso
	sha512sum "${isoname}.${buildnum}.el7-usb.iso" > "${isoname}.${buildnum}.el7-usb.iso.sha512sum"
	genisoimage -o "${isoname}.${buildnum}.el7-usbboot.iso" -b syslinux/isolinux.bin -c syslinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -R -J -v -T -joliet-long -V "CentOS 7 x86_64" ${bootdir} 
	sha512sum "${isoname}.${buildnum}.el7-usbboot.iso" > "${isoname}.${buildnum}.el7-usbboot.iso.sha512sum"
}

refreshBuildEnv
getDistIso
getRepo
customizeIso
makeIso
