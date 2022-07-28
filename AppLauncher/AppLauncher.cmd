@echo off

rem   ========================================
TITLE Application Launcher v4.0
rem   Copyright (c) Arik Fletcher
rem   ========================================


:Read Application Config FIle

if "%1"=="" (
echo This application requires a preconfigured config file.
echo Please enter the full path to the application config file:
echo.
set /p INIFILE=# 
) ELSE (
set INIFILE=%1
)

for /f "delims=" %%a in ('type "%INIFILE%"^|find /i "="') do set %%a


:Progress Bar
start ^"%systemroot%\system32\wscript^" ^"progress.vbs^" ^"%APPNAME%^"


:CD Image Mount
IF DEFINED ISOPATH (
for /f %a in ('dir /s daemon.exe /b') do set DTOOLS=%a
"%DTOOLS%" -unmount 0
"%DTOOLS%" -mount 0,"%ISOPATH%"
)


:Compatibility Fixes
IF DEFINED COMPAT SET __COMPAT_LAYER=%COMPAT%
IF DEFINED RESFIX CHRES %RESFIX%


:Application Launch
"%EXEPATH%"


:Compatibility Resets
IF DEFINED COMPAT set __compat_layer=
IF DEFINED RESFIX chres reset


:Cleanup and Exit
SET EXEPATH=
SET COMPAT=
SET RESFIX=
SET DTOOLS=
SET ISOPATH=
SET INIFILE=