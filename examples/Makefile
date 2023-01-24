ZMAKEBAS := ../zmakebas
RM := rm
MKDIR := mkdir
BD := ./compiled

all: $(BD) zxspectrum zxnext zx81

zxspectrum: $(BD)/demo.tap $(BD)/demolbl.tap
zxnext: $(BD)/zx-next-demo.bas $(BD)/zx-next-demolbl.bas
zx81: $(BD)/zx81-basic-demo.p $(BD)/zx81-basic-demo-lbl.p

$(BD)/demo.tap: demo.bas
	$(ZMAKEBAS) -a 10 -o $@ -n "$(basename $^)" $^

$(BD)/demolbl.tap: demolbl.bas
	$(ZMAKEBAS) -i 10 -a 10 -l -o $@ -n "$(basename $^)" $^

$(BD)/zx-next-demo.bas: zx-next-demo.bas
	$(ZMAKEBAS) -a 10 -3 -o $@ $^

$(BD)/zx-next-demolbl.bas: zx-next-demolbl.bas
	$(ZMAKEBAS) -i 10 -a 10 -3 -l -o $@ $^

$(BD)/zx81-basic-demo.p: zx81-basic-demo.bas
	$(ZMAKEBAS) -a 10 -p -o $@ $^

$(BD)/zx81-basic-demo-lbl.p: zx81-basic-demo-lbl.bas
	$(ZMAKEBAS) -i 10 -a 10 -l -p -o $@ $^

$(BD):
	$(MKDIR) -p $(BD)

clean:
	$(RM) $(BD)/*
