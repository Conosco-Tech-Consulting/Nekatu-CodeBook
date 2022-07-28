Import-Module MSOnline 
 $O365Cred = Get-Credential 
 $O365Session = New-PSSession –ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell -Credential $O365Cred -Authentication Basic -AllowRedirection 
Import-PSSession $O365Session -AllowClobber 
Connect-MsolService –Credential $O365Cred

$allUsers = Get-Mailbox | Select Identity

ForEach ( $user in $allUsers ) {
    Get-Mailbox | ForEach { 
        If ( $_.Identity -ne $user.Identity ) {
            Add-MailboxFolderPermission $($_.SamAccountName+":\calendar") -User $user.Identity -AccessRights Reviewer
        }
    }
}