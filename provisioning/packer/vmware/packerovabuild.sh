# packerovabuild.sh
#
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#  purpose: builds vmware ova appliance image
#           from the customized centos 7 iso and 
#           posts them to //asoc-platform/linux -
#           /centos/7/could/images/vmware
#
# requires: packer binary, ovf-tool install and 
#           json templates from git repo
# 
#     todo:
#
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#!/bin/bash
#
#fulltoolstarball='VMware-Tools-10.0.9-3917699.tar.gz'
#fulltoolstar=${fulltoolstarball%\.tar\.gz}
#toolstarball='VMwareTools-10.0.9-3917699.tar.gz'
#toolsurl='https://libhq-ro.rsa.lab.emc.com/SA/tools/VMWare'
#bootstrapurl='https://libhq-ro.rsa.lab.emc.com/SA/Platform/bootstrap-repo/11.0/'
#keysurl='https://libhq-ro.rsa.lab.emc.com/SA/Platform/bootstrap-repo/keys/'
# check nfs mount
if ! [ -d  /mnt/buildStorage/linux/centos/7 ]; then
	echo 'nfs mount to //asoc-platform offline, exiting'
	exit 1
fi 
mypost='/mnt/buildStorage/linux/centos/7/cloud/images/vmware' 
mypostdir='\/mnt\/buildStorage\/linux\/centos\/7\/cloud\/images\/vmware'
if ! [ -d ${mypost} ]; then
	mkdir -p ${mypost}
fi
if ! [ -d ${mypost} ]; then
	echo 'post directory missing, exiting'
	exit 1	
