echo. >> %SHR_Rprt%
echo -------------------------------------------------------------- >> %SHR_Rprt%
echo TEMPORARY FILES CLEANUP >> %SHR_Rprt%
echo -------------------------------------------------------------- >> %SHR_Rprt%

echo. >> %SHR_Rprt%
for /f %%a in ('DEL /s /q /f "%userprofile%\Local Settings\Temporary Internet Files\*.*" ^| find /i /c "\"') do echo Temporary internet file(s) removed:  %%a >> %SHR_Rprt%
for /f %%a in ('DEL /s /q /f "%tmp%\*.*" ^| find /i /c "\"') do echo Temporary install file(s) removed:  %%a >> %SHR_Rprt%
echo. >> %SHR_Rprt%
