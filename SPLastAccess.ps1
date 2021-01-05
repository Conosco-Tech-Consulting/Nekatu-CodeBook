#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
 
#Variables
$SiteURL ="https://longview365.sharepoint.com"
 
#Get Credentials to connect
$Cred= Get-Credential
 
Function Get-SPOSiteLastModified($SiteURL)
{
    Try {
        #Setup the context
        $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
        $Ctx.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.Username, $Cred.Password)
          
        #Get the site
        $Web = $Ctx.web
        $Ctx.Load($Web)
        $Ctx.ExecuteQuery()
  
        #Get the last modified date of the site
        Write-host "Last Modified Date of $($SiteURL):"$Web.LastItemUserModifiedDate
 
        #Get Subsites of the site
        $Webs = $Web.Webs
        $Ctx.Load($Webs)
        $Ctx.ExecuteQuery()
        ForEach($SubWeb in $Webs)
        {
            #Call the function to get subsite's last modified date               
            Get-SPOSiteLastModified $SubWeb.URL
        }
    }
    Catch {
        write-host -f Red "Error:" $_.Exception.Message
    }
}
 
#Call the function to get last modified date of a site and its subsites

Start-Transcript -Path "D:\Scripts\AccessData.csv" -NoClobber
Get-SPOSiteLastModified $SiteURL
Stop-Transcript
