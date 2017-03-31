# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#
#   purpose: extracts the oem CentOS 6 install DVD iso image and
#            creates a custom netwitness install iso image. 'usbboot' iso
#            images are used for creating boot able flash media, 'usb'
#            iso images must be present on the flash media for usb 
#            flash stick installs, 'dvd' iso images are used for
#            creating dvd install media.  
#
#  requries: 'as passed parameter:' the directory path of the extracted
#            CentOS install DVD iso image files, yum-utils/repo-graph
#            and yum-utils/repoquery packages, anaconda and 
#            anaconda-runtime packages, about 6 GB of available
#            space in the working directory, sudo access to the mount
#            and umount commands, write access to all work directories 
#            and files therein, the mkisofs package, NW application
#            repositories need to be defined in the host system's
#            yum configuration.
#
#  optional: 'as passed parameter:' the release version of the NW
#            applications, by default daily build isos are created,
#            'as passed parameter:' the revision number of the NW
#            applications, this is required for non daily/default builds,
#            'as passed parameter:' the type of iso image to create either
#            'dvd', 'usb' or 'boot', by default usb images are created,
#            'as passed  parameter:' the working directory where the
#            build iso images are created, by default the script's
#            location is used, 'as passed parameter:' the path of the
#            CentOS intall DVD iso file, this causes a fresh copy of the
#            DVD iso image to be extracted in "$isodir", if "$isodir"
#            exists it is deleted, file level CentOS repositories
#            including 'base', 'updates' and 'extras' should be
#            created and configured on the host system  
#
#      todo: add routine that enables/disables yum.conf to allow 
#            enabling/disabling of repos
#
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#
#!/bin/bash
# 
# ^^^^^^^^^^^^^^^^^^^^^^^^^ global constants ^^^^^^^^^^^^^^^^^^^^^^^^^^^

# build artifacts path
isostor='/mnt/buildStorage/nw10/iso/6.6'
majorRelease='10.3'
nextgenRepoID='nw10'
ngapps='nwappliance nwarchiver nwbroker nwconcentrator nwconsole nwdecoder nwlogdecoder nwdecodercontent nwlogplayer'
baseRepoID='fbase'
spectrumMajor='10'
spectrumMinor='3'
spectrumRepoID='mp' 
saName='security-analytics-web-server'
saMajor='10'
saMinor='3'
saRepoID='tranny'
reMajor='10'
reMinor='3'
reRepoID='re10.3'
ipdbextMajor='10'
ipdbextMinor='3'
ipdbextRepoID='ngext10.3'
logcolMajor='10'
logcolMinor='3'
logcolRepoID='ngc-10.3'
ngccMajor='10'
ngccMinor='3'
ngccRepoID='ng-cc'
#compfile='2727fcb43fbe4c1a3588992af8c19e4d97167aee2f6088959221fc285cab6f72-c6-x86_64-comps.xml'
#compfile='b4e0b9342ef85d3059ff095fa7f140f654c2cb492837de689a58c581207d9632-c6-x86_64-comps.xml'
#compfile='9e2ddcc42b44eb150ebc61dde29c997318d8330b92205b3dbb3a87bcc06d10be-c6-x86_64-comps.xml' 
#compfile='4df092633ebecaeebdd78359a11a3c13f619f22605322e15e5e307beebd8e641-c6-x86_64-comps.xml'
compfile='3eda3fefdbaf4777fcab430c80bc438293c512f22fd706b12c6567d535b2142a-c7-x86_64-comps.xml' 
#3eda3fefdbaf4777fcab430c80bc438293c512f22fd706b12c6567d535b2142a-c7-x86_64-comps.xml
repourl='http://mirror.rsa.lab.emc.com/centos/7/os/x86_64/repodata/'
#rsacompfile='33ebc4065bfb9672e82cbac25a0855d5602468dd688b728f4b67b49ef0d03163-c6-x86_64-comps.xml'
#rsacompfile='3eacb00bc5dded53fe9adab1e241a0987232dc25a07faf0200701a7052fd7da6-c6-x86_64-comps.xml'
#rsacompfile='9f6b2702ec4e152f6363f9582147479df0fbee55cb694187a241443c9fea769a-c6-x86_64-comps.xml'
#rsacompfile='6b07c431c786386505eeb0f677af3a29c7e94023ed7be96c68a931b67f5a93d1-c6-x86_64-comps.xml'
#rsacompfile='51d3ed3d26b9ed0e365ac194c3be25d1a07e253405e68751f7e8a78e1c1a214b-c6-x86_64-comps.xml'
#rsacompfile='647108cccbccfb27bf376178c99a69565f451b0047afe71a7a1ef5c17c8c62df-c6-x86_64-comps.xml'
#rsacompfile='3dde432c8850b13dfc18892142907003083fac50f11bf8642300551820530022-c6-x86_64-comps.xml'
#rsacompfile='749549a36c0572a1f90a1245bd8e7e6f7343b180bfcfe053269618fd41f5d5b2-c6-x86_64-comps.xml'
#rsacompfile='5397bec20d6a1d2cbafdac74a6e9ca8b4b8fa3e469729aa5b44873bb150fad90-c6-x86_64-comps.xml'


# set path of yum.conf
yumConf="${WORKSPACE}/yum.conf.hudson"
# for hashing code base
ngver='ng10.5'
rsacomp=${WORKSPACE}/baseiso/el7/${CODEVERSION}/el7_upgrade_gold_iso/comps.xml
parsecomp=${WORKSPACE}/baseiso/el7/${CODEVERSION}/el7_upgrade_gold_iso/parsecomp.py
kscode="${WORKSPACE}/baseiso/el7/${CODEVERSION}/el7_upgd_ks"
isocode="${WORKSPACE}/baseiso/el7/${CODEVERSION}/el7_upgrade_gold_iso"
compcode="${WORKSPACE}/baseiso/el7/${CODEVERSION}/el7_upgrade_gold_iso/comps.xml"
mylog="${WORKSPACE}/nwisobuild.log"

# ^^^^^^^^^^^^^^^^^^^^^^^^ global variables ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

