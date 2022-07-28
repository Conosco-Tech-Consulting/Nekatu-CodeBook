# Description
#   Check-in and Publishes all checked-out files in a library
#
# Syntax
#   ./pubFiles [[-l] <string>] [[-f] <string>]
#
# Parameters
#   [[-l] <string>]
#       Specify an alternate library to publish files in
#
#   [[-f] <string>]
#       Filter to use when searching for files to publish
#
#       Example:
#       ./pubFiles -f file.jpg      - returns exact match
#       ./pubFiles -f ?ile.jpg      - single character wildcard
#       ./pubFiles -f *e.jpg        - multiple character wildcard
#
# Settings
#   Only change the -value parameter!
#
set-variable -option constant -name url     -value "http://joskosgroup.sharepoint.com/Projects"     # Site collection
set-variable -option constant -name comment -value "System Approval"            # Publishing comment
set-variable -option constant -name lib     -value "Shared Documents"              # Library to publish
set-variable -option constant -name dfilter -value "*"                          # Default file filter
# End of settings

# Function: Approve-File
# Description: Approve a single file in a Publishing Web
# Parameters: publishingPage File object
# comment Comment to accompany the check-in/approve/publish
#
function Approve-File ([Microsoft.SharePoint.SPListItem]$pubFile, [string]$comment) {
    "Processing " + $pubFile.Name
    $listitemfile = $pubFile.File

    # Check item if checked out
    if ($listitemfile.Level -eq [Microsoft.SharePoint.SPFileLevel]::Checkout)
    {
        " Checking in file"
        $listitemfile.CheckIn($comment,[Microsoft.SharePoint.SPCheckInType]::MajorCheckin )
    }

    # If moderation is being used then handle the approval and publishing
    if ($pubFile.ParentList.EnableModeration)
    {
        $modInformation = $pubFile.ModerationInformation
        " Moderation Enabled"

        # Check for pending approval
        if($modInformation.Status -eq [Microsoft.SharePoint.SPModerationStatusType]::Pending)
        {
            " Approving"
            $listitemfile.Approve($comment)
        }

        # Publish
        if($modInformation.Status -eq [Microsoft.SharePoint.SPModerationStatusType]::Draft)
        {
            " Publishing"
            $listitemfile.Publish($comment)
        }
    }
}

# Function: Approve-AllPagesInSPWeb
# Description: Loop through all the pages in a Publishing Web and checkin and approve them
# Parameters: web SPWeb object
# comment Comment to accompany the checkin/approve/publish
#
function Approve-AllPagesInSPWeb([Microsoft.SharePoint.SPWeb]$web, [string]$comment, [string]$destination, [string]$filter)
{
    # Check this is a publishing web
    if ([Microsoft.SharePoint.Publishing.PublishingWeb]::IsPublishingWeb($web) -eq $true)
    {
        # just a quick loop to space out dashes
        for($c = 0; $c -lt $destination.length; $c++)
        {
            $dshspcr += "-"
        }

        # provide some feedback
        ""
        "Checking " + $destination + "..."
        "---------" + $dshspcr + "---"
        ""

        # do some stuff
        $list = $web.Lists[$destination]            # Load library we want to check
        [Object[]]$files = $list.get_items() | where { $_.Level -eq [Microsoft.SharePoint.SPFileLevel]::Checkout} | where { $_.Name -like $filter }
        $formatted = $files | ft -Autosize Url, Name, ID, Level, HasPublishedVersion
        if($files.count -gt 0)
        {
            "Found the following files:"
            $formatted
            "Checking in files..."
            for($i=0; $i -lt $files.count; $i++)
            {
                Approve-File $files[$i] $comment
            }
        }
        else
        {
            " - Found no files"
        }
        $web.Dispose()
    }

}
# Handle input parameters
for($c = 0; $c -lt $args.length; $c++)
{
    if($args[$c] -eq "-f")
    {
        $c++
        $filter = $args[$c]
    }
    elseif($args[$c] -eq "-l")
    {
        $c++
        $library =  $args[$c]
    }
    else
    {
        "Invalid parameter(s)"
        $fail = "yes"
    }
}

if($library.length -lt 1)
{
    $library = $lib
}
if($filter.length -lt 0)
{
    $filter = $dfilter
}

if($fail -ne "yes")
{
    # Create site object
    $site = new-object Microsoft.SharePoint.SPSite($url)
    $site.rootweb | foreach {Approve-AllPagesInSPweb $_ $comment $library $filter}

    #Dispose of objects
    $site.Dispose()
    ""
    "Check-in and publish completed!"
    ""
}

# Changelog
#
#   v1.1 - June 19th, 2008
#       * Added ability to publish files based on a filename filter
#       * Added ability to publish files in an alternate library
#       * fixed bug preventing more than 2 function parameters to ApprovePagesInSPweb
#
#   v1.0 - June 18th, 2008
#       * First public release
