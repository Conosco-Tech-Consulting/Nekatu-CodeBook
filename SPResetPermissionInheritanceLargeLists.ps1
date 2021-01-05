function Retry()
{
    param(
        [Parameter(Mandatory=$true)][Action]$action,
        [Parameter(Mandatory=$false)][int]$maxAttempts = 3
    )

    $attempts=1    
    $ErrorActionPreferenceToRestore = $ErrorActionPreference
    $ErrorActionPreference = "Stop"

    do
    {
        try
        {
            $action.Invoke();
            break;
        }
        catch [Exception]
        {
            Write-Host $_.Exception.Message
        }

        # exponential backoff delay
        $attempts++
        if ($attempts -le $maxAttempts) {
            $retryDelaySeconds = [math]::Pow(2, $attempts)
            $retryDelaySeconds = $retryDelaySeconds - 1  # Exponential Backoff Max == (2^n)-1
            Write-Host("Action failed. Waiting " + $retryDelaySeconds + " seconds before attempt " + $attempts + " of " + $maxAttempts + ".")
            Start-Sleep $retryDelaySeconds 
        }
        else {
            $ErrorActionPreference = $ErrorActionPreferenceToRestore
            Write-Error $_.Exception.Message
        }
    } while ($attempts -le $maxAttempts)
    $ErrorActionPreference = $ErrorActionPreferenceToRestore
}

function Restore-SPOListAllItemsInheritance
{
  
   param (
        [Parameter(Mandatory=$true,Position=1)]
		[string]$Username,
		[Parameter(Mandatory=$true,Position=2)]
		[string]$Url,
        [Parameter(Mandatory=$true,Position=3)]
		[SecureString]$AdminPassword,
        [Parameter(Mandatory=$true,Position=4)]
		[string]$ListTitle
		)
  
  
  
  $ctx=New-Object Microsoft.SharePoint.Client.ClientContext($Url)
  $ctx.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Username, $AdminPassword)
  $ctx.Load($ctx.Web.Lists)
  $ctx.Load($ctx.Web)
  $ctx.Load($ctx.Web.Webs)
  $ctx.ExecuteQuery()
  $ll=$ctx.Web.Lists.GetByTitle($ListTitle)
  $ctx.Load($ll)
  $ctx.ExecuteQuery()

  ## View XML
$qCommand = @"
<View Scope="RecursiveAll">
    <Query>
        <OrderBy><FieldRef Name='ID' Ascending='TRUE'/></OrderBy>
    </Query>
    <RowLimit Paged="TRUE">5000</RowLimit>
</View>
"@
## Page Position
$position = $null
 
## All Items
$allItems = @()
Do{
    $camlQuery = New-Object Microsoft.SharePoint.Client.CamlQuery
    $camlQuery.ListItemCollectionPosition = $position
    $camlQuery.ViewXml = $qCommand
 ## Executing the query
    $currentCollection = $ll.GetItems($camlQuery)
    $ctx.Load($currentCollection)
    $ctx.ExecuteQuery()
 
 ## Getting the position of the previous page
    $position = $currentCollection.ListItemCollectionPosition
 
 # Adding current collection to the allItems collection
    $allItems += $currentCollection

     Write-Host "Collecting items. Current number of items: " $allItems.Count


}


 while($position -ne $null)
 

 Write-Host "Total number of items: " $allItems.Count

for($j=0;$j -lt $allItems.Count ;$j++)
  {
        
      Write-Host "Resetting permissions for " $allItems[$j]["Title"] ".." $allItems[$j]["FileRef"]
      $allItems[$j].ResetRoleInheritance()
      Retry {$ctx.ExecuteQuery()} -maxAttempts 10
   
  }

 
   

  
  
  }


# Paths to SDK. Please verify location on your computer.
Add-Type -Path "c:\Program Files\Common Files\microsoft shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll" 
Add-Type -Path "c:\Program Files\Common Files\microsoft shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"

#Enter the data
$AdminPassword=Read-Host -Prompt "Enter password" -AsSecureString
$username="conoscoadmin@SocialFinanceLtd.onmicrosoft.com"
$Url="https://socialfinanceltd.sharepoint.com/sites/AdvisoryTeam"
$ListTitle="DWP Innovation Fund"


