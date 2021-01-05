#Apply Site Policy for a Site collection
Function Apply-PnPSitePolicy([String]$SiteUrl, [String]$PolicyName)
{
    #Connect to the Site 
    Connect-PnPOnline -Url $SiteUrl -UseWebLogin
 
    #Check if "Site Policy" Feature is active
    $SitePolicyFeature = Get-PnPFeature -Identity "2fcd5f8a-26b7-4a6a-9755-918566dba90a" -Scope Site -Web $SiteUrl
    If($SitePolicyFeature.DefinitionId -eq $null)
    {
        #Activate "Site Policy" Feature for the site collection
        Enable-PnPFeature -Identity "2fcd5f8a-26b7-4a6a-9755-918566dba90a" -Scope Site
        Write-Host "Site Policy Feature is Activated at $($SiteUrl)" -ForegroundColor Green
    }
     
    #Get Policy to Activate
    $SitePolicyToActivate = Get-PnPSitePolicy -Name $PolicyName | Select-Object -Property Name
    If ($SitePolicyToActivate)
    {
        #Apply Site Policy
        Set-PnPSitePolicy -Name $PolicyName
 
        #Close the site
        Set-PnPSiteClosure -State Closed
 
        Write-Host "Site Policy Applied to $($SiteUrl)" -ForegroundColor Green
    }
    Else
    {
        write-Host "Site Policy '$($PolicyName)' not found in Site $($SiteUrl)" -ForegroundColor Yellow
    }
}
 
#Parameters
$SiteURL = $Args[0]
$PolicyName= "Migration Lockdown"
 
#Call the function to apply site policy
Apply-PnPSitePolicy -SiteUrl $SiteURL -PolicyName $PolicyName