# version of sa server
saverstr=
# sa release version, major.minor
saver= 
# cuurent path of group file comps.xml
COMPSNAME=
# iso type string, dvd, usb or usbboot
isotype=
# build number string, jenkins env variable
buildnum="${BUILD_NUMBER}" 
# add miscellaneous packages here, i.e. not in CentOS @CORE or @RSA package groups
declare -a miscpacks
miscpacks=( mdadm logrotate crontabs dbus parted tmpwatch )

# ^^^^^^^^^^^^^^^^^^^^^^^^^ function defs ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

# creates a file list of the base, core and rsa package groups
createpacklist () {

local group
local numpacks
local packgroups
declare -a packgroups
local count 
local packlist
declare -a packlist
local line
local startline
local item

# get compfile
if ! [ -s ${workdir}/${compfile} ]; then
    wget ${repourl}/${compfile}
fi

# prepend rsa comps.xml file to centos' and check for deltas
#$parsecomp ${WORKSPACE}/${compfile} ${rsacomp} 
#mysha256=`sha256sum ${workdir}/comps.xml | awk '{print $1}'`
#if ! [ -s "${workdir}/${rsacompfile}" ]; then
#   cp ${workdir}/comps.xml ${workdir}/${mysha256}-c6-x86_64-comps.xml
#fi
#if ! [[ `echo "${workdir}/${rsacompfile}" | grep "${mysha256}"` ]]; then
#    mv -f ${workdir}/comps.xml ${workdir}/${mysha256}-c6-x86_64-comps.xml  
#    echo "sha256sum of rsacompfile: ${rsacompfile} has changed, please update nwisobuild.sh global variable definition to ${mysha256}-c6-x86_64-comps.xml"
#    exit 1
#fi

# load package group lists into array
echo "creating package groups list ..."
let count=0
while read line
do
packlist[$count]=$line
let count=$count+1
done < ${WORKSPACE}/${compfile}

let numpacks=${#packlist[@]}

# remove/touch existing packlist file
rm -f ${workdir}/corelist.txt
# kernel and grub2 packages are assumed
echo "writing 'kernel' to corelist.txt" >> ${mylog}
echo "kernel" > ${workdir}/corelist.txt
echo "grub2" >> ${workdir}/corelist.txt
echo "grub2-efi" >> ${workdir}/corelist.txt
echo "open-vm-tools" >> ${workdir}/corelist.txt
# add cloud related packages
#echo "cloud-init" >> ${workdir}/corelist.txt
#echo "cloud-utils" >> ${workdir}/corelist.txt
#echo "cloud-utils-growpart" >> ${workdir}/corelist.txt
# add addtional packages not included in @Core and @Base groups
cat ${WORKSPACE}/baseiso/el7/ng11.0/el7_upgrade_gold_iso/nwpackagelist >> ${workdir}/corelist.txt

writepacklist () {

local packgroup=$3

for ((i=$1; i<$2; i++))
do
	# break at @group end
	if [[ `/bin/echo ${packlist[$i]} | /bin/grep -i '</packagelist>'` ]]; then
		break
	# skip optional centos packages
	elif ! [[ `echo "$packgroup" | grep '^rsa-sa'` ]]; then 
		if [[ `/bin/echo "${packlist[$i]}" | /bin/grep -i -E '^[[:space:]]*<packagereq'` ]] && ! [[ `/bin/echo "${packlist[$i]}" | /bin/grep -i -E '^[[:space:]]*<packagereq[[:space:]]+type="optional">'` ]]; then     
			# parse package name
			local packstr="${packlist[$i]}"
			packstr="${packstr#*>}"
			packstr="${packstr%<*}"
			# skip upstream packages not included in downstream disto, i.e. redhat -> centos
			case "$packstr" in
				'yum-rhn-plugin' | 'rhnsd' | 'rhn-setup-gnome' | 'abrt-plugin-mailx' | 'abrt-plugin-sosreport'  | 'openssl-ibmca' | 'iprutils' | 'netxen-firmware' | 'ppc64-diag' | 'ppc64-utils' | 's390utils' | 'yaboot' | 'libjpeg' | 'redhat-access-insights' | 'bfa-firmware' | 'libertas-sd8686-firmware' | 'libertas-sd8787-firmware' | 'libertas-usb8388-firmware' | 'ql2100-firmware' | 'ql2200-firmware' | 'ql23xx-firmware' | 'yum-plugin-security' )
				continue
				;;
				* )
				;;
			esac
			if ! [[ `grep "^${packstr}$" $workdir/corelist.txt` ]]; then
				echo "writing ${packstr} to corelist.txt" >> $mylog
				echo "${packstr}" >> $workdir/corelist.txt
			fi
		else
			continue
		fi
	# add all rsa default, optional and required packages, needed for 3rd party installer menu
	else
		if [[ `/bin/echo "${packlist[$i]}" | /bin/grep -i -E '^[[:space:]]*<packagereq'` ]]; then     
			# parse package name
			local packstr="${packlist[$i]}"
			packstr="${packstr#*>}"
			packstr="${packstr%<*}"
			if ! [[ `grep "^${packstr}$" $workdir/corelist.txt` ]]; then
				echo "writing ${packstr} to corelist.txt" >> $mylog			
				echo "${packstr}" >> $workdir/corelist.txt
			fi
		else
			continue
		fi
	fi	   
done
} 

# generate package list from centos comps.xml file after rsa comps.xml insert
#packgroups=( core rsa-sa-archiver rsa-sa-broker rsa-sa-concentrator rsa-sa-core rsa-sa-esa-server rsa-sa-ipmi-tools rsa-sa-log-decoder rsa-sa-lsi-megacli rsa-sa-malware-analysis rsa-sa-malware-analysis-colocated rsa-sa-packet-decoder rsa-sa-san-tools rsa-sa-server )

packgroups=( core base )
#echo "packgroups[] = ${packgroups[@]}"

for group in ${packgroups[@]}
do
	unset startline
	startline=`grep -i -n "<id>${group}</id>" ${workdir}/${compfile} | awk '{ print $1 }'`
	startline=${startline//:/}
	#echo "startline = $startline"
	writepacklist $startline $numpacks $group
done

for item in ${miscpacks[@]}
do
 	echo "writing ${item} to corelist.txt" >> ${mylog}
	echo "${item}" >> ${workdir}/corelist.txt
done

}

