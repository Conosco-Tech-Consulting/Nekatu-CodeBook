@echo off
cls
title Mobile TCP Port Checker

echo =============================================
echo Mobile TCP Port Checker - v1.0
echo Copyright (c) Arik Fletcher
echo =============================================
echo.

echo Please enter the IP address or hostname you wish to connect to.
echo.
set /p ip=Host:		


echo.

echo Please enter the tcp port number you wish to connect to.
echo (RDP port 3389 is recommended as the service starts only when
echo all other services have started and the server is ready to use)
echo.
set /p port=TCP Port:	

set count=0

:LOOP

set /a count=%count%+1
cls
echo =============================================
echo Mobile TCP Port Checker - v1.0
echo Copyright (c) Arik Fletcher
echo.
echo Host: %ip% - Port: %port% - Attempt: %count%
echo =============================================
echo.
echo Server is live when the telnet box stays open
start /min /wait telnet %ip% %port%

goto :LOOP