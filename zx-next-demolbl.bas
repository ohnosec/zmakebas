	rem zmakebas demo for zx spectrum next

# Prevent screensaver from launching
	SPECTRUM SCREEN$ 0,0

# See manual p226. Where [AT n] is a number from 0 to 3 (0=3.5 MHz, 1=7 MHz, 2=14 MHz and 3=28 MHz).
	RUN AT 3
	PRINT "Speed = "; % REG 7 & \@11

#	CLEAR %$A000

	BANK NEW %m
	PROC dec16tohex( %m ) TO b$
	PRINT "Bank "; %m; " ("; b$; ")"

	LET %a = %$2345: PROC dec16tohex( %a ) TO a$: PRINT "Hex Convert "; %a; " ("; a$; ")"
	PROC dec16tohex( %$5678 ) TO a$: PRINT "Hex Convert 2 "; %$5678; " ("; a$; ")"

	LET %a = %$4000: PROC dec16tohex( %a ) TO a$: LET %b = %$55AA: PROC dec16tohex( %b ) TO b$
	DPOKE %a, %b
	DPOKE %$4003, %$AA55
	PRINT "DPOKE "; %a; " ("; a$; ") with "; %b; " ("; b$; ")"
	LET p = % ( ( PEEK ( a + 1 ) ) * 256 ) + PEEK a
	LET %p = % ( ( PEEK ( a + 1 ) ) * 256 ) + PEEK a
	PROC dec16tohex( %p ) TO p$
	PRINT "PEEK Screen "; %p; " ("; p$; ")"

	LET a$ = "$4000": PROC hextodec( a$ ) TO %a
	LET %d = % DPEEK a
	PROC dec16tohex( %d ) TO d$
	PRINT "DPEEK "; a$; " = "; %d; " ("; d$; ")"

	PROC dpeekaddr( %a ) TO %d
	PROC dec16tohex( %d ) TO d$
	PRINT "dpeekaddr "; a$; " = "; %d; " ("; d$; ")"

#	LET a$ = "$8967": PROC hextodec( a$ ) TO %a
	LET %a = %$8967: PROC dec16tohex( %a ) TO a$
	PRINT "POKE Bank "; %m; " with "; %a; " ("; a$; ")"
	LET a$ = "$67": PROC hextodec( a$ ) TO %a: BANK %m POKE 0, %a
	LET a$ = "$89": PROC hextodec( a$ ) TO %a: BANK %m POKE 1, %a
	LET %h = % BANK m PEEK 1
	LET %l = % BANK m PEEK 0
	LET %p = % ( h * 256 ) + l
	PROC dec16tohex( %p ) TO p$
	PRINT "BANK PEEK "; %m; " "; %p; " ("; p$; ")"

	LET a$ = "$3456": PROC hextodec( a$ ) TO %a
#	LET %a = %$3456: PROC dec16tohex( %a ) TO a$
	PRINT "DPOKE Bank "; %m; " with "; %a; " ("; a$; ")"
	BANK %m DPOKE 0, %a
	LET p = % ( ( BANK m PEEK 1 ) * 256 ) + BANK m PEEK 0
	PROC dec16tohex( p ) TO p$
	PRINT "BANK PEEK 2 "; %m; " "; p; " ("; p$; ")"
	LET %d = % BANK m DPEEK 0
	PROC dec16tohex( %d ) TO d$
	PRINT "DPEEK Bank "; %m; " "; %d; " ("; d$; ")"

	PROC dpeekbank( %m, 0 ) TO %d
	PROC dec16tohex( %d ) TO d$
	PRINT "dpeekbank Bank "; %m; " "; %d; " ("; d$; ")"

	LET a$ = "Test String" + CHR$ 0
	BANK %m POKE 0, a$
	LET b$ = BANK %m PEEK$( 0, ~0 )
	PRINT "POKE$ Bank "; %m; " "; a$; " = "; b$

	PRINT "Press any key...": PAUSE 0: CLS

	PRINT "7 & 8 = "; %\@111 & \@1000; " = 0"
	PRINT "7 | 8 = "; %\@111 | \@1000; " = 15"
	PRINT "7 ^ 8 = "; %\@111 ^ \@1000; " = 15"

	LET num = -345: GO SUB @posnegorzero
	LET num = 0: GO SUB @posnegorzero
	LET num = 345: GO SUB @posnegorzero

	PRINT "2 << 2 = "; %$2 << $2
	LET %a = 2: LET %b = 2: PRINT %a; " << "; %b; " = "; %a << b
	PRINT "64 >> 2 = "; %$40 >> $2
	LET %a = 64: LET %b = 2: PRINT %a; " >> "; %b; " = "; %a >> b

	PRINT "23 MOD 5 = "; % 23 MOD 5
	LET %a = 17: LET %b = 6: PRINT %a; " MOD "; %b; " = "; %a MOD b

	DIM d$( 255 ): DIM e$( 32 ): OPEN #2,"v>d$": PWD #2: CLOSE #2
	PROC trunc( d$ ) TO e$: PRINT "Current dir = "; e$
	CD "\\demos\\NextBASIC"
	DIM d$( 255 ): DIM e$( 32 ): OPEN #2,"v>d$": PWD #2: CLOSE #2
	PROC trunc( d$ ) TO e$: PRINT "Changed dir = "; e$
	CD "\\"
	DIM d$( 255 ): DIM e$( 32 ): OPEN #2,"v>d$": PWD #2: CLOSE #2
	PROC trunc( d$ ) TO e$: PRINT "Changed dir 2 = "; e$

	PRINT "Press any key...": PAUSE 0: CLS

	GO SUB @spritetest

	PRINT "Press any key...": PAUSE 0: CLS

	ON ERROR PRINT "An error ocurred...": ERROR TO e,l,s,b: PRINT "Error: "; e; " on line "; l; " statement "; s; " in BANK "; b: ON ERROR: STOP
	PRINT 5/0: REM Generate error condition

	STOP

	DEFPROC dpeekaddr( %a )
	ENDPROC = % ( ( PEEK ( a + 1 ) ) * 256 ) + PEEK a

	DEFPROC dpeekbank( %b, %o )
	LOCAL %h, %l

	LET %h = % BANK b PEEK ( o + 1 )
	LET %l = % BANK b PEEK o

	ENDPROC = % ( h * 256 ) + l

	DEFPROC inttohilobytes( addr )
