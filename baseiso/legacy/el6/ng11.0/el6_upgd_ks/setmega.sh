#!/bin/bash
kickstarts=( `ls -A *.ks.sh` )
for file in ${kickstarts[@]}
do 
	echo "$file" 
	if [[ `grep -E '^[[:space:]]*writePackageList.*MegaCli-[0-9].*' $file` ]]; then 
		oldstr=`grep -E '^[[:space:]]*writePackageList.*MegaCli-[0-9].*' $file`
		echo "$oldstr"
		packagestr=( `grep -E -h '^[[:space:]]*writePackageList.*MegaCli-[0-9].*' $file` )
		newstr=''
		for item in ${packagestr[@]}
		do 
			if [[ `echo $item | grep 'MegaCli'` || `echo $item | grep 'Lib_Utils'` ]]; then
				continue
			else	
				if [[ $newstr ]]; then
					newstr="$newstr $item"
				else
					newstr="$item"
				fi
			fi 
		done
	newstr="$newstr Lib_Utils-1.00-09 MegaCli-8.02.21-1"
	echo "	$newstr"
	fi
	sed "s/\(^[[:space:]]*\)writePackageList.*/\1$newstr/" < $file > $file.tmp
	mv -f $file.tmp $file
done
