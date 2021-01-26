10 %connect #4,"spectrum.alioth.net",80
20 %oneof 100
30 PRINT #4;"GET HTTP/1.0"
40 PRINT #4
50 INPUT #4;a$
60 PRINT a$
70 GO TO 50
100 %close #4