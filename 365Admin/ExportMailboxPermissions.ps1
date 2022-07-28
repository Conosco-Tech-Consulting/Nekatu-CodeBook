Import-Module MSOnline 
 $O365Cred = Get-Credential 
 $O365Session = New-PSSession –ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell -Credential $O365Cred -Authentication Basic -AllowRedirection 
Import-PSSession $O365Session -AllowClobber 
Connect-MsolService –Credential $O365Cred

Get-mailbox | Get-MailboxPermission | ?{($_.IsInherited -eq $False) -and -not ($_.User -match “NT AUTHORITY”)} |Select User,Identity,@{Name=”AccessRights”;Expression={$_.AccessRights}} | Export-csv mailboxPermission.csv