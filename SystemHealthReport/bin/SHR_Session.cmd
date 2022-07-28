echo ^<tr^>^<td colspan=2^> >> %SHR_Rprt%
echo ^<u^>^<h3^>^<img src=file:///C:/Users/nekatu/Projects/SystemHealthReport/img/info.gif /^>^&nbsp Session Information^</h3^>^</u^> >> %SHR_Rprt%
echo ^</td^>^</tr^> >> %SHR_Rprt%

echo ^<tr^>^<td^>^&nbsp^&nbsp^<b^>Report Date:^</b^>^</td^>^<td^>%date%^</td^>^</tr^> >> %SHR_Rprt%
echo ^<tr^>^<td^>^&nbsp^&nbsp^<b^>Recipient:^</b^>^</td^>^<td^>%SHR_MailRcpt%^</td^>^</tr^> >> %SHR_Rprt%
echo ^<tr^>^<td^>^&nbsp^&nbsp^<b^>Mail Server:^</b^>^</td^>^<td^>%SHR_MailSvr%^</td^>^</tr^> >> %SHR_Rprt%

ECHO ^<tr^>^<td colspan=2^>^<hr^>^</td^>^</tr^> >> %SHR_Rprt%