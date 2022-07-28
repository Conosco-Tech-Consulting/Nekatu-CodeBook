'----------------------------------------
' Get Login DC Info
'----------------------------------------

set objDomain = GetObject("LDAP://rootDSE")
strDCFULL = objDomain.Get("dnsHostName")
strDC = Mid(strDCFull,1,InStr(strDCFull, ".") -1)

Set objNetwork = CreateObject("Wscript.Network")

struserName = objNetwork.userName

'---------------------------------------------
' Map Network Drives depending on login Server
'---------------------------------------------

objNetwork.MapNetworkDrive "G:", "\\" & strDC & "\Shared"
objNetwork.MapNetworkDrive "P:", "\\" & strDC & "\user Documents\" & struserName
objNetwork.MapNetworkDrive "X:", "\\" & strDC & "\Archive"
objNetwork.MapNetworkDrive "Z:", "\\Unicorn-nas\Public\Archive\" & struserName
