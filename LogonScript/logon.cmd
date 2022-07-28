@echo off

rem   ========================================
TITLE Joskos Logon Script v3.5
rem   copyright (c) Joskos Limited
rem   ========================================

rem   Required Additonal Files:
rem   ------------------
rem   IFMEMBER.EXE
rem   REDIRECT.VBS
rem   NAMEDRIVE.VBS

rem ----------------------------------------
rem User Identification
rem ----------------------------------------

%logonserver%\NETLOGON\IFMEMBER "Pupils"
if not "%errorlevel%"=="0" (
set Group=Pupils
goto :PUPILS
)

%logonserver%\NETLOGON\IFMEMBER "Staff"
if not "%errorlevel%"=="0" (
set Group=Staff
goto :STAFF
)

%logonserver%\NETLOGON\IFMEMBER "Domain Admins"
if not "%errorlevel%"=="0" (
set Group=Admins
goto :ADMINS
)

GOTO :%1
GOTO :EOF


:STAFF

rem ----------------------------------------
rem Staff Drive Mapping & Network Data Folders
rem ----------------------------------------

net use p: /delete
net use r: /delete
net use s: /delete

net use p: "%logonserver%\ud$\Pupils"
net use r: "%logonserver%\pd$\TeacherResources"
net use s: "%logonserver%\pd$\SharedWork"

IF NOT EXIST u:\InternetFavorites\. md u:\InternetFavorites

GOTO :TIMESYNC


:PUPILS

rem ----------------------------------------
rem Pupil Drive Mapping
rem ----------------------------------------

net use s: /delete

net use s: "%logonserver%\pd$\SharedWork"

GOTO :TIMESYNC


:ADMINS

rem ----------------------------------------
rem Admin Drive Mapping
rem ----------------------------------------

net use p: /delete
net use r: /delete
net use s: /delete
net use t: /delete

net use p: "%logonserver%\ud$\Pupils"
net use t: "%logonserver%\ud$\Staff"
net use r: "%logonserver%\pd$\TeacherResources"
net use s: "%logonserver%\pd$\SharedWork"

GOTO :TIMESYNC


:TIMESYNC

rem ----------------------------------------
rem Sync time with logon server
rem ----------------------------------------

net time /set /y %logonserver%


:NETDATA

rem ----------------------------------------
rem Redirected Folders & Network Software Data
rem ----------------------------------------

%logonserver%\netlogon\redirect.vbs "%Group%"

if exist p:\. %logonserver%\netlogon\namedrive.vbs P:\ "Pupils Work"
if exist t:\. %logonserver%\netlogon\namedrive.vbs T:\ "Staff Work"
if exist r:\. %logonserver%\netlogon\namedrive.vbs R:\ "Teacher Resources"
if exist u:\. %logonserver%\netlogon\namedrive.vbs U:\ "My Documents"
if exist s:\. %logonserver%\netlogon\namedrive.vbs S:\ "Shared Work"


:CLEANTMPFILES

rem ----------------------------------------
rem Temp Files Cleanup
rem ----------------------------------------

DEL /s /q /f "%userprofile%\Local Settings\Temporary Internet Files\*.*"
DEL /s /q /f "%tmp%\*.*"


:PRINTINSTALL

rem ----------------------------------------
rem Printer Install
rem ----------------------------------------

FOR /L %%a IN (1,1,9) DO IF "%COMPUTERNAME%"=="%USERDOMAIN%ICT0%%a" GOTO PRINTICT
FOR /L %%a IN (10,1,16) DO IF "%COMPUTERNAME%"=="%USERDOMAIN%ICT%%a" GOTO PRINTICT

IF "\\%COMPUTERNAME%"=="%LOGONSERVER%" GOTO :UNMOUNTDTOOLS


:PRINTCLASS

cscript %systemroot%\system32\prnmngr.vbs -ac -p "%logonserver%\ICT Colour"

GOTO :UNMOUNTDTOOLS

:PRINTICT

cscript %systemroot%\system32\prnmngr.vbs -x
cscript %systemroot%\system32\prnmngr.vbs -ac -p "%logonserver%\ICT Colour"
cscript %systemroot%\system32\prnmngr.vbs -t -p "%logonserver%\ICT Colour"

GOTO :UNMOUNTDTOOLS


:UNMOUNTDTOOLS

rem ----------------------------------------
rem Unmount all Daemon Tools Virtual Drives
rem ----------------------------------------

"c:\Program Files\D-Tools\daemon.exe" -unmount 0


:END

rem ----------------------------------------
rem Run TASKMENU or EXIT
rem ----------------------------------------

if /i {%1}=={admin} call %logonserver%\NETWORKADMINS$\TASKMENU\taskmenu.cmd
GOTO :EOF