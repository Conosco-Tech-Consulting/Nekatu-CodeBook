@echo off
cls

for /l %%a in (0,1,9) do (
echo.>playlist0%%a.m3u
cscript m3usplit.vbs %1 0%%a
for /f %%b in ('type playlist0%%a.m3u ^| find /c /i "#0%%a"') do if "%%b"=="0" del playlist0%%a.m3u
)

for /l %%a in (10,1,23) do (
echo.>playlist%%a.m3u
cscript m3usplit.vbs %1 %%a
for /f %%b in ('type playlist%%a.m3u ^| find /c /i "#%%a"') do if "%%b"=="0" del playlist%%a.m3u
)