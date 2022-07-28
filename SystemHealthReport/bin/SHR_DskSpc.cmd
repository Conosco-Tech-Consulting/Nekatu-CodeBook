echo. >> %SHR_Rprt%
echo -------------------------------------------------------------- >> %SHR_Rprt%
echo CHECKING AVAILABLE DISK SPACE >> %SHR_Rprt%
echo -------------------------------------------------------------- >> %SHR_Rprt%
echo. >> %SHR_Rprt%

for %%i in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do if exist %%i:\nul (

for /f %%a in ('net use ^| find /c /i "%%i:"') do if "%%a"=="0" (

for /f "tokens=3 delims= " %%a in ('dir %%i:\ ^| find /i "bytes free"') do if not "%%a"=="0" echo %%i:\ - %%a bytes free before defragmentation >> %SHR_Rprt%

)

)
