for /f "tokens=1,2,3 delims=/" %%a in ("%date%") do set SHR_Date=%%a%%b%%c

set SHR_MailRcpt=arik@coopsys.net
set SHR_MailSvr=mailgate.coopsys.net
set SHR_DirPath=%SystemDrive%\SHR
set SHR_EvntPath=%SHR_DirPath%\Events
set SHR_Rprt=%SHR_DirPath%\%SHR_Date%-%computername%.htm
set SHR_ArcFile=%SHR_DirPath%\%SHR_Date%-%computername%.zip
Set SHR_EvntSec=%SHR_EvntPath%\%SHR_Date%-Sec-%computername%.csv
Set SHR_EvntSys=%SHR_EvntPath%\%SHR_Date%-Sys-%computername%.csv
Set SHR_EvntApp=%SHR_EvntPath%\%SHR_Date%-App-%computername%.csv

if exist %SHR_DirPath%\. (
RD /s /q %SHR_DirPath%
)

MD %SHR_DirPath%
MD %SHR_EvntPath%

ECHO ^<html^>^<title^>System Health Report^</title^> > %SHR_Rprt%
echo ^<style type="text/css"^> >> "%SHR_Rprt%"
echo ^<!-- >> "%SHR_Rprt%"
echo body {background-color: #FFFFFF} >> "%SHR_Rprt%"
echo body,td,th {font-family: Verdana; font-size: 10px; color: #000000} >> "%SHR_Rprt%"
echo .heading {font-family: Tahoma; font-size: 18px} >> "%SHR_Rprt%"
echo .section {font-size: 14px; font-weight: bold; background-color: #CCCCFF} >> "%SHR_Rprt%"
echo .fieldtitle {font-size: 10px; font-weight: bold; background-color: #EEEEEE} >> "%SHR_Rprt%"
echo --^> >> "%SHR_Rprt%"
echo ^<^/style^> >> "%SHR_Rprt%"
ECHO ^<body^>^<table^> >> %SHR_Rprt%
ECHO ^<tr^>^<td colspan=2^>^<hr^>^</td^>^</tr^> >> %SHR_Rprt%
ECHO ^<tr^>^<td width=250px^>^<img src=http://www.coopsys.net/templates/images/logo_rgb3.gif /^>^</td^> >> %SHR_Rprt%
ECHO ^<td class=heading^>^<strong^>SYSTEM HEALTH REPORT^</strong^> >> %SHR_Rprt%
ECHO ^<br^>Copyright ^&copy Co-Operative Systems^</td^>^</tr^> >> %SHR_Rprt%
ECHO ^<tr^>^<td colspan=2^>^<hr^>^</td^>^</tr^> >> %SHR_Rprt%

