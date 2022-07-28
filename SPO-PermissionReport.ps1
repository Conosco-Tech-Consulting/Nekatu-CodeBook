#SPO-specific cmdlets require sharepoint-online module
Install-Module -Name Microsoft.Online.SharePoint.PowerShell
$ServiceURL = "https://insightsw-admin.sharepoint.com"
$URL = "https://insightsw.sharepoint.com"
$Path = "D:\output\SharePointReport.csv"
$Cred = Get-Credential
#Connect to SharePoint Online
Connect-SPOService -url $ServiceURL -Credential $Cred
#Generating Report
$GroupsData = @()
#get sharepoint online groups powershell
$SiteGroups = Get-SPOSiteGroup -Site $URL
ForEach($Group in $SiteGroups) {
$GroupsData += New-Object PSObject-Property @{
'Group Name' = $Group.Title
'Permissions' = $Group.Roles -join ","
'Users' = $Group.Users -join ","
}
}
#Export the data to CSV
$GroupsData |Export-Csv $Path-NoTypeInformation