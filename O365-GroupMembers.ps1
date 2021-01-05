### All users of all groups 
 
$CSVPath = "D:\Output\AllGroupMembersList.csv"
  
### Get Credentials
$Credential = Get-Credential
    
### Create Session
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $Credential -Authentication Basic -AllowRedirection
    
### Import Session
Import-PSSession $Session -DisableNameChecking
 
### Remove the CSV file if already exists
If(Test-Path $CSVPath) { Remove-Item $CSVPath}
 
### Retreive all Office 365 Groups
$O365Groups=Get-UnifiedGroup
ForEach ($Group in $O365Groups) 
{ 
    Write-Host "Group Name:" $Group.DisplayName -ForegroundColor Green
    Get-UnifiedGroupLinks -Identity $Group.Id -LinkType Members | Select DisplayName,PrimarySmtpAddress
  
    ### Get Group Members and export to CSV
    Get-UnifiedGroupLinks -Identity $Group.Id -LinkType Members | Select-Object @{Name="Group Name";Expression={$Group.DisplayName}},`
         @{Name="User Name";Expression={$_.DisplayName}}, PrimarySmtpAddress | Export-CSV $CSVPath -NoTypeInformation -Append
}
   
#Remove the session 
Remove-PSSession $Session