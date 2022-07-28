for %%i in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do if exist %%i:\nul (

for /f %%a in ('net use ^| find /c /i "%%i:"') do if "%%a"=="0" (

for /f "tokens=3 delims= " %%b in ('dir %%i:\ ^| find /i "bytes free"') do if not "%%b"=="0" (

echo. >> %SHR_Rprt%
echo -------------------------------------------------------------- >> %SHR_Rprt%
echo ANALYSING DRIVE %%i:\ FRAGMENTATION >> %SHR_Rprt%
echo -------------------------------------------------------------- >> %SHR_Rprt%

defrag %%i: -v -a | find /v /i "copyright" | find /v /i "Windows Disk Defragmenter" >> %SHR_Rprt%
echo. >> %SHR_Rprt%

)

)

)