solvedeps () { 
echo "calling solvedeps() with ${1}" >> $mylog
if  [[ `egrep -x "^\"${1}\" -> {$" ${workdir}/repodeps.txt` ]]; then
    local linenum=`grep -x -n "^\"${1}\" -> {$" ${workdir}/repodeps.txt` 
    # strip from right side to colon 
    let linenum="${linenum%%:*}" 
    #echo "linenum = $linenum"
    #echo "${depslist[$linenum]}" 
    while [ 1 ]
    do
        local depstr="${depslist[$linenum]}" 
        local stripstr='"'
        depstr="${depstr//$stripstr/}"
	#echo "depstr = |${depstr}|" 
        if [[ `echo "${depstr}" | grep '}'` ]]; then
            break
        else
            if ! [[ `grep "^${depstr}$" $workdir/corelist.txt` ]]; then
       		echo "adding ${depstr} to corelist.txt" >> ${mylog}        
		echo "${depstr}" >> ${workdir}/corelist.txt
                solvedeps "${depstr}"
            fi
        fi
    let linenum=${linenum}+1
    done 
fi
}

function setbuildstr {
# set global buildnum variable with jenkins ${BUILD_NUMBER} env var
# if isofolder parameter is provided, enforce unique iso name(s) in
# $isofolder, only needed if different jobs post to the same location 
	
	buildnum=${BUILD_NUMBER} 
	local isofolder=$1
	if ! [ -z $isoifolder ]; then
		local alphalist=( 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 'u' 'v' 'w' 'x' 'y' 'z' )
		local conflict='true'
		local count
		let count=0
		while [[ $conflict = 'true' ]]
		do	
		    if [[ -s "$isofolder/sainstall-$saverstr-$buildnum-$isotype.iso" ]]; then
    		   	 buildnum="${BUILD_NUMBER}${alphalist[$count]}"
		       	 let count=$count+1 
		    else
			conflict='false' 
		    fi
		done
	fi
}

function gethashes {
# create flat file containing: filename, tab space and md5sum of all iso build code files
	local hashes
	local item
	local hash
	local mypwd=`pwd`

	echo "creating build code and package hashes ..."
	if [ -s ${WORKSPACE}/$isotype.hashes.new ]; then
		mv -f ${WORKSPACE}/$isotype.hashes.new ${WORKSPACE}/$isotype.hashes.old
	fi
	declare -a hashes
	cd ${kscode}
	#hashes=( `ls -A $kscode` )
	hashes=( `ls -A` )
	for item in ${hashes[@]}
	do
		if ! [[ `git status -s ${item} | awk '{print $1}' | grep '\?'` ]]; then
			hash=`md5sum ${item} | awk '{print $1}'`
			echo -e "$item\t$hash" >> ${WORKSPACE}/$isotype.hashes.new
		fi

	done
	unset hashes
	
	declare -a hashes
	cd ${isocode}
	#hashes=( `ls -A $isocode` )
	hashes=( `ls -A` )
	for item in ${hashes[@]}
	do
		if ! [[ `git status -s ${item} | awk '{print $1}' | grep '\?'` ]]; then
			hash=`md5sum ${item} | awk '{print $1}'`
			echo -e "$item\t$hash" >> ${WORKSPACE}/$isotype.hashes.new
		fi

	done
	unset hashes

	hash=`md5sum $compcode | awk '{print $1}'`
	echo -e "$compcode\t$hash" >> ${WORKSPACE}/$isotype.hashes.new
	cd ${mypwd}
}

function shouldirun {
# only build ISO if code base or package list changed
	
	gethashes
	local newcodehashes=${WORKSPACE}/${isotype}.hashes.new
	local oldcodehashes=${WORKSPACE}/${isotype}.hashes.old
	local newcodesum
	local oldcodesum
	local oldpack=$1
	local newpack=$2
	local newpacksum
	local oldpacksum
	
	# build if there is nothing to compare
	if ! [[ -s $oldcodehashes  && -s $oldpack ]]; then
		echo "no code hashes and or package lists to compare, building iso"
		return
	fi
	
	oldcodesum=`md5sum $oldcodehashes | awk '{print $1}'`
	newcodesum=`md5sum $newcodshashes | awk '{print $1}'`
	oldpacksum=`md5sum $oldpack | awk '{print $1}'`
	newpacksum=`md5sum $newpack | awk '{print $1}'` 
	
	echo "oldcodesum = $oldcodesum , newcodesum = $newcodesum"
	echo "oldpacksum = $oldpacksum , newpacksum = $newpacksum"
	
	if [[ $oldcodesum = $newcodesum && $oldpacksum = $newpacksum ]]; then
		echo "no new code or package updates found, not building isos'"
		rm -f $oldpack
		exit 1
	elif [[ $oldcodesum != $newcodesum && $oldpacksum = $newpacksum ]]; then
		echo "new code updates found, building iso"
	elif [[ $oldcodesum = $newcodesum && $oldpacksum != $newpacksum ]]; then
		echo "new package updates found, building iso"
	elif [[ $oldcodesum != $newcodesum && $oldpacksum != $newpacksum ]]; then
		echo "new code and package updates found, building iso"
	fi
}

function getrelease {
    # get repo path, assuming consistent version naming in the platform-2 branch
    safullver=`cat $workdir/nwAppRpmVer`
    samajver=`echo ${safullver} | awk -F. '{print $1}'`
    saminver=`echo ${safullver} | awk -F. '{print $2}'`
    saspver=`echo ${safullver} | awk -F. '{print $3}'`
    sahfver=`echo ${safullver} | awk -F. '{print $4}'`
    saver="${samajver}.${saminver}"
}

# ^^^^^^^^^^^^^^^^^^^^^^^^ variables main ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
rpmlist=
declare -a rpmlist 
item=
count=
mymd5sum=
mflist=
declare -a mflist
oldmf=
newmf=
optinstallmd5=

# ^^^^^^^^^^^^^^^^^^^^^^^^^ main program ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


# get passed parameters
let count=1 
while [[ $count -le 5  ]]
do
    if [[ $count -eq 1 ]]; then
        isodir=$1
    elif [[ $count -eq 2 ]]; then
        isotype=$1
    elif [[ $count -eq 3 ]]; then
        workdir=$1
    elif [[ $count -eq 4 ]]; then
        isopath=$1
    elif [[ $count -eq 5 ]]; then
        url=$1
    fi
    shift
    let count=$count+1
