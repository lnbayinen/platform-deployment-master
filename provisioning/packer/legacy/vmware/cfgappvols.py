#!/usr/bin/env python
#
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#   script: cfgappvols.py 
#
#  purpose: creates or extends application storage 
#           logical volumes on user selected disks
#          
# requires: gparted and lsblk packages
#
#     todo:
#
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#
#
import os, re, subprocess, sys, time, logging, curses, curses.ascii, glob

# ^^^^^^^^^^^^^^^^ const defs ^^^^^^^^^^^^^^^^
mylog = 'cfgappvols.py.log' 

# ^^^^^^^^^^^^^^^^ func defs ^^^^^^^^^^^^^^^^^^

def popencmd( cmdstr, rtntype = 'integer', shellbool = False, splitstr = True, pqueue = '' ):
        "try executing subprocess.Popen command, return result"

        if ( splitstr ):
                mycmdlist = cmdstr.split( )
                try:
                        myproc = subprocess.Popen( mycmdlist, shell=shellbool, stderr=subprocess.PIPE, stdout=subprocess.PIPE )
                        mytup = myproc.communicate( )
                except StandardError, OSError:
                        logging.warn( 'subprocess.Popen command: %s, return type: %s, shell=%s, return code: %s, command output/error:\n(CMD_OUT): %s\n(CMD_ERR): %s', mycmdlist, rtntype, shellbool, myproc.returncode, mytup[0], mytup[1] )
                        if ( pqueue ):
                                pqueue.put( [ myproc.returncode, mytup ] )
                                #pqueue.close( )
                                return
                        if ( rtntype == 'integer' ):
                                return 13 
                        else:
                                return ( Error, Error )
                else:
                        logging.info( 'subprocess.Popen command: %s, return type: %s, shell=%s, return code: %s, command output/error:\n(CMD_OUT): %s\n(CMD_ERR): %s', mycmdlist, rtntype, shellbool, myproc.returncode, mytup[0], mytup[1] )
                        if ( pqueue ):
                                pqueue.put( [ myproc.returncode, mytup ] )
                                #pqueue.close( )
                                return
                        if ( rtntype == 'integer' ):
                                return myproc.returncode
                        else:
                                return mytup
        else:
                try:
                        myproc = subprocess.Popen( cmdstr, shell=shellbool, stderr=subprocess.PIPE, stdout=subprocess.PIPE )
                        mytup = myproc.communicate( )
                except StandardError, OSError:
                        logging.warn( 'subprocess.Popen command: %s, return type: %s, shell=%s, return code: %s, command output/error:\n(CMD_OUT): %s\n(CMD_ERR): %s', mycmdlist, rtntype, shellbool, myproc.returncode, mytup[0], mytup[1] )
                        if ( pqueue ):
                                pqueue.put( [ myproc.returncode, mytup ] )
                                #pqueue.close( )
                                return
                        if ( rtntype == 'integer' ):
                                return 13
                        else:
                                return ( Error, Error )
                else:
                        logging.info( 'subprocess.Popen command: %s, return type: %s, shell=%s, return code: %s, command output/error:\n(CMD_OUT): %s\n(CMD_ERR): %s', mycmdlist, rtntype, shellbool, myproc.returncode, mytup[0], mytup[1] )
                        if ( pqueue ):
                                pqueue.put( [ myproc.returncode, mytup ] )
                                #pqueue.close( )
                                return
                        if ( rtntype == 'integer' ):
                                return myproc.returncode
                        else:
                                return mytup

