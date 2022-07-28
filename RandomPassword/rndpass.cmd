@ECHO OFF

REM   ==========================================
TITLE Joskos Random Password Generator - v1.0
REM   Copyright (c) Joskos Limited
REM   ==========================================


for /f "tokens=1,2,3 delims=/ " %%a in ('date /t') do set date=%%a-%%b-%%c&set day=%%a&set month=%%b&set year=%%c
for /f "tokens=1 skip=2 delims=rad." %%a in ('cscript "P:\Tech Support\Admin\RNDPass\rnd.vbs"') do set pswd=jk%day%%month%@%%a

net user %username% %pswd% /domain
schtasks /change /rp %pswd% /tn "ABS File"
schtasks /change /rp %pswd% /tn "ABS Tape"
schtasks /change /rp %pswd% /tn "Password Reset"

echo.>%tmp%\pass.tmp
echo.>>%tmp%\pass.tmp
echo Username: %username%>>%tmp%\pass.tmp
echo Password: %pswd%>>%tmp%\pass.tmp
echo.>>%tmp%\pass.tmp
echo NB: This password will be valid for the>>%tmp%\pass.tmp
echo next 24 hours. Do not attempt to login>>%tmp%\pass.tmp
echo using this password once it has expired.>>%tmp%\pass.tmp

blat -install "UMAH" "pswd@joskos.com"
blat "%tmp%\pass.tmp" -to "pswd@joskos.com,arikf@joskos.com,chil27a84@hotmail.com" -subject "%USERDOMAIN% Network Admin Password - %date%"

del %tmp%\pass.tmp