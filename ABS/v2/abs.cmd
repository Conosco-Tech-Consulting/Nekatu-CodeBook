@ECHO off

REM ==================================================================
REM |A|B|S| - Automated Backup Script for Windows 2k/XP/2k3
REM ==================================================================
REM Copyright (c) Arik Fletcher, some components copyright (c) their
REM various owners and/or publishers. See README.TXT for more info.
REM ==================================================================
REM Modifications to the script are not permitted unless express 
REM permission is granted by the author. Please forward requests for 
REM new features to the author at the email address specified above.
REM ==================================================================


:DEBUGMODECHECK

if /i {%1}=={/debug} (

set ABSDebug=1
prompt $g
ABS.CMD %2 %3 %4 %5 %6 %7 %8 %9 > ABSDebug.log

) ELSE (

if "%ABSDebug%"=="1" (

ECHO ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
ECHO ABS Debugging Mode Output - %DATE% - %TIME%
ECHO ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
ECHO.

ECHO on
CLS

) ELSE (

CLS

)

)


:OSCHECK

if not "%OS%"=="Windows_NT" echo ABS requires Windows 2000/XP/2003 to run. & GOTO :EOF

for /f "tokens=4,5 delims=[.] " %%a in ('ver') do set OSVer=%%a.%%b

if "%OSver%"=="Version.5" SET OSName=Windows 2000& GOTO :INIT
if "%OSver%"=="5.1" SET OSName=Windows XP& GOTO :INIT
if "%OSver%"=="5.2" SET OSName=Windows 2003& GOTO :INIT

ECHO Operating System not supported.
ECHO ABS requires Windows 2000/XP/2003 to run.
GOTO :EOF


:INIT

for /f "tokens=1,2,3,4 delims=/ " %%a in ('date /t') do set BckpDate=%%a%%b%%c%%d
for /f %%a in ('time /t') do set starttime=%%a

for /f "tokens=3" %%a in ('reg query "hklm\software\Joskos Solutions\ABS" /v CurrentVersion ^| find "CurrentVersion"') do set ABSVer=%%a
for /f "tokens=3" %%a in ('reg query "hklm\software\Joskos Solutions\ABS" /v InstallPath ^| find "InstallPath"') do set ABSDir=%%a
for /f "tokens=3" %%a in ('reg query "hklm\software\Joskos Solutions\ABS" /v MailServerAddress ^| find "MailServerAddress"') do set SMTPsvr=%%a
for /f "tokens=3" %%a in ('reg query "hklm\software\Joskos Solutions\ABS" /v MailSender ^| find "MailSender"') do set SMTPsend=%%a
for /f "tokens=3" %%a in ('reg query "hklm\software\Joskos Solutions\ABS" /v MailReceiver ^| find "MailReceiver"') do set SMTPrcpt=%%a
for /f "tokens=3" %%a in ('reg query "hklm\software\Joskos Solutions\ABS" /v BackupReportsPath ^| find "BackupReportsPath"') do set BckpLogDir=%%a
for /f "tokens=3" %%a in ('reg query "hklm\software\Joskos Solutions\ABS" /v BackupTapeDevice ^| find "BackupTapeDevice"') do set BckpTapeDST=%%a
for /f "tokens=3" %%a in ('reg query "hklm\software\Joskos Solutions\ABS" /v BackupFilesPath ^| find "BackupFilesPath"') do set BckpFileDst=%%a\FileBackup.bkf
for /f "tokens=3" %%a in ('reg query "hklm\software\Joskos Solutions\ABS" /v HTMLReports ^| find "HTMLReports"') do set HTMLReports=%%a
for /f "tokens=3" %%a in ('reg query "hklm\software\Joskos Solutions\ABS" /v BackupSharepoint ^| find "BackupSharepoint"') do set Sharepoint=%%a

if /i {%1}=={/test} (
shift
set BckpSrc=SystemState
)

if /i {%1}=={/userdata} (
shift
set BckpSrc=%ABSDir%\userdata.bks
set BckpSrcEnc=%ABSDir%\userdata.dat
)

if /i {%1}=={/publicdata} (
shift
set BckpSrc=%ABSDir%\publicdata.bks
set BckpSrcEnc=%ABSDir%\publicdata.dat
)

if /i {%1}=={/alldata} (
shift
set BckpSrc=%ABSDir%\alldata.bks
set BckpSrcEnc=%ABSDir%\alldata.dat
)



if /i "%HTMLReports%"=="0x0" (
set Bckprprt=%BckpLogDir%\%BckpDate%-REPORT.log
) ELSE (
set Bckprprt=%BckpLogDir%\%BckpDate%-REPORT.htm
)

if /i "%BckpTapeDst%"=="4mm" set BckpTapeDst=4mm DDS

set ABSLogs=%ABSDir%\Logs
set TMPDir=%USERPROFILE%\Local Settings\Application Data\Microsoft\Windows NT\NTBackup\data
set TMPLogs=%USERPROFILE%\Local Settings\Application Data\Microsoft\Windows NT\NTBackup\data\*.log
set Bckplog=%BckpLogDir%\%BckpDate%-%2.log
set Bckpzip=%BckpLogDir%\%BckpDate%-%2.zip
set BckpSharepoint=%SystemDrive%\SharePointBackup.spb

for /f "tokens=1,2 delims=:" %%a in ("%BckpZip%") do set BckpZipUNC=\\%computername%\%%a$%%b
for /f "tokens=1,2 delims=:" %%a in ("%Bckprprt%") do set BckpRprtUNC=\\%computername%\%%a$%%b


:START

TITLE ABS - Automated Backup Script %ABSver% - Copyright (c) Arik Fletcher

