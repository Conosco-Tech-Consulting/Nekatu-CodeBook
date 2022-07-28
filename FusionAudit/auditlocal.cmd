@echo off
cls

echo ---------------------------------------
title  CS Command Line Documentation Tool
echo   Copyright (c) Co-Operative Systems
echo   Version 1.5 - Written by Arik Fletcher
echo ---------------------------------------

echo.
echo Please enter the name of the site: 
set /p site=(e.g. Brentford) # 

echo.
echo Please enter the path to audit script:
set /p root=(e.g. E:\FUSION) # 

set audit=%root%\%site%
if not exist %audit%\. md %audit%

rem ---------------------------------------
title Scanning %computername%
rem ---------------------------------------
cls

cscript.exe %root%\sydi\sydi-server.vbs -d -ex -o"%audit%\%computername%.xml" -t"%computername%"