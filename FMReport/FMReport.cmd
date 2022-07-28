@echo off
cls

:START

TITLE Automated FM Report - Co-Operative Systems
CALL :INIT

ECHO ===============================================================================
ECHO.
ECHO Automated FM Report Tool (BETA)
ECHO Copyright (c) Co-operative Systems
ECHO.
ECHO ===============================================================================
ECHO.

REM -------------------------------------------------------------------------------
REM Script:    FMReport.cmd (and ./bin contents)
REM Created:   12/03/2008
REM Modified:  13/03/2008
REM Author:    Arik Fletcher
REM -------------------------------------------------------------------------------
REM Description: This script (and the sub-scripts) collect information on the local
REM              system and generate an HTML file containing the current state of
REM              the network. This report is then emailed to the closeout folder
REM              and any other specified addresses.
REM -------------------------------------------------------------------------------

CALL :REQCHECK

:SESSION

echo Please enter your full name: [e.g. John Doe]
set /p engineer=
echo.

echo Please enter the session code: [e.g. ABC] 
set /p code=
echo.

echo Please enter the site name or initials: [e.g. CS]
set /p site=
echo.

echo Please select a session:
echo.
echo [A] Full Day
echo [B] Half Day - AM
echo [C] Half Day - PM
echo.
set /p session=

if /i "%session%"=="A" (
set session=Full Day
goto :TASKLIST
)

if /i "%session%"=="B" (
set session=Half Day - AM
goto :TASKLIST
)

if /i "%session%"=="C" (
set session=Half Day - PM
goto :TASKLIST
)

goto :SESSION

:TASKLIST
cls

copy .\bin\tasklist.rtf %repdir%>nul
start /wait wordpad %repdir%\tasklist.rtf

:HOSTFILES

if "%1"=="" (

CLS
ECHO -------------------------------------------------------------------------------
ECHO Scanning for FM Servers...
ECHO -------------------------------------------------------------------------------

for /f "tokens=1-20 delims=$ " %%a in ('net group "FM Servers" /domain ^| find /i "$"') do (

if not "%%a"=="" echo %%a>> %fmlist%
if not "%%b"=="" echo %%b>> %fmlist%
if not "%%c"=="" echo %%c>> %fmlist%

)

) else (

echo %1>%fmlist%

)

if "%2"=="" (

CLS
ECHO -------------------------------------------------------------------------------
ECHO Scanning for Exchange Servers...
ECHO -------------------------------------------------------------------------------

for /f "tokens=1-20 delims=$ " %%a in ('net group "Exchange Domain Servers" /domain ^| find /i "$"') do (

if not "%%a"=="" echo %%a>> %exlist%
if not "%%b"=="" echo %%b>> %exlist%
if not "%%c"=="" echo %%c>> %exlist%

)

) else (

echo %2>%exlist%

)

:HOSTINFO
for /f %%a in (%fmlist%) do (

cls
ECHO -------------------------------------------------------------------------------
ECHO Gathering System Information for %%a...
ECHO -------------------------------------------------------------------------------

if not exist \\%%a\admin$ (

echo Host Name^: %%a>%repdir%\%%a-info.log
echo OS Name^: Unknown>>%repdir%\%%a-info.log
echo OS Configuration^: Unknown>>%repdir%\%%a-info.log
echo System Up Time^: Unknown>>%repdir%\%%a-info.log
echo System Manufacturer^: Unknown>>%repdir%\%%a-info.log
echo System Model^: Unknown>>%repdir%\%%a-info.log
echo System Type^: Unknown>>%repdir%\%%a-info.log
echo Total Physical Memory^: Unknown>>%repdir%\%%a-info.log
echo Available Physical Memory^: Unknown>>%repdir%\%%a-info.log

) else (

systeminfo /FO LIST /s %%a>%repdir%\%%a-info.log

)

)

for /f %%a in (%exlist%) do (

cscript //nologo .\bin\storesize.vbs %%a>%repdir%\%%a-mail.log

)


:REPORTSTYLE
cls

ECHO -------------------------------------------------------------------------------
ECHO Generating FM Report...
ECHO -------------------------------------------------------------------------------

