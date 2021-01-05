#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
 
#Variables
$AdminSiteURL ="https://longview365-admin.sharepoint.com"
$CSVFile = "D:\Scripts\SiteData.csv"
 
#Get Credentials to connect
$Cred= Get-Credential
 
#Connect to Admin Center
Connect-SPOService -Url $AdminSiteURL -Credential $Cred
 
#Get All Site Collections
$Sites = Get-SPOSite -Limit All
$SiteData = @()
 
#Loop through each site collection
ForEach($Site in $Sites)
{
    Write-host -f Yellow "Getting Data for Site:" $Site.URL
    Try {
        #Setup the context
        $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($Site.URL)
        $Ctx.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.Username, $Cred.Password)
          
        #Get the Root Web
        $Web = $Ctx.web
        $Ctx.Load($Web)
        $Ctx.ExecuteQuery()
  
        #Get the last modified date of the site
        $SiteData += New-Object PSObject -Property @{
            SiteTitle = $Web.Title
            URL = $Web.Url
            LastModified= $Web.LastItemUserModifiedDate
        }
    }
    Catch {
        write-host -f Red "Error:" $_.Exception.Message
    }
}
#Export the results to CSV
$SiteData | Export-CSV $CSVFile -NoTypeInformation


#Read more: https://www.sharepointdiary.com/2019/08/sharepoint-online-find-unused-sites-using-powershell.html#ixzz6ODRacgth