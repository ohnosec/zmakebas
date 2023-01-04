# (for Emacs) -*- indented-text -*-

# this file `demo.bas' demonstrates the features of zmakebas
# (basically just the escape sequences), and gives you an example of
# what the input can look like if you use all the bells and whistles. :-)
#
# See `demolbl.bas' for a label-using version.


	rem zmakebas demo

# tabs (as below) are fine (they're removed)
#	let HEADER=	2000
#	let BLOCKDEM=4000

	gosub @header
	gosub @blockdem
	stop

# init

# [ deleted ]

@header:

	print "\..\..\..\..\..\..\..\..\..\..\..\..\..\..\..\..";\
	         "\..\..\..\..\..\..\..\..\..\..\..\..\..\..\.."
	print "  NON-ASCII CHARS IN ZMAKEBAS  "
	print "\''\''\''\''\''\''\''\''\''\''\''\''\''\''\''\''";\
	         "\''\''\''\''\''\''\''\''\''\''\''\''\''\''\''"
	print
	return

@blockdem:

#                   01234567890123456789012345678901
	print at 9,0;"THE BLOCK GRAPHICS, FIRST AS ";\
		   "LISTED BY A FOR..NEXT LOOP, THEN ";\
		   "VIA ZMAKEBAS\"S ESCAPE SEQUENCES:"
	print at 13,0;
	for F=0 to 10
	print chr$(F);" ";
	next F
	print
	print
	for F=128 to 138
	print chr$(F);" ";
	next F
	print
	print
	print at 17,0;"\   \'  \ ' \'' \.  \:  \.' \:' \!: \!. \!'",,, \
		   TAB 0; "\:: \.: \:. \.. \': \ : \'. \ . \|: \|. \|'"
	return