#Restore-SPOListAllItemsInheritance -Username $username -Url $Url -AdminPassword $AdminPassword -ListTitle $ListTitle

Restore-SPOListAllItemsInheritance -Username $username -Url "https://socialfinanceltd.sharepoint.com/sites/AdvisoryTeam" -AdminPassword $AdminPassword -ListTitle "Documents"
Restore-SPOListAllItemsInheritance -Username $username -Url "https://socialfinanceltd.sharepoint.com/sites/AdvisoryTeam" -AdminPassword $AdminPassword -ListTitle "Housing Documents"
Restore-SPOListAllItemsInheritance -Username $username -Url "https://socialfinanceltd.sharepoint.com/sites/AdvisoryTeam" -AdminPassword $AdminPassword -ListTitle "Data"
Restore-SPOListAllItemsInheritance -Username $username -Url "https://socialfinanceltd.sharepoint.com/sites/AdvisoryTeam" -AdminPassword $AdminPassword -ListTitle "DWP Innovation Fund"
Restore-SPOListAllItemsInheritance -Username $username -Url "https://socialfinanceltd.sharepoint.com/sites/AdvisoryTeam" -AdminPassword $AdminPassword -ListTitle "DWP Youth Engagement Fund"
Restore-SPOListAllItemsInheritance -Username $username -Url "https://socialfinanceltd.sharepoint.com/sites/HR" -AdminPassword $AdminPassword -ListTitle "Documents"
Restore-SPOListAllItemsInheritance -Username $username -Url "https://socialfinanceltd.sharepoint.com/sites/HSCTeam" -AdminPassword $AdminPassword -ListTitle "Documents"
Restore-SPOListAllItemsInheritance -Username $username -Url "https://socialfinanceltd.sharepoint.com/sites/HSCteam" -AdminPassword $AdminPassword -ListTitle "Documents"
Restore-SPOListAllItemsInheritance -Username $username -Url "https://socialfinanceltd.sharepoint.com/sites/InternationalTeam" -AdminPassword $AdminPassword -ListTitle "Documents"
Restore-SPOListAllItemsInheritance -Username $username -Url "https://socialfinanceltd.sharepoint.com" -AdminPassword $AdminPassword -ListTitle "Documents"
Restore-SPOListAllItemsInheritance -Username $username -Url "https://socialfinanceltd.sharepoint.com" -AdminPassword $AdminPassword -ListTitle "Precedent Documents"
Restore-SPOListAllItemsInheritance -Username $username -Url "https://socialfinanceltd.sharepoint.com" -AdminPassword $AdminPassword -ListTitle "HR"
Restore-SPOListAllItemsInheritance -Username $username -Url "https://socialfinanceltd.sharepoint.com" -AdminPassword $AdminPassword -ListTitle "Compliance"
Restore-SPOListAllItemsInheritance -Username $username -Url "https://socialfinanceltd.sharepoint.com" -AdminPassword $AdminPassword -ListTitle "Due Diligence"
Restore-SPOListAllItemsInheritance -Username $username -Url "https://socialfinanceltd.sharepoint.com" -AdminPassword $AdminPassword -ListTitle "Knowledge"
Restore-SPOListAllItemsInheritance -Username $username -Url "https://socialfinanceltd.sharepoint.com/sites/MHEPbackupdata" -AdminPassword $AdminPassword -ListTitle "Wdrive Backup"
Restore-SPOListAllItemsInheritance -Username $username -Url "https://socialfinanceltd.sharepoint.com/sites/operations" -AdminPassword $AdminPassword -ListTitle "Documents"
Restore-SPOListAllItemsInheritance -Username $username -Url "https://socialfinanceltd.sharepoint.com/sites/SocialFinanceCommunications" -AdminPassword $AdminPassword -ListTitle "Documents"
Restore-SPOListAllItemsInheritance -Username $username -Url "https://socialfinanceltd.sharepoint.com/sites/TeamPipeline" -AdminPassword $AdminPassword -ListTitle "Documents"
