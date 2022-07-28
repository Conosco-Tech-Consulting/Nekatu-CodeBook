@echo off

for /f "tokens=1,2,3,4,5,6 delims=/:. " %%a in ("%date%.%time%") do set backup=%%a%%b%%c_%%d%%e%%f

e:
cd\backup

:INIT
echo ==========================================>>e:\backup\logs\%backup%_report.txt
echo MumsAndBubs Database Backup ^& Compact Tool>>e:\backup\logs\%backup%_report.txt
echo v1.0  Copyright ^(c^) Micronicity Limited>>e:\backup\logs\%backup%_report.txt
echo Date: %DATE%   Time: %TIME%>>e:\backup\logs\%backup%_report.txt
echo ==========================================>>e:\backup\logs\%backup%_report.txt


:DOWNLOAD
echo.>>e:\backup\logs\%backup%_report.txt
echo %time% - Downloading current database>>e:\backup\logs\%backup%_report.txt
echo ------------------------------------------>>e:\backup\logs\%backup%_report.txt
echo.>>e:\backup\logs\%backup%_report.txt

FTP -v -s:e:\backup\scripts\1and1get.ftp s160332898.websitehome.co.uk>>e:\backup\logs\%backup%_priget.log

for /f "tokens=1,2,3,4" %%a in ('dir e:\backup\logs\%backup%_priget.log ^| find /i "%date%"') do echo File: %%d    Size: %%c byte^(s^)    Modified: %%a @ %%b>>e:\backup\logs\%backup%_report.txt


:ARCHIVE
if exist "e:\backup\mabuk.mdb" (

echo.>>e:\backup\logs\%backup%_report.txt
echo %time% - Archiving database>>e:\backup\logs\%backup%_report.txt
echo ------------------------------------------>>e:\backup\logs\%backup%_report.txt
echo.>>e:\backup\logs\%backup%_report.txt

ren "e:\backup\mabuk.mdb" "%backup%.mdb"

for /f "tokens=1,2,3,4" %%a in ('dir %backup%.mdb ^| find /i "%date%"') do echo File: %%d    Size: %%c byte^(s^)    Modified: %%a @ %%b>>e:\backup\logs\%backup%_report.txt

) else (

echo.>>e:\backup\logs\%backup%_report.txt
echo %time% - ERROR DETECTED!>>e:\backup\logs\%backup%_report.txt
echo Retrying download>>e:\backup\logs\%backup%_report.txt
echo.>>e:\backup\logs\%backup%_report.txt
goto :DOWNLOAD

)


:COMPACT
if exist e:\backup\%backup%.mdb (

echo.>>e:\backup\logs\%backup%_report.txt
echo %time% - Compacting database>>e:\backup\logs\%backup%_report.txt
echo ------------------------------------------>>e:\backup\logs\%backup%_report.txt
echo.>>e:\backup\logs\%backup%_report.txt

for /f "tokens=1,2,3,4" %%a in ('dir %backup%.mdb ^| find /i "%date%"') do echo Database size before compacting: %%c byte^(s^)>>e:\backup\logs\%backup%_report.txt

"c:\Program Files\Microsoft Office\OFFICE11\MSACCESS.EXE" "e:\backup\%backup%.mdb" /compact "e:\backup\mabuk.mdb"

for /f "tokens=1,2,3,4" %%a in ('dir mabuk.mdb ^| find /i "%date%"') do echo Database size after compacting: %%c byte^(s^)>>e:\backup\logs\%backup%_report.txt


) else (

echo.>>e:\backup\logs\%backup%_report.txt
echo %time% - ERROR DETECTED!>>e:\backup\logs\%backup%_report.txt
echo Retrying archive>>e:\backup\logs\%backup%_report.txt
echo.>>e:\backup\logs\%backup%_report.txt
goto :ARCHIVE

)


:UPLOAD
if exist "e:\backup\mabuk.mdb" (

echo.>>e:\backup\logs\%backup%_report.txt
echo %time% - Uploading to Primary Host>>e:\backup\logs\%backup%_report.txt
echo ------------------------------------------>>e:\backup\logs\%backup%_report.txt
echo.>>e:\backup\logs\%backup%_report.txt
FTP -v -s:e:\backup\scripts\1and1put.ftp s160332898.websitehome.co.uk>>e:\backup\logs\%backup%_priput.log
for /f "tokens=1,2,3,4" %%a in ('dir e:\backup\logs\%backup%_priput.log ^| find /i "%date%"') do echo File: %%d    Size: %%c byte^(s^)    Modified: %%a @ %%b>>e:\backup\logs\%backup%_report.txt

) else (

echo.>>e:\backup\logs\%backup%_report.txt
echo %time% - ERROR DETECTED!>>e:\backup\logs\%backup%_report.txt
echo Retrying compact>>e:\backup\logs\%backup%_report.txt
echo.>>e:\backup\logs\%backup%_report.txt
goto :COMPACT

)


:CLEANUP
echo.>>e:\backup\logs\%backup%_report.txt
echo %time% - Archiving Compacted Database>>e:\backup\logs\%backup%_report.txt
echo ------------------------------------------>>e:\backup\logs\%backup%_report.txt
echo.>>e:\backup\logs\%backup%_report.txt
move "e:\backup\mabuk.mdb" "e:\backup\archive\%backup%.md_"
move "e:\backup\*.mdb" "e:\backup\archive\"
for /f "tokens=1,2,3,4" %%a in ('dir e:\backup\archive\*.mdb ^| find /i "%date%"') do echo File: %%d    Size: %%c byte^(s^)    Modified: %%a @ %%b>>e:\backup\logs\%backup%_report.txt


if exist "e:\backup\archive\%backup%.md_" (

echo.>>e:\backup\logs\%backup%_report.txt
echo ==========================================>>e:\backup\logs\%backup%_report.txt
echo %time% - Operation completed successfully>>e:\backup\logs\%backup%_report.txt
echo ==========================================>>e:\backup\logs\%backup%_report.txt
goto :EOF

) else (

echo.>>e:\backup\logs\%backup%_report.txt
echo %time% - ERROR DETECTED!>>e:\backup\logs\%backup%_report.txt
echo Retrying cleanup>>e:\backup\logs\%backup%_report.txt
echo.>>e:\backup\logs\%backup%_report.txt
goto :CLEANUP

)