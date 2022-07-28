echo. >> %SHR_Rprt%
echo -------------------------------------------------------------- >> %SHR_Rprt%
echo CHECKING LOCAL ACCOUNT RIGHTS >> %SHR_Rprt%
echo -------------------------------------------------------------- >> %SHR_Rprt%

echo. >> %SHR_Rprt%
echo Local Administrators: >> %SHR_Rprt%
for /f "skip=6" %%a in ('net localgroup Administrators ^| find /v /i "The command completed successfully"') do echo * %%a >> %SHR_Rprt%
echo. >> %SHR_Rprt%
echo Power Users: >> %SHR_Rprt%
for /f "tokens=1 skip=6 delims=" %%a in ('net localgroup "Power Users" ^| find /v /i "The command completed successfully"') do echo * %%a >> %SHR_Rprt%
