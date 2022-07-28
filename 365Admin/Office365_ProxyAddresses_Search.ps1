	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $True, Position = 0)]
		[ValidateNotNullOrEmpty()]
		[string]$MatchString
	)
	
#------------------------------------------------------------------------------ 
# 
# Copyright © 2013 Microsoft Corporation.  All rights reserved. 
# 
# THIS CODE AND ANY ASSOCIATED INFORMATION ARE PROVIDED “AS IS” WITHOUT 
# WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT 
# LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS 
# FOR A PARTICULAR PURPOSE. THE ENTIRE RISK OF USE, INABILITY TO USE, OR  
# RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER. 
# 
#------------------------------------------------------------------------------ 
# 
# PowerShell Source Code 
# 
# NAME: 
#    Office365_ProxyAddresses_Search.ps1 
# 
# VERSION: 
#    1.0 
# 
#------------------------------------------------------------------------------ 

#set up vars
$ScriptPath = Split-Path -parent $MyInvocation.MyCommand.Definition
$Stamp = Get-Date -Format "yyyy-MM-dd_hh-mm-ss"
$FilePath = “$ScriptPath\Office365_ProxyAddresses_Found_$Stamp.csv”

#get users
Import-Module MSOnline
write-host "`n Connecting to MSO..."
Connect-MsolService
write-host " Obtaining UPN and proxyAddresses of all users (this may take a while)..."
$MyUsers = Get-MsolUser –All | Select userPrincipalName,proxyAddresses
write-host "`tDone" -Foregroundcolor Green

#loop users
write-host " Checking all users for proxyAddresses containing $MatchString (this may take a while)..."
$Total = $MyUsers.Count
$Count = 1

ForEach ($User in $MyUsers)
{
	Write-Progress -Activity "Checking for proxyAddresses matching $MatchString" -Status "Processing User $Count" –PercentComplete ($Count/$Total * 100) -ErrorAction SilentlyContinue
	$MatchFound = $False

	#loop proxyAddresses
	ForEach ($PA in $User.ProxyAddresses)
	{
		If ($PA –Match $MatchString)
		{
			$MatchFound = $True
		}
	}

	#add matches to array
	If ($MatchFound)
	{
		$FirstTime = $True

		ForEach ($PA in $User.proxyAddresses)
		{
			If ($FirstTime)
			{
				[string]$concatPA += $PA
				$FirstTime = $False
			}
			Else
			{
				[string]$concatPA += (","+$PA)
			}
		}

		$User.proxyAddresses = $concatPA
		[array]$MyMatches += $User
	}
	
	$Count++
}

#write array to file
If ($MyMatches –ne $null)
{
	$MyMatches | Export-Csv –Path $FilePath -NoTypeInformation
	$FoundCount = $MyMatches.Count
	write-host "`tDone. Found $FoundCount users with proxyAddresses matching $MatchString`n`tOutput written to $FilePath`n`n" -Foregroundcolor Green
}
Else
{
	write-host "`tDone. No users found`n`n" -Foregroundcolor Yellow
}
