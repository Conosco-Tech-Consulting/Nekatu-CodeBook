echo off

REM disconnect all exisiting Network drives

net use G: /d
net use P: /d
net use X: /d
net use Z: /d

REM Set Time from Server

net time \\unicorn-dc /set /y


IF EXIST c:\printmig081105.txt Goto :skip
REM Deleting and installing Printers

cscript c:\windows\system32\prnmngr.vbs -d -p "HP LaserJet 4050 Series (1st Floor)"
cscript c:\windows\system32\prnmngr.vbs -d -p "HP LaserJet 4050 Series (3rd Floor)"
cscript c:\windows\system32\prnmngr.vbs -d -p "Canon iR2200 Copier"
cscript c:\windows\system32\prndrvr.vbs -a -m "HP LaserJet 1022n" -h "\\unicorn-dc\Client Apps\LJ1022n" -i "\\unicorn-dc\Client Apps\LJ1022n\HPLJ1020.inf"

"\\unicorn-dc\Client Apps\printmig\printmig31.exe" -r "\\unicorn-dc\Client Apps\printmig\newbuilding.cab"

ECHO Printmig %DATE% >> c:\printmig081105.txt

:Skip

REM Change PC comment to current user logged in.
REM NB: Works only with WIN2K-XP PRO
NET CONFIG SERVER /SRVCOMMENT:""

REM Enable Messengerservice and allow File and Print Sharing
netsh firewall set service type = FILEANDPRINT mode = ENABLE scope = SUBNET
sc config messenger start= auto
net start messenger


REM Run Script that maps Network Drives based on Logon Server

wscript \\unicorn-dc\netlogon\unicornusers.vbs


:end
