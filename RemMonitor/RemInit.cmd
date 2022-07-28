@echo off
cls

echo ---------------------------------------
title  Co-Operative Systems Monitor Daemon
echo   Copyright (c) Co-Operative Systems
echo   Version 1.0 - Written by Arik Fletcher
echo ---------------------------------------

set root="C:\Users\ArikF\Documents\Projects\RemMonitor"
set audit=%root%\Live
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
			cscript.exe %root%\remmonitor.vbs /i %%z smtp.easynet.co.uk scan@coopsys.net arik@coopsys.net

			)
		)

	)

)