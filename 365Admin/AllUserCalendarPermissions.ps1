foreach($user in Get-Mailbox -RecipientTypeDetails UserMailbox) {
$cal = $user.alias+":\Calendar" 
Set-MailboxFolderPermission -Identity $cal -User Default -AccessRights Reviewer
}