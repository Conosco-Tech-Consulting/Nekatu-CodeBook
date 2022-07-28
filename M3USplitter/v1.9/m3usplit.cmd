@echo off
cls
color 1F

if %1=="" goto :ERROR

:START
title m3u Playlist Splitter - v1.09
echo ======================================
echo  .-._.-._.-. .----. .-. .-. ----------
echo  : .-. .-. : '--. : : : : :  PLAYLIST
echo  : : : : : : .--' : : : : :  SPLITTER
echo  : : : : : : '--. : : : : : ----------
echo  : : : : : : .--' : : '-' :  VER 1.09
echo  '-' '-' '-' '----' '-----' ----------
echo   ~ Copyright © 2010 Arik Fletcher ~
echo ======================================
echo.
echo Original m3u File:
echo %1
echo.
echo Destination File Path:
echo %~dp1
echo.

pushd "%~dp1"

GOTO :RUN1

:RUN1
for /l %%a in (0,1,9) do (
echo.>"%~dp1%~n1.0%%a.tmp"
call :SPLIT %1 0%%a
for /f %%b in ('type "%~dp1%~n1.0%%a.tmp" ^| find /c /i "\\Mybookworld\public\Q\Powergold4\Hour0%%a.mp3"') do if not "%%b"=="0" (
		type "%~dp1%~n1.0%%a.tmp" | find /v /i "\\Mybookworld\PUBLIC\Q\Powergold4\Hour0%%a.mp3" | find /i ".mp3">"%~dp1%~n1.0%%a.m3u"
		del "%~dp1%~n1.0%%a.tmp"
	) else (
		del "%~dp1%~n1.0%%a.tmp"
	)
)
GOTO :RUN2

:RUN2
for /l %%a in (10,1,23) do (
echo.>"%~dp1%~n1.%%a.tmp"
call :SPLIT %1 %%a
for /f %%b in ('type "%~dp1%~n1.%%a.tmp" ^| find /c /i "\\Mybookworld\PUBLIC\Q\Powergold4\Hour%%a.mp3"') do if not "%%b"=="0" (
		type "%~dp1%~n1.%%a.tmp" | find /v /i "\\Mybookworld\PUBLIC\Q\Powergold4\Hour%%a.mp3" | find /i ".mp3">"%~dp1%~n1.%%a.m3u"
		del "%~dp1%~n1.%%a.tmp"
	) else (
		del "%~dp1%~n1.%%a.tmp"
	)
)

popd

GOTO :EOF

:ERROR
cls
title m3u Playlist Splitter - v1.09
echo ===============================================================================
echo  .-._.-._.-. .----. .-. .-. ----------
echo  : .-. .-. : '--. : : : : :  PLAYLIST
echo  : : : : : : .--' : : : : :  SPLITTER
echo  : : : : : : '--. : : : : : ----------
echo  : : : : : : .--' : : '-' :  VER 1.09
echo  '-' '-' '-' '----' '-----' ----------       
echo   ~ Copyright © 2010 Arik Fletcher ~
echo ===============================================================================
echo.
echo  This program requires a playlist to be specified in order to function.
echo.
echo  Please create a shortcut on your desktop to %systemdrive%\system32\m3usplit.cmd
echo  then drag your playlist onto the shortcut for the new files to be 
echo  created in the original location of your playlist.
echo.
echo  For further assistance, please contact arikf@micronicity.co.uk
echo.
echo ===============================================================================

GOTO :EOF

:SPLIT

if "%2"=="00" cscript //nologo %systemroot%\system32\m3usplit.vbs %1 00 01
if "%2"=="01" cscript //nologo %systemroot%\system32\m3usplit.vbs %1 01 02
if "%2"=="02" cscript //nologo %systemroot%\system32\m3usplit.vbs %1 02 03
if "%2"=="03" cscript //nologo %systemroot%\system32\m3usplit.vbs %1 03 04
if "%2"=="04" cscript //nologo %systemroot%\system32\m3usplit.vbs %1 04 05
if "%2"=="05" cscript //nologo %systemroot%\system32\m3usplit.vbs %1 05 06
if "%2"=="06" cscript //nologo %systemroot%\system32\m3usplit.vbs %1 06 07
if "%2"=="07" cscript //nologo %systemroot%\system32\m3usplit.vbs %1 07 08
if "%2"=="08" cscript //nologo %systemroot%\system32\m3usplit.vbs %1 08 09
if "%2"=="09" cscript //nologo %systemroot%\system32\m3usplit.vbs %1 09 10
if "%2"=="10" cscript //nologo %systemroot%\system32\m3usplit.vbs %1 10 11
if "%2"=="11" cscript //nologo %systemroot%\system32\m3usplit.vbs %1 11 12
if "%2"=="12" cscript //nologo %systemroot%\system32\m3usplit.vbs %1 12 13
if "%2"=="13" cscript //nologo %systemroot%\system32\m3usplit.vbs %1 13 14
if "%2"=="14" cscript //nologo %systemroot%\system32\m3usplit.vbs %1 14 15
if "%2"=="15" cscript //nologo %systemroot%\system32\m3usplit.vbs %1 15 16
if "%2"=="16" cscript //nologo %systemroot%\system32\m3usplit.vbs %1 16 17
if "%2"=="17" cscript //nologo %systemroot%\system32\m3usplit.vbs %1 17 18
if "%2"=="18" cscript //nologo %systemroot%\system32\m3usplit.vbs %1 18 19
if "%2"=="19" cscript //nologo %systemroot%\system32\m3usplit.vbs %1 19 20
if "%2"=="20" cscript //nologo %systemroot%\system32\m3usplit.vbs %1 20 21
if "%2"=="21" cscript //nologo %systemroot%\system32\m3usplit.vbs %1 21 22
if "%2"=="22" cscript //nologo %systemroot%\system32\m3usplit.vbs %1 22 23
if "%2"=="23" cscript //nologo %systemroot%\system32\m3usplit.vbs %1 23 24

GOTO :EOF