ECHO ==================================================================
ECHO ^|A^|B^|S^| - Automated Backup Script %ABSver% for Windows 2k/XP/2k3
ECHO ==================================================================
ECHO Copyright (c) Arik Fletcher, some components copyright (c) their
ECHO various owners and/or publishers. See README.TXT for more info.
ECHO ==================================================================
ECHO.
ECHO Author:  Arik Fletcher
ECHO Contact: arikf@joskos.com
ECHO.
ECHO ABS performs an automated NTBackup based on several environmental
ECHO variables set within this script. Throughout the session, a report
ECHO is generated, displayed on the screen, then emailed to a specified
ECHO address. ABS will also compress the NTBackup log and move it to a
ECHO specified location and then analyse the log for errors.
ECHO.
ECHO ==================================================================
ECHO.
ECHO NB: Modifications to the script are not permitted unless express 
ECHO permission is granted by the author. Please forward requests for 
ECHO new features to the author at the email address specified above.
ECHO.
ECHO ==================================================================
ECHO.

if /i {%1}=={/?} GOTO :HELP
if /i {%1}=={/help} GOTO :HELP
if /i {%1}=={/update} GOTO :UPDATE
if /i {%1}=={/uninstall} GOTO :UNINSTALL
if /i {%1}=={/backup} GOTO :BACKUPTYPE


:HELP
CLS
ECHO Usage:
ECHO   ABS.CMD [Operation] [Optional Parameters]
ECHO.
ECHO Valid Operations:
ECHO   File Backup   - ABS.CMD /BACKUP TAPE
ECHO   Tape Backup   - ABS.CMD /BACKUP FILE
ECHO   Remove ABS    - ABS.CMD /UNINSTALL
ECHO   Update ABS    - ABS.CMD /UPDATE
ECHO.
ECHO For development and troubleshooting purposes it is possible to run
ECHO ABS in 'debugging' mode via the /DEBUG switch. To run ABS in debug
ECHO mode, enter 'ABS.CMD /DEBUG' followed by the operation you wish to
ECHO perform, e.g. 'ABS.CMD /DEBUG /UPDATE' to run the ABS Update tool
ECHO under debug mode or 'ABS.CMD /DEBUG /BACKUP TAPE' to run a tape
ECHO backup operation under debug mode. Debug mode will run your chosen
ECHO ABS operation and save all command output to a log file in the ABS
ECHO install location called 'ABSDebug.log'. Open the log in NOTEPAD to
ECHO troubleshoot backup issues then examine the backup logs in the ABS
ECHO 'LOGS' folder for further details.

GOTO :EOF


:UPDATE

REDSHIRT /d "%ABSdir%\update.dat" "%ABSdir%\update.log"
FTP -v -s:%ABSdir%\update.log support.joskos.com
DEL "%ABSdir%\update.log" /q
MD "%ABSdir%\update"
FBZIP -e %ABSdir%\abs.zip "%ABSdir%\update"
"%ABSdir%\update\install.bat" update
GOTO :EOF


:UNINSTALL

Echo Deleting Tape Backup Job...
SCHTASKS /DELETE /TN "ABS Tape Backup" /f
ECHO.
Echo Deleting File Backup Job...
SCHTASKS /DELETE /TN "ABS File Backup" /f
ECHO.
Echo Removing ABS Registry Settings...
REG DELETE "hklm\software\Joskos Solutions" /f
ECHO.
Echo Deleting ABS Installation...
RD /S /Q %BckpLogDir%
RD /S /Q %ABSdir%

GOTO :EOF


:BACKUPTYPE

if /i {%2}=={file} set BckpType=File& GOTO :BACKUP
if /i {%2}=={tape} set BckpType=Tape& GOTO :BACKUP

ECHO Backup media type not specified.
ECHO Valid entries are FILE and TAPE.
GOTO :EOF


:BACKUP

