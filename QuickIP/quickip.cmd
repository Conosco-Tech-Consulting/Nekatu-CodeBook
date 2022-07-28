@echo off
cls

title Quick IP Changer

echo QUICK IP CHANGER
ECHO ==========================
echo.
echo To use DHCP just press ENTER
echo.
Set /p addr=	* New IP Address:	
set /p snet=	* New Subnet Mask:	
set /p gway=	* New Gateway IP:	
echo.

if "%ip%"=="" (
netsh int ip set address "local area connection" source=dhcp
) else (
netsh int ip set address "local area connection" static "%addr%" "%snet%" "%gway%" 1
)

cls

echo CURRENT SETTINGS
ECHO ==========================
echo.
netsh int ip show address "local area connection"
echo.
pause
