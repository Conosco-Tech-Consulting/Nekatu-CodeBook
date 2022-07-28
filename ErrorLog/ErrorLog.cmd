for /f "tokens=1,2,3,4 delims=/ " %%a in ('date /t') do set logdate=%%a%%b%%c%%d
md c:\eventlogs\%logdate%

for /f "tokens=1-3 delims=$ " %%a in ('net group "FM servers" /domain ^| find /i "$"') do (

psloglist.exe \\%%a /s /t \t /f we /x /c "Application">c:\EventLogs\%logdate%\%%a-app.tsv
psloglist.exe \\%%a /s /t \t /f we /x /c "System">c:\EventLogs\%logdate%\%%a-sys.tsv
psloglist.exe \\%%a /s /t \t /f we /x /c "Security">c:\EventLogs\%logdate%\%%a-sec.tsv
psloglist.exe \\%%a /s /t \t /f we /x /c "DNS Server">c:\EventLogs\%logdate%\%%a-dns.tsv
psloglist.exe \\%%a /s /t \t /f we /x /c "File Replication Service">c:\EventLogs\%logdate%\%%a-frs.tsv 
psloglist.exe \\%%a /s /t \t /f we /x /c "Directory Service">c:\EventLogs\%logdate%\%%a-ads.tsv 

psloglist.exe \\%%b /s /t \t /f we /x /c "Application">c:\EventLogs\%logdate%\%%b-app.tsv
psloglist.exe \\%%b /s /t \t /f we /x /c "System">c:\EventLogs\%logdate%\%%b-sys.tsv
psloglist.exe \\%%b /s /t \t /f we /x /c "Security">c:\EventLogs\%logdate%\%%b-sec.tsv
psloglist.exe \\%%b /s /t \t /f we /x /c "DNS Server">c:\EventLogs\%logdate%\%%b-dns.tsv
psloglist.exe \\%%b /s /t \t /f we /x /c "File Replication Service">c:\EventLogs\%logdate%\%%b-frs.tsv 
psloglist.exe \\%%b /s /t \t /f we /x /c "Directory Service">c:\EventLogs\%logdate%\%%b-ads.tsv 

psloglist.exe \\%%c /s /t \t /f we /x /c "Application">c:\EventLogs\%logdate%\%%c-app.tsv
psloglist.exe \\%%c /s /t \t /f we /x /c "System">c:\EventLogs\%logdate%\%%c-sys.tsv
psloglist.exe \\%%c /s /t \t /f we /x /c "Security">c:\EventLogs\%logdate%\%%c-sec.tsv
psloglist.exe \\%%c /s /t \t /f we /x /c "DNS Server">c:\EventLogs\%logdate%\%%c-dns.tsv
psloglist.exe \\%%c /s /t \t /f we /x /c "File Replication Service">c:\EventLogs\%logdate%\%%c-frs.tsv 
psloglist.exe \\%%c /s /t \t /f we /x /c "Directory Service">c:\EventLogs\%logdate%\%%c-ads.tsv

)
