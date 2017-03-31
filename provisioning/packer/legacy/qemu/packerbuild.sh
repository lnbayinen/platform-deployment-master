# packerbuild.sh
#
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#  purpose: builds qcow2 appliance images from
#           the iso 3rd party installer menu and
#           posts them to //sludge/linux/centos/
#           6/could/images/qemu
#
# requires: packer binary, qemu-system-x86_64,
#           and json templates from git repo
# 
#     todo:
#
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#!/bin/bash
#
if ! [[ `mount -l | grep '10\.4\.61\.101'` ]]; then
	echo 'nfs mount to //asoc-platform offline, exiting'
	exit 1
fi
mypost='/mnt/buildStorage/linux/centos/6/cloud/images/qemu'
mypostdir='\/mnt\/buildStorage\/linux\/centos\/6\/cloud\/images\/qemu'
if ! [ -d ${mypost} ]; then
	mkdir -p ${mypost}
fi
if ! [ -d ${mypost} ]; then
	echo 'post directory missing, exiting'
	exit 1	
fi
echo "WORKSPACE = $WORKSPACE"

# freshen up
rm -f ${WORKSPACE}/*.json
rm -f ${WORKSPACE}/tpprovision.sh

# add upstream jenkins dvd iso parameter if initialized 
if ! [ -z "${UPSTREAMDVDISO}" ]; then
	echo "UPSTREAMDVDISO = ${UPSTREAMDVDISO}"
	echo "${UPSTREAMDVDISO}" > ${WORKSPACE}/DVD_ISO.txt
fi

# overwrite using current jenkins dvd iso parameter if specified
if [ "${DVD_ISO}" != 'NONE' ]; then
	echo "${DVD_ISO}" > ${WORKSPACE}/DVD_ISO.txt
fi

# check for successful ISO build
if ! [ -e ${WORKSPACE}/DVD_ISO.txt ]; then
	echo "ISO Descriptor File: ${WORKSPACE}/DVD_ISO.txt not found, exiting"
	exit 1
fi

# generate new packer templates and copy provisioning script
cd ${WORKSPACE}/provisioning/packer/qemu
cp tpprovision.sh ${WORKSPACE}
myisodir='/mnt/buildStorage/linux/centos/6/nw10/iso/6.7'
myiso=`cat ${WORKSPACE}/DVD_ISO.txt`
myjobstr=${myiso%-dvd\.iso}
myverstr=${myjobstr#sa-upgrade}
echo "getting md5sum of ${myisodir}/${myiso}"
mymd5sum=`md5sum ${myisodir}/${myiso} | awk '{print $1}'`
echo "myjobstr = $myjobstr"
echo "myverstr = $myverstr"
myjobs=( `ls -r *.json` )
echo "myjobs[] = ${myjobs[@]}"
# update packer templates with iso specifics
for job in "${myjobs[@]}"
do
	echo "job = $job"
	# skip one off job
	if [ "${job}" = 'centos7.json' ]; then
		continue
	fi
	sed -r "s/(^[[:space:]]*\"iso_url\":[[:space:]]+\").*$/\1file:\/\/\/mnt\/buildStorage\/linux\/centos\/6\/nw10\/iso\/6.7\/${myiso}\",/" < ${job} > ${WORKSPACE}/${job}
	myapp=`grep 'output_directory' ${job} | awk -F: '{print $2}'`
	myapp=${myapp##*_}
	echo "myapp = $myapp" 
	sed -r "s/(^[[:space:]]*\"output_directory\":[[:space:]]+\").*$/\1${mypostdir}\",/" < ${WORKSPACE}/${job} > ${WORKSPACE}/${job}.tmp
	mv -f ${WORKSPACE}/${job}.tmp ${WORKSPACE}/${job}
 	sed -r "s/(^[[:space:]]*\"iso_checksum\":[[:space:]]+\").*$/\1${mymd5sum}\",/" < ${WORKSPACE}/${job} > ${WORKSPACE}/${job}.tmp
	mv -f ${WORKSPACE}/${job}.tmp ${WORKSPACE}/${job}
	sed -r "s/(^[[:space:]]*\"output_directory\":[[:space:]]+\").*$/\1${mypostdir}\/${myjobstr}_${myapp}/" < ${WORKSPACE}/${job} > ${WORKSPACE}/${job}.tmp
	mv -f ${WORKSPACE}/${job}.tmp ${WORKSPACE}/${job}
 	sed -r "s/(^[[:space:]]*\"vm_name\":[[:space:]]+\"rsa-[a-z]+)-.*$/\1${myverstr}-x86_64.qcow2.img\",/" < ${WORKSPACE}/${job} > ${WORKSPACE}/${job}.tmp
	mv -f ${WORKSPACE}/${job}.tmp ${WORKSPACE}/${job}
done
#exit 0

# initialize packer build status variables
PACKEREXIT=
PACKERFAIL=
ARCHIVER=
BROKER=
CONCENTRATOR=
DECODER=
ESA=
LOGDECODER=
MALWAREANALYSIS=
SASERVER=

# run packer appliance jobs, skip one offs
cd ${WORKSPACE}
for job in "${myjobs[@]}"
do
	if [ "${job}" = 'centos7.json' ]; then
		continue
	fi
	myoutdir=`grep output_directory ${job} | awk -F: '{print $2}' | awk '{print $1}'`
	myoutdir=${myoutdir#\"}
	myoutdir=${myoutdir%\",}
	mymvdir=${myoutdir%/*}
	echo "myoutdir = $myoutdir"
	echo "mymvdir = $mymvdir"
	echo "Building ${job}"
	sudo packer build ${job}
	PACKEREXIT=$?
	if ! [ ${PACKEREXIT} = 0 ]; then
		PACKERFAIL='true'
	fi
	sleep 5
	case "${job}" in
		nwarchiver.json )
			ARCHIVER=${PACKEREXIT}
		;;
		nwbroker.json )
			BROKER=${PACKEREXIT}
		;;
		nwconcentrator.json )
			CONCENTRATOR=${PACKEREXIT}
		;;
		nwdecoder.json )
			DECODER=${PACKEREXIT}
		;;
		nwesa.json )
			ESA=${PACKEREXIT}
		;;
		nwlogdecoder.json )
			LOGDECODER=${PACKEREXIT}
		;;
		nwma.json )
			MALWAREANALYSIS=${PACKEREXIT}
		;;
		nwsaserver.json )
			SASERVER=${PACKEREXIT}
		;;

	esac
	if [ -e ${myoutdir}/*.img ]; then
		mv -f ${myoutdir}/*.img ${mymvdir} 
		rm -rf ${myoutdir}
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
echo -n 'ARCHIVER: '
if ! [ ${ARCHIVER} = 0 ]; then
	echo 'FAIL'
else
	echo 'PASS'
fi
echo -n 'BROKER: '
if ! [ ${BROKER} = 0 ]; then
	echo 'FAIL'
else
	echo 'PASS'
fi
echo -n 'CONCENTRATOR: '
if ! [ ${CONCENTRATOR} = 0 ]; then
	echo 'FAIL'
else
	echo 'PASS'
fi
echo -n 'DECODER: '
if ! [ ${DECODER} = 0 ]; then
	echo 'FAIL'
else
	echo 'PASS'
fi
echo -n 'ESA: '
if ! [ ${ESA} = 0 ]; then
	echo 'FAIL'
else
	echo 'PASS'
fi
echo -n 'LOGDECODER: '
if ! [ ${LOGDECODER} = 0 ]; then
	echo 'FAIL'
else
	echo 'PASS'
fi
echo -n 'MALWAREANALYSIS: '
if ! [ ${MALWAREANALYSIS} = 0 ]; then
	echo 'FAIL'
else
	echo 'PASS'
fi
echo -n 'SASERVER: '
if ! [ ${SASERVER} = 0 ]; then
	echo 'FAIL'
else
	echo 'PASS'
fi
 
# remove iso descriptor file
rm -f ${WORKSPACE}/DVD_ISO.txt

# return overall build status
if [ ${PACKERFAIL} ]; then
	exit 1
else
	exit 0
fi