if /i "%HTMLReports%"=="0x0" (

echo =============================================== > "%BckpRprt%"
echo ^|A^|B^|S^| - Automated Backup Script >> "%BckpRprt%"
echo           %ABSver% %BckpType% Backup Edition >> "%BckpRprt%"
echo. >> "%BckpRprt%"
echo Copyright ^(c^) Arik Fletcher, some components >> "%BckpRprt%"
echo ^(c^) their various owners and/or publishers. >> "%BckpRprt%"
echo =============================================== >> "%BckpRprt%"
echo. >> "%BckpRprt%"
echo BACKUP SETTINGS >> "%BckpRprt%"
echo - Server Name:  "%COMPUTERNAME%" >> "%BckpRprt%"
echo - OS Version:   "%OSName%" >> "%BckpRprt%"
echo - Backup User:  "%USERDOMAIN%\%USERNAME%" >> "%BckpRprt%"
echo - Log Location: "%BckpZipUNC%" >> "%BckpRprt%"
echo. >> "%BckpRprt%"
echo REPORT SETTINGS >> "%BckpRprt%"
echo - Mail Server:  "%SMTPsvr%" >> "%BckpRprt%"
echo - Sender:       "%SMTPsend%" >> "%BckpRprt%"
echo - Recipient^(s^):    "%SMTPrcpt%" >> "%BckpRprt%"
echo - Report Date:  "%DATE%" >> "%BckpRprt%"
echo. >> "%BckpRprt%"
echo =============================================== >> "%BckpRprt%"

) ELSE (

echo ^<html^> > "%BckpRprt%"
echo ^<head^> >> "%BckpRprt%"
echo ^<title^>ABS Backup Report - %BckpDate%^<^/title^> >> "%BckpRprt%"
echo ^<style type="text/css"^> >> "%BckpRprt%"
echo ^<!-- >> "%BckpRprt%"
echo body,td,th {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px; color: #000000} >> "%BckpRprt%"
echo body {background-color: #FFFFFF} >> "%BckpRprt%"
echo .heading {font-size: 36px} >> "%BckpRprt%"
echo .sectiontitle {font-size: 12px; font-weight: bold; color: #FFFFFF} >> "%BckpRprt%"
echo --^> >> "%BckpRprt%"
echo ^<^/style^> >> "%BckpRprt%"
echo ^<^/head^> >> "%BckpRprt%"
echo ^<body^> >> "%BckpRprt%"
echo ^<table width="500" border="0" cellpadding="0" cellspacing="0"^> >> "%BckpRprt%"
echo ^<tr^> >> "%BckpRprt%"
echo ^<td colspan="2"^>^<hr^>^<^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"
echo ^<tr^> >> "%BckpRprt%"
echo ^<td width="150"^>^<span class="heading"^>^|A^|B^|S^|^<^/span^>^<^/td^> >> "%BckpRprt%"
echo ^<td width="364"^>Automated Backup Script^<br^> >> "%BckpRprt%"
echo %ABSver% %BckpType% Backup Edition ^<^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"
echo ^<tr^> >> "%BckpRprt%"
echo ^<td colspan="2"^>^<hr^>^<^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"
echo ^<tr^> >> "%BckpRprt%"
echo ^<td colspan="2"^>Copyright ^(c^) Arik Fletcher, some components ^(c^) their various owners and^/or publishers.^<^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"
echo ^<tr^> >> "%BckpRprt%"
echo ^<td colspan="2"^>^<hr^>^<^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"
echo ^<tr^> >> "%BckpRprt%"
echo ^<td height="10" colspan="2"^>^<^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"
echo ^<tr^> >> "%BckpRprt%"
echo ^<td colspan="2"^>^<table width="500" border="1" cellpadding="0" cellspacing="0" bordercolor="#000066"^> >> "%BckpRprt%"
echo ^<tr bgcolor="#000066"^> >> "%BckpRprt%"
echo ^<td height="30" colspan="2"^>^<span class="sectiontitle"^>BACKUP SETTINGS ^<^/span^>^<^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"
echo ^<tr^> >> "%BckpRprt%"
echo ^<td width="110" bgcolor="#9999FF"^>^<strong^>Server Name^<^/strong^>^<^/td^> >> "%BckpRprt%"
echo ^<td^>%COMPUTERNAME%^<^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"
echo ^<tr^> >> "%BckpRprt%"
echo ^<td width="110" bgcolor="#9999FF"^>^<strong^>OS Version^<^/strong^>^<^/td^> >> "%BckpRprt%"
echo ^<td^>%OSNAME%^<^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"
echo ^<tr^> >> "%BckpRprt%"
echo ^<td width="110" bgcolor="#9999FF"^>^<strong^>Backup User^<^/strong^>^<^/td^> >> "%BckpRprt%"
echo ^<td^>%USERDOMAIN%\%USERNAME%^<^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"
echo ^<tr^> >> "%BckpRprt%"
echo ^<td width="110" bgcolor="#9999FF"^>^<strong^>Log Location^<^/strong^>^<^/td^> >> "%BckpRprt%"
echo ^<td^>%BckpZipUNC%^<^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"
echo ^<^/table^> ^<^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"
echo ^<tr^> >> "%BckpRprt%"
echo ^<td height="10" colspan="2"^>^<^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"
echo ^<tr^> >> "%BckpRprt%"
echo ^<td colspan="2"^>^<table width="500" border="1" cellpadding="0" cellspacing="0" bordercolor="#000066"^> >> "%BckpRprt%"
echo ^<tr bgcolor="#000066"^> >> "%BckpRprt%"
echo ^<td height="30" colspan="2"^>^<span class="sectiontitle"^>REPORT SETTINGS ^<^/span^>^<^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"
echo ^<tr^> >> "%BckpRprt%"
echo ^<td width="110" bgcolor="#9999FF"^>^<strong^>Mail Server^<^/strong^>^<^/td^> >> "%BckpRprt%"
echo ^<td^>%SMTPsvr%^<^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"
echo ^<tr^> >> "%BckpRprt%"
echo ^<td width="110" bgcolor="#9999FF"^>^<strong^>Sender ^<^/strong^>^<^/td^> >> "%BckpRprt%"
echo ^<td^>%SMTPsend%^<^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"
echo ^<tr^> >> "%BckpRprt%"
echo ^<td width="110" bgcolor="#9999FF"^>^<strong^>Recipient^(s^) ^<^/strong^>^<^/td^> >> "%BckpRprt%"
echo ^<td^>%SMTPrcpt%^<^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"
echo ^<tr^> >> "%BckpRprt%"
echo ^<td bgcolor="#9999FF"^>^<strong^>Report Date ^<^/strong^>^<^/td^> >> "%BckpRprt%"
echo ^<td^>%Date%^<^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"
echo ^<^/table^> ^<^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"
echo ^<tr^> >> "%BckpRprt%"
echo ^<td height="10" colspan="2"^>^<^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"
echo ^<tr^> >> "%BckpRprt%"
echo ^<td colspan="2"^>^<hr^>^<^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"

)

:OLDLOGS

for /f %%a in ('time /t') do set OLDLOGSTART=%%a

if /i "%HTMLReports%"=="0x0" (

echo. >> "%BckpRprt%"
echo %OLDLOGSTART% - Removing redundant Backup Logs ^(if present^)... >> "%BckpRprt%"
echo. >> "%BckpRprt%"

) ELSE (

echo ^<tr^> >> "%BckpRprt%"
echo ^<td height="10" colspan="2"^>^<^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"
echo ^<tr^> >> "%BckpRprt%"
echo ^<td colspan="2"^>^<table width="500" border="1" cellpadding="0" cellspacing="0" bordercolor="#0066FF"^> >> "%BckpRprt%"
echo ^<tr bgcolor="#3300FF"^> >> "%BckpRprt%"
echo ^<td height="30" bgcolor="#3300FF"^>^<span class="sectiontitle"^>%OLDLOGSTART% - Removing Redundant Backup Logs ^<^/span^>^<^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"

)

if exist "%TMPlogs%" (

del "%TMPlogs%" /f /q

if /i "%HTMLReports%"=="0x0" (

echo * Redundant Backup Logs removed successfully. >> "%BckpRprt%"
echo. >> "%BckpRprt%"

) else (

echo ^<tr^> >> "%BckpRprt%"
echo ^<td^>^<p^>^<ul^>^<li^>^<b^>^<font color=green^>Redundant Backup Logs removed successfully.^<^/font^>^<^/b^>^<^/ul^>^<^/p^>^<^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"

)

) else (

if /i "%HTMLReports%"=="0x0" (

echo * No redundant logs found. >> "%BckpRprt%"
echo. >> "%BckpRprt%"

) else (

echo ^<tr^> >> "%BckpRprt%"
echo ^<td^>^<p^>^<ul^>^<li^>^<b^>^<font color=red^>No redundant logs found.^<^/font^>^<^/b^>^<^/ul^>^<^/p^>^<^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"

)

)

for /f %%a in ('time /t') do set OLDLOGEND=%%a

for /f "tokens=1 delims=:" %%a in ('echo %oldlogstart%') do set STARTHOUR=%%a
for /f "tokens=2 delims=:" %%a in ('echo %oldlogstart%') do set STARTMINS=%%a
for /f "tokens=1 delims=:" %%a in ('echo %oldlogend%') do set ENDHOUR=%%a
for /f "tokens=2 delims=:" %%a in ('echo %oldlogend%') do set ENDMINS=%%a

set /a HOURSRUN=%ENDHOUR%-%STARTHOUR%

IF /i "%ENDMINS%" LSS "%STARTMINS%" set /a MINSRUN=%ENDMINS%+(60-%STARTMINS%)
IF /i "%ENDMINS%" GEQ "%STARTMINS%" set /a MINSRUN=%ENDMINS%+(60-%STARTMINS%)-60


if /i "%HTMLReports%"=="0x0" (

echo ------------------------------ >> "%BckpRprt%"
if "%HOURSRUN%" LEQ "0" echo Time Elapsed: %MINSRUN% Minute^(s^) >> "%BckpRprt%"
if "%HOURSRUN%" GEQ "1" echo Time Elapsed: %HOURSRUN% Hour^(s^) %MINSRUN% Minute^(s^) >> "%BckpRprt%"
echo ------------------------------ >> "%BckpRprt%"
) else (

echo ^<tr^> >> "%BckpRprt%"
if "%HOURSRUN%" LEQ "0" echo ^<td bgcolor="#9999FF"^>^<strong^>Time Elapsed: ^<^/strong^>%MINSRUN% Minute^(s^)^<^/td^> >> "%BckpRprt%"
if "%HOURSRUN%" GEQ "1" echo ^<td bgcolor="#9999FF"^>^<strong^>Time Elapsed: ^<^/strong^>%HOURSRUN% Hour^(s^) %MINSRUN% Minute^(s^)^<^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"
echo ^<^/table^> ^<^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"

)


:BCKPINIT

for /f %%a in ('time /t') do set BCKPINITSTART=%%a

if /i "%HTMLReports%"=="0x0" (

echo. >> "%BckpRprt%"
echo %BCKPINITSTART% - Performing Backup... >> "%BckpRprt%"
echo. >> "%BckpRprt%"

) ELSE (

echo ^<tr^> >> "%BckpRprt%"
echo ^<td height="20" colspan="2"^>^<^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"
echo ^<tr^> >> "%BckpRprt%"
echo ^<td colspan="2"^>^<table width="500" border="1" cellpadding="0" cellspacing="0" bordercolor="#0066FF"^> >> "%BckpRprt%"
echo ^<tr bgcolor="#3300FF"^> >> "%BckpRprt%"
echo ^<td height="30" bgcolor="#3300FF"^>^<span class="sectiontitle"^>%BCKPINITSTART% - Performing Backup^<^/span^>^<^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"

)

if /i {%bckptype%}=={tape} GOTO :BCKPTAPE
if /i {%bckptype%}=={file} GOTO :BCKPFILE


:BCKPTAPE

IF "%OSVer%"=="Version.5" SET BckpParams1=/j "%BckpDate%" /n "%BckpDate%" /p "%BckpTapeDst%" /V:yes /L:f /HC:on /M normal /UM
IF "%OSVer%"=="5.1" SET BckpParams1=/j "%BckpDate%" /n "%BckpDate%" /p "%BckpTapeDst%" /V:yes /L:f /HC:on /SNAP:on /M normal /UM
IF "%OSVer%"=="5.2" SET BckpParams1=/j "%BckpDate%" /n "%BckpDate%" /p "%BckpTapeDst%" /V:yes /L:f /HC:on /SNAP:on /M normal /UM

IF "%OSVer%"=="Version.5" SET BckpParams2=/j "Mail-%BckpDate%" /n "%BckpDate%" /p "%BckpTapeDst%" /A /V:yes /L:f /HC:on /M normal /UM
IF "%OSVer%"=="5.1" SET BckpParams2=/j "Mail-%BckpDate%" /n "%BckpDate%" /p "%BckpTapeDst%" /A /V:yes /L:f /HC:on /M normal /UM
IF "%OSVer%"=="5.2" SET BckpParams2=/j "Mail-%BckpDate%" /n "%BckpDate%" /p "%BckpTapeDst%" /A /V:yes /L:f /HC:on /M normal /UM


GOTO :BCKPSTART


:BCKPFILE

IF "%OSVer%"=="Version.5" SET BckpParams1=%BckpSrc% /j "%BckpDate%" /f "%BckpFileDst%" /V:yes /L:f /M normal
IF "%OSVer%"=="5.1" SET BckpParams1=/j "%BckpDate%" /f "%BckpFileDst%" /V:yes /L:f /M normal /SNAP:on
IF "%OSVer%"=="5.2" SET BckpParams1=/j "%BckpDate%" /f "%BckpFileDst%" /V:yes /L:f /M normal /SNAP:on

IF "%OSVer%"=="Version.5" SET BckpParams2=%BckpSrc% /j "Mail-%BckpDate%" /f "%BckpFileDst%" /A /V:yes /L:f /M normal
IF "%OSVer%"=="5.1" SET BckpParams2=/j "Mail-%BckpDate%" /f "%BckpFileDst%" /A /V:yes /L:f /M normal
IF "%OSVer%"=="5.2" SET BckpParams2=/j "Mail-%BckpDate%" /f "%BckpFileDst%" /A /V:yes /L:f /M normal

GOTO :BCKPSTART


:BCKPSTART

if /i "%sharepoint%"=="0x1" "%systemdrive%\Program Files\Common Files\Microsoft Shared\web server extensions\60\BIN\stsadm.exe" -o backup -url http://localhost -filename "%BckpSharepoint%" -overwrite
)

redshirt /d %BckpSrcEnc% %BckpSrc%
if not "%BckpSrc%"=="SystemState" (
ntbackup backup @%BckpSrc% %BckpParams1%
) ELSE (
ntbackup backup %BckpSrc% %BckpParams1%
)

del %BckpSrc% /q

if exist "%absdir%\mail.dat" (
redshirt /d "%absdir%\mail.dat" "%absdir%\mail.bks"
ntbackup backup "%absdir%\mail.bks" %BckpParams1%
del "%absdir%\mail.bks" /q
)

if /i "%sharepoint%"=="0x1" (
del /q "%BckpSharepoint%"
)

GOTO :TMPLOGCHECK


:TMPLOGCHECK

if exist "%TmpLogs%" (

if /i "%HTMLReports%"=="0x0" (

echo * Backup Log created successfully. >> "%BckpRprt%"
echo. >> "%BckpRprt%"

) else (

echo ^<tr^> >> "%BckpRprt%"
echo ^<td^>^<p^>^<ul^>^<li^>^<b^>^<font color=green^>Backup Log created successfully.^<^/font^>^<^/b^>^<^/ul^>^<^/p^>^<^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"

)

) else (


GOTO :BCKPSTART


)

for /f %%a in ('time /t') do set BCKPINITEND=%%a

for /f "tokens=1 delims=:" %%a in ('echo %bckpinitstart%') do set STARTHOUR=%%a
for /f "tokens=2 delims=:" %%a in ('echo %bckpinitstart%') do set STARTMINS=%%a
for /f "tokens=1 delims=:" %%a in ('echo %bckpinitend%') do set ENDHOUR=%%a
for /f "tokens=2 delims=:" %%a in ('echo %bckpinitend%') do set ENDMINS=%%a

set /a HOURSRUN=%ENDHOUR%-%STARTHOUR%

IF /i "%ENDMINS%" LSS "%STARTMINS%" set /a MINSRUN=%ENDMINS%+(60-%STARTMINS%)
IF /i "%ENDMINS%" GEQ "%STARTMINS%" set /a MINSRUN=%ENDMINS%+(60-%STARTMINS%)-60

if /i "%HTMLReports%"=="0x0" (

echo ------------------------------ >> "%BckpRprt%"
if "%HOURSRUN%" LEQ "0" echo Time Elapsed: %MINSRUN% Minute^(s^) >> "%BckpRprt%"
if "%HOURSRUN%" GEQ "1" echo Time Elapsed: %HOURSRUN% Hour^(s^) %MINSRUN% Minute^(s^) >> "%BckpRprt%"
echo ------------------------------ >> "%BckpRprt%"

) else (

echo ^<tr^> >> "%BckpRprt%"
if "%HOURSRUN%" LEQ "0" echo ^<td bgcolor="#9999FF"^>^<strong^>Time Elapsed: ^<^/strong^>%MINSRUN% Minute^(s^)^<^/td^> >> "%BckpRprt%"
if "%HOURSRUN%" GEQ "1" echo ^<td bgcolor="#9999FF"^>^<strong^>Time Elapsed: ^<^/strong^>%HOURSRUN% Hour^(s^) %MINSRUN% Minute^(s^)^<^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"
echo ^<^/table^> ^<^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"

)


:LOGCHECK

for /f %%a in ('time /t') do set LOGCHECKSTART=%%a

if /i "%HTMLReports%"=="0x0" (

echo. >> "%BckpRprt%"
echo %LOGCHECKSTART% - Analysing Backup Log... >> "%BckpRprt%"
echo. >> "%BckpRprt%"

) ELSE (

echo ^<tr^> >> "%BckpRprt%"
echo ^<td height="20" colspan="2"^>^<^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"
echo ^<tr^> >> "%BckpRprt%"
echo ^<td colspan="2"^>^<table width="500" border="1" cellpadding="0" cellspacing="0" bordercolor="#0066FF"^> >> "%BckpRprt%"
echo ^<tr bgcolor="#3300FF"^> >> "%BckpRprt%"
echo ^<td height="30" bgcolor="#3300FF"^>^<span class="sectiontitle"^>%LOGCHECKSTART% - Analysing Backup Log^<^/span^>^<^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"
)

for /F %%a in ('type "%TmpLogs%" ^| find /i /c "Backup Status"') do set BckpChk=%%a

if "%BckpChk%"=="1" (
GOTO :LOGCHECK2
) ELSE (
GOTO :LOGFAIL
)

:LOGCHECK2

for /F %%a in ('type "%TmpLogs%" ^| find /i /c "Verify Started"') do if "%%a"=="0" set BckpErr=1
for /F %%a in ('type "%TmpLogs%" ^| find /i /c "end of Media encountered"') do if not "%%a"=="0" set BckpErr=2
for /F %%a in ('type "%TmpLogs%" ^| find /i /c "requested media failed to mount"') do if not "%%a"=="0" set BckpErr=3
for /F %%a in ('type "%TmpLogs%" ^| find /i /c "invalid Removable Storage backup destination"') do if not "%%a"=="0" set BckpErr=4

if defined BckpErr (

if /i "%HTMLReports%"=="0x0" (

echo * Backup did not complete successfully. >> "%BckpRprt%"
echo. >> "%BckpRprt%"
if "%BckpErr%"=="1" echo There may be a fault with the backup media or device. >> "%BckpRprt%"
if "%BckpErr%"=="2" echo The backup media or device may have been unavailable. >> "%BckpRprt%"
if "%BckpErr%"=="3" echo There may be insufficient space on the backup media. >> "%BckpRprt%"
if "%BckpErr%"=="4" echo An invalid backup media type was specified. >> "%BckpRprt%"
echo Please examine the backup log for more information. >> "%BckpRprt%"
echo. >> "%BckpRprt%"

) else (

echo ^<tr^> >> "%BckpRprt%"
echo ^<td^>^<p^>^<ul^>^<li^>^<b^>^<font color=red^>Backup did not complete successfully.^<^/font^> >> "%BckpRprt%"
if "%BckpErr%"=="1" echo ^<br^>There may be a fault with the backup media or device.^<^/b^>^<^/ul^>^<^/p^> >> "%BckpRprt%"
if "%BckpErr%"=="2" echo ^<br^>The backup media or device may have been unavailable.^<^/b^>^<^/ul^>^<^/p^> >> "%BckpRprt%"
if "%BckpErr%"=="3" echo ^<br^>There may be insufficient space on the backup media.^<^/b^>^<^/ul^>^<^/p^> >> "%BckpRprt%"
if "%BckpErr%"=="4" echo ^<br^>An invalid backup media type was specified.^<^/b^>^<^/ul^>^<^/p^> >> "%BckpRprt%"
echo ^<p^>^<b^>Please examine the backup log for more information.^<^/b^>^<^/p^><^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"

)

) else (

if /i "%HTMLReports%"=="0x0" (

echo * Backup completed successfully. >> "%BckpRprt%"

) else (

echo ^<tr^> >> "%BckpRprt%"
echo ^<td^>^<p^>^<ul^>^<li^>^<b^>^<font color=green^>Backup completed successfully.^<^/font^> >> "%BckpRprt%"

) 

)

GOTO :LOGSKIP

:LOGFAIL

set BckpErr=0

if /i "%HTMLReports%"=="0x0" (

echo * Backup did not complete successfully. >> "%BckpRprt%"
echo   A serious error was detected with your configuration. >> "%BckpRprt%"
echo. >> "%BckpRprt%"
echo Please check your backup hardware and reconfigure ABS. >> "%BckpRprt%"
echo. >> "%BckpRprt%"

) else (

echo ^<tr^> >> "%BckpRprt%"
echo ^<td^>^<p^>^<ul^>^<li^>^<b^>^<font color=red^>Backup did not complete successfully.^<^/font^> >> "%BckpRprt%"
echo ^<br^>A serious error was detected with your configuration.^<^/b^>^<^/ul^>^<^/p^> >> "%BckpRprt%"
echo ^<p^>^<b^>Please check your backup hardware and reconfigure ABS.^<^/b^>^<^/p^><^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"

)


:LOGSKIP

for /F %%a in ('type "%TmpLogs%" ^| find /i /c " - skipped."') do set BckpSkip=%%a

if "%BckpSkip%"=="0" (

if /i "%HTMLReports%"=="0x0" (

echo * No objects were skipped during backup. >> "%BckpRprt%"
echo. >> "%BckpRprt%"

) else (

echo ^<tr^> >> "%BckpRprt%"
echo ^<td^>^<p^>^<ul^>^<li^>^<b^>^<font color=green^>No objects were skipped during backup.^<^/font^>^<^/b^>^<^/ul^>^<^/p^>^<^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"

)

) else (

if /i "%HTMLReports%"=="0x0" (

echo * Some files/folders were found to be open or in use and were not backed up. >> "%BckpRprt%"
echo   Backup reported %BckpSkip% open object^(s^) which have been skipped. >> "%BckpRprt%"
echo. >> "%BckpRprt%"
echo Please examine the backup log for more information. >> "%BckpRprt%"
echo. >> "%BckpRprt%"

) else (

echo ^<tr^> >> "%BckpRprt%"
echo ^<td^>^<ul^>^<p^>^<li^>^<b^>^<font color=red^>Some files/folders were found to be open or in use and were not backed up.^<^/b^> >> "%BckpRprt%"
echo ^<br^>^<b^>Backup reported %BckpSkip% open object^(s^) which have been skipped.^<^/font^>^<^/b^>^<^/p^>^<^/ul^>^ >> "%BckpRprt%"
echo ^<p^>^<b^>Please examine the backup log for more information.^<^/b^>^<^/p^><^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"

)

)


for /f %%a in ('time /t') do set LOGCHECKEND=%%a

for /f "tokens=1 delims=:" %%a in ('echo %logcheckstart%') do set STARTHOUR=%%a
for /f "tokens=2 delims=:" %%a in ('echo %logcheckstart%') do set STARTMINS=%%a
for /f "tokens=1 delims=:" %%a in ('echo %logcheckend%') do set ENDHOUR=%%a
for /f "tokens=2 delims=:" %%a in ('echo %logcheckend%') do set ENDMINS=%%a

set /a HOURSRUN=%ENDHOUR%-%STARTHOUR%

IF /i "%ENDMINS%" LSS "%STARTMINS%" set /a MINSRUN=%ENDMINS%+(60-%STARTMINS%)
IF /i "%ENDMINS%" GEQ "%STARTMINS%" set /a MINSRUN=%ENDMINS%+(60-%STARTMINS%)-60


if /i "%HTMLReports%"=="0x0" (

echo ------------------------------ >> "%BckpRprt%"
if "%HOURSRUN%" LEQ "0" echo Time Elapsed: %MINSRUN% Minute^(s^) >> "%BckpRprt%"
if "%HOURSRUN%" GEQ "1" echo Time Elapsed: %HOURSRUN% Hour^(s^) %MINSRUN% Minute^(s^) >> "%BckpRprt%"
echo ------------------------------ >> "%BckpRprt%"

) else (

echo ^<tr^> >> "%BckpRprt%"
if "%HOURSRUN%" LEQ "0" echo ^<td bgcolor="#9999FF"^>^<strong^>Time Elapsed: ^<^/strong^>%MINSRUN% Minute^(s^)^<^/td^> >> "%BckpRprt%"
if "%HOURSRUN%" GEQ "1" echo ^<td bgcolor="#9999FF"^>^<strong^>Time Elapsed: ^<^/strong^>%HOURSRUN% Hour^(s^) %MINSRUN% Minute^(s^)^<^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"
echo ^<^/table^> ^<^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"

)


:LOGSECURE

for /f %%a in ('time /t') do set LOGSECSTART=%%a

if /i "%HTMLReports%"=="0x0" (

echo. >> "%BckpRprt%"
echo %LOGSECSTART% - Securing Backup Log... >> "%BckpRprt%"
echo. >> "%BckpRprt%"

) ELSE (

echo ^<tr^> >> "%BckpRprt%"
echo ^<td height="20" colspan="2"^>^<^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"
echo ^<tr^> >> "%BckpRprt%"
echo ^<td colspan="2"^>^<table width="500" border="1" cellpadding="0" cellspacing="0" bordercolor="#0066FF"^> >> "%BckpRprt%"
echo ^<tr bgcolor="#3300FF"^> >> "%BckpRprt%"
echo ^<td height="30" bgcolor="#3300FF"^>^<span class="sectiontitle"^>%LOGSECSTART% - Securing Backup Log^<^/span^>^<^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"

)

copy "%TmpLogs%" "%Bckplog%" /v /y

if exist "%Bckplog%" (

if /i "%HTMLReports%"=="0x0" (

echo * Backup Log relocated successfully. >> "%BckpRprt%"

) else (

echo ^<tr^> >> "%BckpRprt%"
echo ^<td^>^<p^>^<ul^>^<li^>^<b^>^<font color=green^>Backup Log relocated successfully.^<^/font^>^<^/b^>^<^/ul^>^<^/p^>^<^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"

)

) else (

if /i "%HTMLReports%"=="0x0" (

echo * Log could not be relocated. >> "%BckpRprt%"
echo   Please examine the original log file: >> "%BckpRprt%"
for /f "delims=" %%a in ('dir /b "%TmpLogs%"') do echo %tmpdir%\%%a >> "%BckpRprt%"


) else (

echo ^<tr^> >> "%BckpRprt%"
echo ^<td^>^<ul^>^<p^>^<li^>^<b^>^<font color=red^>Backup Log could not be relocated.^<^/b^>^<^/p^> >> "%BckpRprt%"
echo ^<p^>^<b^>Please examine the original log file:^<^/b^> >> "%BckpRprt%"
for /f "delims=" %%a in ('dir /b "%TmpLogs%"') do echo ^<br^>%tmpdir%\%%a^<^/font^>^<^/p^>^<^/ul^>^<^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"

)

)

fbzip -a %Bckpzip% "%Bckplog%"

if exist "%Bckpzip%" (

del "%BckpLog%"

if /i "%HTMLReports%"=="0x0" (

echo * Backup Log compressed successfully. >> "%BckpRprt%"
echo. >> "%BckpRprt%"

) else (

echo ^<tr^> >> "%BckpRprt%"
echo ^<td^>^<p^>^<ul^>^<li^>^<b^>^<font color=green^>Backup Log compressed successfully.^<^/font^>^<^/b^>^<^/ul^>^<^/p^>^<^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"

)

) else (

if /i "%HTMLReports%"=="0x0" (

echo * Backup Log could not be compressed. >> "%BckpRprt%"
echo. >> "%BckpRprt%"

) else (

echo ^<tr^> >> "%BckpRprt%"
echo ^<td^>^<p^>^<ul^>^<li^>^<b^>^<font color=green^>Backup Log could not be compressed.^<^/font^>^<^/b^>^<^/ul^>^<^/p^>^<^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"

)

)


for /f %%a in ('time /t') do set LOGSECEND=%%a

for /f "tokens=1 delims=:" %%a in ('echo %logsecstart%') do set STARTHOUR=%%a
for /f "tokens=2 delims=:" %%a in ('echo %logsecstart%') do set STARTMINS=%%a
for /f "tokens=1 delims=:" %%a in ('echo %logsecend%') do set ENDHOUR=%%a
for /f "tokens=2 delims=:" %%a in ('echo %logsecend%') do set ENDMINS=%%a

set /a HOURSRUN=%ENDHOUR%-%STARTHOUR%

IF /i "%ENDMINS%" LSS "%STARTMINS%" set /a MINSRUN=%ENDMINS%+(60-%STARTMINS%)
IF /i "%ENDMINS%" GEQ "%STARTMINS%" set /a MINSRUN=%ENDMINS%+(60-%STARTMINS%)-60


if /i "%HTMLReports%"=="0x0" (

echo ------------------------------ >> "%BckpRprt%"
if "%HOURSRUN%" LEQ "0" echo Time Elapsed: %MINSRUN% Minute^(s^) >> "%BckpRprt%"
if "%HOURSRUN%" GEQ "1" echo Time Elapsed: %HOURSRUN% Hour^(s^) %MINSRUN% Minute^(s^) >> "%BckpRprt%"
echo ------------------------------ >> "%BckpRprt%"

) else (

echo ^<tr^> >> "%BckpRprt%"
if "%HOURSRUN%" LEQ "0" echo ^<td bgcolor="#9999FF"^>^<strong^>Time Elapsed: ^<^/strong^>%MINSRUN% Minute^(s^)^<^/td^> >> "%BckpRprt%"
if "%HOURSRUN%" GEQ "1" echo ^<td bgcolor="#9999FF"^>^<strong^>Time Elapsed: ^<^/strong^>%HOURSRUN% Hour^(s^) %MINSRUN% Minute^(s^)^<^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"
echo ^<^/table^> ^<^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"

)

:BCKPEND

for /f %%a in ('time /t') do set endtime=%%a

for /f "tokens=1 delims=:" %%a in ('echo %starttime%') do set STARTHOUR=%%a
for /f "tokens=2 delims=:" %%a in ('echo %starttime%') do set STARTMINS=%%a
for /f "tokens=1 delims=:" %%a in ('echo %endtime%') do set ENDHOUR=%%a
for /f "tokens=2 delims=:" %%a in ('echo %endtime%') do set ENDMINS=%%a

set /a HOURSRUN=%ENDHOUR%-%STARTHOUR%

IF /i "%ENDMINS%" LSS "%STARTMINS%" set /a MINSRUN=%ENDMINS%+(60-%STARTMINS%)
IF /i "%ENDMINS%" GEQ "%STARTMINS%" set /a MINSRUN=%ENDMINS%+(60-%STARTMINS%)-60

if /i "%HTMLReports%"=="0x0" (

echo. >> "%BckpRprt%"
echo =============================================== >> "%BckpRprt%"
echo %ENDTIME% - ABS session completed >> "%BckpRprt%"
if "%HOURSRUN%" LEQ "0" echo Total Time Elapsed: %MINSRUN% Minute^(s^) >> "%BckpRprt%"
if "%HOURSRUN%" GEQ "1" echo Total Time Elapsed: %HOURSRUN% Hour^(s^) %MINSRUN% Minute^(s^) >> "%BckpRprt%"
echo =============================================== >> "%BckpRprt%"

) else (

echo ^<tr^> >> "%BckpRprt%"
echo ^<td height="10" colspan="2"^>^<^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"
echo ^<tr^> >> "%BckpRprt%"
echo ^<td colspan="2"^>^<hr^>^<^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"
echo ^<tr^> >> "%BckpRprt%"
echo ^<td height="10" colspan="2"^>^<p^>^<b^>%ENDTIME% - ABS session completed^<^/b^> >> "%BckpRprt%"
if "%HOURSRUN%" LEQ "0" echo ^<br^>^<b^>Total Time Elapsed: ^<^/b^>%MINSRUN% Minute^(s^)^<^/p^> >> "%BckpRprt%" >> "%BckpRprt%"
if "%HOURSRUN%" GEQ "1" echo ^<br^>^<b^>Total Time Elapsed: ^<^/b^>%HOURSRUN% Hour^(s^) %MINSRUN% Minute^(s^)^<^/p^> >> "%BckpRprt%" >> "%BckpRprt%"
echo ^<^/p^> ^<^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"
echo ^<tr^> >> "%BckpRprt%"
echo ^<td colspan="2"^>^<hr^>^<^/td^> >> "%BckpRprt%"
echo ^<^/tr^> >> "%BckpRprt%"
echo ^<^/table^> >> "%BckpRprt%"
echo ^<^/body^> >> "%BckpRprt%"
echo ^<^/html^> >> "%BckpRprt%"

)


attrib +r "%BckpRprt%"
attrib +r "%BckpZip%"

blat -install "%SMTPsvr%" "%SMTPsend%"


if /i "%HTMLReports%"=="0x0" (

if defined BckpErr blat "%BckpRprt%" -to "%SMTPrcpt%" -subject "%USERDOMAIN% Backup - Failure - %BckpSkip% Skipped File(s)" -priority 1 -attach "%Bckpzip%"
if not defined BckpErr blat "%BckpRprt%" -to "%SMTPrcpt%" -subject "%USERDOMAIN% Backup - Success - %BckpSkip% Skipped File(s)" -attach "%Bckpzip%"

) ELSE (

if defined BckpErr blat "%BckpRprt%" -html -to "%SMTPrcpt%" -subject "%USERDOMAIN% Backup - Failure - %BckpSkip% Skipped File(s)" -priority 1 -attach "%Bckpzip%"
if not defined BckpErr blat "%BckpRprt%" -html -to "%SMTPrcpt%" -subject "%USERDOMAIN% Backup - Success - %BckpSkip% Skipped File(s)" -attach "%Bckpzip%" 

)


:END

if "%ABSDebug%"=="1" prompt $p$g
GOTO :EOF
