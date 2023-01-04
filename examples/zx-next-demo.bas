10 rem zmakebas demo for zx spectrum next

# Prevent screensaver from launching
20 SPECTRUM SCREEN$ 0,0

# See manual p226. Where [AT n] is a number from 0 to 3 (0=3.5 MHz, 1=7 MHz, 2=14 MHz and 3=28 MHz).
30 RUN AT 3
40 PRINT "Speed = "; % REG 7 & @11

#40 CLEAR %$A000

50 BANK NEW %m
60 PROC dec16tohex( %m ) TO b$
70 PRINT "Bank "; %m; " ("; b$; ")"

80 LET %a = %$2345: PROC dec16tohex( %a ) TO a$: PRINT "Hex Convert "; %a; " ("; a$; ")"
90 PROC dec16tohex( %$5678 ) TO a$: PRINT "Hex Convert 2 "; %$5678; " ("; a$; ")"

100 LET %a = %$4000: PROC dec16tohex( %a ) TO a$: LET %b = %$55AA: PROC dec16tohex( %b ) TO b$
110 DPOKE %a, %b
120 DPOKE %$4003, %$AA55
130 PRINT "DPOKE "; %a; " ("; a$; ") with "; %b; " ("; b$; ")"
140 LET p = % ( ( PEEK ( a + 1 ) ) * 256 ) + PEEK a
150 LET %p = % ( ( PEEK ( a + 1 ) ) * 256 ) + PEEK a
160 PROC dec16tohex( %p ) TO p$
170 PRINT "PEEK Screen "; %p; " ("; p$; ")"

180 LET a$ = "$4000": PROC hextodec( a$ ) TO %a
190 LET %d = % DPEEK a
200 PROC dec16tohex( %d ) TO d$
210 PRINT "DPEEK "; a$; " = "; %d; " ("; d$; ")"

220 PROC dpeekaddr( %a ) TO %d
230 PROC dec16tohex( %d ) TO d$
240 PRINT "dpeekaddr "; a$; " = "; %d; " ("; d$; ")"

#250 LET a$ = "$8967": PROC hextodec( a$ ) TO %a
250 LET %a = %$8967: PROC dec16tohex( %a ) TO a$
260 PRINT "POKE Bank "; %m; " with "; %a; " ("; a$; ")"
270 LET a$ = "$67": PROC hextodec( a$ ) TO %a: BANK %m POKE 0, %a
280 LET a$ = "$89": PROC hextodec( a$ ) TO %a: BANK %m POKE 1, %a
290 LET %h = % BANK m PEEK 1
300 LET %l = % BANK m PEEK 0
310 LET %p = % ( h * 256 ) + l
320 PROC dec16tohex( %p ) TO p$
330 PRINT "BANK PEEK "; %m; " "; %p; " ("; p$; ")"

340 LET a$ = "$3456": PROC hextodec( a$ ) TO %a
#340 LET %a = %$3456: PROC dec16tohex( %a ) TO a$
350 PRINT "DPOKE Bank "; %m; " with "; %a; " ("; a$; ")"
360 BANK %m DPOKE 0, %a
370 LET p = % ( ( BANK m PEEK 1 ) * 256 ) + BANK m PEEK 0
380 PROC dec16tohex( p ) TO p$
390 PRINT "BANK PEEK 2 "; %m; " "; p; " ("; p$; ")"
400 LET %d = % BANK m DPEEK 0
410 PROC dec16tohex( %d ) TO d$
420 PRINT "DPEEK Bank "; %m; " "; %d; " ("; d$; ")"

430 PROC dpeekbank( %m, 0 ) TO %d
440 PROC dec16tohex( %d ) TO d$
450 PRINT "dpeekbank Bank "; %m; " "; %d; " ("; d$; ")"

460 LET a$ = "Test String" + CHR$ 0
470 BANK %m POKE 0, a$
480 LET b$ = BANK %m PEEK$( 0, ~0 )
490 PRINT "POKE$ Bank "; %m; " "; a$; " = "; b$

500 PRINT "Press any key...": PAUSE 0: CLS

510 PRINT "7 & 8 = "; %@111 & @1000; " = 0"
520 PRINT "7 | 8 = "; %@111 | @1000; " = 15"
530 PRINT "7 ^ 8 = "; %@111 ^ @1000; " = 15"

540 LET num = -345: GO SUB 3500
550 LET num = 0: GO SUB 3500
560 LET num = 345: GO SUB 3500

570 PRINT "2 << 2 = "; %$2 << $2
580 LET %a = 2: LET %b = 2: PRINT %a; " << "; %b; " = "; %a << b
590 PRINT "64 >> 2 = "; %$40 >> $2
600 LET %a = 64: LET %b = 2: PRINT %a; " >> "; %b; " = "; %a >> b

610 PRINT "23 MOD 5 = "; % 23 MOD 5
620 LET %a = 17: LET %b = 6: PRINT %a; " MOD "; %b; " = "; %a MOD b

