#!/bin/bash
#

# ZX Spectrum
../zmakebas -a 10 -o demo.tap -n "demo" demo.bas
../zmakebas -i 10 -a 10 -l -o demolbl.tap -n "demolbl" demolbl.bas

# ZX Spectrum Next
../zmakebas -a 10 -o zx-next-demo.tap -n "nextdemo" zx-next-demo.bas
../zmakebas -i 10 -a 10 -l -o zx-next-demolbl.tap -n "nextdemolb" zx-next-demolbl.bas

# ZX81
../zmakebas -a 10 -p -o zx81-basic-demo.p zx81-basic-demo.bas
../zmakebas -i 10 -a 10 -l -p -o zx81-basic-demo-lbl.p zx81-basic-demo-lbl.bas

exit
