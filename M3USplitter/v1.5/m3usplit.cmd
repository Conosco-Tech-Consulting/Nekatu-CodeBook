@echo off
cls

if %1=="" goto :ERROR

:START
title m3u Playlist Splitter - v1.0
echo ======================================
echo  .-._.-._.-. .----. .-. .-. ----------
echo  : .-. .-. : '--. : : : : :  PLAYLIST
echo  : : : : : : .--' : : : : :  SPLITTER
echo  : : : : : : '--. : : : : : ----------
echo  : : : : : : .--' : : '-' :  VER 1.05
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

cd "%~dp1"

GOTO :RUN1

:RUN1
for /l %%a in (1,1,9) do (
echo.>"%~dp1%~n1.0%%a.tmp"
call :SPLIT %1 0%%a 0
for /f %%b in ('type "%~dp1%~n1.0%%a.tmp" ^| find /c /i "c:\Hour0%%a.mp3"') do if not "%%b"=="0" (
		type "%~dp1%~n1.0%%a.tmp" | find /v /i "c:\Hour0%%a.mp3" | find /i ".mp3">"%~dp1%~n1.0%%a.m3u"
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
for /f %%b in ('type "%~dp1%~n1.%%a.tmp" ^| find /c /i "c:\Hour%%a.mp3"') do if not "%%b"=="0" (
		type "%~dp1%~n1.%%a.tmp" | find /v /i "c:\Hour%%a.mp3" | find /i ".mp3">"%~dp1%~n1.%%a.m3u"
		del "%~dp1%~n1.%%a.tmp"
	) else (
		del "%~dp1%~n1.%%a.tmp"
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

GOTO :EOF

:SPLIT
set /a next=%2+1

if "%3"=="0" (
cscript //nologo %systemroot%\system32\m3usplit.vbs %1 %2 0%next%
) else (
cscript //nologo %systemroot%\system32\m3usplit.vbs %1 %2 %next%
)

GOTO :EOF