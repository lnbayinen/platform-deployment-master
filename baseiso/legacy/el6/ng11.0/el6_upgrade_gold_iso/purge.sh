# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# purge.sh
# 
# purpose: remove non gold iso sets older than the last five
#           sucessful builds
#
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#
#!/bin/bash
# 
# define log
MYLOG=purge.log
date >> $MYLOG
declare -a isolist
declare -a isosets
isolist=( `ls -rt /mnt/buildStorage/nw10/iso/${SLUDGEPOST}/sa-upgrade* | grep -v '\.5\.'` )
echo "isolist[] = ${isolist[@]}" >> $MYLOG
let count=0
for item in ${isolist[@]}
do
	myset=$item
	myset=${myset%-*}
	myset=${myset##*\.}
	#echo "myset = $myset"
	if [ $count -eq 0 ] || ! [[ `echo ${isosets[$count-1]} | grep "$myset"` ]]; then 
		isosets[$count]=$myset
		let count=$count+1
	else
		continue
	fi
done
echo "isosets[] = ${isosets[@]}" | tee -a  $MYLOG
let setsize=${#isosets[@]}
# purge old iso sets
if [ $setsize -gt 5 ]; then
	let setsize=$setsize-5
	saveset=${isosets[$setsize]}
	#echo "saveset = $saveset"
	for item in ${isosets[@]}
	do
		if ! [ `echo $item | grep "$saveset"` ]; then
			echo "deleting old iso artifacts: /mnt/buildStorage/nw10/iso/${SLUDGEPOST}/sa-upgrade*\.$item-*" | tee -a $MYLOG
			rm -f /mnt/buildStorage/nw10/iso/${SLUDGEPOST}/sa-upgrade*\.${item}-*
		else
			break
		fi
	done
fi
