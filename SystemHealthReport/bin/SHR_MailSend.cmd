echo. >> %SHR_Rprt%
echo. >> %SHR_Rprt%
echo -------------------------------------------------------------- >> %SHR_Rprt%
echo SENDING REPORT EMAIL >> %SHR_Rprt%
echo -------------------------------------------------------------- >> %SHR_Rprt%
echo. >> %SHR_Rprt%

:SEND
echo.
echo Report will be sent as follows:
echo.
echo - Email To:  %SHR_MailRcpt%
echo - SMTP Host: %SHR_MailSvr%
echo.

.\bin\blat -install "%SHR_MailSvr%" SHR@coopsys.net 3 -q
.\bin\blat "%SHR_Rprt%" -to "%SHR_MailRcpt%" -subject "Health Report - %COMPUTERNAME% - %DATE%" -attach "%SHR_ArcFile%" -q

if not "%errorlevel%"=="0" (
echo.
echo Unable to send report, please confirm settings.
echo.
set /p SHR_MailRcpt=Enter the recipient address:   
set /p SHR_MailSvr=Enter the SMTP server address: 
echo.
echo To send the report with the above settings,
pause
goto :SEND
)