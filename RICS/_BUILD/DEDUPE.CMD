@echo off > %2

ECHO - Cleaning %1

for /f "tokens=* delims= " %%a in (%1) do (
find "%%a" < %2 > nul
if errorlevel 1 echo %%a >> %2
)
GOTO :EOF