#!/usr/bin/python

import sys, re

centcomp = sys.argv[1]

rsacomp = sys.argv[2]

fh = open( centcomp, 'r' )

oemlist = fh.readlines()

fh.close()

fh = open( rsacomp, 'r' )

ourlist = fh.readlines()

fh.close

oemsize = len( oemlist )

oursize = len( ourlist )

count = 0
while ( count < oursize ):
	if ( re.search( '<comps>', ourlist[count] )):
		startprint = count + 1
	elif ( re.search( '</comps>', ourlist[count] )): 
		endprint = count - 1
	count = count + 1

fh = open( 'comps.xml', 'w' )
count = 0
insert = False
while ( count < oemsize ):
	if ( re.search( '<comps>', oemlist[count] )):
		fh.write( oemlist[count] )
		count = count + 1
		insert = True

	if ( insert ):
		fh.write( '<!-- Begin RSA Groups Insert -->\n' )
		while ( startprint <= endprint ):
			fh.write( ourlist[startprint] )
			startprint = startprint + 1
		fh.write( '<!-- End RSA Groups Insert -->\n' )
		insert = False 
	
	if ( not insert ):
		fh.write( oemlist[count] ) 

	count = count + 1

fh.close()
