# cent7build.sh
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ 
#
# purpose:   build minimal centos 7 qemu image
#            using httpdir/ks.cfg and post to
#            platform openstack environment 
#
# requires: packer binary, qemu-kvm package
#           openstack admin credentials and
#           api access, sudo packer and rm
#           command access
#
# todo:
#
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# 
#!/bin/bash

# specify and check nfs mount
mymount='/mnt/buildStorage/linux/centos'
mypost="${mymount}/7/cloud/images/qemu"
if ! [ -d "${mymount}/7" ]; then
	echo "nfs mount to //asoc-platform offline, exiting"
	exit 1
fi

if ! [ -d ${mypost} ]; then
	mkdir -p ${mypost}
fi

# freshen workspace
rm -rf ${WORKSPACE}/httpdir
rm -f ${WORKSPACE}/provision.sh
rm -f ${WORKSPACE}/centos7.json
rm -f ${WORKSPACE}/packer.out
rm -f ${WORKSPACE}/rsanw-appliance-RPMS-*.txt
rm -f ${WORKSPACE}/DVD_ISO.txt
cp -R ${WORKSPACE}/provisioning/packer/qemu/httpdir ${WORKSPACE}
cp ${WORKSPACE}/provisioning/packer/qemu/provision.sh ${WORKSPACE}
cp ${WORKSPACE}/provisioning/packer/qemu/centos7.json ${WORKSPACE} 
#cd ${WORKSPACE}/provisioning/packer/qemu 

# add upstream jenkins dvd iso trigger parameter if initialized 
if ! [ -z "${UPSTREAMDVDISO}" ]; then
	echo "UPSTREAMDVDISO = ${UPSTREAMDVDISO}"
	echo "${UPSTREAMDVDISO}" > ${WORKSPACE}/DVD_ISO.txt
fi

# use jenkins dvd iso parameter if specified
if [ "${DVD_ISO}" != 'NONE' ]; then
	echo "${DVD_ISO}" > ${WORKSPACE}/DVD_ISO.txt
fi

# check for initialized ISO build parameters
if ! [ -s ${WORKSPACE}/DVD_ISO.txt ]; then
	echo "ISO Descriptor File: ${WORKSPACE}/DVD_ISO.txt not found, exiting"
	exit 1
else
	myiso=`cat ${WORKSPACE}/DVD_ISO.txt | awk '{print $1}'`
fi 

# get latest ISO string and md5hash
myisodir=/mnt/buildStorage/linux/centos/7/iso
#myiso=`ls -ltr ${myisodir}/rsanw-11*.iso | tail -n1 | sed -r 's/^.*\///'`
echo "getting md5sum of ${myisodir}/${myiso}"
mymd5sum=`md5sum ${myisodir}/${myiso} | awk '{print $1}'`
echo "mymd5sum = ${mymd5sum}"

# sunset for now
# build image without cloud-init
#sed -r "s/(^[[:space:]]*\"output_directory\":[[:space:]]+\").*$/\1cent7min-${BUILD_NUMBER}\",/" < ${WORKSPACE}/centos7.json > ${WORKSPACE}/centos7.json.tmp
#mv -f ${WORKSPACE}/centos7.json.tmp ${WORKSPACE}/centos7.json
#sed -r "s/(^[[:space:]]*\"vm_name\"\:[[:space:]]+\").*$/\1cent7min-${BUILD_NUMBER}.img\",/" < ${WORKSPACE}/centos7.json > ${WORKSPACE}/centos7.json.tmp
#mv -f ${WORKSPACE}/centos7.json.tmp ${WORKSPACE}/centos7.json 
#sudo packer build centos7.json
#sleep 3 

