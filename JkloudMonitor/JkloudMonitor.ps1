# Script:   JkloudMonitor.ps1
# Created:  26/01/2016
# Version:  1.0
# Author:   Arik Fletcher
# Contact:  arikf@joskos.com
#============================================
# Copyright (c) Joskos Solutions Limited

#--------------------------------------------
# Define Email Variables
#--------------------------------------------

$smtp="172.16.0.253"
$from="Jkloud Monitoring Alert <jkloud@joskos.com>"
$to="jkloud.JOSKOS.COM@email.uk.autotask.net"

#--------------------------------------------
# Download Jkloud Usage Report
#--------------------------------------------

$src = "https://joskosgroup.sharepoint.com/support/Jkloud/_layouts/15/guestaccess.aspx?guestaccesstoken=MqTfA%2bgfLWD9%2fyuBk70vfkWpPO5lAzEbKuJAJOfe6og%3d&docid=1a0f740e1933b4fd8bb61f21e338ca426"
$dst = "c:\windows\temp\export.csv"
Invoke-WebRequest $src -OutFile $dst

#--------------------------------------------
# Import Jkloud Usage Report
#--------------------------------------------

$File = Import-Csv $src

#--------------------------------------------
# Analyse Jkloud Usage Report
#--------------------------------------------

ForEach ($item in $File) {

$used = [math]::Round($item."Used (Gb)")
$quota = $item."Quota"
$warn = $item."Quota" - 25
$company = $item."Company"
$user = $item."User"
$body="<font face=arial><table><tr><td>Company:</td><td>$company</td></tr><tr><td>User:</td><td>$User</td></tr><td>Usage:</td><td>$used GB</td></tr><tr><td>Quota:</td><td>$quota GB</td></tr><tr><td>Warning:</td><td>$warn GB</td></tr></table></font>"

#--------------------------------------------
# Alert if client is approaching limit
#--------------------------------------------

if ($used -gt $warn -and $used -lt $quota) {

$subject="Jkloud: Approaching licensed limit - $Company"
Send-Mailmessage -smtpServer $smtp -from $user -to $to -bcc $from -subject $subject -body $body -bodyasHTML -priority High

#--------------------------------------------
# Alert if client has exceeded limit
#--------------------------------------------

} elseif ($used -ge $quota) {

$subject="Jkloud: Exceeded licensed limit - $Company"
Send-Mailmessage -smtpServer $smtp -from $user -to $to -bcc $from -subject $subject -body $body -bodyasHTML -priority High

}
}