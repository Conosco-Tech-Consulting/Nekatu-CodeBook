echo. >> %SHR_Rprt%
echo. >> %SHR_Rprt%
echo -------------------------------------------------------------- >> %SHR_Rprt%
echo ARCHIVING EVENT LOGS >> %SHR_Rprt%
echo -------------------------------------------------------------- >> %SHR_Rprt%

echo. >> %SHR_Rprt%
.\bin\psloglist.exe -s application > %SHR_EvntApp%


if "%errorlevel%"=="0" (
echo - Application Log cleared and saved>> %SHR_Rprt%
) else (
echo * Application Log could not be cleared and saved>> %SHR_Rprt%
)



echo. >> %SHR_Rprt%
.\bin\psloglist.exe -s system > %SHR_EvntSys%

if "%errorlevel%"=="0" (
echo - System Log cleared and saved>> %SHR_Rprt%
) else (
echo * System Log could not be cleared and saved>> %SHR_Rprt%
)

echo. >> %SHR_Rprt%
.\bin\psloglist.exe -s security > %SHR_EvntSec%


if "%errorlevel%"=="0" (
echo - Security Log cleared and saved>> %SHR_Rprt%
) else (
echo * Security Log could not be cleared and saved>> %SHR_Rprt%
)

echo. >> %SHR_Rprt%
.\bin\addtozipcmd.vbs %SHR_EvntPath% %SHR_ArcFile%

if "%errorlevel%"=="0" (
echo - Event Logs archived successfully>> %SHR_Rprt%
) else (
echo * Event Logs could not be archived>> %SHR_Rprt%
)