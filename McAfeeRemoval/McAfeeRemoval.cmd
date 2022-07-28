@echo off

if not exist "%systemdrive%\mcafee.log" (

echo.
echo * Removing McAfee Agent...
echo.
start /wait msiexec.exe /q /x{2AAB21C2-4CDA-4189-A0EC-5ED666113F84} forceuninstall=true

echo.
echo * Removing McAfee Site Advisor...
echo.
start /wait msiexec.exe /q /x{00FC3F65-86EB-475E-881F-A5B1CF731320} forceuninstall=true 

echo.
echo * Removing McAfee VirusScan...
echo.
start /wait msiexec.exe /q /x{CE15D1B6-19B6-4D4D-8F43-CF5D2C3356FF} forceuninstall=true

echo %date% %time% > "%systemdrive%\mcafee.log" 

)

if exist ""C:\Program Files\McAfee\Common Framework\frminst.exe" (

"C:\Program Files\McAfee\Common Framework\frminst.exe" /remove=agent

)