def getblockdev( ): 
	"create a text file containing usable block devices"
	diskfile = '/root/osdisk.txt'
        fhand = open( diskfile, 'w' )
	mycmd = 'lsblk -adn'
	blkdev = []
	mytup = popencmd( mycmd, 'tup' )
	#print mytup[0] 
	blkdev = mytup[0].split('\n')
	#print blkdev[:]	
	for item in blkdev:
		if ( re.search( 'disk', item )):
			#print 'item =',item,'\n'
			blkstats = item.split()
			print 'device =',blkstats[0]
			# check for missing disk labels, create gpt by default
			mycmd = 'parted /dev/' + blkstats[0] + ' -s print'
			mytup = popencmd( mycmd, 'tup' )
			#print mytup[0]
			# check for missing disk labels, create gpt by default
			if ( re.search( 'Error: /dev/' + blkstats[0] + ': unrecognised disk label', mytup[0] )):
				print 'in no partition table'
				mycmd = 'parted /dev/' + blkstats[0] + ' -s mklabel gpt'
				myrtn = popencmd( mycmd )
				mycmd = 'parted /dev/' + blkstats[0] + ' -s unit GB print'
				mytup = popencmd( mycmd, 'True' )
				print 'mytup[0]=\n',mytup[0],'\nendmytup[0]'
				mysearch = re.search( 'Disk.*', mytup[0], flags=0 )
				mysearch2 = re.search( 'Model.*', mytup[0], flags=0 )
				#print 'mysearch = ',mysearch.group(  )
				#print 'mysearch2 = ',mysearch2.group(  )
				fhand.write( mysearch.group( ) + '\n' )
				fhand.write( mysearch2.group( ) + '\n' )
				print 'adding ',blkstats[0]
				continue
				
			# check for partitions
			if ( os.path.exists( '/sys/block/' + blkstats[0] + '/' + blkstats[0] + '1' )):
				print 'in path exists'
				# get freespace in sectors, convert to mb
				mycmd = 'parted /dev/' + blkstats[0] + ' -s unit s print free'
				mytup = popencmd( mycmd, 'tup' )
				myfree = []
				myfree = mytup[0].split( '\n' )
				for item in myfree:
					if ( re.search( 'Free Space', item )):
						myfreestats = item.split()
						freemb = myfreestats[2]
						freemb = freemb.rstrip( 's' )
						if not ( int( freemb ) % 2 == 0 ):
							freemb = int( freemb ) - 1
						freemb = int( freemb ) / 2 / 1024
						if ( int( freemb ) >= 1024 ):
							mycmd = 'parted /dev/' + blkstats[0] + ' -s unit GB print'
							mytup = popencmd( mycmd, 'True' )
							#print 'mytup[0]=\n',mytup[0],'\nendmytup[0]'
							mysearch = re.search( 'Disk.*', mytup[0], flags=0 )
							mysearch2 = re.search( 'Model.*', mytup[0], flags=0 )
							#print 'mysearch = ',mysearch.group(  )
							#print 'mysearch2 = ',mysearch2.group(  )
							fhand.write( mysearch.group( ) + '\n' )
							fhand.write( mysearch2.group( ) + '\n' )		
							print 'adding disk:', blkstats[0]
							continue
					
			else:
				# check for lvm pv metadata
				mytup = popencmd( 'pvscan', 'tup' )
				if ( re.search( '/dev/' + blkstats[0], mytup[0] )):
					continue
				else:
					mycmd = 'parted /dev/' + blkstats[0] + ' -s unit GB print'
					mytup = popencmd( mycmd, 'True' )
					#print 'mytup[0]=\n',mytup[0],'\nendmytup[0]'
					mysearch = re.search( 'Disk.*', mytup[0], flags=0 )
					mysearch2 = re.search( 'Model.*', mytup[0], flags=0 )
					#print 'mysearch = ',mysearch.group(  )
					#print 'mysearch2 = ',mysearch2.group(  )
					fhand.write( mysearch.group( ) + '\n' )
					fhand.write( mysearch2.group( ) + '\n' )
					print 'adding: /dev/', blkstats[0]
					continue
	fhand.close( )	

