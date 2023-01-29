# (for Emacs) -*- indented-text -*-

# this file `demo.bas' demonstrates the features of zmakebas
# (basically just the escape sequences), and gives you an example of
# what the input can look like if you use all the bells and whistles. :-)
#
# See `demolbl.bas' for a label-using version.

# Machine code test. The codes 1 and 201 should not get translated by the ASCII
# to ZX81 character mapping, but if it is mis-applied, then the two bytes in-
# between may get changed.

    rem MACHINE CODE:\{1}\{40}\{65}\{201}

	rem zmakebas demo

# tabs (as below) are fine (they're removed)
#	let HEADER=	2000
#	let BLOCKDEM=4000
#   let OTHER   =4500
#   let MCTEST  =5000

	gosub @header
	gosub @blockdem
    gosub @other
	gosub @mctest
	stop

# init

# [ deleted ]

@header:

	print "\..\..\..\..\..\..\..\..\..\..\..\..\..\..\..\..";\
	         "\..\..\..\..\..\..\..\..\..\..\..\..\..\..\.."
	print "  NON-ASCII CHARS IN ZMAKEBAS  "
	print "\''\''\''\''\''\''\''\''\''\''\''\''\''\''\''\''";\
	         "\''\''\''\''\''\''\''\''\''\''\''\''\''\''\''"
	return

@blockdem:

#                   01234567890123456789012345678901
	print "THE BLOCK GRAPHICS, FIRST AS ";\
		   "LISTED BY A FOR..NEXT LOOP, THEN ";\
		   "VIA ZMAKEBAS\"S ESCAPE SEQUENCES:"
	print
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
	print "\   \'  \ ' \'' \.  \:  \.' \:' \!: \!. \!'",,, \
		   TAB 0; "\:: \.: \:. \.. \': \ : \'. \ . \|: \|. \|'"
	return

# Other escapes or characers

@other:
    print
    print "DOUBLE-BACKSLASH FOR POUND : \\"
    print "BACKSLASH-AT FOR INV. POUND: \@"
    print "BACKTICK FOR QUOTE IMAGE   : `"
    print
    return

@mctest:

    let REF=65*256+40
    print "MC RESULT SHOULD BE "; REF;"."
    let MC= usr 16527
    print "THE MC RESULT IS ";MC;"."
    print "ESCAPE CODE TEST ";
    if MC<>REF then print "FAIL."
    if MC=REF then print "PASS."
    return
