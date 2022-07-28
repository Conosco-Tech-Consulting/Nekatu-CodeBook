@echo off
REM ============================================
REM User Logon Count Tool v1.3
REM ============================================

if "%1"=="/q" goto :Quick
if "%1"=="/e" goto :Export
if "%1"=="/u" goto :Upload
if "%1"=="/?" goto :Help
GOTO :HELP

:Quick
echo.
echo Users logged in today:
for /f %%a in ('date /t') do set today=%%a
cscript c:\UserCount\usrcount.vbs | find "%today%" /c
GOTO :EOF

:Export
echo.
for /f %%a in ('date /t') do set today=%%a

for /f "tokens=2,5 delims= " %%a in ('now') do (
set month=%%a
set year=%%b
)

echo - Exporting today's logons to "%month%%year%.csv"...
for /f "tokens=2,4 delims=,;=" %%a in ('cscript c:\UserCount\usrcount.vbs ^| find "%today%"') do echo %%a,%%b,%today% >> c:\usercount\logs\%month%%year%.csv

GOTO :EOF


:Upload

for /f "tokens=2,5 delims= " %%a in ('now') do (
set month=%%a
set year=%%b
)

cscript //nologo c:\UserCount\SPUpload.vbs "c:\usercount\logs\%month%%year%.csv" "https://admin.odinet.org.uk/facilities/facilitiesrestricted/space/daily logs/AD%month%%year%.csv" odi\administrator Anima!Far3

GOTO :EOF


:Help
echo.
echo User Logon Count Tool
echo.
echo Usage:
echo 	Quick Count-	usrCount.cmd /q
echo 	Export List-	usrCount.cmd /e
echo 	Upload List-	usrCount.cmd /u
echo.
echo Exported lists will be appended to:
echo 	C:\UserCount\Logs\[Month][Year].csv
echo 	e.g. \C:\UserCount\Logs\Jun2010.csv
echo.
echo Uplodade lists will be placed in:
echo 	"Facilities Restricted \ space \ Daily Logs"

GOTO :EOF