fi
echo "WORKSPACE = $WORKSPACE"
echo "UPSTREAMDVDISO = ${UPSTREAMDVDISO}"
# freshen up workspace
rm -f ${WORKSPACE}/*.json ${WORKSPACE}/DVD_ISO.txt
rm -rf ${WORKSPACE}/httpdir
rm -f ${WORKSPACE}/provision.sh
#rm -f ${WORKSPACE}/bootstrap-repo.tgz
cp -R ${WORKSPACE}/provisioning/packer/vmware/httpdir ${WORKSPACE}
cp ${WORKSPACE}/provisioning/packer/vmware/provision.sh ${WORKSPACE}
#mkdir -p ${WORKSPACE}/bootstrap-repo
#cd ${WORKSPACE}/bootstrap-repo
#wget -r -np -nH --reject 'index.html*' --cut-dirs=4 ${bootstrapurl}
#mkdir keys
#cd keys
#wget -r -np -nH --reject 'index.html*' --cut-dirs=4 ${keysurl}
#cd ${WORKSPACE}
#chmod 755 ${WORKSPACE}/bootstrap-repo ${WORKSPACE}/bootstrap-repo/repodata ${WORKSPACE}/bootstrap-repo/keys
#chmod 644 ${WORKSPACE}/bootstrap-repo/*.rpm ${WORKSPACE}/bootstrap-repo/repodata/* ${WORKSPACE}/bootstrap-repo/keys/*.pgp
#tar -czf bootstrap-repo.tgz bootstrap-repo/
#rm -rf ${WORKSPACE}/bootstrap-repo

# replaced with open-vm-tools package for el7
# check for and attempt to download and copy vmware-tools tarball
#if ! [ -s ${toolstarball} ]; then
#	wget ${toolsurl}/${fulltoolstarball} --no-check-certificate
#	mkdir -p ${WORKSPACE}/mnt
#	tar -xzf ${fulltoolstarball}
#	sudo mount -o loop ${fulltoolstar}/vmtools/linux.iso mnt/
#	cp mnt/${toolstarball} ${WORKSPACE}
#	sudo umount mnt/
#	rm -Rf ${fulltoolstar}
#	rm -f ${fulltoolstarball}
#fi
#if ! [ -s ${toolstarball} ]; then
#	echo "vmware tools tar archive not found, exiting"
#	exit 1 	
#fi

# use upstream or user provided dvd iso file parameter
if [ "${UPSTREAMDVDISO}" != 'NONE' ]; then
	echo "${UPSTREAMDVDISO}" > ${WORKSPACE}/DVD_ISO.txt
fi

# check for initialized ISO build parameters
if ! [ -s ${WORKSPACE}/DVD_ISO.txt ]; then
	echo "ISO Descriptor File: ${WORKSPACE}/DVD_ISO.txt not found, exiting"
	exit 1
else
	myiso=`cat ${WORKSPACE}/DVD_ISO.txt`
fi

# generate new packer templates and copy provisioning script
cd ${WORKSPACE}/provisioning/packer/vmware
myisodir='/mnt/buildStorage/linux/centos/7/iso'
myjobstr=${myiso%-dvd\.iso}
myverstr=${myjobstr#rsa}
echo "getting md5sum of ${myisodir}/${myiso}"
mymd5sum=`md5sum ${myisodir}/${myiso} | awk '{print $1}'`
echo "myjobstr = $myjobstr"
echo "myverstr = $myverstr"
#myjobs=( `ls -r *.json` ) 
#myjobs=( 'nwwarehouseconnector.json' 'nwsaserver.json' 'nwma.json' 'nwlogdecoder.json' 'nwlogcollector.json' )
#myjobs=( 'nwipdbextractor.json' 'nwesa.json' 'nwdecoder.json' 'nwconcentrator.json' 'nwbroker.json' 'nwarchiver.json' ) 
myjobs=( 'rsanwappliance.json' )
echo "myjobs[] = ${myjobs[@]}"
# update packer templates with iso specifics
for job in "${myjobs[@]}"
do
	echo "job = $job"
	# skip one off job
	if [ "${job}" = 'centos7.json' ]; then
		continue
	fi
	sed -r "s/(^[[:space:]]*\"iso_url\":[[:space:]]+\").*$/\1file:\/\/\/mnt\/buildStorage\/linux\/centos\/7\/iso\/${myiso}\",/" < ${job} > ${WORKSPACE}/${job}
	myapp=`grep 'output_directory' ${job} | awk -F: '{print $2}'`
	myapp=${myapp##*_}
	echo "myapp = $myapp" 
	sed -r "s/(^[[:space:]]*\"output_directory\":[[:space:]]+\").*$/\1${mypostdir}\",/" < ${WORKSPACE}/${job} > ${WORKSPACE}/${job}.tmp
	mv -f ${WORKSPACE}/${job}.tmp ${WORKSPACE}/${job}
 	sed -r "s/(^[[:space:]]*\"iso_checksum\":[[:space:]]+\").*$/\1${mymd5sum}\",/" < ${WORKSPACE}/${job} > ${WORKSPACE}/${job}.tmp
	mv -f ${WORKSPACE}/${job}.tmp ${WORKSPACE}/${job}
	sed -r "s/(^[[:space:]]*\"output_directory\":[[:space:]]+\").*$/\1${myjobstr}_${myapp}/" < ${WORKSPACE}/${job} > ${WORKSPACE}/${job}.tmp
	mv -f ${WORKSPACE}/${job}.tmp ${WORKSPACE}/${job}
 	sed -r "s/(^[[:space:]]*\"vm_name\":[[:space:]]+\"nwappliance)-.*$/\1${myverstr}-x86_64\",/" < ${WORKSPACE}/${job} > ${WORKSPACE}/${job}.tmp
	mv -f ${WORKSPACE}/${job}.tmp ${WORKSPACE}/${job}
done
#exit 0

# initialize packer build status variables
PACKEREXIT=
PACKERFAIL=
#ARCHIVER=
#BROKER=
#CONCENTRATOR=
#DECODER=
#ESA=
#IPDBEXTRACTOR=
#LOGCOLLECTOR=
#LOGDECODER=
#MALWAREANALYSIS=
#SASERVER=
#WAREHOUSECONNECTOR=

# run packer appliance jobs, skip one offs
cd ${WORKSPACE}
for job in "${myjobs[@]}"
do
	if [ "${job}" = 'centos7.json' ]; then
		continue
	fi
	echo "Building ${job}"
	sudo packer build ${job}
	PACKEREXIT=$?
	if ! [ ${PACKEREXIT} = 0 ]; then
		PACKERFAIL='true'
	fi
	sleep 5
#	case "${job}" in
#		nwarchiver.json )
#			ARCHIVER=${PACKEREXIT}
#		;;
#		nwbroker.json )
#			BROKER=${PACKEREXIT}
#		;;
#		nwconcentrator.json )
#			CONCENTRATOR=${PACKEREXIT}
#		;;
#		nwdecoder.json )
#			DECODER=${PACKEREXIT}
#		;;
#		nwesa.json )
#			ESA=${PACKEREXIT}
#		;;
#		nwipdbextractor.json )
#			IPDBEXTRACTOR=${PACKEREXIT}
#		;;
#		nwlogcollector.json )
#			LOGCOLLECTOR=${PACKEREXIT}
#		;;
#		nwlogdecoder.json )
#			LOGDECODER=${PACKEREXIT}
#		;;
#		nwma.json )
#			MALWAREANALYSIS=${PACKEREXIT}
#		;;
#		nwsaserver.json )
#			SASERVER=${PACKEREXIT}
#		;;
#		nwwarehouseconnector.json )
#			WAREHOUSECONNECTOR=${PACKEREXIT}
#		;;
#
#	esac 
	myoutdir=`grep vm_name ${job} | awk -F: '{print $2}' | awk '{print $1}'`
	myoutdir=${myoutdir#\"}
	myoutdir=${myoutdir%\",}
	myoutroot="${WORKSPACE}/${myoutdir}"
	myartdir="${WORKSPACE}/${myoutdir}/${myoutdir}.ova"
	echo "myoutdir = ${myoutdir}"
	echo "myoutroot = ${myoutroot}"
	echo "mypost =${mypost}"
	echo "myartdir = ${myartdir}"
	if [ -e ${myartdir}/*.ova ]; then
		# extract ova and inject eula into ovf
		sudo /bin/chown -Rf jenkins:jenkins ${myoutroot}
		sudo /bin/chmod -Rf 755 ${myoutroot}	
	#	myname=`ls ${myartdir}/*.ova`
	#	myname=${myname##*/}
	#	myovf=${myname%\.*}
	#	myovf="${myovf}.ovf"
	#	echo "myname = ${myname}"
	#	echo "myovf = ${myovf}"
	#	cd ${myartdir}
	#	tar -xf ${myname}
	#	declare -a ovfout
	#	IFS='|'
	#	let count=0
	#	while read line
	#	do
	#		ovfout[$count]="$line"
	#		let count=$count+1
	#	done < ${myovf}
	#	IFS=' '	
	#	mv -f ${myname} ${myname}.tmp
	#	mv -f ${myovf} ${myovf}.tmp
	#	for item in "${ovfout[@]}"
	#	do
	#		echo "${item}" >> ovfout.txt
	#		if ! [[ `echo "${item}" | grep -i '</OperatingSystemSection>'` ]] && ! [[ `echo "${item}" | grep -i '</VirtualSystem>'` ]]; then
	#			echo "${item}" >> ${myovf}
	#		elif [[ `echo "${item}" | grep -i '</OperatingSystemSection>'` ]]; then
	#			echo "${item}" >> ${myovf}
	#			cat ${WORKSPACE}/rsaimage/cloud/images/packer/vmware/eula.xml >> ${myovf}
	#		elif [[ `echo "${item}" | grep -i '</VirtualSystem>'` ]]; then
	#			echo "${item}" >> ${myovf}			
	#			cat ${WORKSPACE}/rsaimage/cloud/images/packer/vmware/eulastr.xml >> ${myovf}
	#			echo '</Envelope>' >> ${myovf}
	#		fi
	#	done
	#	unset ovfout item line
	#	tar -cf ${myname} *.ovf *.mf *.vmdk
	#	cd ${WORKSPACE}
	#	#exit 0
	#	sudo /bin/chown -f 48:48 ${myartdir}/*.ova
	#	sudo /bin/chmod 644 ${myartdir}/*.ova
		sudo mv -f ${myartdir}/*.ova ${mypost}
		sudo rm -rf ${myoutdir}
	fi
done

# generate build status report
echo
echo '------------- BUILD STATUS -------------'
echo
if ! [ ${PACKERFAIL} ]; then
	echo 'Success: All Builds Completed'
else
	echo 'Failure: Not All Builds Completed'
fi
echo
#echo -n 'ARCHIVER: '
#if ! [ ${ARCHIVER} = 0 ]; then
#	echo 'FAIL'
#else
#	echo 'PASS'
#fi
#echo -n 'BROKER: '
#if ! [ ${BROKER} = 0 ]; then
#	echo 'FAIL'
#else
#	echo 'PASS'
#fi
#echo -n 'CONCENTRATOR: '
#if ! [ ${CONCENTRATOR} = 0 ]; then
#	echo 'FAIL'
#else
#	echo 'PASS'
#fi
#echo -n 'DECODER: '
#if ! [ ${DECODER} = 0 ]; then
#	echo 'FAIL'
#else
#	echo 'PASS'
#fi
#echo -n 'ESA: '
#if ! [ ${ESA} = 0 ]; then
#	echo 'FAIL'
#else
#	echo 'PASS'
#fi
#echo -n 'IPDBEXTRACTOR: '
#if ! [ ${IPDBEXTRACTOR} = 0 ]; then
#	echo 'FAIL'
#else
#	echo 'PASS'
#fi
#echo -n 'LOGCOLLECTOR: '
#if ! [ ${LOGCOLLECTOR} = 0 ]; then
#	echo 'FAIL'
#else
#	echo 'PASS'
#fi
#echo -n 'LOGDECODER: '
#if ! [ ${LOGDECODER} = 0 ]; then
#	echo 'FAIL'
#else
#	echo 'PASS'
#fi
#echo -n 'MALWAREANALYSIS: '
#if ! [ ${MALWAREANALYSIS} = 0 ]; then
#	echo 'FAIL'
#else
#	echo 'PASS'
#fi
#echo -n 'SASERVER: '
#if ! [ ${SASERVER} = 0 ]; then
#	echo 'FAIL'
#else
#	echo 'PASS'
#fi
#echo -n 'WAREHOUSECONNECTOR: '
#if ! [ ${WAREHOUSECONNECTOR} = 0 ]; then
#	echo 'FAIL'
#else
#	echo 'PASS'
#fi

# remove iso descriptor file
rm -f ${WORKSPACE}/DVD_ISO.txt

# return overall build status
if [ ${PACKERFAIL} ]; then
	exit 1
else
	exit 0
fi

