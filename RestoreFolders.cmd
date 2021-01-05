@echo off 

:INIT
set ServerPath=\\SSFLON03\Redirection\%username%

:START
title Redirected Folder Removal Script
cls
echo =================================================================
echo.
echo This script will remove the network configured redirected folders
echo and migrate data from network/cached storage to the local machine
echo.
echo =================================================================
echo.
echo Data will be migrated from: %ServerPath%
echo Data will be migrated to: %UserProfile%
echo.
pause

cls
REM ================================================
title Closing Explorer...
REM ================================================

taskkill /f /im explorer.exe
timeout /t 2 /nobreak >nul

cls
REM ================================================
title Clearing Policies...
REM ================================================

reg export "HKLM\Software\Policies\Microsoft" "%userprofile%\HKLM-Policy.reg" /y
reg export "HKCU\Software\Policies\Microsoft" "%userprofile%\HKCU-Policy.reg" /y
reg export "HKCU\Software\Microsoft\Windows\CurrentVersion\Group Policy Objects" "%userprofile%\HKLM-PolicyList.reg" /y
reg export "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies" "%userprofile%\HKCU-PolicyList.reg" /y

reg delete "HKLM\Software\Policies\Microsoft" /f
reg delete "HKCU\Software\Policies\Microsoft" /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Group Policy Objects" /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies" /f

DEL /S /F /Q "%ALLUSERSPROFILE%\Application Data\Microsoft\Group Policy\History\*.*"
DEL /F /Q C:\WINDOWS\security\Database\secedit.sdb
Klist purge

cls
REM ================================================
title Creating Folders...
REM ================================================

if not exist "%UserProfile%\3D Objects\." md "%UserProfile%\3D Objects"
if not exist "%UserProfile%\Searches\." md "%UserProfile%\Searches"
if not exist "%UserProfile%\Pictures\." md "%UserProfile%\Pictures"
if not exist "%UserProfile%\Music\." md "%UserProfile%\Music"
if not exist "%UserProfile%\Links\." md "%UserProfile%\Links"
if not exist "%UserProfile%\Favorites\." md "%UserProfile%\Favorites"
if not exist "%UserProfile%\Contacts\." md "%UserProfile%\Contacts"
if not exist "%UserProfile%\Saved Games\." md "%UserProfile%\Saved Games"
if not exist "%UserProfile%\Downloads\." md "%UserProfile%\Downloads"
if not exist "%UserProfile%\Documents\." md "%UserProfile%\Documents"
if not exist "%UserProfile%\Desktop\." md "%UserProfile%\Desktop"
if not exist "%UserProfile%\Videos\." md "%UserProfile%\Videos"

cls
REM ================================================
title Changing Registry...
REM ================================================

reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "{31C0DD25-9439-4F12-BF41-7FF4EDA38722}" /t REG_SZ /d "C:\Users\%USERNAME%\3D Objects" /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "{31C0DD25-9439-4F12-BF41-7FF4EDA38722}" /t REG_EXPAND_SZ /d %%USERPROFILE%%"\3D Objects" /f

reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "{7D1D3A04-DEBB-4115-95CF-2F29DA2920DA}" /t REG_SZ /d "C:\Users\%USERNAME%\Searches" /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "{7D1D3A04-DEBB-4115-95CF-2F29DA2920DA}" /t REG_EXPAND_SZ /d %%USERPROFILE%%"\Searches" /f

reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "My Pictures" /t REG_SZ /d "C:\Users\%USERNAME%\Pictures" /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "{0DDD015D-B06C-45D5-8C4C-F59713854639}" /t REG_EXPAND_SZ /d %%USERPROFILE%%"\Pictures" /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "My Pictures" /t REG_EXPAND_SZ /d %%USERPROFILE%%"\Pictures" /f

reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "My Music" /t REG_SZ /d "C:\Users\%USERNAME%\Music" /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "{A0C69A99-21C8-4671-8703-7934162FCF1D}" /t REG_EXPAND_SZ /d %%USERPROFILE%%"\Music" /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "My Music" /t REG_EXPAND_SZ /d %%USERPROFILE%%"\Music" /f

reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "{BFB9D5E0-C6A9-404C-B2B2-AE6DB6AF4968}" /t REG_SZ /d "C:\Users\%USERNAME%\Links" /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "{BFB9D5E0-C6A9-404C-B2B2-AE6DB6AF4968}" /t REG_EXPAND_SZ /d %%USERPROFILE%%"\Links" /f

reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "Favorites" /t REG_SZ /d "C:\Users\%USERNAME%\Favorites" /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "Favorites" /t REG_EXPAND_SZ /d %%USERPROFILE%%"\Favorites" /f

reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "{56784854-C6CB-462B-8169-88E350ACB882}" /t REG_SZ /d "C:\Users\%USERNAME%\Contacts" /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "{56784854-C6CB-462B-8169-88E350ACB882}" /t REG_EXPAND_SZ /d %%USERPROFILE%%"\Contacts" /f

reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "{4C5C32FF-BB9D-43B0-B5B4-2D72E54EAAA4}" /t REG_SZ /d "C:\Users\%USERNAME%\Saved Games" /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "{4C5C32FF-BB9D-43B0-B5B4-2D72E54EAAA4}" /t REG_EXPAND_SZ /d %%USERPROFILE%%"\Saved Games" /f

reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "{374DE290-123F-4565-9164-39C4925E467B}" /t REG_SZ /d "C:\Users\%USERNAME%\Downloads" /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "{374DE290-123F-4565-9164-39C4925E467B}" /t REG_EXPAND_SZ /d %%USERPROFILE%%"\Downloads" /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "{7D83EE9B-2244-4E70-B1F5-5393042AF1E4}" /t REG_EXPAND_SZ /d %%USERPROFILE%%"\Downloads" /f

reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "Personal" /t REG_SZ /d "C:\Users\%USERNAME%\Documents" /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "{f42ee2d3-909f-4907-8871-4c22fc0bf756}" /t REG_EXPAND_SZ /d %%USERPROFILE%%"\Documents" /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "Personal" /t REG_EXPAND_SZ /d %%USERPROFILE%%"\Documents" /f

reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "Desktop" /t REG_SZ /d "C:\Users\%USERNAME%\Desktop" /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "Desktop" /t REG_EXPAND_SZ /d %%USERPROFILE%%"\Desktop" /f

reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "My Video" /t REG_SZ /d "C:\Users\%USERNAME%\Videos" /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "{35286A68-3C57-41A1-BBB1-0EAE73D76C95}" /t REG_EXPAND_SZ /d %%USERPROFILE%%"\Videos" /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "My Video" /t REG_EXPAND_SZ /d %%USERPROFILE%%"\Videos" /f

cls
REM ================================================
title Fixing Permissions...
REM ================================================

attrib +r -s -h "%USERPROFILE%\3D Objects" /S /D
attrib +r -s -h "%USERPROFILE%\Searches" /S /D
attrib +r -s -h "%USERPROFILE%\Pictures" /S /D
attrib +r -s -h "%USERPROFILE%\Music" /S /D
attrib +r -s -h "%USERPROFILE%\Links" /S /D
attrib +r -s -h "%USERPROFILE%\Favorites" /S /D
attrib +r -s -h "%USERPROFILE%\Contacts" /S /D
attrib +r -s -h "%USERPROFILE%\Saved Games" /S /D
attrib +r -s -h "%USERPROFILE%\Downloads" /S /D
attrib +r -s -h "%USERPROFILE%\Documents" /S /D
attrib +r -s -h "%USERPROFILE%\Desktop" /S /D
attrib +r -s -h "%USERPROFILE%\Videos" /S /D

cls
REM ================================================
title Migrating Data...
REM ================================================

xcopy "%ServerPath%\3D Objects\*.*" "%USERPROFILE%\3D Objects" /v /e /y /h /i /c /d
xcopy "%ServerPath%\Searches\*.*" "%USERPROFILE%\Searches" /v /e /y /h /i /c /d
xcopy "%ServerPath%\Pictures\*.*" "%USERPROFILE%\Pictures" /v /e /y /h /i /c /d
xcopy "%ServerPath%\Music\*.*" "%USERPROFILE%\Music" /v /e /y /h /i /c /d
xcopy "%ServerPath%\Links\*.*" "%USERPROFILE%\Links" /v /e /y /h /i /c /d
xcopy "%ServerPath%\Favorites\*.*" "%USERPROFILE%\Favorites" /v /e /y /h /i /c /d
xcopy "%ServerPath%\Contacts\*.*" "%USERPROFILE%\Contacts" /v /e /y /h /i /c /d
xcopy "%ServerPath%\Saved Games\*.*" "%USERPROFILE%\Saved Games" /v /e /y /h /i /c /d
xcopy "%ServerPath%\Downloads\*.*" "%USERPROFILE%\Downloads" /v /e /y /h /i /c /d
xcopy "%ServerPath%\Documents\*.*" "%USERPROFILE%\Documents" /v /e /y /h /i /c /d
xcopy "%ServerPath%\Desktop\*.*" "%USERPROFILE%\Desktop" /v /e /y /h /i /c /d
xcopy "%ServerPath%\Videos\*.*" "%USERPROFILE%\Videos" /v /e /y /h /i /c /d

cls
REM ================================================
title Restarting to Apply Settings
REM ================================================

timeout /t 1 /nobreak >nul
shutdown -r -t 0 -f