630 DIM d$( 255 ): DIM e$( 32 ): OPEN #2,"v>d$": PWD #2: CLOSE #2
640 PROC trunc( d$ ) TO e$: PRINT "Current dir = "; e$
650 CD "\\demos\\NextBASIC"
660 DIM d$( 255 ): DIM e$( 32 ): OPEN #2,"v>d$": PWD #2: CLOSE #2
670 PROC trunc( d$ ) TO e$: PRINT "Changed dir = "; e$
680 CD "\\"
690 DIM d$( 255 ): DIM e$( 32 ): OPEN #2,"v>d$": PWD #2: CLOSE #2
700 PROC trunc( d$ ) TO e$: PRINT "Changed dir 2 = "; e$

710 PRINT "Press any key...": PAUSE 0: CLS

720 GO SUB 5000

730 PRINT "Press any key...": PAUSE 0: CLS

740 ON ERROR PRINT "An error ocurred...": ERROR TO e,l,s,b: PRINT "Error: "; e; " on line "; l; " statement "; s; " in BANK "; b: ON ERROR: STOP
750 PRINT 5/0: REM Generate error condition

760 STOP

1000 DEFPROC dpeekaddr( %a )
1010 ENDPROC = % ( ( PEEK ( a + 1 ) ) * 256 ) + PEEK a

1500 DEFPROC dpeekbank( %b, %o )
1510 LOCAL %h, %l

1520 LET %h = % BANK b PEEK ( o + 1 )
1530 LET %l = % BANK b PEEK o

1540 ENDPROC = % ( h * 256 ) + l

2000 DEFPROC inttohilobytes( addr )
# addr = decimal int to convert
# hibyte = hi byte of addr
# lobyte = lo byte of addr

2010 LET hibyte = INT( addr / 256 )
2020 LET lobyte = addr - ( hibyte * 256 )
2030 ENDPROC

2400 DEF FN p$(n)=CHR$ ( n + 48 + ( 7 AND ( n > 9 ) ) )

2500 DEFPROC dec16tohex ( addr )
# addr = decimal int to convert
# h$ = hex output with leading $

2510 LOCAL h$, hinybb, lonybb

2520 PROC inttohilobytes( addr )
2530 LET h$ = "$"

2540 LET hinybb = INT( hibyte / 16 )
2550 LET lonybb = hibyte - ( hinybb * 16 )

2560 LET h$ = h$ + FN p$( hinybb )
2570 LET h$ = h$ + FN p$( lonybb )

#@dec16tohex1:
2580 LET hinybb = INT( lobyte / 16 )
2590 LET lonybb = lobyte - ( hinybb * 16 )

2600 LET h$ = h$ + FN p$( hinybb )
2610 LET h$ = h$ + FN p$( lonybb )

2620 ENDPROC = h$

3000 DEFPROC hextodec( h$ )
# h$ = hex to convert with or without leading $
# addr = decimal int output

3010 LOCAL h, addr, mult

3020 LET addr = 0
3030 LET mult = 1

3040 FOR h = LEN h$ TO 1 STEP -1
3050 	IF ( ( CODE h$( h ) >= CODE "0" ) AND ( CODE h$( h ) <= CODE "F" ) ) THEN LET addr = addr + ( ( CODE h$( h ) - ( 7 AND CODE h$( h ) > CODE "9" ) - CODE "0" ) * mult )
3060	LET mult = mult * 16
3070 NEXT h

3080 ENDPROC = addr

# IF THEN ELSE example as per Manual p44
3500 PRINT num; ": ";: IF num < 0 THEN PRINT "Negative number": ELSE IF num > 0 THEN PRINT "Positive number": ELSE PRINT "The number is zero"
3510 RETURN

4000 DEFPROC trunc( i$ )
4010 LOCAL idx
4020 LET idx = LEN i$
4030 REPEAT : WHILE ( ( CODE i$( idx ) <= 32 ) OR ( CODE i$( idx ) >= 128 ) ): REM Non-alpha chars
4040	WHILE idx >= 1
4050	LET idx = idx - 1
4060 REPEAT UNTIL 0: REM Note: Endless loop without the WHILE condition
4090 ENDPROC = i$( 1 TO idx )

# Sprite test as per /systemnext1.3/demos/NextBASIC/basicSprites/spriteAnim.bas
5000 SPRITE CLEAR
5010 BANK NEW %m
5020 LOAD "c:\\demos\\NextBASIC\\basicSprites\\dksprite.spr" BANK %m
5030 SPRITE BANK %m

5040 SPRITE PRINT 1
5050 SPRITE BORDER 1

5060 FOR a = 0 TO 7
5070	FOR b = 0 TO 7
5080		LET s = a * 8 + b
5090		SPRITE s, b * 24, a * 24 + 24, s, 1
5100	NEXT b
5110 NEXT a

5120 FOR y = 24 TO 230
5130	SPRITE 0,0,y,0,1
5140	PAUSE 1
5150 NEXT y

5160 LET i=0

5170 FOR x = 0 TO 319
5180 	SPRITE 0,x,230,i,1
5190 	LET i=i+0.25: IF i>4 THEN LET i=1
5200	PAUSE 1
5210 NEXT x

5220 SPRITE CLEAR: LAYER CLEAR

5230 RETURN