def getappliancetype():
	"return a string describing the netwitness appliance type"
	mytup = popencmd( 'rpm -qa', 'tup' )
	#print mytup[0]
	if  ( re.search( 'nwarchiver', mytup[0] )):
		return 'archiver'
	elif ( re.search( 'nwbroker', mytup[0] )) and not ( re.search( 'security-analytics-web-server', mytup[0] )) and not ( re.search( 'rsaMalwareDevice', mytup[0] )):
		return 'broker'
	elif ( re.search( 'nwconcentrator', mytup[0] )) and not ( re.search( 'nwdecoder', mytup[0] )) and not ( re.search( 'nwlogdecoder', mytup[0] )):
		return 'concentrator'
	elif ( re.search( 'nwdecoder', mytup[0] )) and not ( re.search( 'nwconcentrator', mytup[0] )):
		return 'decoder'
	elif  ( re.search( 'rsa-esa-server', mytup[0] )):
		return 'esa'
	elif ( re.search( 'nwipdbextractor', mytup[0] )) and not ( re.search( 'security-analytics-web-server', mytup[0] )):
		return 'ipdbextractor'
	elif ( re.search( 'nwlogcollector', mytup[0] )) and not ( re.search( 'nwlogdecoder', mytup[0] )):
		return 'logcollector'
	elif ( re.search( 'nwlogdecoder', mytup[0] )) and not ( re.search( 'nwlogcollector', mytup[0] )):
		return 'logdecoder'
	elif ( re.search( 'rsaMalwareDevice', mytup[0] )):
		return 'malwareanalytics'
	elif ( re.search( 'security-analytics-web-server', mytup[0] )):
		return 'saserver'
	elif ( re.search( 'nwwarehouseconnector', mytup[0] )) and not ( re.search( 'nwdecoder', mytup[0] )) and not ( re.search( 'nwlogdecoder', mytup[0] )):
		return 'warehouseconnector'
		
def getosdisk( ):                                                                                                                                                                                                                                                              
        "display detected block devices and get user selection"                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                               
        diskfile = '/root/osdisk.txt'
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
        stdscr.addstr( 1, 6, 'Please select Disk(s) for application storage' )
        stdscr.addstr( 2, 3, '*Warning* All free space on the selected Disk(s) will be utilized' )
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
			sys.exit( 0 )
                # <space> select
                elif ( c == 32 ):
                        #curses.echo( )
                        if ( mytup[0] < lastrow - 1 and mytup[1] == 3 ):
                                stdscr.addch( mytup[0], mytup[1], 88 )
                                stdscr.move( ypos, 3 )
                                currow = ypos 
                                #if ( minrow != maxrow - 1 ):
                                #        irow = minrow
                                #        stdscr.move( irow, 3 )
                                #        while ( irow < maxrow ):
                                #                if ( irow != currow ):
                                #                        stdscr.addch( irow, 3, 32 )
                                #                irow = irow + 1
                                #stdscr.move( ypos, 3 )
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
                        if ( len( osdisk ) > 0 ):
                                break 
        curses.endwin( )
        # add user selected OS disks to /tmp/partdisk.txt 
        fhand = open( '/root/partdisk.txt', 'w' )
        for item in osdisk:
		fhand.write( item.rstrip( ':' ) + '\n' )
        fhand.close( )

def agumentappstoage ( ):
	"create or extend and mount application logical volumes"
	
	myapptype = ''	
	createvg = False
	
	# check for existing application storage volume group: VolGroup01
	mycmd = 'vgs --all --noheadings -o vg_name'
	mytup = popencmd( mycmd, 'tup' )
	if not ( re.search( 'VolGroup01', mytup[0] )):
		createvg = True
	
	# read in user selected block devices
	fhand = open( '/root/partdisk.txt', 'r' )
	mydisks = fhand.readlines( )
	fhand.close( )	
	for item in  mydisks:
		# check for partitions
		item = item.rstrip( )
		mycmd = 'echo 1 > /sys/block/' + item + '/device/rescan'
		myrtn = popencmd( mycmd, 'integer', True )		
		print '/sys/block/' + item + '/' + item + '1'
		if ( os.path.exists( '/sys/block/' + item + '/' + item + '1' )):
			# get start of free space		
			print 'in got parts'
			numparts = len( glob.glob( '/sys/block/' + item + '/' + item + '[1-9]' ) )
			mycmd = 'parted /dev/' + item + ' -s unit mb print'
			mytup = popencmd( mycmd, 'tup' )
			print mytup[0]
			diskstats = mytup[0].split( '\n' )
			for mystat in diskstats:
				if ( re.search( '^\s*' + str( numparts ) + '\s* ', mystat )):
					myparts = mystat.split( )
					partend = myparts[2]
					mycmd = 'parted /dev/' + item + ' -s make part primary ext2 ' + partend + ' 100%' 									
					print 'mycmd =',mycmd


# ^^^^^^^^^^^^^^^ main ^^^^^^^^^^^^^^
getblockdev()
mystr = getappliancetype()
print 'i am a', mystr
getosdisk( )
agumentappstoage ( )
#mytup = popencmd( 'lsblk -d \| grep disk', 'tup', 'True' )
#print mytup[0]
