@echo off
cls

if "%computername%"=="VAI-DC" goto :EOF

rem ====================================
title Resetting Local Admin Password...
rem ====================================

net user administrator A42dj3d
cls

rem ====================================
title Clearing Old Profiles...
rem ====================================

%logonserver%\netlogon\cleanup\delprof\delprof.exe
cls

rem ====================================
title Clearing Old Printers...
rem ====================================

cscript %systemroot%\system32\prnmngr.vbs -x
cls

rem ====================================
title Fixing Outlook Name Cache...
rem ====================================

for /f "tokens=1 delims=" %%a in ('dir /b /s *.nk2) do (
%logonserver%\netlogon\cleanup\nk2view\nk2view.exe /nk2file "%%a" /delete_by_type "EX"
)

rem ====================================
title Optimising Local Profiles...
rem ====================================

%logonserver%\netlogon\cleanup\ccleaner\ccleaner.exe /auto

for /f "tokens=1 delims=" %%a in ('dir /b c:\docume~1') do (
DEL /s /q /f "c:\documents and settings\%%a\Local Settings\Temporary Internet Files\*.*"
DEL /s /q /f "c:\documents and settings\%%a\Local Settings\Temp\*.*"

cls

rem ====================================
title Defragmenting Hard Disk...
rem ====================================

pause
%logonserver%\netlogon\cleanup\ccleaner\df.exe c:
cls

rem ====================================
title Shutting Down...
rem ====================================

if not "%computername%"=="VAI-TS" (
shutdown -s -t 0 -f
)
