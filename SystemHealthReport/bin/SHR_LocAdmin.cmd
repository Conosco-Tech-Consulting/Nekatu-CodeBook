echo ^<tr^>^<td colspan=2^> >> %SHR_Rprt%
echo ^<u^>^<h3^>^<img src=file:///C:/Users/nekatu/Projects/SystemHealthReport/img/info.gif /^>^&nbsp Local Admin Rights^</h3^>^</u^> >> %SHR_Rprt%
echo ^</td^>^</tr^> >> %SHR_Rprt%

echo ^<tr^>^<td^>^&nbsp^&nbsp^<b^>Local Administrators:^</b^>^</td^>^<td^> >> %SHR_Rprt%
for /f "skip=6" %%a in ('net localgroup Administrators ^| find /v /i "The command completed successfully"') do echo * %%a^<br /^> >> %SHR_Rprt%
echo ^</td^>^</tr^> >> %SHR_Rprt%
echo ^<tr^>^<td^>^&nbsp^&nbsp^<b^>Power Users:^</b^>^</td^>^<td^> >> %SHR_Rprt%

for /f "tokens=1 skip=6 delims=" %%a in ('net localgroup "Power Users" ^| find /v /i "The command completed successfully"') do echo * %%a^<br /^> >> %SHR_Rprt%
echo ^</td^>^</tr^> >> %SHR_Rprt%