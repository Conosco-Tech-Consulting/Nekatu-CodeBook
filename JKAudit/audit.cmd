@echo off
cls

echo ---------------------------------------
title  JK Command Line Documentation Tool
echo   Copyright (c) Joskos Solutions Ltd
echo   Version 1.2 - Written by Arik Fletcher
echo ---------------------------------------

echo.
echo Please enter the name of the site: 
set /p site=(e.g. Brentford) # 
echo.
echo Please enter the path to audit script:
set /p root=(e.g. E:\Audit) # 

set audit=%root%\%site%
if not exist %audit%\. md %audit%

rem ---------------------------------------
title Obtaining IP Address...
rem ---------------------------------------
cls

for /f "tokens=2 delims=:" %%a in ('ipconfig /all ^| find /i "IP Address"') do set IP=%%a

if not defined IP (

for /f "tokens=2 delims=:" %%a in ('ipconfig /all ^| find /i "IPv4 Address"') do set IP=%%a

)


rem ---------------------------------------
title Determining Network Address...
rem ---------------------------------------
cls

for /f "tokens=1,2,3 delims=. " %%b in ("%ip%") do set net=%%b.%%c.%%d

for /l %%x in (1,1,254) do (

rem ---------------------------------------
title Scanning %net%.%%x...
rem ---------------------------------------
cls

echo Checking status of %net%.%%x...
	for /f %%y in ('ping %net%.%%x -n 1 ^| find /i /c "reply from"') do (

	if "%%y"=="1" (

		for /f "tokens=1 delims= " %%z in ('nbtstat -a %net%.%%x ^| find /i "<00>  UNIQUE"') do (

			cls
			title Auditing %%z...
			cscript.exe %root%\sydi\sydi-server.vbs -d -ex -o"%audit%\%%z.xml" -t"%net%.%%x"

			)
		)

	)

)