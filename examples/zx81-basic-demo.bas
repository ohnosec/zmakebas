# (for Emacs) -*- indented-text -*-

# this file `demo.bas' demonstrates the features of zmakebas
# (basically just the escape sequences), and gives you an example of
# what the input can look like if you use all the bells and whistles. :-)
#
# See `demolbl.bas' for a label-using version.

# Machine code test. The codes 1 and 201 should not get translated by the ASCII
# to ZX81 character mapping, but if it is mis-applied, then the two bytes in-
# between may get changed.

1 REM MACHINE CODE:\{1}\{40}\{65}\{201}

10 rem zmakebas demo

# tabs (as below) are fine (they're removed)
20 let HEADER=	2000
25 let BLOCKDEM=4000
30 let MCTEST  =5000

40 gosub HEADER
50 gosub MCTEST
60 gosub BLOCKDEM
70 stop

# init

# [ deleted ]

# header

2000 print "\..\..\..\..\..\..\..\..\..\..\..\..\..\..\..\..";\
	         "\..\..\..\..\..\..\..\..\..\..\..\..\..\..\.."
2010 print "  NON-ASCII CHARS IN ZMAKEBAS  "
2020 print "\''\''\''\''\''\''\''\''\''\''\''\''\''\''\''\''";\
	         "\''\''\''\''\''\''\''\''\''\''\''\''\''\''\''"
2030 print
2040 return

# blockdem

#                   01234567890123456789012345678901
4000 print at 9,0;"THE BLOCK GRAPHICS, FIRST AS ";\
		   "LISTED BY A FOR..NEXT LOOP, THEN ";\
		   "VIA ZMAKEBAS\"S ESCAPE SEQUENCES:"
4020 print at 13,0;
4030 for F=0 to 10
4040 print chr$(F);" ";
4050 next F
4060 print
4070 print
4080 print at 15,0;
4090 for F=128 to 138
4100 print chr$(F);" ";
4110 next F
4120 print
4130 print
4140 print at 17,0;"\   \'  \ ' \'' \.  \:  \.' \:' \!: \!. \!'",,, \
		   TAB 0; "\:: \.: \:. \.. \': \ : \'. \ . \|: \|. \|'"
4150 return

5010 let REF=65*256+40
5020 print "MC RESULT SHOULD BE "; REF;"."
5030 let MC= usr 16527
5040 print "THE MC RESULT IS ";MC;"."
5050 print "ESCAPE CODE TEST ";
5060 if MC<>REF then print "FAIL."
5070 if MC=REF then print "PASS."
5080 return
