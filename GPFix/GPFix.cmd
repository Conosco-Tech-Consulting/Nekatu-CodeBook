@echo off
cls
echo - Disabling Media Sensing...
reg add HKLM\System\CurrentControlSet\Services\Tcpip\Parameters /v DisableDHCPMediaSense /t REG_DWORD /d 1 /f
echo.
echo - Extending Group Policy Timeout...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\Current Version\Winlogon" /v GpNetworkStartTimeoutPolicyValue /t REG_DWORD /d 120 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v GpNetworkStartTimeoutPolicyValue /t REG_DWORD /d 120 /f
echo.
echo - Syncronising Policy Settings...
ECHO y|GPUPDATE /FORCE
echo.
echo The computer must be restarted to activate the settings.
echo Please run GPUPDATE /FORCE on next logon if policies do not apply.
pause
shutdown -r -t 0 -f