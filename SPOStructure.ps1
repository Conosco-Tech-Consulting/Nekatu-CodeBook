###Function to Get Lists and Libraries of a web
Function Get-SPOSiteInventory([Microsoft.SharePoint.Client.Web]$Web)
{
    Write-host -f Yellow "Getting Lists and Libraries from site:" $Web.URL
  
    ###Get all lists and libraries
    $SiteInventory= @()
    $Lists= Get-PnPList -Web $Web
    foreach ($List in $Lists)
    {
        $Data = new-object PSObject
        $Data | Add-member NoteProperty -Name "Site Name" -Value $Web.Title
        $Data | Add-member NoteProperty -Name "Site URL" -Value $Web.Url
        $Data | Add-member NoteProperty -Name "List Title" -Value $List.Title
        $Data | Add-member NoteProperty -Name "List URL" -Value $List.RootFolder.ServerRelativeUrl
        $Data | Add-member NoteProperty -Name "List Item Count" -Value $List.ItemCount
        $Data | Add-member NoteProperty -Name "Last Modified" -Value $List.LastItemModifiedDate
        $SiteInventory += $Data
    }
  
    ###Get All Subwebs
    $SubWebs = Get-PnPSubWebs -Web $Web
    Foreach ($Web in $SubWebs)
    {
        $SiteInventory+= Get-SPOSiteInventory -Web $Web
    }
    Return $SiteInventory
}
  
###Config Variables
$SiteURL = "https://raedas.sharepoint.com"
$CSVFile = "d:\output\newstructure.csv"
  
###Get Credentials to connect
  
Try {
    #Connect to PNP Online
    Connect-PnPOnline -Url $SiteURL -UseWebLogin
  
    ###Get the Root Web
    $Web = Get-PnPWeb
  
    ###Call the function and export results to CSV file
    Get-SPOSiteInventory -Web $Web | Export-CSV $CSVFile -NoTypeInformation
}
Catch {
    write-host "Error: $($_.Exception.Message)" -foregroundcolor Red
}