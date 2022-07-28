for /F "tokens=1" %%A in ('cscript %systemroot%\system32\oem\asset.vbs //nologo') do (set ASSET=%%A)
for /F "tokens=1" %%B in ('date /t') do (set DATE1=%%B)
for /F "tokens=2,3 delims=/ " %%C in ('date /t') do (set DATE2=%%C%%D)

set BUILDNO=%USERDOMAIN%SVR%DATE2%2K3

ECHO [General] > %systemroot%\system32\OEMINFO.INI
ECHO Manufacturer=Joskos Solutions >> %systemroot%\system32\OEMINFO.INI
ECHO. >> %systemroot%\system32\OEMINFO.INI
ECHO [OEMSpecific] >> %systemroot%\system32\OEMINFO.INI
ECHO SubModel=Joskos Solutions Server >> %systemroot%\system32\OEMINFO.INI
ECHO SerialNo=%ASSET% >> %systemroot%\system32\OEMINFO.INI
ECHO OEM1=Build Number: %BUILDNO% >> %systemroot%\system32\OEMINFO.INI
ECHO OEM2=Build Date: %DATE1% >> %systemroot%\system32\OEMINFO.INI
ECHO. >> %systemroot%\system32\OEMINFO.INI
ECHO [Support Information] >> %systemroot%\system32\OEMINFO.INI
ECHO Line1=Contact Details  >> %systemroot%\system32\OEMINFO.INI
ECHO Line2=-----------------  >> %systemroot%\system32\OEMINFO.INI
ECHO Line3= >> %systemroot%\system32\OEMINFO.INI
ECHO Line4= Tel: 0700 4 567567 >> %systemroot%\system32\OEMINFO.INI
ECHO Line5= Fax: 020 7689 5002 >> %systemroot%\system32\OEMINFO.INI
ECHO Line6= Email: solutions@joskos.com >> %systemroot%\system32\OEMINFO.INI
ECHO Line7= Web: http://www.joskos.com >> %systemroot%\system32\OEMINFO.INI
ECHO Line8= >> %systemroot%\system32\OEMINFO.INI
ECHO Line9=Service Information >> %systemroot%\system32\OEMINFO.INI
ECHO Line10=------------------------- >> %systemroot%\system32\OEMINFO.INI
ECHO Line11= >> %systemroot%\system32\OEMINFO.INI
ECHO Line12= Computer Name: %COMPUTERNAME% >> %systemroot%\system32\OEMINFO.INI
ECHO Line13= Asset Tag: %ASSET% >> %systemroot%\system32\OEMINFO.INI
ECHO Line14= Build Number: %BUILDNO% >> %systemroot%\system32\OEMINFO.INI
ECHO Line15= Build Date: %DATE1% >> %systemroot%\system32\OEMINFO.INI

copy %systemroot%\system32\oem\oemlogo.bmp %systemroot%\system32
copy %systemroot%\system32\oem\joskos.ico %systemroot%\system32

regedit /s %systemroot%\system32\oem\SVRPatch.reg