# addr = decimal int to convert
# hibyte = hi byte of addr
# lobyte = lo byte of addr

	LET hibyte = INT( addr / 256 )
	LET lobyte = addr - ( hibyte * 256 )

	ENDPROC

	DEF FN p$(n)=CHR$ ( n + 48 + ( 7 AND ( n > 9 ) ) )

	DEFPROC dec16tohex ( addr )
# addr = decimal int to convert
# h$ = hex output with leading $

	LOCAL h$, hinybb, lonybb

	PROC inttohilobytes( addr )
	LET h$ = "$"

	LET hinybb = INT( hibyte / 16 )
	LET lonybb = hibyte - ( hinybb * 16 )
	LET h$ = h$ + FN p$( hinybb )
	LET h$ = h$ + FN p$( lonybb )

#@dec16tohex1:
	LET hinybb = INT( lobyte / 16 )
	LET lonybb = lobyte - ( hinybb * 16 )

	LET h$ = h$ + FN p$( hinybb )
	LET h$ = h$ + FN p$( lonybb )

	ENDPROC = h$

	DEFPROC hextodec( h$ )
# h$ = hex to convert with or without leading $
# addr = decimal int output

	LOCAL h, addr, mult
	LET addr = 0
	LET mult = 1

	FOR h = LEN h$ TO 1 STEP -1
		IF ( ( CODE h$( h ) >= CODE "0" ) AND ( CODE h$( h ) <= CODE "F" ) ) THEN LET addr = addr + ( ( CODE h$( h ) - ( 7 AND CODE h$( h ) > CODE "9" ) - CODE "0" ) * mult )
		LET mult = mult * 16
	NEXT h

	ENDPROC = addr

@posnegorzero:
# IF THEN ELSE example as per Manual p44
	PRINT num; ": ";: IF num < 0 THEN PRINT "Negative number": ELSE IF num > 0 THEN PRINT "Positive number": ELSE PRINT "The number is zero"
	RETURN

	DEFPROC trunc( i$ )
	LOCAL idx
	LET idx = LEN i$
	REPEAT : WHILE ( ( CODE i$( idx ) <= 32 ) OR ( CODE i$( idx ) >= 128 ) ): REM Non-alpha chars
		WHILE idx >= 1
		LET idx = idx - 1
	REPEAT UNTIL 0: REM Note: Endless loop without the WHILE condition
	ENDPROC = i$( 1 TO idx )

@spritetest:
# Sprite test as per /systemnext1.3/demos/NextBASIC/basicSprites/spriteAnim.bas
	SPRITE CLEAR
	BANK NEW %m
	LOAD "c:\\demos\\NextBASIC\\basicSprites\\dksprite.spr" BANK %m
	SPRITE BANK %m

	SPRITE PRINT 1
	SPRITE BORDER 1

	FOR a = 0 TO 7
		FOR b = 0 TO 7
		LET s = a * 8 + b
		SPRITE s, b * 24, a * 24 + 24, s, 1
		NEXT b
	NEXT a

	FOR y = 24 TO 230
		SPRITE 0,0,y,0,1
		PAUSE 1
	NEXT y

	LET i=0

	FOR x = 0 TO 319
		SPRITE 0,x,230,i,1
		LET i=i+0.25: IF i>4 THEN LET i=1
		PAUSE 1
	NEXT x

	SPRITE CLEAR: LAYER CLEAR

	RETURN