done

# check iso build type
if [ -z $isotype ]; then
    isotype='dvd'
elif ! [[ "$isotype" = "usb" || "$isotype" = "dvd" || "$isotype" = "usbboot" ]]; then
    echo "invaild iso build type"
    echo "usage: nwisobuild.sh /installDVD-isoImages-directory[ '' '' dvd | usb | usbboot ]"
    exit 1
fi

# check for valid iso directory
#if ! [[ "$isotype" = 'usbboot' ]]; then
    # since the os upgrade to centos 6.5 the compfile is renamed after running createrep, bug?
    #if ! [[ -s "$isodir/repodata/$compfile" && -d "$isodir/Packages" && -d "$isodir/isolinux" ]] && [[ -z $isopath ]]; then
#    if ! [[ -d "$isodir/Packages" && -d "$isodir/isolinux" ]] && [[ -z $isopath ]]; then
#       echo "invalid iso directory; no install dvd iso path provided"
#       echo "usage: nwisobuild.sh /installDVD-isoImages-directory[ '' '' '' '' '/path-to-install-dvd-iso']"
#       exit 1
#    fi   
#fi
if ! [[ -d "${isodir}" ]] && [[ -z $isopath ]]; then
    echo "missing iso template directory, no install dvd iso path provided"
    echo "usage: nwisobuild.sh /installDVD-isoImages-directory[ '' '' '' '' '/path-to-install-dvd-iso']"
     exit 1
fi

# check build version parameter, create daily build iso by default
if [ -z $buildtag ]; then
    buildtag=0
else
    case $buildtag in
        0   ) ;; # daily/default
        1   ) ;; # dev
        2   ) ;; # alpha
        3   ) ;; # beta
        4   ) ;; # rc
        5   ) ;; # gold
        *   ) echo "invalid build version, 0 :daily/default, 1 :dev, 2 :alpha, 3 :beta, 4 :rc, 5 : gold"
              echo "usage: nwisobuild.sh /installDVD-isoImages-directory[ 0 | 1 | 2 | 3 | 4 | 5 ]"
              exit 1
	   ;;
    esac  
fi 

# check working directory
if [[ -z $workdir ]]; then
    workdir=`pwd`
elif ! [[ -d $workdir ]]; then
    echo "invalid working directory"
    echo "usage: nwisobuild.sh /installDVD-isoImages-directory[ '' '' '' '/working-directory']"
    exit 1
fi

# check install DVD iso path
#if ! [[ -z $isopath ]]; then
#    if ! [[ -e $isopath ]]; then
#        echo "invaild install dvd iso path"
#        echo "usage: nwisobuild.sh /installDVD-isoImages-directory[ '' '' '' '' '/path-to-dvd-install-iso']" 
#        exit 1
#    fi	
#    if ! [[ -d $workdir/isomnt ]]; then
#        mkdir $workdir/isomnt
#    fi	
#    if [[ -d $isodir ]]; then
#        rm -Rf $isodir
#        if [[ $? -ne 0 ]]; then
#            echo "error deleting iso image directory, exiting"
#            exit 1
#        fi 
#    fi 
#    echo "mounting and copying dvd image ..."
#    sudo mount $isopath -o loop $workdir/isomnt
#    if ! [[ $? -eq 0 ]]; then
#        echo "error mounting install dvd iso, exiting"
#        exit 1
#    fi
#    cp -R $workdir/isomnt $isodir
#    sudo umount $workdir/isomnt
#    chmod +w $isodir/isolinux/isolinux.bin 
#fi 

# check install DVD iso path
if ! [[ -d $isodir ]] && ! [[ -z $isopath ]]; then
    if ! [[ -e $isopath ]]; then
        echo "invaild install dvd iso path"
        echo "usage: nwisobuild.sh /installDVD-isoImages-directory[ '' '' '' '' '/path-to-dvd-install-iso']" 
        exit 1
    fi	
    mkdir -p $workdir/isomnt
    echo "mounting and copying dvd image ..."
    sudo mount $isopath -o loop $workdir/isomnt
    if ! [[ $? -eq 0 ]]; then
        echo "error mounting install dvd iso, exiting"
        exit 1
    fi
    cp -R $workdir/isomnt $isodir
    sudo umount $workdir/isomnt
    chmod -R u+w,a+r $isodir 
fi


# strip any trailing slashes from url
if ! [ -z $url ]; then
	url=${url%/}
fi

