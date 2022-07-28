rem @echo off
cls


REM =====================================
REM Set SYDI Locations
REM =====================================

set sydi=C:\Users\arikf\SkyDrive\Documents\Projects\AuditMerge
set client=C:\Users\arikf\SkyDrive\Documents\Joskos\Schools\Chandlers Field\Audit

REM =====================================
REM Collate all audits from Client Folder
REM =====================================

for /f "tokens=1 delims=." %%a in ('dir /b "%client%\*.XML"') do (
cls
%systemroot%\system32\cscript.exe "%sydi%\ss-xml2word.vbs" -x"%client%\%%a.xml" -l"%sydi%\lang_english.xml" -o"%client%\%%a.DOC" -T"%sydi%\template.dot" -d
)

pause