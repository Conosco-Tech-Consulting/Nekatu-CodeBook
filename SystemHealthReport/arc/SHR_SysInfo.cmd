echo. >> %SHR_Rprt%
echo -------------------------------------------------------------- >> %SHR_Rprt%
echo SYSTEM INFORMATION >> %SHR_Rprt%
echo -------------------------------------------------------------- >> %SHR_Rprt%

for /f "tokens=1,2,10,12,14-16,30 delims=," %%a in ('systeminfo.exe /FO CSV /NH') do (
set SHR_SI_HN=%%~a
set SHR_SI_OS=%%~b
set SHR_SI_ID=%%~c
set SHR_SI_BD=%%~d
set SHR_SI_MK=%%~e
Set SHR_SI_MD=%%~f
set SHR_SI_SA=%%~g
set SHR_SI_IM=%%~h
)

echo. >> %SHR_Rprt%
echo Logon Name:        %username% >> %SHR_Rprt%
echo Host Name:         %userdomain%\%computername% >> %SHR_Rprt%
echo. >> %SHR_Rprt%
echo Installed OS:      %SHR_SI_OS% >> %SHR_Rprt%
echo Install Date:      %SHR_SI_ID% >> %SHR_Rprt%
echo Last Boot Date:    %SHR_SI_BD% >> %SHR_Rprt%
echo. >> %SHR_Rprt%
echo Manufacturer:      %SHR_SI_MK% >> %SHR_Rprt%
echo System Model:      %SHR_SI_MD% >> %SHR_Rprt%
echo Architecture:      %SHR_SI_SA% >> %SHR_Rprt%
echo System Memory:     %SHR_SI_IM% >> %SHR_Rprt%
echo. >> %SHR_Rprt%

for /f "tokens=4,5,6,7 delims=. " %%a in ('ipconfig ^| find /i "IP Address"') do echo IP Address:        %%a.%%b.%%c.%%d >> %SHR_Rprt%
for /f "tokens=4,5,6,7 delims=. " %%a in ('ipconfig ^| find /i "Subnet Mask"') do echo Subnet Mask:       %%a.%%b.%%c.%%d >> %SHR_Rprt%