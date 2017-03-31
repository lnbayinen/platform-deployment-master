#!/bin/bash

function generateAllKickstarts
{
	if [[ -z $1 || -z $2 ]]; then
		echo -e 'missing required parameters, exiting\nusage: ./generateAllKickstarts <target path> <install type: usb | cdrom | url>'
		exit 1
	fi 
	
	local generator
	local output=$1
	local type=$2
	local suffix=$3
	
	for generator in generate*.ks.sh
	do
		# debug
		#echo "file = $generator" >&2
		local generated_sh=${generator/generate_}
		local generated=${generated_sh/.sh}
		if ! ./$generator $type > $1/${generated}$suffix
		then
			echo "$generator failed" >&2
			return 1
		fi
		
	done
	
	return 0
}

generateAllKickstarts "$@"
