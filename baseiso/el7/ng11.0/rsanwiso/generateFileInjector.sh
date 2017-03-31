#!/bin/bash


function generateFileInjector
{
	# debug
	#echo "\$1 = $1" >&2
	local fname=$(basename $1)
	#local fname=`basename $1`
	local encoder="uuencode -m"
	local decoder=/tmp/uudecode
	if [ "$2" == "base64" ]
	then
		encoder=base64
		decoder="base64 -d"
	fi
	# generate function code
	echo -n "function extract$fname
{
	echo '"
	# insert uuencoded data
	bzip2 -c < $1 | ${encoder}  -
	echo "' | ${decoder} | bzip2 -dc
}"
}


