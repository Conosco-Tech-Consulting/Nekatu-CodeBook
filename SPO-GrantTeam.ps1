#Variables
$SiteURLs = "Advertising","Campaigns","Contentmarketing","Events","Identity","MarketingMaterials","Press","Referrals","Trips","Website"
$UserIDs = "raedas@raedas.com"
 
#Iterate through each site
ForEach($Site in $SiteURLs)
{
    #Connect to SharePoint Online Site
    Write-host "Connecting to Site: "$Site
    Connect-PnPOnline -Url https://raedas.sharepoint.com/sites/$Site -UseWebLogin
 
    #Get the Associcated Owners group of the site
    $Web = Get-PnPWeb
    $Group = Get-PnPGroup -AssociatedMemberGroup
 
    #Add Each user to the Group
    ForEach($User in $UserIDs)
    {
        Add-PnPUserToGroup -LoginName $User -Identity $Group
        Write-host -f Green "`tAdded $User to $($Group.Title)"
    }
}