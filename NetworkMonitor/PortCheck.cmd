@echo off
cls

for /f "tokens=1,2,3,4 delims=/ " %%a in ('date /t') do set Date=%%a/%%b/%%c
for /f %%a in ('time /t') do set time=%%a

set home=C:\inetpub\wwwroot\CheckUp

Set sitelog=index.htm
Set hostlog=hosts.htm
Set infolog=info.htm

:SITELOG
echo.>%sitelog%
echo ^<html^>^<title^>Co-Operative Systems Uptime Monitor - %date%^</title^> >>%sitelog%
echo ^<link REL="SHORTCUT ICON" HREF="favicon.ico"^> >>%sitelog%
echo ^<body^>^<font face=arial^> >>%sitelog%
echo ^<table^>^<tr^> >>%sitelog%
echo ^<td^>^<img src="http://www.coopsys.net/templates/images/logo_rgb3.gif" /^>^</td^> >>%sitelog%
echo ^<td^>^&nbsp;^&nbsp;^&nbsp;^</td^> >>%sitelog%
echo ^<td^>^<b^>Co-Operative Systems Network Uptime Monitor 2.0^</b^>^<br ^>^<i^>20 MILES STREET, VAUXHALL, LONDON, SW8 1SD^</i^>^</td^> >>%sitelog%
echo ^<td^>^&nbsp;^&nbsp;^&nbsp;^</td^> >>%sitelog%
echo ^<td^>^<b^>Scanned On:^</b^>^<br /^>^%date%^</td^> >>%sitelog%
echo ^</tr^>^</table^> >>%sitelog%
echo ^<hr /^> >>%sitelog%
echo ^<table^>^<tr^> >>%sitelog%
echo ^<td^>^<iframe frameborder=0 name=main src=%hostlog% width="800" height="500"^>^</iframe^>^</td^> >>%sitelog%
echo ^<td^>^<iframe frameborder=0 name=info src=%infolog% width="400" height="500"^>^</iframe^>^</td^> >>%sitelog%
echo ^</tr^>^</table^> >>%sitelog%
echo ^<hr /^>^</body^>^</html^> >>%sitelog%

:HOSTLOG
echo.>%hostlog%
echo ^<html^>^<title^>Co-Operative Systems Uptime Monitor - %date%^</title^> >>%hostlog%
echo ^<body^>^<font face=arial^> >>%hostlog%
echo ^<table^> >>%hostlog%
echo ^<tr^>^<td width="255"^>^<b^>^&nbsp;^</b^>^</td^> >>%hostlog%
echo ^<td width="30"^>^<img src="img/up.gif" alt="PING" title="PING" /^>^</td^> >>%hostlog%
echo ^<td width="30"^>^<img src="img/http.png" alt="HTTP" title="HTTP" /^>^</td^> >>%hostlog%
echo ^<td width="30"^>^<img src="img/https.png" alt="HTTPS" title="HTTPS" /^>^</td^> >>%hostlog%
echo ^<td width="30"^>^<img src="img/smtp.gif" alt="SMTP" title="SMTP" /^>^</td^> >>%hostlog%
echo ^<td width="30"^>^<img src="img/sql.gif" alt="SQL" title="SQL" /^>^</td^> >>%hostlog%
echo ^<td width="30"^>^<img src="img/dns.png" alt="DNS" title="DNS" /^>^</td^> >>%hostlog%
echo ^<td width="30"^>^<img src="img/FTP.png" alt="FTP"  title="FTP"/^>^</td^> >>%hostlog%
echo ^<td width="30"^>^<img src="img/telnet.png" alt="Telnet" title="Telnet" /^>^</td^> >>%hostlog%
echo ^<td width="30"^>^<img src="img/RDP.gif" alt="RDP" title="RDP" /^>^</td^> >>%hostlog%
echo ^<td width="120"^>^<b^>Last Update^</b^>^</td^>^</tr^> >>%hostlog%
echo ^</table^> >>%hostlog%