echo ^<html^>^<title^>%userdomain% FM Report - %date%^</title^> > %report%
echo ^<style type="text/css"^> >> "%report%"
echo ^<!-- >> "%report%"
echo body {background-color: #FFFFFF} body,td,th {font-family: Verdana; font-size: 10px; color: #000000} .logo {font-family: Tahoma; font-size: 18px; font-weight: bold; color: #006699} .heading {font-family: Arial; font-size: 18px} .section {font-size: 14px; font-weight: bold; background-color: #CCCCFF} .fieldtitle {font-size: 10px; font-weight: bold; background-color: #EEEEEE; width: 130; height: 30} .fieldtext {font-size: 10px; font-weight: normal; background-color: #FFFFFF; width: 230; height: 30} >> "%report%"
echo --^> >> "%report%"
echo ^<^/style^> >> "%report%"


:REPORTHEAD

echo ^<body leftmargin=0px topmargin=0px marginwidth=0px marginheight=0px^>^<table^> >> %report%
echo ^<tr^>^<td colspan=20^>^<hr^>^</td^>^</tr^> >> %report%
echo ^<tr^>^<td class=logo^>^<center^>%date%^</center^>^</td^> >> %report%
echo ^<td class=heading^ colspan=19^>^<strong^>Co-Operative Systems FM Report^</strong^> >> %report%
echo ^<tr^>^<td colspan=20^>^<hr^>^</td^>^</tr^> >> %report%

:SITEINFO

echo ^<tr^>^<td colspan=20 class=section^>SITE INFORMATION^</td^>^</tr^> >> %report%

echo ^<tr^>^<td class=fieldtitle^>Engineer^</td^> >> %report%
echo ^<td class=fieldtext^>%engineer%^</td^> >> %report%
echo ^</tr^> >> %report%

echo ^<tr^>^<td class=fieldtitle^>Site Name^</td^> >> %report%
echo ^<td class=fieldtext^>%site%^</td^> >> %report%
echo ^</tr^> >> %report%

echo ^<tr^>^<td class=fieldtitle^>Session Code^</td^> >> %report%
echo ^<td class=fieldtext^>%code%^</td^> >> %report%
echo ^</tr^> >> %report%

echo ^<tr^>^<td class=fieldtitle^>Session Type^</td^> >> %report%
echo ^<td class=fieldtext^>%session%^</td^> >> %report%
echo ^</tr^> >> %report%

:TASKINFO

echo ^<tr^>^<td colspan=20 class=section^>TASK LIST^</td^>^</tr^> >> %report%

echo ^<tr^>^<td colspan=20^>^<br /^> >> %report%
.\bin\rtf2html %repdir%\tasklist.rtf >> %report%
echo ^<STYLE type=text/css^>body {padding: 0; margin: 0}^</style^> >> %report%
echo ^<br /^>^</td^>^</tr^> >> %report%


:REPORTINFO

echo ^<tr^>^<td colspan=20 class=section^>SYSTEM INFORMATION^</td^>^</tr^> >> %report%

echo ^<tr^>^<td class=fieldtitle^>Hostname^</td^> >> %report%
set var=Host Name
call :SVRINFO
echo ^</tr^> >> %report%

echo ^<tr^>^<td class=fieldtitle^>IP Address^</td^> >> %report%
call :SVRIP
echo ^</tr^> >> %report%

echo ^<tr^>^<td class=fieldtitle^>Operating System^</td^> >> %report%
set var=OS Name
call :SVRINFO
echo ^</tr^> >> %report%

echo ^<tr^>^<td class=fieldtitle^>Roles^</td^> >> %report%
set var=OS Configuration
call :SVRINFO
echo ^</tr^> >> %report%

echo ^<tr^>^<td class=fieldtitle^>Running Time^</td^> >> %report%
set var=System Up Time
call :SVRINFO
echo ^</tr^> >> %report%

echo ^<tr^>^<td class=fieldtitle^>Manufacturer^</td^> >> %report%
set var=System Manufacturer
call :SVRINFO
echo ^</tr^> >> %report%

echo ^<tr^>^<td class=fieldtitle^>Model^</td^> >> %report%
set var=System Model
call :SVRINFO
echo ^</tr^> >> %report%

echo ^<tr^>^<td class=fieldtitle^>Architecture^</td^> >> %report%
set var=System Type
call :SVRINFO
echo ^</tr^> >> %report%

echo ^<tr^>^<td class=fieldtitle^>Service Tag^</td^> >> %report%
call :SVRTAG
echo ^</tr^> >> %report%

echo ^<tr^>^<td class=fieldtitle^>Installed Memory^</td^> >> %report%
set var=Total Physical Memory
call :SVRINFO
echo ^</tr^> >> %report%

echo ^<tr^>^<td class=fieldtitle^>Available Memory^</td^> >> %report%
set var=Available Physical Memory
call :SVRINFO
echo ^</tr^> >> %report%

echo ^<tr^>^<td class=fieldtitle^>Free Space^</td^> >> %report%
call :SVRSPACE
echo ^</tr^> >> %report%

echo ^<tr^>^<td colspan=20 class=section^>EXCHANGE INFORMATION^</td^>^</tr^> >> %report%

echo ^<tr^>^<td class=fieldtitle^>Mail Server^</td^> >> %report%
set var=Exchange Server:
call :EXINFO
echo ^</tr^> >> %report%

echo ^<tr^>^<td class=fieldtitle^>Storage Group^</td^> >> %report%
set var=Private Storage Group:
call :EXINFO
echo ^</tr^> >> %report%

echo ^<tr^>^<td class=fieldtitle^>Mailboxes^</td^> >> %report%
set var=Private Store Mailboxes:
call :EXINFO
echo ^</tr^> >> %report%

echo ^<tr^>^<td class=fieldtitle^>Private Stores^</td^> >> %report%
set var=Private Store Size:
call :EXINFO
echo ^</tr^> >> %report%

echo ^<tr^>^<td class=fieldtitle^>Public Stores^</td^> >> %report%
set var=Public Store Size:
call :EXINFO
echo ^</tr^> >> %report%

echo ^</table^>^</body^>^</html^> >> %report%

start %report%

:REPORTMAIL

cls

ECHO -------------------------------------------------------------------------------
ECHO Emailing Report...
ECHO -------------------------------------------------------------------------------

call :MAILSEND

:END

call :CLEANUP

GOTO :EOF


:SVRINFO

for /f %%a in (%fmlist%) do (

if /i "%var%"=="Host Name" (

echo ^<td class=fieldtext^>^<b^>%%a^</b^>^</td^> >> %report%

) else (

for /f "tokens=2* delims=:" %%b in ('type %repdir%\%%a-info.log^|find /i "%var%"') do (

if "%%c"=="" (
echo ^<td class=fieldtext^>%%b^</td^> >> %report%
) else (
echo ^<td class=fieldtext^>%%b:%%c^</td^> >> %report%
)
)
)
)
GOTO :EOF


:SVRIP

for /f %%a in (%fmlist%) do (
for /f "tokens=2 delims=[]" %%b in ('ping %%a -n 1') do (
echo ^<td class=fieldtext^>%%b^</td^> >> %report%
)
)
GOTO :EOF


:SVRTAG

for /f %%a in (%fmlist%) do (

if not exist \\%%a\admin$ (

echo ^<td class=fieldtext^>Unknown^</td^> >> %report%

) else (

for /f %%b in ('cscript //nologo .\bin\asset.vbs %%a') do (
echo ^<td class=fieldtext^>%%b^</td^> >> %report%
)
)
)
GOTO :EOF

:SVRSPACE

for /f %%a in (%fmlist%) do (

if not exist \\%%a\admin$ (

echo ^<td class=fieldtext^>Unknown^</td^> >> %report%

) else (

echo ^<td class=fieldtext^> >> %report%

for /f "tokens=1,2 delims=," %%b in ('cscript //nologo .\bin\diskfree.vbs %%a') do (
echo ^<b^>%%b^</b^> - %%c MB^<br /^> >> %report%
)

echo ^</td^> >> %report%

)

)

GOTO :EOF


:EXINFO

for /f %%a in (%exlist%) do (
for /f "tokens=2* delims=:" %%b in ('type %repdir%\%%a-mail.log^|find /i "%var%"') do (
echo ^<td class=fieldtext^>%%b^</td^> >> %report%
)
)
GOTO :EOF


:MAILSEND
echo.
echo Please enter any additional email addresses to send the report to:
echo [separate by a "," e.g. client@network.co.uk,test@test.co.uk]
echo.
set /p othermail=

cscript //nologo .\bin\sendmail.vbs "%report%" "(%code%) - %site% - FM Closeout - %DATE%" "arik@coopsys.net" "%othermail%"

GOTO :EOF

:CLEANUP

del /s /q %repdir%
cls

GOTO :EOF

:INIT

set repdir=C:\FMReport
set fmlist=%repdir%\%userdomain%-FM.txt
set exlist=%repdir%\%userdomain%-EX.txt
set report=%repdir%\FM-%userdomain%.htm

for /f %%a in ('date /t') do set date=%%a

if not exist %repdir%\. md %repdir%

CALL :CLEANUP

GOTO :EOF

:REQCHECK

if not exist %systemdrive%\inetpub\. (

echo WARNING:
echo This script requires IIS for the email report functionality. 
echo Please exit and run the script from an IIS-enabled machine.
pause
exit

)

