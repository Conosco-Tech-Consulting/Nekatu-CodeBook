@echo off

set BckpErr=
set ABSLog=

echo.
echo ==================================================================
echo ^|A^|B^|S^| - Automated Backup Script Log Checking Engine
echo Copyright ^(c^) Arik Fletcher -  arikf@micronicity.co.uk
echo ==================================================================
echo Modifications to the script are not permitted unless express 
echo permission is granted by the author. Please forward requests for 
echo new features to the author at the email address specified above.
echo ==================================================================
echo.

echo Enter the full path to the ABS Backup Log you want to analyse:
set /p ABSLOG=# 
echo.

echo * Performing Error Check 1...
for /F %%a in ('type "%ABSLOG%" ^| find /i /c "backup status"') do set BckpChk=%%a

if "%BckpChk%"=="1" goto :SCAN
goto :FAIL


:SCAN
echo * Performing Error Check 2...
for /F %%a in ('type "%ABSLOG%" ^| find /i /c "verify started"') do if /i "%%a"=="0" set BckpErr=1

echo * Performing Error Check 3...
for /F %%a in ('type "%ABSLOG%" ^| find /i /c "end of media encountered"') do if /i not "%%a"=="0" set BckpErr=2

echo * Performing Error Check 4...
for /F %%a in ('type "%ABSLOG%" ^| find /i /c "requested media failed to mount"') do if /i not "%%a"=="0" set BckpErr=3

echo * Performing Error Check 5...
for /F %%a in ('type "%ABSLOG%" ^| find /i /c "invalid Removable Storage backup destination"') do if /i not "%%a"=="0" set BckpErr=4

if defined BckpErr (

echo.
echo * Backup did not complete successfully. Error %BckpErr%
echo.
if "%BckpErr%"=="1" echo There may be a fault with the backup media or device.
if "%BckpErr%"=="2" echo The backup media or device may have been unavailable.
if "%BckpErr%"=="3" echo There may be insufficient space on the backup media.
if "%BckpErr%"=="4" echo An invalid backup media type was specified.
echo Please examine the backup log for more information.
echo.

) else (

echo * Backup completed successfully.

)

GOTO :end


:FAIL

echo * Backup did not complete successfully.
echo   A serious error was detected with your configuration.
echo.
echo   Please check your backup hardware and reconfigure ABS.

GOTO :end


:END
pause