:INIT
for /f "tokens=1-2 delims=," %%a in (hosts.csv) do (

	echo ^<html^>^<title^>Co-Operative Systems Uptime Monitor - %date%^</title^> >.\pages\%%a.htm
	echo ^<meta http-equiv="refresh" content="5" ^> >>.\pages\%%a.htm
	echo ^<body^>^<font face=arial^> >>.\pages\%%a.htm
	echo ^<table^> >>.\pages\%%a.htm
	echo ^<tr^>^<td width=280^>^<i^>Scanning %%b^</i^>^</td^>^<tr^> >>.\pages\%%a.htm
	echo ^</table^>^</body^>^</html^> >>.\pages\%%a.htm

	echo ^<iframe scrolling=no frameborder=0 src=pages/%%a.htm width="700" height="35"^>^</iframe^>^<br /^> >>%hostlog%

	if not exist %home%\pages\%%a-i.htm (
	cscript //nologo %home%\SysInfo.vbs %%b %home%\pages\%%a-i.htm
	)

)

echo ^</body^>^</html^> >>%hostlog%

:LOOP
for /f "tokens=1-2 delims=," %%a in (hosts.csv) do (
	echo Checking %%b...
	echo ^<html^>^<title^>Co-Operative Systems Uptime Monitor - %date%^</title^> >.\pages\%%a.htm
	echo ^<meta http-equiv="refresh" content="5" ^> >>.\pages\%%a.htm
	echo ^<body^>^<font face=arial^> >>.\pages\%%a.htm
	echo ^<table^> >>.\pages\%%a.htm

	echo ^<tr^>^<td width=250^>^<a href="../pages/%%a-i.htm" target=info ^>^<img src="../img/info.gif" /^>^</a^>^<b^>^&nbsp;^&nbsp; %%b^</b^>^</td^> >>.\pages\%%a.htm

	for /f %%x in ('ping %%b -n 1 ^| find /i /c "reply from"') do (

		echo * Ping Test

		if /i "%%x"=="0" echo ^<td width=30^>^<img src="../img/inactive.png" alt="INACTIVE" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="1" echo ^<td width=30^>^<img src="../img/active.gif" alt="ACTIVE" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="" echo ^<td width=30^>^<img src="../img/unknown.png" alt="UNKNOWN" /^>^</td^> >>.\pages\%%a.htm

	)

	for /f "tokens=6" %%x in ('PortQry.exe -n %%b -wt 5 -e 80 ^| find /i "TCP"') do (

		echo * HTTP Test
		
		if /i "%%x"=="NOT" echo ^<td width=30^>^<img src="../img/inactive.png" alt="INACTIVE" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="LISTENING" echo ^<td width=30^>^<img src="../img/active.gif" alt="ACTIVE" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="TIMEOUT" echo ^<td width=30^>^<img src="../img/unknown.png" alt="UNKNOWN" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="FILTERED" echo ^<td width=30^>^<img src="../img/inactive.png" alt="INACTIVE" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="" echo ^<td width=30^>^<img src="../img/unknown.png" alt="UNKNOWN" /^>^</td^> >>.\pages\%%a.htm
	)

	for /f "tokens=6" %%x in ('PortQry.exe -n %%b -wt 5 -e 443 ^| find /i "TCP"') do (

		echo * HTTPS Test
		
		if /i "%%x"=="NOT" echo ^<td width=30^>^<img src="../img/inactive.png" alt="INACTIVE" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="LISTENING" echo ^<td width=30^>^<img src="../img/active.gif" alt="ACTIVE" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="TIMEOUT" echo ^<td width=30^>^<img src="../img/unknown.png" alt="UNKNOWN" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="FILTERED" echo ^<td width=30^>^<img src="../img/inactive.png" alt="INACTIVE" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="" echo ^<td width=30^>^<img src="../img/unknown.png" alt="UNKNOWN" /^>^</td^> >>.\pages\%%a.htm
	)

	for /f "tokens=6" %%x in ('PortQry.exe -n %%b -wt 5 -e 25 ^| find /i "TCP"') do (

		echo * SMTP Test		

		if /i "%%x"=="NOT" echo ^<td width=30^>^<img src="../img/inactive.png" alt="INACTIVE" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="LISTENING" echo ^<td width=30^>^<img src="../img/active.gif" alt="ACTIVE" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="TIMEOUT" echo ^<td width=30^>^<img src="../img/unknown.png" alt="UNKNOWN" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="FILTERED" echo ^<td width=30^>^<img src="../img/inactive.png" alt="INACTIVE" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="" echo ^<td width=30^>^<img src="../img/unknown.png" alt="UNKNOWN" /^>^</td^> >>.\pages\%%a.htm
	)

	for /f "tokens=6" %%x in ('PortQry.exe -n %%b -wt 5 -e 1433 ^| find /i "TCP"') do (

		echo * SQL Test
		
		if /i "%%x"=="NOT" echo ^<td width=30^>^<img src="../img/inactive.png" alt="INACTIVE" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="LISTENING" echo ^<td width=30^>^<img src="../img/active.gif" alt="ACTIVE" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="TIMEOUT" echo ^<td width=30^>^<img src="../img/unknown.png" alt="UNKNOWN" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="FILTERED" echo ^<td width=30^>^<img src="../img/inactive.png" alt="INACTIVE" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="" echo ^<td width=30^>^<img src="../img/unknown.png" alt="UNKNOWN" /^>^</td^> >>.\pages\%%a.htm
	)

	for /f "tokens=6" %%x in ('PortQry.exe -n %%b -wt 5 -e 53 ^| find /i "TCP"') do (

		echo * DNS Test		

		if /i "%%x"=="NOT" echo ^<td width=30^>^<img src="../img/inactive.png" alt="INACTIVE" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="LISTENING" echo ^<td width=30^>^<img src="../img/active.gif" alt="ACTIVE" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="TIMEOUT" echo ^<td width=30^>^<img src="../img/unknown.png" alt="UNKNOWN" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="FILTERED" echo ^<td width=30^>^<img src="../img/inactive.png" alt="INACTIVE" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="" echo ^<td width=30^>^<img src="../img/unknown.png" alt="UNKNOWN" /^>^</td^> >>.\pages\%%a.htm
	)

	for /f "tokens=6" %%x in ('PortQry.exe -n %%b -wt 5 -e 21 ^| find /i "TCP"') do (

		echo * FTP Test
		
		if /i "%%x"=="NOT" echo ^<td width=30^>^<img src="../img/inactive.png" alt="INACTIVE" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="LISTENING" echo ^<td width=30^>^<img src="../img/active.gif" alt="ACTIVE" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="TIMEOUT" echo ^<td width=30^>^<img src="../img/unknown.png" alt="UNKNOWN" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="FILTERED" echo ^<td width=30^>^<img src="../img/inactive.png" alt="INACTIVE" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="" echo ^<td width=30^>^<img src="../img/unknown.png" alt="UNKNOWN" /^>^</td^> >>.\pages\%%a.htm
	)

	for /f "tokens=6" %%x in ('PortQry.exe -n %%b -wt 5 -e 23 ^| find /i "TCP"') do (

		echo * Telnet Test		

		if /i "%%x"=="NOT" echo ^<td width=30^>^<img src="../img/inactive.png" alt="INACTIVE" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="LISTENING" echo ^<td width=30^>^<img src="../img/active.gif" alt="ACTIVE" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="TIMEOUT" echo ^<td width=30^>^<img src="../img/unknown.png" alt="UNKNOWN" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="FILTERED" echo ^<td width=30^>^<img src="../img/inactive.png" alt="INACTIVE" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="" echo ^<td width=30^>^<img src="../img/unknown.png" alt="UNKNOWN" /^>^</td^> >>.\pages\%%a.htm
	)

	for /f "tokens=6" %%x in ('PortQry.exe -n %%b -wt 5 -e 3389 ^| find /i "TCP"') do (

		echo * RDP Test
		
		if /i "%%x"=="NOT" echo ^<td width=30^>^<img src="../img/inactive.png" alt="INACTIVE" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="LISTENING" echo ^<td width=30^>^<img src="../img/active.gif" alt="ACTIVE" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="TIMEOUT" echo ^<td width=30^>^<img src="../img/unknown.png" alt="UNKNOWN" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="FILTERED" echo ^<td width=30^>^<img src="../img/inactive.png" alt="INACTIVE" /^>^</td^> >>.\pages\%%a.htm
		if /i "%%x"=="" echo ^<td width=30^>^<img src="../img/unknown.png" alt="UNKNOWN" /^>^</td^> >>.\pages\%%a.htm
	)

	for /f %%t in ('time /t') do echo ^<td width=120^>^<i^>%%t^</i^>^</td^>^</tr^> >>.\pages\%%a.htm

		echo.
		echo ^</table^>^</body^>^</html^> >>.\pages\%%a.htm
)
GOTO :LOOP