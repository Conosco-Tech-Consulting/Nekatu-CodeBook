@echo off

set report=%systemdrive%\Maintenance.log
set recipient=sysbot@joskos.com
set mailserver=192.168.0.2

for /f "tokens=1,2,3 delims=/" %%a in ("%date%") do set shortdate=%%a%%b%%c

echo ============================================================== > %report%
echo System Maintenance Bot v1.0 >> %report%
echo Copyright (c) Arik Fletcher >> %report%
echo ============================================================== >> %report%

echo. >> %report%
echo -------------------------------------------------------------- >> %report%
echo SYSTEM INFORMATION >> %report%
echo -------------------------------------------------------------- >> %report%

echo. >> %report%
echo User:  %username% >> %report%
echo Host:  %computername%.%userdnsdomain% >> %report%
for /f "delims=" %%a in ('ver') do echo OS:    %%a  >> %report%
for /f "tokens=4,5,6,7 delims=. " %%a in ('ipconfig ^| find /i "IP Address"') do echo IP:    %%a.%%b.%%c.%%d >> %report%


echo. >> %report%
echo -------------------------------------------------------------- >> %report%
echo SESSION INFORMATION >> %report%
echo -------------------------------------------------------------- >> %report%

echo. >> %report%
echo Date:  %date% >> %report%
echo Time:  %time% >> %report%
echo. >> %report%
echo Report Location:  %report% >> %report%
echo Email Recipient:  %recipient% >> %report%
echo Email Server IP:  %mailserver% >> %report%
echo. >> %report%


echo. >> %report%
echo -------------------------------------------------------------- >> %report%
echo CHECKING LOCAL ACCOUNT RIGHTS >> %report%
echo -------------------------------------------------------------- >> %report%

echo. >> %report%
echo Local Administrators: >> %report%
for /f "skip=6" %%a in ('net localgroup Administrators ^| find /v /i "The command completed successfully"') do echo * %%a >> %report%
echo. >> %report%
echo Power Users: >> %report%
for /f "tokens=1 skip=6 delims=" %%a in ('net localgroup "Power Users" ^| find /v /i "The command completed successfully"') do echo * %%a >> %report%
echo. >> %report%


echo. >> %report%
echo -------------------------------------------------------------- >> %report%
echo SYSTEM CLEANUP >> %report%
echo -------------------------------------------------------------- >> %report%
echo. >> %report%

if exist "c:\Program Files\CCleaner\CCleaner.exe" (
"c:\Program Files\CCleaner\CCleaner.exe" /auto
)

echo. >> %report%
echo -------------------------------------------------------------- >> %report%
echo TEMPORARY FILES CLEANUP >> %report%
echo -------------------------------------------------------------- >> %report%

echo. >> %report%
for /f %%a in ('DEL /s /q /f "%userprofile%\Local Settings\Temporary Internet Files\*.*" ^| find /i /c "\"') do echo Temporary internet file(s) removed:  %%a >> %report%
for /f %%a in ('DEL /s /q /f "%tmp%\*.*" ^| find /i /c "\"') do echo Temporary install file(s) removed:  %%a >> %report%
echo. >> %report%

for %%i in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do if exist %%i:\nul (

for /f %%a in ('net use ^| find /c /i "%%i:"') do if "%%a"=="0" (

for /f "tokens=3 delims= " %%b in ('dir %%i:\ ^| find /i "bytes free"') do if not "%%b"=="0" (

echo. >> %report%
echo -------------------------------------------------------------- >> %report%
echo DEFRAGMENTING DRIVE %%i:\ >> %report%
echo -------------------------------------------------------------- >> %report%

defrag %%i: -v | find /v /i "copyright" | find /v /i "Windows Disk Defragmenter" >> %report%
echo. >> %report%

)

)

)

echo. >> %report%
echo -------------------------------------------------------------- >> %report%
echo CHECKING AVAILABLE DISK SPACE >> %report%
echo -------------------------------------------------------------- >> %report%
echo. >> %report%

for %%i in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do if exist %%i:\nul (

for /f %%a in ('net use ^| find /c /i "%%i:"') do if "%%a"=="0" (

for /f "tokens=3 delims= " %%a in ('dir %%i:\ ^| find /i "bytes free"') do if not "%%a"=="0" echo %%i:\ - %%a bytes free after defragmentation >> %report%

)

)


echo. >> %report%
echo. >> %report%
echo -------------------------------------------------------------- >> %report%
echo ARCHIVING EVENT LOGS >> %report%
echo -------------------------------------------------------------- >> %report%

echo. >> %report%
echo Saving and Clearing Application Log... >> %report%
psloglist.exe -s application > %systemdrive%\%shortdate%-App-%computername%.csv

echo. >> %report%
echo Saving and Clearing System Log... >> %report%
psloglist.exe -s system > %systemdrive%\%shortdate%-Sys-%computername%.csv

echo. >> %report%
echo Saving and Clearing Security Log... >> %report%
psloglist.exe -s security > %systemdrive%\%shortdate%-Sec-%computername%.csv

echo. >> %report%
echo Compressing Event Logs... >> %report%
fbzip -a %systemdrive%\%shortdate%-%computername%.zip "%systemdrive%\%shortdate%-App-%computername%.csv"
fbzip -a %systemdrive%\%shortdate%-%computername%.zip "%systemdrive%\%shortdate%-Sys-%computername%.csv"
fbzip -a %systemdrive%\%shortdate%-%computername%.zip "%systemdrive%\%shortdate%-Sec-%computername%.csv"

rem echo. >> %report%
rem echo Attaching Event Log Archive to Report Email... >> %report%
rem echo. >> %report%

rem Blat -install "%mailserver%" %computername%@%userdomain%.local 3
rem blat "%report%" -to "%recipient%" -subject "%DATE% Maintenance Session for %COMPUTERNAME%" -attach "%systemdrive%\%shortdate%-%computername%.zip"

if "%errorlevel%"=="0" (

del %report%
del %systemdrive%\%shortdate%-Sec-%computername%.csv
del %systemdrive%\%shortdate%-Sys-%computername%.csv
del %systemdrive%\%shortdate%-App-%computername%.csv
del %systemdrive%\%shortdate%-%computername%.zip

)