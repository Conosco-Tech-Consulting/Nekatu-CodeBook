@echo off
cls

for /f "tokens=1,2,3,4 delims=/ " %%a in ('date /t') do set Date=%%a/%%b/%%c
for /f %%a in ('time /t') do set time=%%a

Set sitelog=index.htm
Set hostlog=hosts.htm

:SITELOG
echo.>%sitelog%
echo ^<html^>^<title^>Co-Operative Systems Uptime Monitor - %date%^</title^> >>%sitelog%
echo ^<link REL="SHORTCUT ICON" HREF="favicon.ico"^> >>%sitelog%
echo ^<body^>^<font face=arial^> >>%sitelog%
echo ^<h2^>^<img src="http://www.coopsys.net/templates/images/logo_rgb3.gif" /^>^&nbsp;Uptime Monitor - %date%^</h2^>^<hr /^> >>%sitelog%
echo ^<iframe frameborder=0 src=%hostlog% width="800" height="500"^>^</iframe^> >>%sitelog%
echo ^<hr /^>^</body^>^</html^> >>%sitelog%

:HOSTLOG
echo.>%hostlog%
echo ^<html^>^<title^>Co-Operative Systems Uptime Monitor - %date%^</title^> >>%hostlog%
echo ^<body^>^<font face=arial^> >>%hostlog%
echo ^<table^> >>%hostlog%
echo ^<tr^>^<td width="315"^>^<b^>Hostname^</b^>^</td^> >>%hostlog%
echo ^<td width="30"^>^<img src=http.png alt="HTTP" /^>^</td^> >>%hostlog%
echo ^<td width="30"^>^<img src=https.png alt="HTTPS" /^>^</td^> >>%hostlog%
echo ^<td width="30"^>^<img src=smtp.gif alt="SMTP" /^>^</td^> >>%hostlog%
echo ^<td width="30"^>^<img src=FTP.png alt="FTP" /^>^</td^> >>%hostlog%
echo ^<td width="30"^>^<img src=telnet.png alt="Telnet" /^>^</td^> >>%hostlog%
echo ^<td width="30"^>^<img src=RDP.gif alt="RDP" /^>^</td^> >>%hostlog%
echo ^<td width="150"^>^<b^>Last Update^</b^>^</td^>^</tr^> >>%hostlog%
echo ^</table^> >>%hostlog%

for /f "tokens=1-2 delims=," %%a in (hosts.csv) do (
	echo ^<html^>^<title^>Co-Operative Systems Uptime Monitor - %date%^</title^> >%%a.htm
	echo ^<meta http-equiv="refresh" content="5" ^> >>.\pages\%%a.htm
	echo ^<body^>^<font face=arial^> >>.\pages\%%a.htm
	echo ^<table^> >>.\pages\%%a.htm
	echo ^<tr^>^<td width=310^>%%b^</td^>^<tr^> >>.\pages\%%a.htm
	echo ^</table^>^</body^>^</html^> >>.\pages\%%a.htm

	echo ^<iframe scrolling=no frameborder=0 src=%%a.htm width="700" height="35"^>^</iframe^>^<br /^> >>%hostlog%
)

echo ^</body^>^</html^> >>%hostlog%

