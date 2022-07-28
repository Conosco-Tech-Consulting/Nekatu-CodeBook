@echo off
COLOR 4F

set DVLdir=c:\projects\abs

for /f "tokens=1,2,3,4 delims=/ " %%a in ('date /t') do set Date=%%a%%b%%c%%d
for /f "tokens=1,2,3,4 delims=: " %%a in ('time /t') do set Time=%%a%%b
for /F %%a in (%DVLdir%\install\version.abs) DO SET ABSVer=%%a
for /f %%a in (%DVLdir%\misc\installkey.txt) DO SET ABSKey=%%a

:START
cls

echo =============================
echo ABS Development Toolkit v1.1
echo Copyright (c) Arik Fletcher
echo =============================
echo.
echo Please select a task to perform:
echo.
echo  [E]dit ABS.CMD Script
echo  [B]uild SYS.DAT crypt
echo  [M]odify Installation Wizard
echo  [U]pdate Readme.txt
echo  [I]ncrement ABS Version Number
echo  [P]ackage ABS-%ABSver%.zip
echo.
echo  [T]est ABS Installation
echo  [L]og Checking Engine Test
echo  [V]iew ABS Installation Key
echo.
echo  [Q]uit ABS Development Toolkit
echo.
set /P TASK=#

cls

IF /I "%TASK%"=="E" GOTO :EDIT
IF /I "%TASK%"=="B" GOTO :BUILD
IF /I "%TASK%"=="M" GOTO :INST
IF /I "%TASK%"=="U" GOTO :READ
IF /I "%TASK%"=="I" GOTO :VER
IF /I "%TASK%"=="P" GOTO :PACK
IF /I "%TASK%"=="T" GOTO :TEST
IF /I "%TASK%"=="L" GOTO :LOGCHK
IF /I "%TASK%"=="V" GOTO :KEYCHK
IF /I "%TASK%"=="Q" GOTO :EOF
GOTO :START


:EDIT

copy %DVLdir%\build\abs.cmd %DVLdir%\archive\abs-%date%-%time%.bak
start notepad %DVLdir%\build\abs.cmd
GOTO :START


:BUILD

copy %DVLdir%\build\abs.cmd %DVLdir%\build\build.cmd
CCRYPT -e -K%ABSKEY% %DVLdir%\build\build.cmd
ren %DVLdir%\build\build.cmd.cpt sys.tmp
REDSHIRT /e %DVLdir%\build\sys.tmp %DVLdir%\build\sys.dat
move /y %DVLdir%\build\sys.dat %DVLdir%\install
del %DVLdir%\build\sys.tmp
GOTO :START


:INST

copy %DVLdir%\install\install.bat %DVLdir%\archive\install-%date%-%time%.bak
start notepad %DVLdir%\install\install.bat
GOTO :START


:READ
start notepad %DVLdir%\install\README.TXT
GOTO :START


:VER

for /f "tokens=1,2,3 delims=." %%a in (%DVLdir%\install\version.abs) do set absmajver=%%a&set absminver=%%b&set /a abssubver=%%c+1
echo %absmajver%.%absminver%.%abssubver%>%DVLdir%\install\version.abs
for /F %%a in (%DVLdir%\install\version.abs) DO SET ABSVer=%%a
GOTO :START


:PACK

FBZIP -a %DVLdir%\package\ABS-%ABSVer%.zip "%DVLdir%\install"
pause
GOTO :START


:TEST

FBZIP -e %DVLdir%\Package\ABS-%ABSVer%.zip "%DVLdir%\Test"
start %DVLdir%\test\install.bat
GOTO :START


:LOGCHK

call %DVLdir%\misc\ABSLogChecker.cmd
GOTO :START


:KEYCHK

echo =============================
echo ABS Development Toolkit v1.0
echo Copyright (c) Arik Fletcher
echo =============================
echo.
echo Your ABS Installation Key is:
echo %ABSKEY%
echo.
pause
GOTO :START