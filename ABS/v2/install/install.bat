@echo off
COLOR 1F

:START
CLS

FOR /f "tokens=1,2,3,4 delims=/ " %%a in ('date /t') do set InstDate=%%a%%b%%c%%d
FOR /F %%a in (version.abs) DO SET ABSVer=%%a
IF NOT DEFINED USERDNSDOMAIN SET USERDNSDOMAIN=%USERDOMAIN%.local

TITLE ABS - Automated Backup Script %ABSver% Installation - Copyright (c) Arik Fletcher

ECHO ==================================================================
ECHO ^|A^|B^|S^| - Automated Backup Script %ABSver% for Windows 2k/XP/2k3
ECHO ==================================================================
ECHO Copyright (c) Arik Fletcher, some components (c) their various
ECHO owners and/or publishers. See README.TXT for more information.
ECHO ==================================================================
ECHO.
ECHO Author:  Arik Fletcher
ECHO Contact: arikf@joskos.com
ECHO.
ECHO ABS performs an automated NTBackup based on several environmental
ECHO variables set within this script. Throughout the session, a report
ECHO is generated and then emailed to a specified address along with
ECHO the NTBackup log file. ABS will compress the NTBackup log and move
ECHO it to a specified location and then analyse the log for errors.
ECHO.
ECHO ==================================================================
ECHO.
ECHO NB: Modifications to the script are not permitted unless express 
ECHO permission is granted by the author. Please forward requests for 
ECHO new features to the author at the email address specified above.
ECHO.
ECHO ==================================================================
ECHO.

PAUSE

:CLEANENV
SET ABSdir=
SET BckpFileDst=
SET BckpJET=
SET BckpSharepoint=
SET BckpLogsDir=
SET BckpState=
SET BckpTapeDst=
SET BckpUser=
SET FileRun=
SET HTMLreports=
SET InstDate=
SET OSVer=
SET SMTPrcpt=
SET SMTPsend=
SET SMTPsvr=


:OSCHECK
if not "%OS%"=="Windows_NT" echo ABS requires Windows 2000/XP/2003 to run. & GOTO :EOF

for /f "tokens=4,5 delims=[.] " %%a in ('ver') do set OSVer=%%a.%%b

if "%OSver%"=="Version.5" SET OSName=Windows 2000& GOTO :CONFIG
if "%OSver%"=="5.1" SET OSName=Windows XP& GOTO :CONFIG
if "%OSver%"=="5.2" SET OSName=Windows 2003& GOTO :CONFIG

ECHO Operating System not supported.
ECHO ABS requires Windows 2000/XP/2003 to run.
GOTO :EOF


:CONFIG
CLS
ECHO ==================================================================
ECHO ^|A^|B^|S^| - Automated Backup Script %ABSver% for Windows 2k/XP/2k3
ECHO ==================================================================
ECHO Copyright (c) Arik Fletcher, some components (c) their various
ECHO owners and/or publishers. See README.TXT for more information.
ECHO ==================================================================
ECHO.
ECHO INSTALLATION SETTINGS:
ECHO Press return to accept default options
ECHO.
ECHO Specify the location the location of ABS
SET /P ABSdir=[%ProgramFiles%\ABS] 

IF NOT DEFINED ABSdir SET ABSdir=C:\Progra~1\ABS

ECHO.
ECHO Specify the storage location for backup reports/logs
SET /P BckpLogsDir=[%ABSDir%\Logs] 

IF NOT DEFINED BckpLogsDir SET BckpLogsDir=%ABSDir%\Logs

ECHO.
ECHO Specify the storage location for file backups
SET /P BckpFileDst=[%ABSDir%\Backups] 

IF NOT DEFINED BckpFileDst SET BckpFileDst=%ABSDir%\Backups

ECHO.
ECHO Specify the backup tape media to be used (if any)
SET /P BckpTapeDst=[NONE/DLT/4mm DDS/miniQIC/Travan] 

IF NOT DEFINED BckpTapeDst SET BckpTapeDst=NONE


