#!/usr/bin/python

import curses, curses.ascii, re, os, sys


# ^^^^^^^^^^^^^^^^^^^ function defs  ^^^^^^^^^^^^^^^^^^^^^^^^

def userstring( packstr ):
	"translate package name strings into user friendly descriptor strings"
	if ( packstr == "nwarchiver" ):
		packdesc = 'Archiver'
		return packdesc
	elif ( packstr == "nwbroker" ):
		packdesc = 'Broker'
		return packdesc		 
	elif ( packstr == "nwconcentrator" ):
		packdesc = 'Concentrator'
		return packdesc
	elif ( packstr == "nwipdbextractor" ):
		packdesc = 'IPDB Extractor'
		return packdesc
	elif ( packstr == "nwlogcollector" ):
		packdesc = 'Log Collector'
		return packdesc
	elif ( packstr == "nwlogdecoder" ):
		packdesc = 'Log Decoder'
		return packdesc
	elif ( packstr == "nwdecoder" ):
		packdesc = 'Packet Decoder'
		return packdesc
	elif ( packstr == "rsaMalwareDevice" ):
		packdesc = 'Malware Analysis Server - incompatible with SA Server'
		return packdesc
	elif ( packstr == "rsaMalwareDeviceCoLo" ):
		packdesc = 'Malware Analysis Colocated'
		return packdesc
	elif ( packstr == "nwworkbench" ):
		packdesc = "WorkBench"
		return packdesc
	elif ( packstr == "nwwarehouseconnector" ):
		packdesc = "Warehouse Connector"
		return packdesc
	elif ( packstr == "rsa-esa-server" ):
		packdesc = "Event Stream Analytics Server - incompatible with SA Server"
		return packdesc
	elif ( packstr == "rsa-security-analytics-web-server" ):
		packdesc = "Security Analytics Server - incompatible with ESA/MA Server"
		return packdesc
	else:
		packdesc = "invalid parameter: "
		if not ( len(packstr) == 0 ):
			packdesc = packdesc + packstr
		else:
			packdesc = packdesc + 'null'
	return packdesc

