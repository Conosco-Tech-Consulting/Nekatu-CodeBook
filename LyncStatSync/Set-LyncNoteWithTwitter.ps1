#requires –Version 3.0
<#
.SYNOPSIS 
Sets Lync 2013 Client's PersonalNote field with latest tweet from your favorite twitter personality:
@SwiftOnSecurity

.DESCRIPTION
Tired of What's happening today? Find out with the Set-LyncNoteWithTwitter.ps1 script. It sets the 
Lync 2013 Client's personal note to match the latest tweet from your favorite twitter personality. 
Authentication and authorization are handled throughTwitter's Oauth implementation. Everything else is 
via their REST API. The Lync COM is used to update the Lync client.

The secret tokens are sensitive. Be like Taylor and protect your secrets.
Your app permissions only need to be read-only. Be like Taylor and follow the principle of least privilege. 

****Requires Lync 2013 SDK.**** The SDK install requires Visual Studio 2010 SP1. To avoid installing 
Visual Studio, download the SDK, use 7-zip to extract the files from the install, and install the MSI 
relevant to your Lync Client build (x86/x64).

.INPUTS
None. You cannot pipe objects to Set-LyncNoteWithTwitter.ps1.

.OUTPUTS
None. Set-LyncNoteWithTwitter.ps1 does not generate any output.

.NOTES
Author Name:   Andrew Healey (@healeyio)
Creation Date: 2015-02-02
Version Date:  2015-02-02

.LINK
Author:          http://healey.io/blog/update-lync-notes-with-twitter-status/
Lync 2013 SDK:   http://www.microsoft.com/en-us/download/details.aspx?id=36824
Some code referenced from:
   MyTwitter:    https://github.com/MyTwitter/MyTwitter

.EXAMPLE
PS C:\PS> .\Set-LyncNoteWithTwitter.ps1

#>


## Parameters
[string]$Consumer_Key =        'hrL3q8hhVeBWs674D7nkrbhhI'
[string]$Consumer_Secret =     'PSLUQyJLW5pQCHSs7oUkWVxUNpBGCxSe7WIJjO6uSA9USB1SnE'
[string]$Access_Token =        '764622614-ZTKGp7u0ETQ9sF2CNhe9TxXgvH4y4Fhms9fDWL78'
[string]$Access_Token_Secret = '2tOaSMwfpqsmmsuLEx3cEJpoiI593wgRaOj1oE1qAbwjU'
[string]$screen_name =         'ArikFletcher'
[int]   $count =                1
[string]$exclude_replies =     'true'
[string]$include_rts =         'false'
[string]$HttpEndPoint =        'https://api.twitter.com/1.1/statuses/user_timeline.json'

[Reflection.Assembly]::LoadWithPartialName("System.Security") | Out-Null
[Reflection.Assembly]::LoadWithPartialName("System.Net") | Out-Null

## Generate a random 32-byte string. Strip out '=' per twitter req's
$OauthNonce = [System.Convert]::ToBase64String(([System.Text.Encoding]::ASCII.GetBytes("$([System.DateTime]::Now.Ticks.ToString())12345"))).Replace('=', 'g')
Write-Verbose "Generated Oauth none string '$OauthNonce'"
			
## Find the total seconds since 1/1/1970 (epoch time)
$EpochTimeNow = [System.DateTime]::UtcNow - [System.DateTime]::ParseExact("01/01/1970", "dd/MM/yyyy", $null)
Write-Verbose "Generated epoch time '$EpochTimeNow'"
$OauthTimestamp = [System.Convert]::ToInt64($EpochTimeNow.TotalSeconds).ToString();
Write-Verbose "Generated Oauth timestamp '$OauthTimestamp'"
			
## Build the signature
$SignatureBase = "$([System.Uri]::EscapeDataString($HttpEndPoint))&"
$SignatureParams = @{
	'oauth_consumer_key' =     $Consumer_Key;
	'oauth_nonce' =            $OauthNonce;
	'oauth_signature_method' = 'HMAC-SHA1';
	'oauth_timestamp' =        $OauthTimestamp;
	'oauth_token' =            $Access_Token;
	'oauth_version' =          '1.0';
}

## Add Signature Params
$SignatureParams.screen_name =     $screen_name
$SignatureParams.exclude_replies = $exclude_replies
$SignatureParams.include_rts =     $include_rts
$SignatureParams.count =           $count
			