:MAIL
CLS
ECHO ==================================================================
ECHO ^|A^|B^|S^| - Automated Backup Script %ABSver% for Windows 2k/XP/2k3
ECHO ==================================================================
ECHO Copyright (c) Arik Fletcher, some components (c) their various
ECHO owners and/or publishers. See README.TXT for more information.
ECHO ==================================================================
ECHO.
ECHO EMAIL REPORT SETTINGS:
ECHO.
ECHO Enter the IP address/hostname of the SMTP server that will send the reports
SET /P SMTPsvr=[MAIL.%USERDNSDOMAIN%] 

IF NOT DEFINED SMTPsvr SET SMTPsvr=MAIL.%USERDNSDOMAIN%

ECHO.
ECHO Enter the source email address (SENDER) to be used by ABS:
SET /P SMTPsend=[backups@%USERDNSDOMAIN%] 

IF NOT DEFINED SMTPsend SET SMTPsend=backups@%USERDNSDOMAIN%

ECHO.
ECHO Enter the destination email address(es) (RECIPIENTS) to be used by ABS:
ECHO To send to multiple addresses, separate each address with a comma.
ECHO e.g. backups@%USERDNSDOMAIN%,admin@%USERDNSDOMAIN%
SET /P SMTPrcpt=[backups@%USERDNSDOMAIN%] 

IF NOT DEFINED SMTPrcpt SET SMTPrcpt=backups@%USERDNSDOMAIN%

ECHO.
ECHO Would you like to receive (H)TML or (P)lain-Text reports?
SET /P HTMLreports=[H/P] 

IF NOT DEFINED HTMLreports SET HTMLreports=1
IF /i "%HTMLreports%"=="H" SET HTMLreports=1
IF /i "%HTMLreports%"=="P" SET HTMLreports=0

:MULTIJOB
CLS
ECHO ==================================================================
ECHO ^|A^|B^|S^| - Automated Backup Script %ABSver% for Windows 2k/XP/2k3
ECHO ==================================================================
ECHO Copyright (c) Arik Fletcher, some components (c) their various
ECHO owners and/or publishers. See README.TXT for more information.
ECHO ==================================================================
ECHO.
ECHO Would you like to schedule multiple backup jobs?
ECHO.
ECHO This is useful for environments where backup media is too small to
ECHO hold a complete backup of all your data. This is also a useful
ECHO feature if you wish to spread your backups across multiple media
ECHO over several days.
ECHO.
SET /P MultiBackup=[Y/N] 

IF NOT DEFINED MultiBackup SET MultiBackup=0
IF /i "%MultiBackup%"=="Y" SET MultiBackup=1
IF /i "%MultiBackup%"=="N" SET MultiBackup=0

IF /i "%MultiBackup%"=="1" (

For /l %%a in (1,1,254) do IF /i"%BackupJob%"=="Job%%a" (
ECHO Please enter the contents of Backup Job %%a
ECHO.
call :CONTENT1
call :CONTENT2
call :CONTENT3

)

)


:CONTENT1
CLS
ECHO ==================================================================
ECHO ^|A^|B^|S^| - Automated Backup Script %ABSver% for Windows 2k/XP/2k3
ECHO ==================================================================
ECHO Copyright (c) Arik Fletcher, some components (c) their various
ECHO owners and/or publishers. See README.TXT for more information.
ECHO ==================================================================
ECHO.

ECHO BACKUP SYSTEM CONTENTS:
ECHO.

ECHO Would you like to backup the local system state?
SET /P BckpState=[y/n] 
ECHO.

IF NOT DEFINED BckpState SET BckpState=y

ECHO Would you like to backup an exchange server?
SET /P BckpJET=[y/n] 

IF NOT DEFINED BckpJET SET BckpJET=y

IF /I "%BckpJET%"=="y" (
ECHO.
ECHO Please enter the name of the exchange server:
SET /P BckpMAIL=[%COMPUTERNAME%.%USERDNSDOMAIN%] 
IF NOT DEFINED BckpExch SET BckpExch=%COMPUTERNAME%.%USERDNSDOMAIN%
)

ECHO.
ECHO Would you like to backup a sharepoint services site?
SET /P BckpSharepoint=[y/n] 
ECHO.

IF NOT DEFINED BckpSharepoint SET BckpSharepoint=0
IF /i "%BckpSharepoint%"=="Y" SET BckpSharepoint=1
IF /i "%BckpSharepoint%"=="N" SET BckpSharepoint=0

