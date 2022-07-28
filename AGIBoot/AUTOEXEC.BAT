@echo off
SET TZ=GHO+00:00
prompt $p$g
MOUSE.COM
SMARTDRV.EXE
MSCDEX /d:BootCD /l:X

IF "%config%"=="EXIT" GOTO EXIT

CLS
echo ====================================================
echo  Co-Operative Systems Quick Recovery Mode v1.2
echo  %CONFIG% Mode Recovery - Modified 24/08/2011
echo ====================================================
echo.
echo Please be aware that continuing in this mode will
echo erase the operating system of the chosen operating
echo mode. No user data will be affected however any
echo applications you have manually installed/updated
echo will need to be re-installed after recovery.
echo.
echo ====================================================
echo.
echo IF YOU HAVE ENTERED RECOVERY MODE IN ERROR OR DO
echo NOT WISH TO CONTINUE THEN PLEASE SWITCH OFF YOUR
echo AND RESTART YOUR COMPUTER NOW.
echo.
echo ====================================================
echo.
echo To begin recovery of the %config% Mode
PAUSE

IF "%config%"=="Corporate" GOTO Corporate
IF "%config%"=="Personal" GOTO Personal

:Corporate
cd \ghost
GHOST.EXE -clone,mode=pload,src=c:\GHOST\CORP.gho,dst=1:2 -sure
goto EXIT

:Personal

cd \ghost
GHOST.EXE -clone,mode=pload,src=c:\GHOST\PERS.gho,dst=1:3 -sure
goto EXIT

:EXIT
RESTART