## Create a string called $SignatureBase that joins all URL encoded 'Key=Value' elements with a &
## Remove the URL encoded & at the end and prepend the necessary 'POST&' verb to the front
$SignatureParams.GetEnumerator() | sort name | foreach { 
    Write-Verbose "Adding '$([System.Uri]::EscapeDataString(`"$($_.Key)=$($_.Value)&`"))' to signature string"
    $SignatureBase += [System.Uri]::EscapeDataString("$($_.Key)=$($_.Value)&".Replace(',','%2C').Replace('!','%21'))
}
$SignatureBase = $SignatureBase.TrimEnd('%26')
$SignatureBase = 'GET&' + $SignatureBase
Write-Verbose "Base signature generated '$SignatureBase'"
			
## Create the hashed string from the base signature
$SignatureKey = [System.Uri]::EscapeDataString($Consumer_Secret) + "&" + [System.Uri]::EscapeDataString($Access_Token_Secret);
			
$hmacsha1 = new-object System.Security.Cryptography.HMACSHA1;
$hmacsha1.Key = [System.Text.Encoding]::ASCII.GetBytes($SignatureKey);
$OauthSignature = [System.Convert]::ToBase64String($hmacsha1.ComputeHash([System.Text.Encoding]::ASCII.GetBytes($SignatureBase)));
Write-Verbose "Using signature '$OauthSignature'"
			
## Build the authorization headers using most of the signature headers elements.  This is joining all of the 'Key=Value' elements again
## and only URL encoding the Values this time while including non-URL encoded double quotes around each value
$AuthorizationParams = $SignatureParams
$AuthorizationParams.Add('oauth_signature', $OauthSignature)
			
## Remove any REST API call-specific params from the authorization params
$AuthorizationParams.Remove('exclude_replies')
$AuthorizationParams.Remove('include_rts')
$AuthorizationParams.Remove('screen_name')
$AuthorizationParams.Remove('count')
			
$AuthorizationString = 'OAuth '
$AuthorizationParams.GetEnumerator() | sort name | foreach { $AuthorizationString += $_.Key + '="' + [System.Uri]::EscapeDataString($_.Value) + '",' }
$AuthorizationString = $AuthorizationString.TrimEnd(',')
Write-Verbose "Using authorization string '$AuthorizationString'"

## Build URI Body
$URIBody = "?count=$count&exclude_replies=$exclude_replies&include_rts=$include_rts&screen_name=$screen_name"
Write-Verbose "Using GET URI: $($HttpEndPoint + $Body)"
$tweet = Invoke-RestMethod -URI $($HttpEndPoint + $URIBody) -Method Get -Headers @{ 'Authorization' = $AuthorizationString } -ContentType "application/x-www-form-urlencoded"

## Verify lync 2013 object model dll is either in script directory or SDK is installed
$lyncSDKPath = "Microsoft Office\Office15\LyncSDK\Assemblies\Desktop\Microsoft.Lync.Model.dll"
$lyncSDKError = "Lync 2013 SDK is required. Download here and install: http://www.microsoft.com/en-us/download/details.aspx?id=36824"

if (-not (Get-Module -Name Microsoft.Lync.Model)) {
    if (Test-Path (Join-Path -Path ${env:ProgramFiles(x86)} -ChildPath $lyncSDKPath)) {
        $lyncPath = Join-Path -Path ${env:ProgramFiles(x86)} -ChildPath $lyncSDKPath
    }
    elseif (Test-Path (Join-Path -Path ${env:ProgramFiles} -ChildPath $lyncSDKPath)) {
        $lyncPath = Join-Path -Path ${env:ProgramFiles} -ChildPath $lyncSDKPath
    }
    else {
        $fileError = New-Object System.io.FileNotFoundException("SDK Not Found: $lyncSDKError")
        throw $fileError
    } # End SDK/DLL check
    try {
        Import-Module -Name $lyncPath -ErrorAction Stop
    }
    catch {
        $fileError = New-Object System.io.FileNotFoundException ("Import-Module Error: $lyncSDKError")
        throw $fileError
    } # End object model import
} # End dll check

## Check if Lync is signed in, otherwise, nothing to do
$Client = [Microsoft.Lync.Model.LyncClient]::GetClient()
if ($Client.State -eq "SignedIn") {
    ## Set PersonalNote in Lync
    $LyncInfo = New-Object 'System.Collections.Generic.Dictionary[Microsoft.Lync.Model.PublishableContactInformationType, object]'
    $LyncInfo.Add([Microsoft.Lync.Model.PublishableContactInformationType]::PersonalNote, "@$($screen_name): $($tweet.text)")
    $Self = $Client.Self
    $Publish = $Self.BeginPublishContactInformation($LyncInfo, $null, $null)
    $Self.EndPublishContactInformation($Publish)
}
else {
    Write-Warning "Lync must be signed in."
} # End client sign-in check