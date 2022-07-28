@ECHO OFF

rem   ========================================
TITLE CD Drive Swap Script v2.0
rem   copyright (c) Arik Fletcher
rem   ========================================

IF EXIST "%TMP%\CD.tmp" DEL "%TMP%\CD.tmp"

REM -------------------------------
ECHO Generate DISKPART CD script...
REM -------------------------------

ECHO SELECT VOLUME 0 > "%TMP%\CD.tmp"
ECHO ASSIGN LETTER=X >> "%TMP%\CD.tmp"
ECHO SELECT VOLUME 1 >> "%TMP%\CD.tmp"
ECHO ASSIGN LETTER=Y >> "%TMP%\CD.tmp"
ECHO SELECT VOLUME 0 >> "%TMP%\CD.tmp"
ECHO ASSIGN LETTER=E >> "%TMP%\CD.tmp"
ECHO SELECT VOLUME 1 >> "%TMP%\CD.tmp"
ECHO ASSIGN LETTER=D >> "%TMP%\CD.tmp"
ECHO EXIT >> "%TMP%\CD.tmp"

REM -------------------------------
ECHO Start DISKPART with CD Script...
REM -------------------------------

DISKPART.EXE /S "%TMP%\CD.tmp"

REM -------------------------------
ECHO Cleanup and remove temp files...
REM -------------------------------

DEL "%TMP%\CD.tmp"