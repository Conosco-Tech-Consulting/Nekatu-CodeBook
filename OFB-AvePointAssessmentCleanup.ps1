Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking
 
#Parameters
$AdminCenterURL = "https://idlnetwork-admin.sharepoint.com"
$AdminAccount = "viresh.gohil@idl.eu"
 
Try {
    #Connect to SharePoint Online Admin Center
    Connect-SPOService -Url $AdminCenterURL -Credential (Get-Credential)
 
    #Get All OneDrive for Business Sites in the Tenant
    $OneDriveSites = Get-SPOSite -Limit ALL -includepersonalsite $True -Filter "Url -like '-my.sharepoint.com/personal/'"
      
    #Loop through each OneDrive Site
    Foreach($Site in $OneDriveSites)
    {
        Write-host "Scanning site:"$Site.Url -f Yellow
 
        #Get All Site Collection Administrators
        $SiteAdmins = Get-SPOUser -Site $Site.Url | Where {$_.IsSiteAdmin -eq $true}
 
        #Iterate through each admin
        Foreach($Admin in $SiteAdmins)
        {
            #Check if the Admin Name matches
            If($Admin.LoginName -eq $AdminAccount)
            {
                #Remove Site collection Administrator            
                Set-SPOUser -site $Site -LoginName $AdminAccount -IsSiteCollectionAdmin $False | Out-Null
                Write-host "`tRemoved Site Collection Admin from:"$Site.URL -f Green
            }
        }
    }
}
Catch {
    write-host -f Red "Error Removing Site Collection Admin:" $_.Exception.Message
}