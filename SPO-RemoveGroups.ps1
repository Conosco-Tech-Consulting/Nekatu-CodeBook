#Parameters
$SiteURL = $Args[0]
$ListName ="Documents"
$GroupName= "Sales Portal Members"
 
#Connect PNP Online
Connect-PnPOnline -Url $SiteURL -Credentials (Get-Credential)
 
#Get the Context
$Context = Get-PnPContext
  
#Get the list
$List = Get-PnPList -Identity $ListName
$Group = Get-PnPGroup -Identity $GroupName
 
#Break Permission Inheritance
Set-PnPList -Identity $ListName -BreakRoleInheritance -CopyRoleAssignments
 
#sharepoint online powershell remove group permissions
$List.RoleAssignments.GetByPrincipal($Group).DeleteObject()
$Context.ExecuteQuery()

#Read more: https://www.sharepointdiary.com/2018/04/sharepoint-online-remove-user-group-from-list-permissions-using-powershell.html#ixzz6cZwHY1rh

  
#Connect to PNP Online
Connect-PnPOnline -Url $SiteURL -UseWebLogin
 
#Get all list items in batches
$ListItems = Get-PnPListItem -List $ListName -PageSize 500
 
#Iterate through each list item
ForEach($ListItem in $ListItems)
{
    #Check if the Item has unique permissions
    $HasUniquePermissions = Get-PnPProperty -ClientObject $ListItem -Property "HasUniqueRoleAssignments"
    If($HasUniquePermissions)
    {        
        $Msg = "Deleting Unique Permissions on {0} '{1}' at {2} " -f $ListItem.FileSystemObjectType,$ListItem.FieldValues["FileLeafRef"],$ListItem.FieldValues["FileRef"]
        Write-host $Msg
        #Delete unique permissions on the list item
        Set-PnPListItemPermission -List $ListName -Identity $ListItem.ID -InheritPermissions
    }
}
