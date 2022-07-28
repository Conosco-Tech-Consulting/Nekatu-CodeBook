$adproxy = "@thegreenschool.net"
$365proxy = "@tgstrust.com"

$userou = 'ou=Staff,ou=Users,ou=Langley-Primay-School-Network,dc=LANGLEY,dc=local'
$users = Get-ADUser -Filter * -SearchBase $userou -Properties SamAccountName, UserPrincipalName, ProxyAddresses 


Foreach ($user in $users) {
    Set-ADUser -Identity $user.samaccountname -Add @{Proxyaddresses="smtp:"+$user.samaccountname+"."+$adproxy}
    Set-ADUser -Identity $user.samaccountname -Add @{Proxyaddresses="smtp:"+$user.samaccountname+"."+$365proxy}
    Set-ADUser -Identity $user.samaccountname -Add @{Proxyaddresses="smtp:"+$user.userprincipalname}

    } 