 $count = $args.Count
  if ($count -lt 2) {
      Write-Host
	    Write-Host "NB: Please ensure that an email-enabled group has been created to assign Mailbox access to" -ForegroundColor Red
      Write-Host "Specify mailbox and security group as arguments: .\CS-ConvertMailboxToShared.ps1 <username@domain.ext> <securitygroup>" -ForegroundColor Yellow
			Write-Host 
  } 
  else { 

Import-Module MSOnline 
 $O365Cred = Get-Credential 
 $O365Session = New-PSSession –ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell -Credential $O365Cred -Authentication Basic -AllowRedirection 
Import-PSSession $O365Session -AllowClobber 
Connect-MsolService –Credential $O365Cred
  
  $mbx = $args[0]
      $secGroup = $args[1]
     Write-Host Processing user: $mbx -ForegroundColor Yellow
  
     # Verify if group exist, remember to DirSync it first
     $test = Get-Group $secGroup -ErrorAction SilentlyContinue
     if ($test -ne $null) {
  
         # Verify if mailbox exist
         $test = Get-Mailbox $mbx -ErrorAction SilentlyContinue
         if ($test -ne $null) {
     
             # Do the "clever" stuff to find out if mbx is less than 4500 MB (leaves a little room up to 5 GB)
             $stat = Get-MailboxStatistics $mbx
             $tmp = $stat.TotalItemSize.Value.ToString().Split("(")[0].Replace(" ","")
             $mb = Invoke-Expression $tmp/1MB
             if ([int]$mb -lt 4500) {
  
                 # Setting the actual mailbox parameters
                 Write-Host Converting user $mbx to shared and setting quota to 5 GB...
                 Set-Mailbox -Identity $mbx -Type "Shared" -ProhibitSendReceiveQuota 5GB -ProhibitSendQuota 4.75GB -IssueWarningQuota 4.5GB
  
                 # Adding permissions
                 Write-Host Adding permissions for $secGroup on $mbx
                 Add-MailboxPermission $mbx -User $secGroup -AccessRights FullAccess
                 Add-RecipientPermission $mbx -Trustee $secGroup -AccessRights SendAs -Confirm:$false
  
                 # Remove the license, Shared Mailboxes with a 5GB limit are free of charge
                 Write-Host Removing license for $mbx
                 $MSOLSKU = (Get-MSOLUser -UserPrincipalName $mbx).Licenses[0].AccountSkuId
                 Set-MsolUserLicense -UserPrincipalName $mbx -RemoveLicenses $MSOLSKU
                 Write-Host Done! -ForegroundColor Green
  
             } 
             else { Write-Host Mailbox is ([int]$mb) MB which is too large for conversion to a nonlicensed shared mailbox, reduce size and try again. -ForegroundColor Red }
         } 
         else { Write-Host Mailbox: $mbx does not exist! -ForegroundColor Red    }
     } 
     else { Write-Host Group: $secGroup does not exist! -ForegroundColor Red    }
    }
 Write-Host