:LOOP
for /f "tokens=1-2 delims=," %%a in (hosts.csv) do (
	echo Checking %%b...
	echo ^<html^>^<title^>Co-Operative Systems Uptime Monitor - %date%^</title^> >.\pages\%%a.htm
	echo ^<meta http-equiv="refresh" content="5" ^> >>.\pages\%%a.htm
	echo ^<body^>^<font face=arial^> >>.\pages\%%a.htm
	echo ^<table^> >>.\pages\%%a.htm
	echo ^<tr^>^<td width=310^>%%b^</td^> >>.\pages\%%a.htm

	for /f "tokens=6" %%x in ('PortQry.exe -n %%b -e 80 ^| find /i "TCP"') do (
		
		if /i "%%x"=="NOT" echo ^<td width=30^>^<img src="inactive.png" alt="INACTIVE" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="LISTENING" echo ^<td width=30^>^<img src="active.gif" alt="ACTIVE" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="TIMEOUT" echo ^<td width=30^>^<img src="unknown.png" alt="UNKNOWN" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="FILTERED" echo ^<td width=30^>^<img src="inactive.png" alt="INACTIVE" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="" echo ^<td width=30^>^<img src="unknown.png" alt="UNKNOWN" /^>^</td^> >>.\pages\%%a.htm
	)

	for /f "tokens=6" %%x in ('PortQry.exe -n %%b -e 443 ^| find /i "TCP"') do (
		
		if /i "%%x"=="NOT" echo ^<td width=30^>^<img src="inactive.png" alt="INACTIVE" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="LISTENING" echo ^<td width=30^>^<img src="active.gif" alt="ACTIVE" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="TIMEOUT" echo ^<td width=30^>^<img src="unknown.png" alt="UNKNOWN" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="FILTERED" echo ^<td width=30^>^<img src="inactive.png" alt="INACTIVE" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="" echo ^<td width=30^>^<img src="unknown.png" alt="UNKNOWN" /^>^</td^> >>.\pages\%%a.htm
	)

	for /f "tokens=6" %%x in ('PortQry.exe -n %%b -e 25 ^| find /i "TCP"') do (
		
		if /i "%%x"=="NOT" echo ^<td width=30^>^<img src="inactive.png" alt="INACTIVE" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="LISTENING" echo ^<td width=30^>^<img src="active.gif" alt="ACTIVE" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="TIMEOUT" echo ^<td width=30^>^<img src="unknown.png" alt="UNKNOWN" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="FILTERED" echo ^<td width=30^>^<img src="inactive.png" alt="INACTIVE" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="" echo ^<td width=30^>^<img src="unknown.png" alt="UNKNOWN" /^>^</td^> >>.\pages\%%a.htm
	)

	for /f "tokens=6" %%x in ('PortQry.exe -n %%b -e 21 ^| find /i "TCP"') do (
		
		if /i "%%x"=="NOT" echo ^<td width=30^>^<img src="inactive.png" alt="INACTIVE" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="LISTENING" echo ^<td width=30^>^<img src="active.gif" alt="ACTIVE" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="TIMEOUT" echo ^<td width=30^>^<img src="unknown.png" alt="UNKNOWN" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="FILTERED" echo ^<td width=30^>^<img src="inactive.png" alt="INACTIVE" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="" echo ^<td width=30^>^<img src="unknown.png" alt="UNKNOWN" /^>^</td^> >>.\pages\%%a.htm
	)

	for /f "tokens=6" %%x in ('PortQry.exe -n %%b -e 23 ^| find /i "TCP"') do (
		
		if /i "%%x"=="NOT" echo ^<td width=30^>^<img src="inactive.png" alt="INACTIVE" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="LISTENING" echo ^<td width=30^>^<img src="active.gif" alt="ACTIVE" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="TIMEOUT" echo ^<td width=30^>^<img src="unknown.png" alt="UNKNOWN" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="FILTERED" echo ^<td width=30^>^<img src="inactive.png" alt="INACTIVE" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="" echo ^<td width=30^>^<img src="unknown.png" alt="UNKNOWN" /^>^</td^> >>.\pages\%%a.htm
	)

	for /f "tokens=6" %%x in ('PortQry.exe -n %%b -e 3389 ^| find /i "TCP"') do (
		
		if /i "%%x"=="NOT" echo ^<td width=30^>^<img src="inactive.png" alt="INACTIVE" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="LISTENING" echo ^<td width=30^>^<img src="active.gif" alt="ACTIVE" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="TIMEOUT" echo ^<td width=30^>^<img src="unknown.png" alt="UNKNOWN" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="FILTERED" echo ^<td width=30^>^<img src="inactive.png" alt="INACTIVE" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="" echo ^<td width=30^>^<img src="unknown.png" alt="UNKNOWN" /^>^</td^> >>.\pages\%%a.htm
	)

	for /f %%t in ('time /t') do echo ^<td width=150^>^<i^>%%t^</i^>^</td^>^</tr^> >>.\pages\%%a.htm
	echo ^</table^>^</body^>^</html^> >>.\pages\%%a.htm
)
GOTO :LOOP