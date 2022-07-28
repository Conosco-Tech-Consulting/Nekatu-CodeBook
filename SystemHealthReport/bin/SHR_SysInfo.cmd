echo ^<tr^>^<td colspan=2 class=section^> >> %SHR_Rprt%
echo ^<img src=file:///C:/Users/nekatu/Projects/SystemHealthReport/img/search.gif width=16 height=16 /^>^&nbsp SYSTEM INFORMATION >> %SHR_Rprt%
echo ^</td^>^</tr^> >> %SHR_Rprt%
echo ^<tr^>^<td^>^&nbsp^</td^>^</tr^> >> %SHR_Rprt%


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

echo ^<tr^>^<td class=fieldtitle^>^<img src=file:///C:/Users/nekatu/Projects/SystemHealthReport/img/info.gif width=16 height=16 /^>^&nbsp Logon Name:^</td^>^<td^>%userdomain%\%username%^</td^>^</tr^> >> %SHR_Rprt%
echo ^<tr^>^<td class=fieldtitle^>^<img src=file:///C:/Users/nekatu/Projects/SystemHealthReport/img/info.gif width=16 height=16 /^>^&nbsp Host Name:^</td^>^<td^>%computername%.%userdnsdomain%^</td^>^</tr^> >> %SHR_Rprt%
echo ^<tr^>^<td^>^&nbsp^</td^>^</tr^> >> %SHR_Rprt%
echo ^<tr^>^<td class=fieldtitle^>^<img src=file:///C:/Users/nekatu/Projects/SystemHealthReport/img/info.gif width=16 height=16 /^>^&nbsp Installed OS:^</td^>^<td^>%SHR_SI_OS%^</td^>^</tr^> >> %SHR_Rprt%
echo ^<tr^>^<td class=fieldtitle^>^<img src=file:///C:/Users/nekatu/Projects/SystemHealthReport/img/info.gif width=16 height=16 /^>^&nbsp Install Date:^</td^>^<td^>%SHR_SI_ID%^</td^>^</tr^> >> %SHR_Rprt%
echo ^<tr^>^<td class=fieldtitle^>^<img src=file:///C:/Users/nekatu/Projects/SystemHealthReport/img/info.gif width=16 height=16 /^>^&nbsp Last Boot Date:^</td^>^<td^>%SHR_SI_BD%^</td^>^</tr^> >> %SHR_Rprt%
echo ^<tr^>^<td^>^&nbsp^</td^>^</tr^> >> %SHR_Rprt%
echo ^<tr^>^<td class=fieldtitle^>^<img src=file:///C:/Users/nekatu/Projects/SystemHealthReport/img/info.gif width=16 height=16 /^>^&nbsp Manufacturer:^</td^>^<td^>%SHR_SI_MK%^</td^>^</tr^> >> %SHR_Rprt%
echo ^<tr^>^<td class=fieldtitle^>^<img src=file:///C:/Users/nekatu/Projects/SystemHealthReport/img/info.gif width=16 height=16 /^>^&nbsp System Model:^</td^>^<td^>%SHR_SI_MD%^</td^>^</tr^> >> %SHR_Rprt%
echo ^<tr^>^<td class=fieldtitle^>^<img src=file:///C:/Users/nekatu/Projects/SystemHealthReport/img/info.gif width=16 height=16 /^>^&nbsp Architecture:^</td^>^<td^>%SHR_SI_SA%^</td^>^</tr^> >> %SHR_Rprt%
echo ^<tr^>^<td class=fieldtitle^>^<img src=file:///C:/Users/nekatu/Projects/SystemHealthReport/img/info.gif width=16 height=16 /^>^&nbsp System Memory:^</td^>^<td^>%SHR_SI_IM%^</td^>^</tr^> >> %SHR_Rprt%
echo ^<tr^>^<td^>^&nbsp^</td^>^</tr^> >> %SHR_Rprt%

for /f "tokens=4 delims=[.] " %%a in ('ver') do set OSVer=%%a

if "%OSver%"=="6" (

for /f "tokens=4,5,6,7 delims=. " %%a in ('ipconfig ^| find /i "IPv4 Address"') do echo ^<tr^>^<td class=fieldtitle^>^<img src=file:///C:/Users/nekatu/Projects/SystemHealthReport/img/info.gif width=16 height=16 /^>^&nbsp IP Address:^</td^>^<td^>%%a.%%b.%%c.%%d^</td^>^</tr^> >> %SHR_Rprt%
for /f "tokens=4,5,6,7 delims=. " %%a in ('ipconfig ^| find /i "Subnet Mask"') do echo ^<tr^>^<td class=fieldtitle^>^<img src=file:///C:/Users/nekatu/Projects/SystemHealthReport/img/info.gif width=16 height=16 /^>^&nbsp Subnet Mask:^</td^>^<td^>%%a.%%b.%%c.%%d^</td^>^</tr^> >> %SHR_Rprt%

) else (

for /f "tokens=4,5,6,7 delims=. " %%a in ('ipconfig ^| find /i "IP Address"') do echo ^<tr^>^<td class=fieldtitle^>^<img src=file:///C:/Users/nekatu/Projects/SystemHealthReport/img/info.gif width=16 height=16 /^>^&nbsp IP Address:^</td^>^<td^>%%a.%%b.%%c.%%d^</td^>^</tr^> >> %SHR_Rprt%
for /f "tokens=4,5,6,7 delims=. " %%a in ('ipconfig ^| find /i "Subnet Mask"') do echo ^<tr^>^<td class=fieldtitle^>^<img src=file:///C:/Users/nekatu/Projects/SystemHealthReport/img/info.gif width=16 height=16 /^>^&nbsp Subnet Mask:^</td^>^<td^>%%a.%%b.%%c.%%d^</td^>^</tr^> >> %SHR_Rprt%

)

ECHO ^<tr^>^<td colspan=2^>^<hr^>^</td^>^</tr^> >> %SHR_Rprt%