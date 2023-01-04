# (for Emacs) -*- indented-text -*-

# this file `demo.bas' demonstrates the features of zmakebas
# (basically just the escape sequences), and gives you an example of
# what the input can look like if you use all the bells and whistles. :-)
#
# See `demolbl.bas' for a label-using version.


10 rem zmakebas demo

# tabs (as below) are fine (they're removed)
20 let HEADER=	2000
25 let BLOCKDEM=4000

40 gosub HEADER
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
4000 print at 11,0;"THE BLOCK GRAPHICS, FIRST AS ";\
		   "LISTED BY A FOR..NEXT LOOP, THEN ";\
		   "VIA ZMAKEBAS\"S ESCAPE SEQUENCES:"
4020 print at 15,0;
4030 for F=128 to 143
4031 print chr$(F);" ";
4032 next F
4034 print
4035 print
4040 print at 17,0;"\   \ ' \'  \'' \ . \ : \'. \': ";\
		   "\.  \.' \:  \:' \.. \.: \:. \::"
4130 return
