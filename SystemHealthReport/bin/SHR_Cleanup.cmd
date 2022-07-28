echo. >> %SHR_Rprt%
echo. >> %SHR_Rprt%
echo -------------------------------------------------------------- >> %SHR_Rprt%
echo POST-REPORT CLEAN UP >> %SHR_Rprt%
echo -------------------------------------------------------------- >> %SHR_Rprt%
echo. >> %SHR_Rprt%

rd /s /q %SHR_DirPath%

if "%errorlevel%"=="0" (
echo - Clean up completed successfully>> %SHR_Rprt%
) else (
echo * Clean up did not complete successfully>> %SHR_Rprt%
echo   Please manually remove "%DHR_DirPath%">> %SHR_Rprt%
)

set SHR_MailRcpt=
set SHR_MailSvr=
set SHR_DirPath=
set SHR_EvntPath=
set SHR_Rprt=
set SHR_ArcFile=
set SHR_EvntSec=
set SHR_EvntSys=
set SHR_EvntApp=
set SHR_Date=