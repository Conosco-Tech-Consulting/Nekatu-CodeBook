# ================================================

$appname = "|A|B|S|"
$apptag = "Automated Backup Script for Windows Backup"
$appver = "3.0"
$appauth = "Arik Fletcher"
$applic = "Joskos Solutions"
$applink = "http://www.joskos.com"

# ================================================
# Please contact the author before attempting to
# modify this script in any way. All variables
# relating to client customisation are pulled from
# the associated ABS-Conf.ini file and as such no
# changes should be required within this script.
# ================================================

clear-host
add-pssnapin windows.serverbackup

Write-Output ("---------------------------------------------------------------------")
Write-Output ("$appname $appver - $apptag")
Write-Output ("---------------------------------------------------------------------")
Write-Output ("Copyright (c) Arik Fletcher, licensed for use by $applic")
Write-Output ("# Modifications to the code are not permitted without authorisation #")
Write-Output ("---------------------------------------------------------------------")
Write-Output (" ")

# -----------------------------------------
# SET EMAIL FUNCTION
# -----------------------------------------

function SendEmail($To, $From, $Subject, $Body, $attachment, $smtpServer)
 {
 Send-MailMessage -To $To -Subject $Subject -From $From -Body $Body -BodyAsHtml -Attachment $attachment -SmtpServer $smtpServer
 }

# -----------------------------------------
# IMPORT VARIABLES FROM CONFIG FILE
# -----------------------------------------

$orgname = (Get-Content .\abs-config.ini)[0] | %{$Config0 = $_.split("="); Write-Output "$($Config0[1])"}

$backuplocation = (Get-Content .\abs-config.ini)[1] | %{$Config1 = $_.split("="); Write-Output "$($Config1[1])"}
$backupweekly = (Get-Content .\abs-config.ini)[2] | %{$Config2 = $_.split("="); Write-Output "$($Config2[1])"}
$backupdaily = (Get-Content .\abs-config.ini)[3] | %{$Config3 = $_.split("="); Write-Output "$($Config3[1])"}
$backuplogs = (Get-Content .\abs-config.ini)[4] | %{$Config4 = $_.split("="); Write-Output "$($Config4[1])"}
$offsiteday = (Get-Content .\abs-config.ini)[5] | %{$Config5 = $_.split("="); Write-Output "$($Config5[1])"}

$emailto = (Get-Content .\abs-config.ini)[6] | %{$Config6 = $_.split("="); Write-Output "$($Config6[1])"}
$emailfrom = (Get-Content .\abs-config.ini)[7] | %{$Config7 = $_.split("="); Write-Output "$($Config7[1])"}
$emailhost = (Get-Content .\abs-config.ini)[8] | %{$Config8 = $_.split("="); Write-Output "$($Config8[1])"}

$emailuser = (Get-Content .\abs-config.ini)[9] | %{$Config9 = $_.split("="); Write-Output "$($Config9[1])"}
$emailpass = (Get-Content .\abs-config.ini)[10] | %{$Config10 = $_.split("="); Write-Output "$($Config10[1])"}

# -----------------------------------------
# SET ADDITIONAL VARIABLES
# -----------------------------------------

$day = (get-date).dayofweek
$hname = hostname
$backuplog = "$backuplogs"+"\"+(get-date -f MM-dd-yyyy)+"-backup-$hname.log"
$secpasswd = ConvertTo-SecureString $emailpass -AsPlainText -Force
$mycreds = New-Object System.Management.Automation.PSCredential ($emailuser, $secpasswd )
$lastgood = Get-WBBackupSet | Sort-Object VersionID | Select-Object -Last 1 -ExpandProperty BackupTime
$lastfull = Get-WBBackupSet | Sort-Object VersionID | Select-Object -First 1 -ExpandProperty BackupTime
$lastapps = Get-WBBackupSet | Sort-Object BackupTime | Select-Object -Last 1 -ExpandProperty Application
$lastvol = Get-WBBackupSet | Sort-Object BackupTime | Select-Object -Last 1 -ExpandProperty Volume
$lastrest = Get-WBBackupSet | Sort-Object BackupTime | Select-Object -Last 1 -ExpandProperty RecoverableItems

