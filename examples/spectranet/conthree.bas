1 DIM c(4)
 10%listen #4,2000
 20%control #5
 30 PRINT #5;"p"
 40 PRINT "Waiting..."
 45 INPUT #5;a;a$
 50 IF a<>0 THEN GO TO 200
 60 LET a$=INKEY$
 70 IF a$="x" THEN GO TO 700
 80 GO TO 45
200 IF a=4 THEN GO TO 400
210 IF a$="disconn" THEN GO TO 600
220 INPUT #a;c$
230 PRINT "Strm ";a;": ";c$
240 IF c$="rnd" THEN PRINT #a;RND: GO TO 40
250 IF c$="foo" THEN PRINT a;"Foo bar baz": GO TO 40
260 IF c$="quit" THEN PRINT #a;"Adios":GO TO 600
300 PRINT #a;"I didn't understand that"
310 GO TO 40
400 FOR i=1 TO 4
410 IF c(i)=0 THEN LET chan=i+5: GO TO 500
420 NEXT i
430 PRINT "Out of streams"
440 STOP
500 PRINT "Accepted connection on stream ";chan
510%accept #chan,4
520 LET c(i)=1
530 GO TO 40
600 PRINT "Closing #";a
605%close #a
610 LET c(a-5)=0
620 GO TO 40
700 PRINT "The program has finished"
710%close #5
715 PRINT "Closing socket"
720%close #4
730 PRINT "Closing connections"
740 FOR i=1 TO 4
750 IF c(i)=1 THEN %close #i+5
760 NEXT i