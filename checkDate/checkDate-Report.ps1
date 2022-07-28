$Today = Get-Date -format yyyyMMdd
$day = Get-Date -format ddd

write ""

Get-Content \\LS-CHL4C6\share\Scripts\checkDate\$day.txt | Foreach-Object {

$File = "ftp://s322000114.websitehome.co.uk/listen/$_"

[System.Net.FtpWebRequest]$request = [System.Net.WebRequest]::Create($File)

$request.Credentials=New-Object System.Net.NetworkCredential("u58080449-SAM","dumbass") 
$request.Method = [System.Net.WebRequestMethods+FTP]::GetDateTimeStamp
$response=$request.GetResponse()
$temp = $response.StatusDescription
$temp = $temp.Substring($temp.LastIndexOf(" ")+1)
$FileCreationDateTime=$temp.Substring(0, 4) + "-" + $temp.Substring(4, 2) + "-" + $temp.Substring(6, 2) 
$modified = $Temp.Substring(0,$Temp.Length-8)

if ( $Temp.Substring(0,$Temp.Length-8) -lt $Today ) {
write "- $_ last uploaded $modified"
} else {
write "+ $_ up to date"
}

}

Write ""
Write-Host "Press any key to continue ..."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")