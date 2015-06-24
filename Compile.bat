@ECHO OFF
DEL Restarter.exe
DCC32 Restarter.dpr
PAUSE
UPX Restarter.exe
DEL *.~*
DEL *.dcu