def getapps( ):
	"display python curses optional package install menu and get user selections"

	# initialize curses screen
	stdscr = curses.initscr()
	
	# bold white on blue, if color tty
	if ( curses.has_colors() ):
		curses.start_color()
		curses.init_pair(1, curses.COLOR_WHITE, curses.COLOR_BLUE)
		stdscr.bkgd( 32, curses.color_pair(1))
		stdscr.attron( curses.A_BOLD )
		stdscr.refresh()
	
	stdscr.border()
	stdscr.refresh()	
	
	# print titles
	stdscr.addstr( 1, 10, 'RSA Security Analytics Optional Software Menu' )
	stdscr.addstr( 3, 3, 'Select additional SA components for installation' )
	stdscr.addstr( 4, 3, 'Please review the installation guide for menu help' )
	stdscr.addstr( 6, 3, 'Navigation Keys:' )
	stdscr.addstr( 7, 3, '<Tab> move, <Space> select, <D> de-select, <S> save' )
	stdscr.addstr( 8, 3, '<Q> quit without saving, <T> terminate installation' )

	# get size of parameter list
	lenargs = len( sys.argv )
	minrow = 10
	maxrow = lenargs - 2 + minrow 
	scrminrow = stdscr.getbegyx()
	scrmaxrow = stdscr.getmaxyx()
	startrow = scrminrow[1]
	numrows = scrmaxrow[1]
	lastrow = numrows - startrow
	# allow for border
	#lastrow = lastrow - 1

	# print optional package selections
	myrow = minrow 
	count = 1
	while ( count < lenargs ):
		mysw = userstring( sys.argv[count] )
		mystr = '( ) ' + mysw 
		stdscr.addstr( myrow, 2, mystr )
                myrow = myrow + 1
		count = count + 1
	c = ''
	stdscr.move( minrow, 3 )
	ypos = minrow 
	curses.noecho()
	while ( c != 81  ) or ( c != 113 ): 
		mytup = stdscr.getyx()
		c = stdscr.getch()
		# <Q>|<q> quit without saving
		if ( c == 81  ) or ( c == 113 ):
			curses.endwin( )
			sys.exit(0)
		# <T>|<t> terminate installation
		if ( c == 84  ) or ( c == 116 ):
			curses.endwin( )
			os.system( '/sbin/reboot' )
		# <space> select
		elif ( c == 32 ):
			#curses.echo( )
			if ( mytup[0] < lastrow and mytup[1] == 3 ):
				stdscr.addch( mytup[0], mytup[1], 88 )
				stdscr.move( ypos, 3 )
				stdscr.refresh( )
		# <D>|<d> de-select
		elif ( c == 68 ) or ( c == 100 ):
			stdscr.addch( ypos, 3, 32 )
			stdscr.move( ypos, 3 )
			stdscr.refresh()
		# <tab> move vertically
		elif ( c == 9 ):
			if ( ypos < maxrow ):
				ypos = ypos + 1	
				stdscr.move( ypos, 3 )
			else:
				ypos = minrow
				stdscr.move( ypos, 3 )	
		# <S>|<s> save
		elif ( c == 83 ) or ( c == 115 ):
			count = 1
			ycount = minrow 
			swlist = [ ]
			while ( ycount <= maxrow ):
				d = stdscr.inch( ycount, 3 )
				# remove screen attributes
				d = curses.ascii.ascii( d )
				if ( d != 88 ): 
					ycount = ycount + 1
					count = count + 1 
					continue 
				else:
					mydesc = userstring( sys.argv[count] )
					if ( re.search( 'invalid\sparameter:', mydesc )):
						swlist.append( '#' + mydesc )					
					elif ( sys.argv[count] == 'nwarchiver' ): 
						swlist.append( '@rsa-sa-archiver' )
					elif ( sys.argv[count] == 'nwbroker' ): 
						swlist.append( '@rsa-sa-broker' )				
					elif ( sys.argv[count] == 'nwconcentrator' ): 
						swlist.append( '@rsa-sa-concentrator' )				
					elif ( sys.argv[count] == 'nwipdbextractor' ): 
						swlist.append( '@rsa-sa-remote-ipdbextractor' )
					elif ( sys.argv[count] == 'nwdecoder' ): 
						swlist.append( '@rsa-sa-packet-decoder' )
					elif ( sys.argv[count] == 'nwlogcollector' ): 
						swlist.append( '-@rsa-sa-remote-logcollector' )
					elif ( sys.argv[count] == 'nwlogdecoder' ): 
						swlist.append( '@rsa-sa-log-decoder' )				
					elif ( sys.argv[count] == 'rsaMalwareDevice' ): 
						swlist.append( '@rsa-sa-malware-analysis' )
					elif ( sys.argv[count] == 'rsaMalwareDeviceCoLo' ): 
						swlist.append( '@rsa-sa-malware-analysis-colocated' )
					elif ( sys.argv[count] == 'rsa-esa-server' ): 
						swlist.append( '@rsa-sa-esa-server' )
					elif ( sys.argv[count] == 'nwwarehouseconnector' ): 
						swlist.append( '-@rsa-sa-warehouse-connector' )
					elif ( sys.argv[count] == 'rsa-security-analytics-web-server' ): 
						swlist.append( '@rsa-sa-server' )
					else:
						swlist.append(sys.argv[count])
				ycount = ycount + 1
				count = count + 1
			break 
	curses.endwin( )
	#print "swlist[] = ", swlist
	# add optional package selections to /tmp/nwpack.txt 
	lenswlist = len( swlist )
	if ( lenswlist > 0 ):
		fpacks = open( '/tmp/nwpack.txt', 'a' )
		for item in swlist:
			fpacks.write( item + '\n' )
		fpacks.close( )
getapps()

