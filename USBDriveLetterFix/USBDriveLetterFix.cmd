@ECHO OFF

rem   ========================================
TITLE Joskos USB Drive Letter Fix Script v1.0
rem   copyright (c) Joskos Limited
rem   ========================================


:start
echo Searching for available drive letter...
for %%i in (Z Y X W V U T S R Q P O N M L K J I H G F E D C B A) do if not exist %%i:\nul set FREEDRV=%%i & goto checkdrive
echo.

:checkdrive
for /f "tokens=1 delims= " %%q in ("%FREEDRV%") do set FREEDRV=%%q
echo Checking availability of drive %FREEDRV%: ...
echo.
if exist %FREEDRV%:\nul echo Drive %FREEDRV% is already in use. Disconnect drive %FREEDRV% first! & goto end
echo.

echo Creating DISKPART script ...
echo list volume > %temp%\dpscr.txt
echo.

echo Creating second DISKPART script ...
for /f "tokens=2 delims= " %%i in ('diskpart /s %temp%\dpscr.txt ^| find /i "   G   "') do @echo select volume %%i > %temp%\dpscr2.txt
echo assign letter=%FREEDRV% >> %temp%\dpscr2.txt
echo.
echo Executing second DISKPART script. USB stick will be connected to driveletter %FREEDRV%!
diskpart /s %temp%\dpscr2.txt
if errorlevel 1 goto start
echo.
echo Your memory stick is now connected to driveletter %FREEDRV%!
echo.
pause
rem exit

:end