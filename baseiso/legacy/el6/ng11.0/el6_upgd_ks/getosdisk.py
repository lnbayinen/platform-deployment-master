#!/usr/bin/python

import curses, curses.ascii, re, os, sys


# ^^^^^^^^^^^^^^^^^^^ function defs  ^^^^^^^^^^^^^^^^^^^^^^^^ 

def getosdisk( ):
	"display detected block devices and get user selection"

	diskfile = '/tmp/osdisk.txt'
	fhand = open( diskfile, 'r' )
	disklist = fhand.readlines( )
	fhand.close( )
	
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
	stdscr.addstr( 1, 6, 'Please select a Single Disk for OS installation' )
	stdscr.addstr( 2, 3, '*Warning* The selected disk will be overwritten' )
	stdscr.addstr( 3, 3, 'Navigation Keys: <Tab> move, <Space> select' )
	stdscr.addstr( 4, 3, '<D> de-select, <S> save, <T> terminate install' )

	# get size of parameter list
	lenargs = len( disklist )
	
	minrow = 5 
	maxrow = lenargs / 2 + minrow 
	scrminrow = stdscr.getbegyx()
	scrmaxrow = stdscr.getmaxyx()
	startrow = scrminrow[0]
	numrows = scrmaxrow[0]
	lastrow = numrows - startrow
        if ( maxrow >= lastrow ):
            maxrow = lastrow - 1 
	myrow = minrow 
	count = 0 
	while ( count < lenargs ) and ( myrow < lastrow - 1 ):
		mystr = '( ) ' + disklist[ count ].rstrip() + ' ' + disklist[ count + 1 ].rstrip()
		stdscr.addstr( myrow, 2, mystr )
		myrow = myrow + 1
		count = count + 2
	c = ''
	stdscr.move( minrow, 3 )
	ypos = minrow 
	curses.noecho()
	# ! <S>|<s>
	while ( c != 83  ) or ( c != 115 ): 
		mytup = stdscr.getyx()
		c = stdscr.getch()
		# <T>|<t> terminate installation
		if ( c == 84  ) or ( c == 116 ):
			curses.endwin( )
			os.system( '/sbin/reboot' )
		# <space> select
		elif ( c == 32 ):
			#curses.echo( )
			if ( mytup[0] < lastrow - 1 and mytup[1] == 3 ):
				stdscr.addch( mytup[0], mytup[1], 88 )
				stdscr.move( ypos, 3 )
				currow = ypos 
				if ( minrow != maxrow - 1 ):
					irow = minrow
					stdscr.move( irow, 3 )
					while ( irow < maxrow ):
						if ( irow != currow ):
							stdscr.addch( irow, 3, 32 )
						irow = irow + 1
				stdscr.move( ypos, 3 )
				stdscr.refresh( )
		# <D>|<d> de-select
		elif ( c == 68 ) or ( c == 100 ):
			stdscr.addch( ypos, 3, 32 )
			stdscr.move( ypos, 3 )
			stdscr.refresh()
		# <tab> move vertically
		elif ( c == 9 ):
			ypos = ypos + 1
			if ( ypos < maxrow ):
				stdscr.move( ypos, 3 )
			else:
				ypos = minrow
				stdscr.move( ypos, 3 )	
		# <S>|<s> save
		elif ( c == 83 ) or ( c == 115 ):
			ycount = minrow 
			osdisk = [ ]
			diskstr = ''
			disksubstr = [ ]
			while ( ycount <= maxrow ):
				d = stdscr.inch( ycount, 3 )
				# remove screen attributes
				d = curses.ascii.ascii( d )
				if ( d != 88 ): 
					ycount = ycount + 1 
					continue 
				else:
					diskstr = stdscr.instr( )
					#diskstr = curses.ascii.ascii( diskstr )
					disksubstr = diskstr.split( )
					for substr in disksubstr:
						if re.search( '\/dev\/', substr ):
							stripi = substr.rindex( '/' )
							osdisk.extend( [ substr[ stripi + 1: ] ] )
				ycount = ycount + 1
			stdscr.move( minrow, 3 )
			ypos = minrow
			if ( len( osdisk ) == 1 ):
				break 
	curses.endwin( )
	# add user selected OS disk to /tmp/partdisk.txt 
	fhand = open( '/tmp/partdisk.txt', 'w' )
	fhand.write( osdisk[0] )
	fhand.close( )
getosdisk()