# -----------------------------------------
# CREATE FOLDER STRUCTURE
# -----------------------------------------

New-Item -ItemType Directory -Force -Path $backupweekly
New-Item -ItemType Directory -Force -Path $backupdaily
New-Item -ItemType Directory -Force -Path $backuplogs

# -----------------------------------------
# BEGIN LOG FILE
# -----------------------------------------

Write-Output ("---------------------------------------------------------------------") | Out-File "$backuplog" -Append
Write-Output ("$appname $appver - $apptag") | Out-File "$backuplog" -Append
Write-Output ("---------------------------------------------------------------------") | Out-File "$backuplog" -Append
Write-Output ("Copyright (c) Arik Fletcher, licensed for use by $applic") | Out-File "$backuplog" -Append
Write-Output (" ") | Out-File "$backuplog" -Append

Write-Output ("-------– Backup started on – $(Get-Date –f o) ---------") | Out-File "$backuplog" -Append
$Error.Clear()

# -----------------------------------------
# START BACKUP
# -----------------------------------------

if ($day -eq $offsiteday) {
wbadmin start backup -backupTarget:$backupweekly -allcritical -vsscopy -quiet | Out-File "$backuplog" -Append
} else {
wbadmin start backup -backupTarget:$backupdaily -allcritical -vssfull -quiet | Out-File "$backuplog" -Append
}

# -----------------------------------------
# ERROR CHECK & REPORT
# -----------------------------------------

$emailhead = "<font face=calibri><font color=blue size=4>"
$emailhead += "<b>$appname - $apptag</b>"
$emailhead += "</font><hr>"

$emailfoot = "<p><b>Last Successful Full Backup:</b>&nbsp;&nbsp;$lastfull<br />"
$emailfoot += "<b>Last Successful Incremental:</b>&nbsp;&nbsp;$lastgood</p>"
$emailfoot += "<hr /><i>V$appver Copyright &copy; <a href=http://uk.linkedin.com/in/arikf>Arik Fletcher</a>, licensed for use by "$emailfoot += "<a href=$applink>$applic</a></i>"

$emailfail = $emailhead
$emailfail += "<p><b><font color=red>BACKUP WAS UNSUCCESSFUL</font></b><br />Please review the attached log for more information</p>"
$emailfail += $emailfoot

$emailsuccess = $emailhead
$emailsuccess += "<p><b><font color=green>BACKUP WAS SUCCESSFUL</font></b><br />Please review the attached log for more information</p>"
$emailsuccess += "<p><b>Backup Contents:</b>&nbsp;&nbsp;$lastvol<br/ >"
$emailsuccess += "<b>Included Applications:</b>&nbsp;&nbsp;$lastapps<br />"
$emailsuccess += "<b>Recovery Options:</b>&nbsp;&nbsp;$lastrest</p>"
$emailsuccess += $emailfoot

if(!$?)
{
Write-Output ("-------– An error has occurred! Please check the event log. – $(Get-Date –f o) ---------") | Out-File "$backuplog" -Append
SendEmail -To "$emailto" -From "$emailfrom" -Subject "$orgname - Backup failure on $hname" -Body "The backup has failed - Please check attached log." -attachment "$backuplog" -smtpServer "$emailhost" -credential $mycreds break 
}

Write-Output ("-------– No errors detected, backup was successful – $(Get-Date –f o) ---------") | Out-File "$backuplog" -Append
SendEmail -To "$emailto" -From "$emailfrom" -Subject "$orgname - Backup success on $hname" -Body $emailsuccess -attachment "$backuplog" -smtpServer "$emailhost" -credential $mycreds out string