IF /i "%BckpSharepoint%"=="1" (
ECHO.
ECHO Please enter the address and port of the Sharepoint Server: (e.g. http://localhost:80)
SET /P BckpSharepointHost=[http://localhost:80] 
IF NOT DEFINED BckpSharepointHost SET BckpSharepointHost=http://localhost:80
)

:CONTENT2
CLS
ECHO ==================================================================
ECHO ^|A^|B^|S^| - Automated Backup Script %ABSver% for Windows 2k/XP/2k3
ECHO ==================================================================
ECHO Copyright (c) Arik Fletcher, some components (c) their various
ECHO owners and/or publishers. See README.TXT for more information.
ECHO ==================================================================
ECHO.
ECHO Please enter the full path to the data you would like to backup:
ECHO e.g. %userprofile%\My Documents
ECHO.
SET /P Bckp01=[Folder 01] 
IF DEFINED Bckp01 SET /P Bckp02=[Folder 02] 
IF DEFINED Bckp02 SET /P Bckp03=[Folder 03] 
IF DEFINED Bckp03 SET /P Bckp04=[Folder 04] 
IF DEFINED Bckp04 SET /P Bckp05=[Folder 05] 
IF DEFINED Bckp05 SET /P Bckp06=[Folder 06] 
IF DEFINED Bckp06 SET /P Bckp07=[Folder 07] 
IF DEFINED Bckp07 SET /P Bckp08=[Folder 08] 
IF DEFINED Bckp08 SET /P Bckp09=[Folder 09] 
IF DEFINED Bckp09 SET /P Bckp10=[Folder 10] 


:CONTENT3
ECHO.
ECHO Please enter the subfolders you would like to exclude from the above:
ECHO e.g. %userprofile%\My Documents\My Pictures
ECHO.
SET /P BckpX01=[Folder 01] 
IF DEFINED BckpX01 SET /P BckpX02=[Folder 02] 
IF DEFINED BckpX02 SET /P BckpX03=[Folder 03] 
IF DEFINED BckpX03 SET /P BckpX04=[Folder 04] 
IF DEFINED BckpX04 SET /P BckpX05=[Folder 05] 
IF DEFINED BckpX05 SET /P BckpX06=[Folder 06] 
IF DEFINED BckpX06 SET /P BckpX07=[Folder 07] 
IF DEFINED BckpX07 SET /P BckpX08=[Folder 08] 
IF DEFINED BckpX08 SET /P BckpX09=[Folder 09] 
IF DEFINED BckpX09 SET /P BckpX10=[Folder 10] 



:ACCOUNT
CLS
ECHO ==================================================================
ECHO ^|A^|B^|S^| - Automated Backup Script %ABSver% for Windows 2k/XP/2k3
ECHO ==================================================================
ECHO Copyright (c) Arik Fletcher, some components (c) their various
ECHO owners and/or publishers. See README.TXT for more information.
ECHO ==================================================================
ECHO.
ECHO BACKUP ACCOUNT SETTINGS:
ECHO.
ECHO Please enter the username that you wish the backups to run as:
SET /P BckpUser=[%USERDOMAIN%\%USERNAME%] 

IF NOT DEFINED BckpUser SET BckpUser=%USERDOMAIN%\%USERNAME%

ECHO.
ECHO Please enter the password for the backup user:
SET /P BckpPswd= > NUL
ECHO.
ECHO Please confirm the password:
SET /P BckpPswd1= > NUL

IF NOT "%BckpPswd%"=="%BckpPswd1%" (
ECHO.
ECHO * Passwords do not match - please try again.
PAUSE
GOTO :ACCOUNT
) ELSE (
GOTO SCHEDULE
)


:SCHEDULE
CLS
ECHO ==================================================================
ECHO ^|A^|B^|S^| - Automated Backup Script %ABSver% for Windows 2k/XP/2k3
ECHO ==================================================================
ECHO Copyright (c) Arik Fletcher, some components (c) their various
ECHO owners and/or publishers. See README.TXT for more information.
ECHO ==================================================================
ECHO.

ECHO BACKUP SCHEDULE:
ECHO.
IF /I "%BckpTapeDst%"=="NONE" goto :FILEBCKP


:TAPEBCKP
ECHO Enter the date frequency you wish the tape backups to run: (if applicable)
SET /P TAPErun=[NEVER/DAILY/WEEKLY/WEEKDAYS/WEEKENDS] 
ECHO.

IF NOT DEFINED TapeRun SET TapeRun=NEVER

IF /I "%TAPErun%"=="NEVER" GOTO :FILEBCKP
IF /I "%TAPErun%"=="DAILY" set TAPErun=MON,TUE,WED,THU,FRI,SAT,SUN&GOTO :TAPETIME
IF /I "%TAPErun%"=="WEEKDAYS" set TAPErun=MON,TUE,WED,THU,FRI&GOTO :TAPETIME
IF /I "%TAPErun%"=="WEEKENDS" set TAPErun=SAT,SUN&GOTO :TAPETIME
IF /I "%TAPErun%"=="WEEKLY" (
ECHO Please enter the day^(s^) you wish the backup to run:
SET /P TAPErun=[MON,TUE,WED,THU,FRI,SAT,SUN] 
ECHO.
GOTO :TAPETIME
) ELSE ( 
GOTO :FILEBCKP
)


:TAPETIME
ECHO Enter the time (24 hour notation) you wish the tape backups to happen
SET /P TAPEtime=[00:00 - 23:59] 
ECHO.


:FILEBCKP
ECHO Enter the date frequency you wish the file backups to run: (if applicable)
SET /P FILErun=[NEVER/DAILY/WEEKDAYS/WEEKENDS/WEEKLY] 
ECHO.

IF NOT DEFINED FileRun SET FileRun=NEVER

IF /I "%FILErun%"=="NEVER" GOTO :SUMMARY
IF /I "%FILErun%"=="DAILY" set FILErun=MON,TUE,WED,THU,FRI,SAT,SUN&GOTO :FILETIME
IF /I "%FILErun%"=="WEEKDAYS" set FILErun=MON,TUE,WED,THU,FRI&GOTO :FILETIME
IF /I "%FILErun%"=="WEEKENDS" set FILErun=SAT,SUN&GOTO :FILETIME
IF /I "%FILErun%"=="WEEKLY" (
ECHO Please enter the day^(s^) you wish the backup to run:
SET /P FILErun=[MON,TUE,WED,THU,FRI,SAT,SUN] 
ECHO.
GOTO :FILETIME
) ELSE ( 
GOTO :SUMMARY
)


:FILETIME
ECHO Enter the time (24 hour notation) you wish the file backups to happen
SET /P FILEtime=[00:00 - 23:59] 
ECHO.


:SUMMARY

CLS
ECHO ==================================================================
ECHO ^|A^|B^|S^| - Automated Backup Script %ABSver% for Windows 2k/XP/2k3
ECHO ==================================================================
ECHO Copyright (c) Arik Fletcher, some components (c) their various
ECHO owners and/or publishers. See README.TXT for more information.
ECHO ==================================================================
ECHO.
ECHO ABS CONFIGURATION SUMMARY
ECHO.
ECHO ABS Install Folder:      %ABSdir%
ECHO ABS Reports Folder:      %BckpLogsDir%
ECHO.
ECHO File Backup Folder:      %BckpFileDst%
ECHO Tape Backup Media:       %BckpTapeDst%
ECHO.
IF DEFINED FILERun ECHO File Backup Schedule:    %FILERun%
IF DEFINED TAPERun ECHO Tape Backup Schedule:    %TAPERun%
ECHO.
ECHO Email Server Address:    %SMTPsvr%
ECHO Email Sender:            %SMTPsend%
ECHO Email Recipient(s):      %SMTPrcpt%
IF "%HTMLREPORTS%"=="1" ECHO Email Format:            HTML
IF "%HTMLREPORTS%"=="0" ECHO Email Format:            Plain Text
ECHO.

ECHO Are these settings correct?
SET /P ABSConfirm=[Y/N] 

IF NOT DEFINED ABSConfirm GOTO :UPGCHECK
IF /i "%ABSConfirm%"=="Y" GOTO :UPGCHECK
IF /i "%ABSConfirm%"=="N" GOTO :START

:UPGCHECK
CLS
ECHO ==================================================================
ECHO ^|A^|B^|S^| - Automated Backup Script %ABSver% for Windows 2k/XP/2k3
ECHO ==================================================================
ECHO Copyright (c) Arik Fletcher, some components (c) their various
ECHO owners and/or publishers. See README.TXT for more information.
ECHO ==================================================================
ECHO.
ECHO - Extracting ABS Tools...
ren tools.dat tools.zip
ren extract.dat FBZIP.exe
FBZIP -e -p tools.zip "%SYSTEMROOT%\SYSTEM32"
ren FBZIP.exe extract.dat
ren tools.zip tools.dat

IF EXIST "%ABSdir%\abs.cmd" (

ECHO.
ECHO * A previous version of ABS has been detected.
ECHO   ABS Install will now archive the previous installation.

ECHO.
ECHO - Creating Archive Folder...
MKDIR "%ABSdir%\Old"

ECHO.
ECHO - Archiving previous version of ABS...
attrib -r -a -s -h "%ABSDIR%\*.*"
FBZIP -a %ABSdir%\Old\%instdate%.zip "%ABSdir%"
del "%ABSDIR%\*.*" /f /q

ECHO.
ECHO - Removing Existing Scheduled Tasks...
SCHTASKS /DELETE /TN "ABS Tape Backup" /f
SCHTASKS /DELETE /TN "ABS File Backup" /f

SET UPDATE=YES

) ELSE (

MKDIR "%ABSdir%"
MKDIR "%BckpLogsDir%"
MKDIR "%BckpFileDst%"

)


:INSTALL
CLS
ECHO ==================================================================
ECHO ^|A^|B^|S^| - Automated Backup Script %ABSver% for Windows 2k/XP/2k3
ECHO ==================================================================
ECHO Copyright (c) Arik Fletcher, some components (c) their various
ECHO owners and/or publishers. See README.TXT for more information.
ECHO ==================================================================
ECHO.
ECHO Please enter your ABS installation keycode to start the install.
ECHO If you do not have a key then please request one from the author.
ECHO.
SET /P ABSKEY=
ECHO.
REDSHIRT /d "sys.dat" "sys.tmp"
CCRYPT -b -K%ABSKEY% -q -d sys.tmp
for /f %%a in ('TYPE sys.tmp ^| find /c /i "Automated Backup Script"') do set ABSINST=%%a
IF "%ABSINST%"=="0" GOTO :INSTALL
ren sys.tmp ABS.CMD
move abs.cmd "%ABSDir%"
IF NOT EXIST %ABSdir%\ABS.CMD GOTO :INSTALL
COPY README.TXT %ABSDIR%


:SCRIPTGEN
CLS
ECHO ==================================================================
ECHO ^|A^|B^|S^| - Automated Backup Script %ABSver% for Windows 2k/XP/2k3
ECHO ==================================================================
ECHO Copyright (c) Arik Fletcher, some components (c) their various
ECHO owners and/or publishers. See README.TXT for more information.
ECHO ==================================================================
ECHO.
ECHO GENERATING SCHEDULED TASKS:
IF /I NOT "%TAPErun%"=="NEVER" SCHTASKS /CREATE /tn "ABS Tape Backup" /tr "%ABSdir%\ABS.CMD /BACKUP TAPE" /ru %BckpUser% /rp %BckpPswd% /sc weekly /d %TAPErun% /st %TAPEtime%:00 
IF /I NOT "%FILErun%"=="NEVER" SCHTASKS /CREATE /tn "ABS File Backup" /tr "%ABSdir%\ABS.CMD /BACKUP FILE" /ru %BckpUser% /rp %BckpPswd% /sc weekly /d %FILErun% /st %FILEtime%:00 

CLS
ECHO ==================================================================
ECHO ^|A^|B^|S^| - Automated Backup Script %ABSver% for Windows 2k/XP/2k3
ECHO ==================================================================
ECHO Copyright (c) Arik Fletcher, some components (c) their various
ECHO owners and/or publishers. See README.TXT for more information.
ECHO ==================================================================
ECHO.
ECHO GENERATING SCRIPTS:
ECHO.
ECHO Building ABS Registry Settings...
ECHO.

if /i "%UPDATE%"=="yes" (
REG ADD "HKLM\Software\Joskos Solutions\ABS" /v UpgradeDate /t REG_SZ /d "%date%" /f
) ELSE (
REG ADD "HKLM\Software\Joskos Solutions\ABS" /v InstallDate /t REG_SZ /d "%date%" /f
)

REG ADD "HKLM\Software\Joskos Solutions\ABS" /v InstallPath /t REG_SZ /d "%absdir%" /f
REG ADD "HKLM\Software\Joskos Solutions\ABS" /v CurrentVersion /t REG_SZ /d "%ABSver%" /f
REG ADD "HKLM\Software\Joskos Solutions\ABS" /v MailServerAddress /t REG_SZ /d "%SMTPsvr%" /f
REG ADD "HKLM\Software\Joskos Solutions\ABS" /v MailSender /t REG_SZ /d "%SMTPsend%" /f
REG ADD "HKLM\Software\Joskos Solutions\ABS" /v MailReceiver /t REG_SZ /d "%SMTPrcpt%" /f
REG ADD "HKLM\Software\Joskos Solutions\ABS" /v BackupReportsPath /t REG_SZ /d "%BckpLogsDir%" /f
REG ADD "HKLM\Software\Joskos Solutions\ABS" /v BackupFilesPath /t REG_SZ /d "%BckpFileDst%" /f
REG ADD "HKLM\Software\Joskos Solutions\ABS" /v BackupTapeDevice /t REG_SZ /d "%BckpTapeDst%" /f
REG ADD "HKLM\Software\Joskos Solutions\ABS" /v HTMLReports /t REG_DWORD /d "%HTMLReports%" /f
REG ADD "HKLM\Software\Joskos Solutions\ABS" /v BackupSharepoint /t REG_DWORD /d "%BckpSharepoint%" /f

CLS
ECHO ==================================================================
ECHO ^|A^|B^|S^| - Automated Backup Script %ABSver% for Windows 2k/XP/2k3
ECHO ==================================================================
ECHO Copyright (c) Arik Fletcher, some components (c) their various
ECHO owners and/or publishers. See README.TXT for more information.
ECHO ==================================================================
ECHO.
ECHO Building Backup Selection File...
ECHO.

IF DEFINED BCKP01 %COMSPEC% /u /c "ECHO %Bckp01%>>%absdir%\data.bks"
IF DEFINED BCKP02 %COMSPEC% /u /c "ECHO %Bckp02%>>%absdir%\data.bks"
IF DEFINED BCKP03 %COMSPEC% /u /c "ECHO %Bckp03%>>%absdir%\data.bks"
IF DEFINED BCKP04 %COMSPEC% /u /c "ECHO %Bckp04%>>%absdir%\data.bks"
IF DEFINED BCKP05 %COMSPEC% /u /c "ECHO %Bckp05%>>%absdir%\data.bks"
IF DEFINED BCKP06 %COMSPEC% /u /c "ECHO %Bckp06%>>%absdir%\data.bks"
IF DEFINED BCKP07 %COMSPEC% /u /c "ECHO %Bckp07%>>%absdir%\data.bks"
IF DEFINED BCKP08 %COMSPEC% /u /c "ECHO %Bckp08%>>%absdir%\data.bks"
IF DEFINED BCKP09 %COMSPEC% /u /c "ECHO %Bckp09%>>%absdir%\data.bks"
IF DEFINED BCKP10 %COMSPEC% /u /c "ECHO %Bckp10%>>%absdir%\data.bks"

IF DEFINED BCKPX01 %COMSPEC% /u /c "ECHO %Bckpx01% /Exclude>>%absdir%\data.bks"
IF DEFINED BCKPX02 %COMSPEC% /u /c "ECHO %Bckpx02% /Exclude>>%absdir%\data.bks"
IF DEFINED BCKPX03 %COMSPEC% /u /c "ECHO %Bckpx03% /Exclude>>%absdir%\data.bks"
IF DEFINED BCKPX04 %COMSPEC% /u /c "ECHO %Bckpx04% /Exclude>>%absdir%\data.bks"
IF DEFINED BCKPX05 %COMSPEC% /u /c "ECHO %Bckpx05% /Exclude>>%absdir%\data.bks"
IF DEFINED BCKPX06 %COMSPEC% /u /c "ECHO %Bckpx06% /Exclude>>%absdir%\data.bks"
IF DEFINED BCKPX07 %COMSPEC% /u /c "ECHO %Bckpx07% /Exclude>>%absdir%\data.bks"
IF DEFINED BCKPX08 %COMSPEC% /u /c "ECHO %Bckpx08% /Exclude>>%absdir%\data.bks"
IF DEFINED BCKPX09 %COMSPEC% /u /c "ECHO %Bckpx09% /Exclude>>%absdir%\data.bks"
IF DEFINED BCKPX10 %COMSPEC% /u /c "ECHO %Bckpx10% /Exclude>>%absdir%\data.bks"

IF /I "%BCKPSTATE%"=="y" %COMSPEC% /u /c ECHO SystemState>>%absdir%\data.bks
IF /I "%BCKPSharepoint%"=="1" %COMSPEC% /u /c ECHO %SystemDrive%\SharePointBackup.spb>>%absdir%\data.bks

IF DEFINED BCKPEXCH %COMSPEC% /u /c ECHO JET %BckpExch%\Microsoft Information Store\First Storage Group\>>%absdir%\mail.bks
IF DEFINED BCKPEXCH %COMSPEC% /u /c ECHO JET %BckpExch%\Microsoft Information Store\First Storage Group\>>%absdir%\mail.bks


CLS
ECHO ==================================================================
ECHO ^|A^|B^|S^| - Automated Backup Script %ABSver% for Windows 2k/XP/2k3
ECHO ==================================================================
ECHO Copyright (c) Arik Fletcher, some components (c) their various
ECHO owners and/or publishers. See README.TXT for more information.
ECHO ==================================================================
ECHO.
ECHO Building Backup Update File...
ECHO.

ECHO abs>%absdir%\update.log
ECHO UpD4t3>>%absdir%\update.log
ECHO hash>>%absdir%\update.log
ECHO cd tools>>%absdir%\update.log
ECHO get abs.zip>>%absdir%\update.log
ECHO quit>>%absdir%\update.log

CLS
ECHO ==================================================================
ECHO ^|A^|B^|S^| - Automated Backup Script %ABSver% for Windows 2k/XP/2k3
ECHO ==================================================================
ECHO Copyright (c) Arik Fletcher, some components (c) their various
ECHO owners and/or publishers. See README.TXT for more information.
ECHO ==================================================================
ECHO.
ECHO Securing ABS Files...
ECHO.

redshirt /e "%ABSdir%\data.bks" "%ABSdir%\files.dat"
redshirt /e "%ABSdir%\mail.bks" "%ABSdir%\mail.dat"
redshirt /e "%ABSdir%\update.log" "%ABSdir%\update.dat"

attrib +r "%ABSdir%\update.dat"
attrib +r "%ABSdir%\files.dat"
attrib +r "%ABSdir%\mail.dat"

CLS
ECHO ==================================================================
ECHO ^|A^|B^|S^| - Automated Backup Script %ABSver% for Windows 2k/XP/2k3
ECHO ==================================================================
ECHO Copyright (c) Arik Fletcher, some components (c) their various
ECHO owners and/or publishers. See README.TXT for more information.
ECHO ==================================================================
ECHO.
ECHO Clearing Temp Files...
ECHO.

del "%ABSdir%\data.bks" /f /q
del "%ABSdir%\mail.bks" /f /q
del "%ABSdir%\update.log" /f /q

:ABSCHK1
IF EXIST %ABSdir%\ABS.CMD (
GOTO :ABSCHK2
) ELSE (
GOTO :ABSFAIL
)


:ABSCHK2
IF EXIST %ABSdir%\update.dat (
GOTO :ABSCHK3
) ELSE (
GOTO :ABSFAIL
)


:ABSCHK3
IF EXIST %ABSdir%\mail.dat (
GOTO :ABSCHK4
) ELSE (
GOTO :ABSFAIL
)


:ABSCHK4
IF EXIST %ABSdir%\files.dat (
GOTO :SUCCEED
) ELSE (
GOTO :ABSFAIL
)


:SUCCEED
ECHO * Installation Completed Successfully.
ECHO.
PAUSE
GOTO :END


:FAIL
ECHO * Installation Failed.
ECHO   Please run the installation wizard again.
ECHO.
PAUSE
GOTO :END


:END

SET ABSdir=
SET BckpFileDst=
SET BckpJET=
SET BckpLogsDir=
SET BckpState=
SET BckpTapeDst=
SET BckpUser=
SET FileRun=
SET HTMLreports=
SET InstDate=
SET OSVer=
SET SMTPrcpt=
SET SMTPsend=
SET SMTPsvr=

GOTO :EOF