@echo off

for /f %%a in ('dir /b \\nsa-filesrv\shared') do (

	if /i not "%%a"=="administrator" (
		taskkill /fi "username eq nsa\%%a" /fi "imagename eq svchost.exe" /f
		taskkill /fi "username eq %%a" /fi "imagename eq svchost.exe" /f
	)

)