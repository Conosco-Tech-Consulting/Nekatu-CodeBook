$Today = Get-Date -format yyyyMMdd
$PSEmailServer = "smtp.ntlworld.com"
$day = Get-Date -format ddd

write ""

Get-Content \\10.255.255.215\share\Scripts\checkDate\$day.txt | Foreach-Object {

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
send-mailmessage -to "dave.botha@gmail.com" -cc "webmaster@southdevonsound.co.uk" -from "Sam Sounds <sam@southdevonsound.co.uk>" -priority "high" -subject "Listen Again: $_ not up to date" -body "$_ last updated on $FileCreationDateTime"
write "- $_ last uploaded $modified"
} else {
write "+ $_ up to date"
}

}

write ""