if [[ "$isotype" = 'usb' || "$isotype" = 'dvd' ]]; then
    # rotate log
    mydate=`date +%Y%m%d%H%M%S`
    if [ -s ${mylog} ]; then
        let logsize=`stat -c %s ${mylog}`
        if [ $logsize -ge 524288 ]; then
            tar -czf ${mylog}-${mydate}.tgz ${mylog}
	    rm -f ${mylog}
        fi
    fi
    # initialize log
    echo '# ------------------------------------------------------------------' >> ${mylog}
    echo "# runtime: ${mydate}" >> ${mylog}
    echo "" >> ${mylog}
 
    # create a file list of the base, core and fonts package groups  
    createpacklist $isodir
   
    # create repo dependancy db
    echo 'graphing package repository dependencies ...'
    repo-graph -c "${yumConf}" --repoid="os" > ${workdir}/repodeps.txt
    # parse out jenkins inserted repo definition
    #myrepo=`grep '\[.*\]' ${workdir}/yum.conf.hudson | grep -v '\[main\]' | grep -v '\[fbase\]' | awk '{print $1}'` 
    #myrepo="${myrepo#[}"
    #myrepo="${myrepo%]}" 
    #echo "myrepo = $myrepo"
    #repo-graph -c "${yumConf}" --repoid="updt" >> ${workdir}/repodeps.txt    
    # read repodeps db and corelist.txt into arrays
    declare -a corelist
    declare -a depslist
    FILENAME=$workdir/repodeps.txt
    let count=0
    while read line
    do
        depslist[$count]="$line"
        let count=$count+1
    done < $FILENAME
    corelist=( `cat $workdir/corelist.txt` )

    # add any missing package dependancies to the list 
    echo "solving package dependencies ..."  
    for item in "${corelist[@]}"
    do
        solvedeps "${item}"
    done

    # remove un-needed/outdated packages
    cd $isodir/Packages
    rm -f *.rpm
    
    # add freshened base, core, fonts and NW packages plus deps 
    #yumdownloader --resolve -c "${yumConf}" --disablerepo=\* --enablerepo=fbase,"${myrepo}" `cat "$workdir/corelist.txt"  | tr '\n' ' '` 
    yumdownloader -c "${yumConf}" --resolve --disablerepo=\* --enablerepo=os,updt,xtras,epel `cat "$workdir/corelist.txt"  | tr '\n' ' '`
    
    # temporarily enable extras for clould-init
    #yumdownloader -c "${yumConf}" --disablerepo=\* --enablerepo=extras,fbase,"${myrepo}" --resolve `cat "$workdir/corelist.txt"  | tr '\n' ' '`
    
    # make sure all files are world readable
    chmod a+r *.rpm

    # check that all packages were downloaded sucessfully
    corelist=( `cat $workdir/corelist.txt` )
    ls -A > "$workdir/packdownload.txt"
    for item in ${corelist[@]}
    do 
	if ! [[ `grep "^$item" $workdir/packdownload.txt` ]] || ! [[ -s ./$packfull ]]; then
            echo "*Package Error* name parsing or download failure: $item"
	    echo "Terminating ISO Build, verify package and or repository"
            # remove dvd iSO and manifest if usb job failed
            if [ "$isotype" = 'usb' ]; then
		rm -f $workdir/*-dvd.iso
		rm -f $workdir/*-dvd.mf
            fi      
            exit 1 
        fi 
    done 
    
    # set sa version
    #if ! [ $saverstr ]; then
    #    saverstr=`grep 'security-analytics-web-server' $workdir/packdownload.txt`
    #    saverstr=${saverstr%%\.[a-zA-Z]*}                        
    #	saverstr=${saverstr##*[a-zA-Z]-}	                
    #	saverstr=`echo $saverstr | awk '{print $1}'`
    #    # write to file for usbboot iso job
    #	echo "$saverstr" > $workdir/nwAppRpmVer
    #fi   
    
    # check for zero byte packages
    packagelist=( `ls -A *.rpm` )
    for member in ${packagelist[@]}
    do
        if ! [[ -s ./$member ]]; then
            echo "*Package Error* name parsing or empty file: $member"
	    echo "Terminating ISO Build, verify package and or repository"    
            # remove dvd iSO and manifest if usb job failed
            if [ "$isotype" = 'usb' ]; then
		rm -f $workdir/*-dvd.iso
		rm -f $workdir/*-dvd.mf
            fi
            exit 1 
        fi
    done
    
    # enforce unique iso names by appending ${BUILD_NUMBER} string
    #setbuildstr $isostor  
   
    # check for previous build's manifest 
    if [[ `ls $isodir/*.mf` ]]; then
        oldmf=`ls $isodir/*.mf`
	echo "previous build manifest file: $oldmf"
    else
        echo "no previous build manifest file found"
    fi 
    
    #: create package manifest file
    newmf="${isodir}/rsanw-11.0.0.0-0.1.${buildnum}-${isotype}.mf" 
    echo '# iso image package manifest' >> $newmf
    echo "# format: 'package name','md5sum'" >> $newmf

    rpmlist=( `ls *.rpm` )
    #echo "rpmlist[] = ${rpmlist[@]}"
    
    let count=0 
    for item in "${rpmlist[@]}"
    do 
	#echo "rpm item = ${item}"
	mymd5sum=`md5sum $item | awk '{print $1}'`
        echo "${item},${mymd5sum}" >> $newmf
	mflist[$count]="${item},${mymd5sum}"
	let count=$count+1
    done

    # get sa release
    #getrelease 
    
    # define repository dependent variables
    #rsacomp=${WORKSPACE}/nwApplianceImage/el6/ng${saver}/el6_upgrade_gold_iso/comps.xml
    #parsecomp=${WORKSPACE}/nwApplianceImage/el6/ng${saver}/el6_upgrade_gold_iso/parsecomp.py
    #kscode="${WORKSPACE}/nwApplianceImage/el6/ng${saver}/el6_upgd_ks"
    #isocode="${WORKSPACE}/nwApplianceImage/el6/ng${saver}/el6_upgrade_gold_iso"
    #compcode="${WORKSPACE}/nwApplianceImage/el6/ng${saver}/el6_upgrade_gold_iso/comps.xml"
    
    # check if iso job should be run 
    if [[ $oldmf ]]; then
        shouldirun $oldmf $newmf
        # remove old manifest file
        echo "removing previous build's manifest: $oldmf"
        rm -f $oldmf
    else
        echo "no previous build manifest file found, skipping shouldirun()"
    fi

    # import rsa comps.xml, create package repo metadata
    echo 'creating package metadata ...'
    cd ../repodata
    # remove old comp files
    rm -f *-comps.xml.gz
    if ! [ -f ${compfile} ]; then
	cp ${workdir}/${compfile} ./comps.xml
    else
        mv -f ${compfile} comps.xml
    fi
    #$parsecomp ${WORKSPACE}/$compfile $rsacomp 
    sleep 3
    cd .. 
    createrepo -g repodata/comps.xml .
    cd $workdir
fi

## if creating a 'dvd' or 'usbboot' iso download any missing binaries
#if [[ "$isotype" = 'dvd' || "$isotype" = 'usbboot' ]]; then
#   if ! [[ -d $workdir/binaries ]]; then
#       mkdir $workdir/binaries
#   fi
#   if ! [[ -e $workdir/binaries/MegaCLI ]]; then
#       cd $workdir/binaries
#       wget http://cent6build1.netwitness.local/~hudson/buildbin/MegaCLI
#       cd $workdir
#   fi
#   # need to add check sums for syslinux binaries
#   if ! [[ -e $workdir/binaries/menu.c32 ]]; then
#       cd $workdir/binaries
#       wget http://cent6build1.netwitness.local/~hudson/buildbin/menu.c32
#       cd $workdir
#   fi 
#   if ! [[ -e $workdir/binaries/isolinux.bin ]]; then
#       cd $workdir/binaries
#       wget http://cent6build1.netwitness.local/~hudson/buildbin/isolinux.bin
#       cd $workdir
#   fi
#   if ! [[ -e $workdir/binaries/splash.jpg ]]; then
#       cd $workdir/binaries
#       wget http://cent6build1.netwitness.local/~hudson/buildbin/splash.jpg
#       cd $workdir
#   fi  
#   if ! [[ -e $workdir/binaries/uudecode ]]; then
#       cd $workdir/binaries
#       wget http://cent6build1.netwitness.local/~hudson/buildbin/uudecode
#       cd $workdir
#   fi
#   if ! [[ -e $workdir/binaries/tr ]]; then
#       cd $workdir/binaries
#       wget http://cent6build1.netwitness.local/~hudson/buildbin/tr
#       cd $workdir
#   fi
#   if ! [[ -e $workdir/binaries/openssl-1.0.0-20.el6_2.5.x86_64.rpm ]]; then
#       cd $workdir/binaries
#       wget http://cent6build1.netwitness.local/~hudson/buildbin/openssl-1.0.0-20.el6_2.5.x86_64.rpm
#       cd $workdir
#   fi  
#   if ! [[ -e $workdir/binaries/MegaCLI && -e $workdir/binaries/menu.c32 && -e $workdir/binaries/isolinux.bin ]] && [[ -e $workdir/binaries/uudecode && -e $workdir/binaries/tr && -e $workdir/binaries/openssl-1.0.0-20.el6_2.5.x86_64.rpm ]] && [[ -e $workdir/binaries/splash.jpg ]]; then
#       echo "required iso binaries missing, exiting"
#       exit 1
#   fi
#fi

# if creating a dvd iso check for NW customizations
if [[ "$isotype" = 'dvd' ]]; then
	rm -f ${isodir}/ks.cfg
	cp ${isocode}/ks.cfg ${isodir} 
	chmod 644 ${isodir}/ks.cfg
fi
#    chmod -f u+w $isodir/isolinux/isolinux.cfg
#    #sed 's/hd:sd[a-z][0-9]/cdrom/g' < "$workdir/el6_upgd_ks/syslinux.cfg" > "$isodir/isolinux/isolinux.cfg"
#    rm -f  "$isodir/isolinux/isolinux.cfg"
#    cp -f "$workdir/rsaimage/nwApplianceImage/el6/ng${saver}/el6_upgd_ks/isolinux.cfg" "$isodir/isolinux/"
#    
#    # add fresh un-modified copy of isolinux.bin
#    cp -f "$workdir/binaries/isolinux.bin" "$isodir/isolinux/"
#    
#    # copy menu.c32 to isolinux directory, removed in CentOS 6.6
#    if ! [[ -e "$isodir/isolinux/menu.c32" ]]; then
#        cp -f "$workdir/binaries/menu.c32" "$isodir/isolinux/" 
#    fi
# 
#    # overwrite splash.jpg 
#    rm -f "$isodir/isolinux/splash.jpg"
#    cp "$workdir/binaries/splash.jpg" "$isodir/isolinux/" 
#    
#    # remove old kickstarts
#    rm -f $isodir/*.ks
#
#    # add kickstarts
#    cd ${kscode}
#    chmod +x *.sh
#    if [ -z $url ]; then
#        # add kickstarts
#	if [[ `echo "$isodir" | grep '^/'` || `echo "$isodir" | grep '^~/'` ]]; then
#            #$workdir/el6_upgd_ks/generateAllKickstarts.sh $isodir cdrom
#            ./generateAllKickstarts.sh $isodir cdrom
#        else
#            #$workdir/el6_upgd_ks/generateAllKickstarts.sh $workdir/$isodir cdrom
#            ./generateAllKickstarts.sh $workdir/$isodir cdrom
#        fi
#    else
#        # generate pxe boot 'default' file from syslinux.cfg
#        echo "$url" > $workdir/url.txt
#	sed 's/\//\\\//g' < $workdir/url.txt > $workdir/url.tmp
#	delimurl=`cat $workdir/url.tmp`
#	sed "s/hd:sd[a-z][0-9]:/$delimurl/g" < "$workdir/nwApplianceImage/el6/ng${saver}/el6_kickstarts/syslinux.cfg" > "$isodir/images/pxeboot/default"
#	# add kickstarts
#	if [[ `echo "$isodir" | grep '^/'` || `echo "$isodir" | grep '^~/'` ]]; then
#            #$workdir/el6_upgd_ks/generateAllKickstarts.sh $workdir/binaries/MegaCLI $isodir $url
#            ./generateAllKickstarts.sh $workdir/binaries/MegaCLI $isodir $url
#        else
#            #$workdir/el6_upgd_ks/generateAllKickstarts.sh $workdir/binaries/MegaCLI $workdir/$isodir $url
#            ./generateAllKickstarts.sh $workdir/binaries/MegaCLI $workdir/$isodir $url
#        fi   
#    fi
#    # add lsi megaraid cli and fips certified openssl packages to install.img
#    cd $isodir/images
#    /usr/sbin/unsquashfs install.img
#    if [ -s $workdir/dvd.hashes.new ]; then 
#        optinstallmd5=`grep 'optinstall.py' $workdir/dvd.hashes.new | awk '{print $2}'`
#        getosdiskmd5=`grep 'getosdisk.py' $workdir/dvd.hashes.new | awk '{print $2}'`
#    fi
#    if ! [[ -s squashfs-root/usr/bin/MegaCLI && -s squashfs-root/usr/bin/uudecode && -s squashfs-root/usr/bin/tr ]] || ! [ -s squashfs-root/rpm/openssl-1.0.0-20.el6_2.5.x86_64.rpm ] || ! [[ -s squashfs-root/usr/bin/optinstall.py && -s $workdir/dvd.hashes.new && `md5sum squashfs-root/usr/bin/optinstall.py | grep "$optinstallmd5"` ]] || ! [[ -s squashfs-root/usr/bin/getosdisk.py && -s $workdir/dvd.hashes.new && `md5sum squashfs-root/usr/bin/getosdisk.py | grep "$getosdiskmd5"` ]]; then
#	if ! [ -s squashfs-root/usr/bin/MegaCLI ]; then
#		cp $workdir/binaries/MegaCLI squashfs-root/usr/bin/
#        	chmod 755 squashfs-root/usr/bin/MegaCLI
#	fi
#	if ! [ -s squashfs-root/usr/bin/uudecode ]; then
#		cp $workdir/binaries/uudecode squashfs-root/usr/bin/
#        	chmod 755 squashfs-root/usr/bin/uudecode
#	fi
#	if ! [ -s squashfs-root/usr/bin/tr ]; then
#		cp $workdir/binaries/tr squashfs-root/usr/bin/
#        	chmod 755 squashfs-root/usr/bin/tr
#	fi
#	if ! [ -s squashfs-root/rpm/openssl-1.0.0-20.el6_2.5.x86_64.rpm ]; then
#            mkdir -p squashfs-root/rpm
#            cp $workdir/binaries/openssl-1.0.0-20.el6_2.5.x86_64.rpm squashfs-root/rpm/
#            chmod 644 squashfs-root/rpm/openssl-1.0.0-20.el6_2.5.x86_64.rpm
#        fi
#	if ! [[ -s squashfs-root/usr/bin/optinstall.py && -s $workdir/dvd.hashes.new && `md5sum squashfs-root/usr/bin/optinstall.py | grep "$optinstallmd5"` ]]; then
#            rm -f squashfs-root/usr/bin/optinstall.py 
#            cp $workdir/rsaimage/nwApplianceImage/el6/ng${saver}/el6_upgd_ks/optinstall.py squashfs-root/usr/bin/
#            chmod 755 squashfs-root/usr/bin/optinstall.py
#        fi
#	if ! [[ -s squashfs-root/usr/bin/getosdisk.py && -s $workdir/dvd.hashes.new && `md5sum squashfs-root/usr/bin/getosdisk.py | grep "$getosdiskmd5"` ]]; then
#            rm -f squashfs-root/usr/bin/getosdisk.py 
#            cp $workdir/rsaimage/nwApplianceImage/el6/ng${saver}/el6_upgd_ks/getosdisk.py squashfs-root/usr/bin/
#            chmod 755 squashfs-root/usr/bin/getosdisk.py
#        fi
#	rm -f install.img
#	sync
#        /sbin/mksquashfs squashfs-root install.img -all-root
#        rm -Rf squashfs-root
#    else
#        rm -Rf squashfs-root
#    fi
#fi

# if creating a usbboot iso check for NW customizations
#if [[ "$isotype" = 'usbboot' ]]; then
#    # get appliance rpm version fom file
#    saverstr=`cat $workdir/nwAppRpmVer`
#    # get sa release
#    getrelease
#    if ! [[ -d "$isodir/syslinux" ]]; then 
#        if [[ -d "$isodir/isolinux" ]]; then
#            mv -f "$isodir/isolinux" "$isodir/syslinux"
#        else
#            echo "$isodir/isolinux directory missing, exiting"
#            exit 1
#        fi
#    fi
#    if ! [[ -e "$isodir/syslinux/vesamenu.c32" ]]; then
#        cp -f "$workdir/binaries/vesamenu.c32" "$isodir/syslinux" 
#    fi
#    cp -f "$workdir/rsaimage/nwApplianceImage/el6/ng${saver}/el6_upgd_ks/syslinux.cfg" "$isodir/syslinux" 
#    
#    # rename menu.c32 so it doesn't conflict with unetbootin's syslinux version
#    if [ -s "$isodir/syslinux/menu.c32" ]; then
#        mv -f "$isodir/syslinux/menu.c32" "$isodir/syslinux/menu.c32.el6"
#    fi 
# 
#    # overwrite splash.jpg and remove isolinux.cfg 
#    rm -f "$isodir/syslinux/splash.jpg"
#    cp "$workdir/binaries/splash.jpg" "$isodir/syslinux/" 
#    rm -f  "$isodir/syslinux/isolinux.cfg"
#    
#    # remove old kickstarts, un-needed files & folders
#    rm -Rf $isodir/repodata $isodir/EFI $isodir/Packages
#    rm -f $isodir/RELEASE-NOTES* $isodir/RPM-GPG-KEY* $isodir/EULA $isodir/GPL $isodir/TRANS.TBL $isodir/CentOS_BuildTag $isodir/.treeinfo $isodir/*.ks
#
#    # add  kickstarts
#    cd ${kscode}
#    chmod +x *.sh
#    if [[ `echo "$isodir" | grep '^/'` || `echo "$isodir" | grep '^~/'` ]]; then
#        #$workdir/el6_upgd_ks/generateAllKickstarts.sh $isodir usb
#        ./generateAllKickstarts.sh $isodir usb
#    else
#        #$workdir/el6_upgd_ks/generateAllKickstarts.sh $workdir/$isodir usb
#        ./generateAllKickstarts.sh $workdir/$isodir usb
#    fi
#    # add lsi megaraid cli and fips certified openssl packages to install.img
#    cd $isodir/images
#    /usr/sbin/unsquashfs install.img
#    if [ -s $workdir/usb.hashes.new ]; then
#        optinstallmd5=`grep 'optinstall.py' $workdir/usb.hashes.new | awk '{print $2}'`
#        getosdiskmd5=`grep 'getosdisk.py' $workdir/dvd.hashes.new | awk '{print $2}'` 
#    fi
#    if ! [[ -s squashfs-root/usr/bin/MegaCLI && -s squashfs-root/usr/bin/uudecode && -s squashfs-root/usr/bin/tr ]] || ! [ -s squashfs-root/rpm/openssl-1.0.0-20.el6_2.5.x86_64.rpm ] || ! [[ -s squashfs-root/usr/bin/optinstall.py && -s $workdir/usb.hashes.new && `md5sum squashfs-root/usr/bin/optinstall.py | grep "$optinstallmd5"` ]] || ! [[ -s squashfs-root/usr/bin/getosdisk.py && -s $workdir/dvd.hashes.new && `md5sum squashfs-root/usr/bin/getosdisk.py | grep "$getosdiskmd5"` ]]; then
#	if ! [ -s squashfs-root/usr/bin/MegaCLI ]; then
#		cp $workdir/binaries/MegaCLI squashfs-root/usr/bin/
#        	chmod 755 squashfs-root/usr/bin/MegaCLI
#	fi
#	if ! [ -s squashfs-root/usr/bin/uudecode ]; then
#		cp $workdir/binaries/uudecode squashfs-root/usr/bin/
#        	chmod 755 squashfs-root/usr/bin/uudecode
#	fi
#	if ! [ -s squashfs-root/usr/bin/tr ]; then
#		cp $workdir/binaries/tr squashfs-root/usr/bin/
#        	chmod 755 squashfs-root/usr/bin/tr
#	fi
#	if ! [ -s squashfs-root/rpm/openssl-1.0.0-20.el6_2.5.x86_64.rpm ]; then
#            mkdir -p squashfs-root/rpm
#            cp $workdir/binaries/openssl-1.0.0-20.el6_2.5.x86_64.rpm squashfs-root/rpm/
#            chmod 644 squashfs-root/rpm/openssl-1.0.0-20.el6_2.5.x86_64.rpm
#        fi
#	if ! [[ -s squashfs-root/usr/bin/optinstall.py && -s $workdir/usb.hashes.new && `md5sum squashfs-root/usr/bin/optinstall.py | grep "$optinstallmd5"` ]]; then
#            rm -f squashfs-root/usr/bin/optinstall.py
#            cp $workdir/rsaimage/nwApplianceImage/el6/ng${saver}/el6_upgd_ks/optinstall.py squashfs-root/usr/bin/
#            chmod 755 squashfs-root/usr/bin/optinstall.py
#        fi
#	if ! [[ -s squashfs-root/usr/bin/getosdisk.py && -s $workdir/dvd.hashes.new && `md5sum squashfs-root/usr/bin/getosdisk.py | grep "$getosdiskmd5"` ]]; then
#            rm -f squashfs-root/usr/bin/getosdisk.py 
#            cp $workdir/rsaimage/nwApplianceImage/el6/ng${saver}/el6_upgd_ks/getosdisk.py squashfs-root/usr/bin/
#            chmod 755 squashfs-root/usr/bin/getosdisk.py
#        fi
#	rm -f install.img
#	sync
#        /sbin/mksquashfs squashfs-root install.img -all-root
#        rm -Rf squashfs-root
#    else
#       	 rm -Rf squashfs-root
#    fi    
#fi

# make iso image
# requires write access to $isodir/isolinux/isolinux.bin 
cd $workdir

# make sure isolinux.bin is writeable
if [[ -d $isodir/isolinux ]]; then
	chmod -f u+w $isodir/isolinux/isolinux.bin
elif [[ -d $isodir/syslinux ]]; then
	chmod -f u+w $isodir/syslinux/isolinux.bin
fi

# make sure all files are world readable for URL installs
chmod -R a+r $isodir

if [[ "$isotype" = 'usbboot' ]]; then
    #setbuildstr   
    # don't create a usbboot iso if creation of the usb iso failed
    if [[ -s rsanw-11.0.0.0-0.1.${buildnum}-usb.iso ]]; then 
        genisoimage -o rsanw-11.0.0.0-0.1.${buildnum}-${isotype}.iso -b syslinux/isolinux.bin -c syslinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -R -J -v -T -joliet-long -V "CentOS 7 x86_64" $isodir
        echo 'getting md5sum of iso ...'
	mymd5sum=`md5sum "rsanw-11.0.0.0-0.1.${buildnum}-${isotype}.iso" | awk '{print $1}'`
	echo '# iso image file manifest' >> "${WORKSPACE}/rsanw-11.0.0.0-0.1.${buildnum}-${isotype}.mf"
	echo "# format: 'file name','md5sum'" >> "${WORKSPACE}/rsanw-11.0.0.0-0.1.${buildnum}-${isotype}.mf"	
	echo "sa-upgrade-${saverstr}.${buildnum}-${isotype}.iso,$mymd5sum" >> "${WORKSPACE}/rsanw-11.0.0.0-0.1.${buildnum}-${isotype}.mf"   
    else
        echo "file rsanw-11.0.0.0-0.1.${buildnum}-usb.iso not found, canceling build of usbboot"
    fi
else
    if [ -z $url ]; then
        genisoimage -o rsanw-11.0.0.0-0.1.${buildnum}-${isotype}.iso -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -R -J -v -T -joliet-long -V "CentOS 7 x86_64" $isodir 
        implantisomd5 rsanw-11.0.0.0-0.1.${buildnum}-${isotype}.iso
        echo 'getting md5sum of iso ...'
	mymd5sum=`md5sum "rsanw-11.0.0.0-0.1.${buildnum}-${isotype}.iso" | awk '{print $1}'`
	echo '# iso image file manifest' >> "${WORKSPACE}/rsanw-11.0.0.0-0.1.${buildnum}-${isotype}.mf"
	echo "# format: 'file name','md5sum'" >> "${WORKSPACE}/rsanw-11.0.0.0-0.1.${buildnum}-${isotype}.mf"	
	echo "sa-upgrade-${saverstr}.${buildnum}-${isotype}.iso,$mymd5sum" >> "${WORKSPACE}/rsanw-11.0.0.0-0.1.${buildnum}-${isotype}.mf"
	# add dvd iso name paramterized trigger 
	if [ ${isotype} = 'dvd' ]; then
		echo "UPSTREAMDVDISO=rsanw-11.0.0.0-0.1.${buildnum}-${isotype}.iso" > ${WORKSPACE}/DVD_ISO.txt
	fi
	for item in "${mflist[@]}"
	do
           echo "$item" >> "${WORKSPACE}/rsanw-11.0.0.0-0.1.${buildnum}-${isotype}.mf"
	done
    else
         genisoimage -o rsanw-11.0.0.0-0.1.${buildnum}-url.iso -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -R -J -v -T -joliet-long -eltorito-alt-boot -V "CentOS 7 x86_64" $isodir
         #genisoimage -o -rsanw-11.0.0.0-0.1.${buildnum}-url.iso -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -R -J -v -T -joliet-long -eltorito-alt-boot -e images/efiboot.img $isodir 
         implantisomd5 rsanw-11.0.0.0-0.1.${buildnum}-url.iso
         	 
    fi
fi
