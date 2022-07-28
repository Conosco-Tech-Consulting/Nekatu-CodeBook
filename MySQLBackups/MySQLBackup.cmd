@echo off
cls

if "%1"=="" (
goto :HELP
) else (
goto :AUDIT
)

GOTO :EOF

:AUDIT

if not defined PROGRAMDATA set PROGRAMDATA=%allusersprofile%\Application Data

for /f "tokens=1 delims=" %%a in ('dir /b /a:d "%programdata%\MySQL\MySQL Server 5.1\data"') do (
call :BACKUP %%a %1 %2
)

GOTO :EOF

:BACKUP
echo.
echo Starting Backup of Database: %1
echo ====================================

For /f "tokens=1-3 delims=/ " %%a in ('date /t') do (set dt=%%c%%a%%b)
For /f "tokens=1-3 delims=:." %%a in ('echo %time%') do (set tm=%%a%%b%%c)
set bkupfilename=c:\MySQLBackups\%1_%dt%_%tm%.bak
echo Backing up to file: %bkupfilename%

"c:\Program Files\MySQL\MySQL Server 5.1\bin\mysqldump.exe" %1 --routines -u %2 -p%3 > "%bkupfilename%"

echo Backup Complete!
cls
GOTO :EOF

:HELP

echo.
echo MySQL Backup Script v2.0
echo ====================================
echo.
echo Usage: mysqlbackup.cmd [dbroot] [dbrootpassword]
echo   e.g. mysqlbackup.cmd root password
echo.