###############################################
# AD Export to CSV
###############################################

import-module ActiveDirectory

Get-ADUser -SearchBase "OU=Students,OU=Users,OU=Network,dc=School,dc=local" -Filter * -ResultSetSize 5000 | Select Name,SamAccountName | export-csv C:\temp\Student.csv
Get-ADUser -SearchBase "OU=Staff,OU=Users,OU=Network,dc=School,dc=local" -Filter * -ResultSetSize 5000 | Select Name,SamAccountName | export-csv C:\temp\Staff.csv

###############################################
# Assign Licenses
###############################################

$msolcred = get-credential
connect-msolservice -credential $msolcred

get-MsolUser | Set-MsolUser -UsageLocation GB 

Import-Csv -Path C:\temp\staff2.csv | ForEach-Object {Set-MsolUserLicense -UserPrincipalName $_.UPN –AddLicenses cchsuk:STANDARDWOFFPACK_FACULTY} | Export-Csv -Path c:\temp\Staff-Log.csv
Import-Csv -Path C:\temp\pupils2.csv | ForEach-Object {Set-MsolUserLicense -UserPrincipalName $_.UPN –AddLicenses cchsuk:STANDARDWOFFPACK_STUDENT} | Export-Csv -Path c:\temp\Pupils-Log.csv