# update json descriptor with iso specifics 
sed -r "s/(^[[:space:]]*\"iso_url\":[[:space:]]+\").*$/\1file:\/\/\/mnt\/buildStorage\/linux\/centos\/7\/iso\/${myiso}\",/" < ${WORKSPACE}/centos7.json > ${WORKSPACE}/centos7.json.tmp
mv -f ${WORKSPACE}/centos7.json.tmp ${WORKSPACE}/centos7.json
sed -r "s/(^[[:space:]]*\"iso_checksum\":[[:space:]]+\").*$/\1${mymd5sum}\",/" < ${WORKSPACE}/centos7.json > ${WORKSPACE}/centos7.json.tmp
mv -f ${WORKSPACE}/centos7.json.tmp ${WORKSPACE}/centos7.json
sed -r "s/(^[[:space:]]*\"output_directory\":[[:space:]]+\").*$/\1rsanw-appliance-${BUILD_NUMBER}\",/" < ${WORKSPACE}/centos7.json > ${WORKSPACE}/centos7.json.tmp
mv -f ${WORKSPACE}/centos7.json.tmp ${WORKSPACE}/centos7.json
sed -r "s/(^[[:space:]]*\"vm_name\":[[:space:]]+\").*$/\1rsanw-appliance-${BUILD_NUMBER}.img\",/" < ${WORKSPACE}/centos7.json > ${WORKSPACE}/centos7.json.tmp
mv -f ${WORKSPACE}/centos7.json.tmp ${WORKSPACE}/centos7.json 
#sed -r 's/(^[[:space:]]*#[[:space:]]*)yum[[:space:]]+-y[[:space:]]+install[[:space:]]+cloud-init.*$/yum -y install cloud-init/' < ${WORKSPACE}/provision.sh > ${WORKSPACE}/provision.sh.tmp
#mv -f ${WORKSPACE}/provision.sh.tmp ${WORKSPACE}/provision.sh
#exit 0 
sudo packer build -machine-readable centos7.json | tee -a ${WORKSPACE}/packer.out 
sleep 3
# upload images
# sunset for now
#if [ -e ${WORKSPACE}/cent7min-${BUILD_NUMBER}/cent7min-${BUILD_NUMBER}.img ]; then
#	. rsaimage/cloud/images/openstack/admin.admin
#	~/openstack/bin/openstack image create --public --min-disk 10 --min-ram 4096 --file ${WORKSPACE}/cent7min-${BUILD_NUMBER}/cent7min-${BUILD_NUMBER}.img --disk-format qcow2  --container-format bare cent7min-${BUILD_NUMBER}
#	sleep 2
#        sudo rm -rf ${WORKSPACE}/cent7min-${BUILD_NUMBER}/
#fi

if [ -e ${WORKSPACE}/rsanw-appliance-${BUILD_NUMBER}/rsanw-appliance-${BUILD_NUMBER}.img ]; then
	# create rpm manifest
	declare -a rpmlist
	IFS='|'
	inblock=
	let count=0
	while read line
	do
		if [[ `echo "${line}" | grep '# installed rpm manifest'` ]]; then
			inblock='true'
			echo '# installed rpm manifest' > ${WORKSPACE}/rsanw-appliance-RPMS-${BUILD_NUMBER}.txt
			continue
		fi
		if [[ `echo "${line}" | grep '# end rpm manifest'` ]]; then
			unset inblock
			echo '# end rpm manifest' >> ${WORKSPACE}/rsanw-appliance-RPMS-${BUILD_NUMBER}.txt
			break
		fi
		if [ ${inblock} ]; then
			echo "${line}" | awk -F qemu: '{print $2}' | awk '{print $1}' >> ${WORKSPACE}/rsanw-appliance-RPMS-${BUILD_NUMBER}.txt
		fi
		let count=${count}+1
	done < ${WORKSPACE}/packer.out
	IFS=' '
	#$exit 0
	cp ${WORKSPACE}/rsanw-appliance-RPMS-${BUILD_NUMBER}.txt ${mypost}
	cp ${WORKSPACE}/rsanw-appliance-${BUILD_NUMBER}/rsanw-appliance-${BUILD_NUMBER}.img ${mypost}
	#. rsaimage/cloud/images/openstack/admin.admin
	#~/openstack/bin/openstack image create --public --min-disk 10 --min-ram 4096 --file ${WORKSPACE}/cent7mincloud-${BUILD_NUMBER}/cent7mincloud-${BUILD_NUMBER}.img --disk-format qcow2  --container-format bare cent7mincloud-${BUILD_NUMBER}
	sleep 2
	sudo rm -rf ${WORKSPACE}/rsanw-appliance-${BUILD_NUMBER}/
fi
