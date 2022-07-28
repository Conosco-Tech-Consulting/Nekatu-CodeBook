$ErrorActionPreference = "SilentlyContinue"
$Today = Get-Date -format yyyyMMdd
$Date = Get-Date -format ddd

$NAS = \\10.255.255.215\share\Scripts\checkDate
$FTP = ftp://s322000114.websitehome.co.uk/listen

$Mon = $Today
$Tue = $Today - 6
$Wed = $Today - 5
$Thu = $Today - 4
$Fri = $Today - 3
$Sat = $Today - 2
$Sun = $Today - 1

#CHECKDATE FUNCTION
function checkDate($File,$Day)
{
	[System.Net.FtpWebRequest]$request = [System.Net.WebRequest]::Create($File)
	$request.Credentials=New-Object System.Net.NetworkCredential("u58080449-SAM","dumbass") 
	$request.Method = [System.Net.WebRequestMethods+FTP]::GetDateTimeStamp
	$response=$request.GetResponse()
	$Modified = $response.StatusDescription
	$Modified = $Modified.Substring($Modified.LastIndexOf(" ")+1)
	$FileCreationDateTime=$Modified.Substring(0, 4) + "-" + $Modified.Substring(4, 2) + "-" + $Modified.Substring(6, 2) 
	$modified = $Modified.Substring(0,$Modified.Length-8)
	
	If ( $Modified -eq $null ) 
	{
		write-host "* $_ not found" -foregroundcolor "red"	
	}
	ElseIf ( $Modified -lt $Day ) 
	{
		write-host "- $_ last updated: $Modified" -foregroundcolor "yellow"
	} 
	Else
	{
		write-host "+ $_ up to date" -foregroundcolor "green"
	}

}

clear

#MONDAY

write-host "Monday - $Mon" -foregroundcolor "cyan"
write-host =====

Get-Content "\\10.255.255.215\share\Scripts\checkDate\Mon.txt" | Foreach-Object {
	$File = "ftp://s322000114.websitehome.co.uk/listen/$_"
	checkDate $File "$Mon"
}

write-host ""

#TUESDAY

write-host "Tuesday - $Tue" -foregroundcolor "cyan"
write-host =====

Get-Content "\\10.255.255.215\share\Scripts\checkDate\Tue.txt" | Foreach-Object {
	$File = "ftp://s322000114.websitehome.co.uk/listen/$_"
	checkDate $File "$Tue"
}

write-host ""

#WEDNESDAY

write-host "Wednesday - $Wed" -foregroundcolor "cyan"
write-host =====

Get-Content "\\10.255.255.215\share\Scripts\checkDate\Wed.txt" | Foreach-Object {
	$File = "ftp://s322000114.websitehome.co.uk/listen/$_"
	checkDate $File "$Wed"
}

write-host ""

#THURSDAY

write-host "Thursday - $Thu" -foregroundcolor "cyan"
write-host =====

Get-Content "\\10.255.255.215\share\Scripts\checkDate\Thu.txt" | Foreach-Object {
	$File = "ftp://s322000114.websitehome.co.uk/listen/$_"
	checkDate $File "$Thu"
}

write-host ""

#FRIDAY

write-host "Friday - $Fri" -foregroundcolor "cyan"
write-host =====

Get-Content "\\10.255.255.215\share\Scripts\checkDate\Fri.txt" | Foreach-Object {
	$File = "ftp://s322000114.websitehome.co.uk/listen/$_"
	checkDate $File "$Fri"
}

write-host ""

#SATURDAY

write-host "Saturday - $Sat" -foregroundcolor "cyan"
write-host =====

Get-Content "\\10.255.255.215\share\Scripts\checkDate\Sat.txt" | Foreach-Object {
	$File = "ftp://s322000114.websitehome.co.uk/listen/$_"
	checkDate $File "$Sat"
}

write-host ""

#SUNDAY

write-host "Sunday - $Sun" -foregroundcolor "cyan"
write-host =====

Get-Content "\\10.255.255.215\share\Scripts\checkDate\Sun.txt" | Foreach-Object {
	$File = "ftp://s322000114.websitehome.co.uk/listen/$_"
	checkDate $File "$Sun"
}

write-host ""

#PAUSE AND EXIT

write-host "Press any key to continue ..."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")