@echo off
cls

if "%1"=="" goto :ERROR

:START
title m3u Playlist Splitter - v1.0
echo ======================================
echo  .-._.-._.-. .----. .-. .-. ----------
echo  : .-. .-. : '--. : : : : :  PLAYLIST
echo  : : : : : : .--' : : : : :  SPLITTER
echo  : : : : : : '--. : : : : : ----------
echo  : : : : : : .--' : : '-' :  VER 1.00
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

GOTO :RUN1

:RUN1
for /l %%a in (0,1,9) do (
echo.>"%~dp1playlist0%%a.tmp"
cscript //nologo %systemroot%\system32\m3usplit.vbs %1 0%%a
for /f %%b in ('type "%~dp1playlist0%%a.tmp" ^| find /c /i "#0%%a"') do if not "%%b"=="0" (
		type "%~dp1playlist0%%a.tmp" | find /i ".mp3">"%~dp1playlist0%%a.m3u"
		del "%~dp1playlist0%%a.tmp"
	) else (
		del "%~dp1playlist0%%a.tmp"
	)
)

)
GOTO :RUN2

:RUN2
for /l %%a in (10,1,23) do (
echo.>"%~dp1playlist%%a.tmp"
cscript //nologo %systemroot%\system32\m3usplit.vbs %1 %%a
for /f %%b in ('type "%~dp1playlist%%a.tmp" ^| find /c /i "#%%a"') do if not "%%b"=="0" (
		type "%~dp1playlist%%a.tmp" | find /i ".mp3">"%~dp1playlist%%a.m3u"
		del "%~dp1playlist%%a.tmp"
	) else (
		del "%~dp1playlist%%a.tmp"
	)
)
GOTO :EOF

:ERROR
cls
title m3u Playlist Splitter - v1.0
echo ===============================================================================
echo  .-._.-._.-. .----. .-. .-. ----------
echo  : .-. .-. : '--. : : : : :  PLAYLIST
echo  : : : : : : .--' : : : : :  SPLITTER
echo  : : : : : : '--. : : : : : ----------
echo  : : : : : : .--' : : '-' :  VER 1.00
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
pause