@echo off

set appName=CS Support Folder Script
set appVer=1.0

:MENU
title %appName% (v%appVer%)
cls
echo %appName% (v%appVer%)
echo =================================================================
echo.
echo This script will create a standard support folder structure for
echo a specified client or a set of clients from an import list.
echo.
echo =================================================================
echo.
echo Do you want to:
echo.
echo [I]mport a client list in plain text
echo [C]reate folders for a single client
echo [E]xit the script and return to CMD
echo.
echo =================================================================
echo.
set /p appMode=Enter a menu code here: 

if /i "%appMode%"=="I" goto :Import
if /i "%appMode%"=="C" goto :Create
if /i "%appMode%"=="E" goto :Exit

goto :Error

:Import
cls
echo %appName% (v%appVer%)
echo =================================================================
echo.
echo This script will create a standard support folder structure for
echo a specified client or a set of clients from an import list.
echo.
echo =================================================================
echo.
echo Please enter the full path to the Client List import file-
echo (If you chose this option by mistake, press ENTER to exit)
echo.

set /p appFile=# 
if /i "%appFile%"=="" goto :Exit

echo.
echo Please enter the full path to the top-level support folder-
echo (If you chose this option by mistake, press ENTER to exit)
echo.

set /p appRoot=#  
if /i "%appRoot%"=="" goto :Exit

echo.
echo Please confirm that the import file and root path are correct-
echo.
echo Import File: "%appFile%"
echo Root Path:   "%appRoot%"
echo.

set /p appConfirm=[Y]/[N] 
if /i "%appConfirm%"=="N" goto :Import

For /f "tokens=1 delims=" %%a in (%appFile%) do (

echo.
echo Creating Support Folders in:
echo [ %appRoot%\%appFile% ]
echo.
md "%appRoot%\%%a\Antispam"
md "%appRoot%\%%a\Antivirus"
md "%appRoot%\%%a\Audits"
md "%appRoot%\%%a\Documentation"
md "%appRoot%\%%a\Firewall"
md "%appRoot%\%%a\Misc"
md "%appRoot%\%%a\Passwords"
md "%appRoot%\%%a\Router-ISP"
md "%appRoot%\%%a\VPN"

)

GOTO :EXIT

:Create
cls
echo %appName% (v%appVer%)
echo =================================================================
echo.
echo This script will create a standard support folder structure for
echo a specified client or a set of clients from an import list.
echo.
echo =================================================================
echo.
echo Please enter the full name of Client folder you wish to create-
echo (If you chose this option by mistake, press ENTER to exit)
echo.

set /p appFile=# 
if /i "%appFile%"=="" goto :Exit

echo.
echo Please enter the full path to the top-level support folder-
echo (If you chose this option by mistake, press ENTER to exit)
echo.

set /p appRoot=#  
if /i "%appRoot%"=="" goto :Exit

echo.
echo Please confirm that the import file and root path are correct-
echo.
echo Client Name: "%appFile%"
echo Root Path:   "%appRoot%"
echo Full Path:   "%appRoot%\%appFile%"
echo.

set /p appConfirm=[Y]/[N] 
if /i "%appConfirm%"=="N" goto :Create

echo.
echo Creating Support Folders in:
echo [ %appRoot%\%appFile% ]
echo.
md "%appRoot%\%appFile%\Antispam"
md "%appRoot%\%appFile%\Antivirus"
md "%appRoot%\%appFile%\Audits"
md "%appRoot%\%appFile%\Documentation"
md "%appRoot%\%appFile%\Firewall"
md "%appRoot%\%appFile%\Misc"
md "%appRoot%\%appFile%\Passwords"
md "%appRoot%\%appFile%\Router-ISP"
md "%appRoot%\%appFile%\VPN"

GOTO :EXIT

:EXIT
cls
echo %appName% (v%appVer%)
echo =================================================================
echo.
echo Thank you for using this script- have a nice day!
echo.

GOTO :EOF


:ERROR
cls
echo %appName% (v%appVer%)
echo =================================================================
echo.
echo -- INVALID SYNTAX --
echo Please enter a valid selection
echo.
pause
GOTO :MENU