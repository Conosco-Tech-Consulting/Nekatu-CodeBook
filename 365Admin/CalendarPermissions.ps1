$users=Get-Mailbox -resultsize Unlimited

ForEach ($user in $users)

              {Set-MailboxFolderPermission -Identity $user":\calendar" -user Default -AccessRights Reviewer}