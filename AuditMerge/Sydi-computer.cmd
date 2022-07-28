@echo off
cls

REM =====================================
REM Set SYDI Locations
REM =====================================

echo.
echo Please enter the path to the SYDI files:
set /p sydi=[e.g. D:\SYDI]
echo.
echo Please enter the path to the Client Folder:
set /p client=[e.g. D:\SYDI CLIENTS\ORGNAME]
echo.

cscript.exe "%sydi%\sydi-server.vbs" -wa -ex -sh -o"%sydi%\%computername%.xml" -t%computername%

pause
