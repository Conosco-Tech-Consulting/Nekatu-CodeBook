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
ECHO ^<body^>^<font face=arial^>^<hr^> >> %SHR_Rprt%
ECHO ^<p^>^<b^>System Health Report^</b^> >> %SHR_Rprt%
ECHO ^<br^>Copyright ^&copy Co-Operative Systems^</p^>^<hr^> >> %SHR_Rprt%

