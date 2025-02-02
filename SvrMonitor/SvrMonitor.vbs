' ----------------------------------------------------------
	strApp = "Co-Operative Systems Server Monitor"
	strAppVer = "v1.8"
	strAppAuthor = "Arik Fletcher"
' ----------------------------------------------------------
' 	Version History:
' 		1.0 - Base script compiled from individual scripts
' 		1.1 - Email alerts modified for improved readability
' 		1.2 - Critical Disk Space Check added
' 		1.3 - Updated Critical Service exclusion list
' 		1.4 - Email reports modified to produce HTML output
' 		1.5 - System Information collection
' 		1.6 - SharePoint Status Update
' 		1.7 - Updated Critical Service exclusion list
' 		1.8 - Incorporated SQL databse check
' ----------------------------------------------------------

' ==========================================================
' Initialise variables
' ==========================================================

On Error Resume Next

Const wbemFlagReturnImmediately = &h10
Const wbemFlagForwardOnly = &h20

Const Unknown = 0
Const Removable = 1
Const Fixed = 2
Const Remote = 3
Const CDROM = 4
Const RAMDisk = 5
Const LOCAL_HARD_DISK = 3

Dim strMode, strHost, strUser, strSvr, strHome, strDNS, strDB, strUN, strPW
Dim objItem, objWMIService, colItems, objFSO, objWrite
Dim strSubject, strBody, strFrom, strTo, strSMTP
Dim hostOSName, hostOSVer, hostSPVer, hostOSDir, hostOSLoc, hostFreePMem, hostTotalVMem, hostFreeVMem
Dim hostVendor, hostModel, hostTimeZone, hostTotalPMem, hostProcArc, hostProcDesc, hostBios, hostSerial

Set oShell = CreateObject( "WScript.Shell" )

strUser=oShell.ExpandEnvironmentStrings("%UserName%")
strHome=oShell.ExpandEnvironmentStrings("%UserDomain%")
strDNS=oShell.ExpandEnvironmentStrings("%UserDNSDomain%")
strSvr=oShell.ExpandEnvironmentStrings("%ComputerName%")

strMode = Wscript.Arguments(0)
strHost = UCase(Wscript.Arguments(1))
strSMTP = Wscript.Arguments(2)
strFrom = LCase(Wscript.Arguments(3))
strTo = LCase(Wscript.Arguments(4))
strDB = Wscript.Arguments(5)
strUN = Wscript.Arguments(6)
strPW = Wscript.Arguments(7)

' ==========================================================
' Interactive Mode
' ==========================================================

if strMode = "" Then
	strMode = InputBox("What operation would you like to run?" &_
			vbCrLf &_
			vbCrLf & "D - Check disk space on all local disks" &_
			vbCrLf & "C - Check if any disks have under 10% free space" &_
			vbCrLf & "P - Remote ping test to a remote server" &_
			vbCrLf & "S - Check for stopped critical services" &_
			vbCrLf & "Q - Query SQL Database Table to check SQL status" &_
			vbCrLf & "I - Gather System Information on specified server" &_
			vbCrLf & "R - Upload System Information to CS Portal" &_
			vbCrLf &_
			vbCrLf & "Choices: D, C, P, S, Q, I, R",strApp)
			
			if uCase(strMode) = "D" Then
				strMode = "/D"
			End If
			if uCase(strMode) = "C" Then
				strMode = "/C"
			End If
			if uCase(strMode) = "P" Then
				strMode = "/P"
			End If
			if uCase(strMode) = "S" Then
				strMode = "/S"
			End If
			if uCase(strMode) = "Q" Then
				strMode = "/Q"
			End If
			if uCase(strMode) = "I" Then
				strMode = "/I"
			End If
			if uCase(strMode) = "R" Then
				strMode = "/R"
			End If
			if uCase(strMode) = "" Then
				wscript.Quit
			End If
			
	strHost = InputBox("Which hostname/IP would you like to check?",strApp)
		if uCase(strHost) = "" Then
			wscript.Quit
		End If
		
	strSMTP = InputBox("Which SMTP server should be used for alerts?",strApp)
		if uCase(strSMTP) = "" Then
			wscript.Quit
		End If
		
	strFrom = InputBox("Which email address should alerts be sent from?",strApp)
		if uCase(strFrom) = "" Then
			wscript.Quit
		End If
		
	strTo = InputBox("Which address(es) should alerts be sent to?" &_
			vbCrLf & "Separate multiple addresses with a semicolon" ,strApp)
		if uCase(strTo) = "" Then
			wscript.Quit
		End If

	if uCase(strMode) = "/Q" Then
	strDB = InputBox("Which database should the query run on?",strApp)
		if uCase(strDB) = "" Then
			wscript.Quit
		End If

	strUN = InputBox("What is the SQL username for the query?",strApp)
		if uCase(strUN) = "" Then
			wscript.Quit
		End If

	strPW = InputBox("What is the SQL password for the query?",strApp)
		if uCase(strPW) = "" Then
			wscript.Quit
		End If
	else

	strDB = ""
	strUN = ""
	strPW = ""

	End If	

End If

' ==========================================================
' Command Line Mode
' ==========================================================

UsageCheck

if Ucase(strMode) = "/P" Then
	PingCheck strHost,strFrom,strTo,strSubject,strBody,nPriority
	Wscript.Quit
End If

If Ucase(strMode) = "/D" Then
	DiskCheck strHost,strFrom,strTo,strSubject,strBody,nPriority
	Wscript.Quit
End If

If Ucase(strMode) = "/C" Then
	CriticalSpaceCheck strHost,strFrom,strTo,strSubject,strBody,nPriority
	Wscript.Quit
End If

If Ucase(strMode) = "/S" Then
	SvcCheck strHost,strFrom,strTo,strSubject,strBody,nPriority
	Wscript.Quit
End If

If Ucase(strMode) = "/Q" Then
	DBQuery strHost,strDB,strUN,strPW,strFrom,strTo,strSubject,strBody,nPriority
	Wscript.Quit
End If

If Ucase(strMode) = "/I" Then
	SystemInfo strHost,strFrom,strTo,strSubject,strBody,nPriority
	Wscript.Quit
End If

If Ucase(strMode) = "/R" Then
	SystemInfoSP strHost
	Wscript.Quit
End If


' ==========================================================
' Ping Check Subroutine
' ==========================================================

Sub PingCheck(strHost,strFrom,strTo,strSubject,strBody,nPriority)

	If Not IsAlive(strHost) Then
		strSubject = strHost & ": " & "Server Not Responding!"
		strBody = "&nbsp;&nbsp;Server Monitor has detected that <b>" & strHost & "</b> is not responding.<br />" & vbCrLf & "&nbsp;&nbsp;Please check the server to confirm if there is a problem."
		
		SendAlert strFrom,strTo,strSubject,strBody,2
	End If

End Sub

' ==========================================================
' Disk Space Subroutine
' ==========================================================

Sub DiskCheck(strHost,strFrom,strTo,strSubject,strBody,nPriority)

	str = ""
	Const HARD_DISK = 3

	Set objWMIService = GetObject("winmgmts:" _
	& "{impersonationLevel=impersonate}!\\" & strHost & "\root\cimv2")

	Set colDisks = objWMIService.ExecQuery _
	("Select * from Win32_LogicalDisk Where DriveType = " & HARD_DISK & "")

	For Each objDisk in colDisks
	str = str & "<p>&nbsp;&nbsp;&nbsp;&nbsp;<b>Drive Letter: </b>"& objDisk.DeviceID & vbTab
	str = str & "<br />&nbsp;&nbsp;&nbsp;&nbsp;<b>Free Space: </b>"& FormatNumber(CLng(objDisk.FreeSpace / 1024 / 1024),0,,,-1) & " MB</p>" & vbcrlf
	Next

	strSubject = strHost & ": " & "Disk Space Report"
	strBody = "&nbsp;&nbsp;Current disk space on <b>" & strHost & "</b> is as follows:" & str
	
	SendAlert strFrom,strTo,strSubject,strBody,nPriority

End Sub


' ==========================================================
' Critical Disk Space Check
' ==========================================================

Sub CriticalSpaceCheck(strHost,strFrom,strTo,strSubject,strBody,nPriority)

	str = ""
	Const HARD_DISK = 3
	Const CONVERSION = 1073741824

	Set objWMIService = GetObject("winmgmts:" _
	& "{impersonationLevel=impersonate}!\\" & strHost & "\root\cimv2")

	Set colDisks = objWMIService.ExecQuery _
	("Select * from Win32_LogicalDisk Where DriveType = " & HARD_DISK & "")

	For Each objDisk in colDisks

	intPercentage = objDisk.FreeSpace / objDisk.Size
	intTotalSpace = Int(objDisk.Size) / CONVERSION
	intFreeSpace = Int(objDisk.FreeSpace) / CONVERSION
	intDivideBy = 10 

	If FormatPercent(IntPercentage,0) < FormatPercent(intDivideBy/100,0) Then 
  str = str & "<p>&nbsp;&nbsp;&nbsp;&nbsp;<b>Disk Letter: </b>"& objDisk.DeviceID & vbTab
	str = str & "<br />&nbsp;&nbsp;&nbsp;&nbsp;<b>Free Space: </b>"& FormatNumber(CLng(objDisk.FreeSpace / 1024 / 1024),0,,,-1) & " MB</p>" & vbcrlf
		
	strSubject = strHost & ": " & "Critical Disk Space Alert"
	strBody = "&nbsp;&nbsp;Reports indicate that<b>" & strHost & "</b> has less than 10% free space left-" & str
	
	SendAlert strFrom,strTo,strSubject,strBody,2

	End If
	Next 

End Sub


' ==========================================================
' Service Check Subroutine
' ==========================================================

Sub SvcCheck(strHost,strFrom,strTo,strSubject,strBody,nPriority)

   Set objWMIService = GetObject("winmgmts:\\" & _
        strHost & "\root\CIMV2")
   Set colItems = objWMIService.ExecQuery("SELECT * FROM Win32_Service", "WQL", wbemFlagReturnImmediately + wbemFlagForwardOnly)

   For Each objItem In colItems

      If StrComp(objItem.State,"Running") <> 0 Then
        If StrComp(objItem.StartMode,"Auto") = 0 Then
			
            If StrComp(objItem.DisplayName,"Performance Logs and Alerts") = 0 Then 
            Else If StrComp(objItem.DisplayName,"Volume Shadow Copy") = 0 Then
            Else If StrComp(objItem.DisplayName,"Microsoft Software Shadow Copy Provider") = 0 Then
            Else If StrComp(objItem.DisplayName,"Removable Storage") = 0 Then
            Else If StrComp(objItem.DisplayName,"ManageEngine OpManager Probe") = 0 Then
            Else If StrComp(objItem.DisplayName,"Microsoft .NET Framework NGEN v4.0.30319_X86") = 0 Then
            Else If StrComp(objItem.DisplayName,"Microsoft .NET Framework NGEN v4.0.30319_X64") = 0 Then
            Else If StrComp(objItem.DisplayName,"Software Protection") = 0 Then
            Else If StrComp(objItem.DisplayName,"Google Update Service (gupdate)") = 0 Then
         	Else	
                strSubject = strHost & ": " & objItem.DisplayName  & " service " & UCase(objItem.State)
                strBody = "&nbsp;&nbsp;Reports indicate that the following service on <b>" & strHost & "</b> has stopped:" & vbCrLf & vbCrLf
                strBody = strBody & "<p>&nbsp;&nbsp;&nbsp;&nbsp;<b>Service Name:</b> 		" & objItem.DisplayName & "<br />" & vbCrLf
                strBody = strBody & "<b>&nbsp;&nbsp;&nbsp;&nbsp;Path Name:</b>&nbsp;&nbsp;" & objItem.PathName & "<br />" & vbCrLf
                strBody = strBody & "<b>&nbsp;&nbsp;&nbsp;&nbsp;State:</b>&nbsp;&nbsp;" & objItem.State & "<br />" & vbCrLf
                strBody = strBody & "<b>&nbsp;&nbsp;&nbsp;&nbsp;Status:</b>&nbsp;&nbsp;" & objItem.Status & "<br />" & vbCrLf
                strBody = strBody & "<b>&nbsp;&nbsp;&nbsp;&nbsp;Exit Code:</b>&nbsp;&nbsp;" & objItem.ExitCode & "<br />" & vbCrLf
                strBody = strBody & "<b>&nbsp;&nbsp;&nbsp;&nbsp;Service Exit Code:</b>&nbsp;&nbsp;" & objItem.ServiceSpecificExitCode & "</p>" & vbCrLf
				
                SendAlert strFrom,strTo,strSubject,strBody,2
            End If
            End If
            End If	   
            End If
            End If
            End If
            End If
            End If
            End If
        End If
      End If
   Next

End Sub

' ==========================================================
' SQL Database Query Subroutine
' ==========================================================

Sub DBQuery(strHost,strDB,strUN,strPW,strFrom,strTo,strSubject,strBody,nPriority)

	Set AdCn = CreateObject("ADODB.Connection")
	Set AdRec = CreateObject("ADODB.Recordset")

	connstr="Provider=SQLOLEDB.1;Data Source=" & strHost & ";Initial Catalog=" & strDB & ";user id = '" & strUN & "';password='" & strPW & "'"
	AdCn.Open = connstr
	SQL="Select @@version as name"
	AdRec.Open SQL, AdCn,1,1
	xxx=Adrec("name")

	if err.number <> 0 or left(xxx,5)<>"Micro" then
        	strSubject = strHost & ": " & strDB & " connection FAILED"
                strBody = "&nbsp;&nbsp;Reports indicate that SQL database connection query has failed" & vbCrLf & vbCrLf
                strBody = strBody & "<p>&nbsp;&nbsp;&nbsp;&nbsp;<b>Server Name:</b> 		" & strHost & "<br />" & vbCrLf
                strBody = strBody & "<b>&nbsp;&nbsp;&nbsp;&nbsp;Database:</b>&nbsp;&nbsp;" & strDB & "<br />" & vbCrLf
                strBody = strBody & "<b>&nbsp;&nbsp;&nbsp;&nbsp;Username:</b>&nbsp;&nbsp;" & strUN & "</p>" & vbCrLf
		SendAlert strFrom,strTo,strSubject,strBody,2
	End If

	if err.number <> 0 or left(xxx,2)<>"Micro" then
        	strSubject = strHost & ": " & strDB & " connection FAILED"
                strBody = "&nbsp;&nbsp;Reports indicate that SQL database connection query has failed" & vbCrLf & vbCrLf
                strBody = strBody & "<p>&nbsp;&nbsp;&nbsp;&nbsp;<b>Server Name:</b> 		" & strHost & "<br />" & vbCrLf
                strBody = strBody & "<b>&nbsp;&nbsp;&nbsp;&nbsp;Database:</b>&nbsp;&nbsp;" & strDB & "<br />" & vbCrLf
                strBody = strBody & "<b>&nbsp;&nbsp;&nbsp;&nbsp;Username:</b>&nbsp;&nbsp;" & strUN & "</p>" & vbCrLf
		SendAlert strFrom,strTo,strSubject,strBody,2
	End If

End Sub


' ==========================================================
' System Info Report
' ==========================================================

Sub SystemInfo(strHost,strFrom,strTo,strSubject,strBody,nPriority)

Set objWMIService = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\" & strHost & "\root\cimv2")

Set colSettings = objWMIService.ExecQuery ("Select * from Win32_OperatingSystem")

For Each objOperatingSystem in colSettings
  hostOSName = objOperatingSystem.Name
  hostOSVer = objOperatingSystem.Version
  hostSPVer = objOperatingSystem.ServicePackMajorVersion & "." & objOperatingSystem.ServicePackMinorVersion
  hostOSDir = objOperatingSystem.WindowsDirectory
  hostOSLoc = objOperatingSystem.Locale
  hostFreePMem = objOperatingSystem.FreePhysicalMemory
  hostTotalVMem = objOperatingSystem.TotalVirtualMemorySize
  hostFreeVMem = objOperatingSystem.FreeVirtualMemory
Next

Set colSettings = objWMIService.ExecQuery ("Select * from Win32_ComputerSystem")

For Each objComputer in colSettings
  hostVendor = objComputer.Manufacturer
  hostModel = objComputer.Model
  hostTimeZone = objComputer.CurrentTimeZone
  hostTotalPMem = objComputer.TotalPhysicalMemory
Next

Set colSettings = objWMIService.ExecQuery ("Select * from Win32_Processor")

For Each objProcessor in colSettings
  hostProcArc = objProcessor.Architecture
  hostProcDesc = objProcessor.Description
Next

Set colSettings = objWMIService.ExecQuery ("Select * from Win32_BIOS")

For Each objBIOS in colSettings
  hostBios =  objBIOS.Version
Next

Set colSMBIOS = objWMIService.ExecQuery ("SELECT * FROM Win32_SystemEnclosure")

For Each objSMBIOS in colSMBIOS
  hostSerial = objSMBIOS.SerialNumber
Next

  str = str & "<p>&nbsp;&nbsp;&nbsp;&nbsp;<b>System Manufacturer: </b>" & hostVendor & "<br />" & vbCrLf
  str = str & "&nbsp;&nbsp;&nbsp;&nbsp;<b>System Model: </b>" & hostModel & "<br />" & vbCrLf
  str = str & "&nbsp;&nbsp;&nbsp;&nbsp;<b>Serial Number: </b>" & hostSerial & "<br />" & vbCrLf
  str = str & "&nbsp;&nbsp;&nbsp;&nbsp;<b>BIOS Version: </b>" & hostBios & "<br />" & vbCrLf
  str = str & "&nbsp;&nbsp;&nbsp;&nbsp;<b>System Type: </b>" & hostProcArc & "<br />" & vbCrLf
  str = str & "&nbsp;&nbsp;&nbsp;&nbsp;<b>Processor: </b>" & hostProcDesc & "</p>" & vbCrLf
  
  str = str & "<p>&nbsp;&nbsp;&nbsp;&nbsp;<b>OS Name: </b>" & hostOSName & "<br />" & vbCrLf
  str = str & "&nbsp;&nbsp;&nbsp;&nbsp;<b>Version: </b>" & hostOSVer & "<br />" & vbCrLf
  str = str & "&nbsp;&nbsp;&nbsp;&nbsp;<b>Service Pack: </b>" & hostSPVer & "<br />" & vbCrLf
  str = str & "&nbsp;&nbsp;&nbsp;&nbsp;<b>Windows Directory: </b>" & hostOSDir & "<br />" & vbCrLf
  str = str & "&nbsp;&nbsp;&nbsp;&nbsp;<b>Locale: </b>" & hostOSLoc & "<br />" & vbCrLf
  str = str & "&nbsp;&nbsp;&nbsp;&nbsp;<b>Time Zone: </b>" & hostTimeZone & "</p>" & vbCrLf
  
  str = str & "<p>&nbsp;&nbsp;&nbsp;&nbsp;<b>Total Physical Memory: </b>" & FormatNumber(CLng(hostTotalPMem / 1024 / 1024),0,,,-1) & " MB<br />" & vbCrLf
  str = str & "&nbsp;&nbsp;&nbsp;&nbsp;<b>Available Physical Memory: </b>" & FormatNumber(CLng(hostFreePMem / 1024),0,,,-1) & " MB<br />" & vbCrLf
  str = str & "&nbsp;&nbsp;&nbsp;&nbsp;<b>Total Virtual Memory: </b>" & FormatNumber(CLng(hostTotalVMem / 1024),0,,,-1) & " MB<br />" & vbCrLf
  str = str & "&nbsp;&nbsp;&nbsp;&nbsp;<b>Available Virtual Memory: </b>" & FormatNumber(CLng(hostFreeVMem / 1024),0,,,-1) & " MB</p>" & vbCrLf

  strSubject = strHost & ": " & "System Information"
  strBody = "&nbsp;&nbsp;System Information report for <b>" & strHost & "</b> is as follows:" & str
  
	SendAlert strFrom,strTo,strSubject,strBody,nPriority

End Sub

' ==========================================================
' System Uptime Report to SharePoint
' ==========================================================

Sub SystemInfoSP(strHost)

Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objWrite = objFSO.OpenTextFile("sysinfo.txt", 2, True)

Set objWMIService = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\" & strHost & "\root\cimv2")

Set colSettings = objWMIService.ExecQuery ("Select * from Win32_OperatingSystem")

For Each objOperatingSystem in colSettings
  hostOSName = objOperatingSystem.Name
  hostOSVer = objOperatingSystem.Version
  hostSPVer = objOperatingSystem.ServicePackMajorVersion & "." & objOperatingSystem.ServicePackMinorVersion
  hostOSDir = objOperatingSystem.WindowsDirectory
  hostOSLoc = objOperatingSystem.Locale
  hostFreePMem = objOperatingSystem.FreePhysicalMemory
  hostTotalVMem = objOperatingSystem.TotalVirtualMemorySize
  hostFreeVMem = objOperatingSystem.FreeVirtualMemory
Next

Set colSettings = objWMIService.ExecQuery ("Select * from Win32_ComputerSystem")

For Each objComputer in colSettings
  hostVendor = objComputer.Manufacturer
  hostModel = objComputer.Model
  hostTimeZone = objComputer.CurrentTimeZone
  hostTotalPMem = objComputer.TotalPhysicalMemory
Next

Set colSettings = objWMIService.ExecQuery ("Select * from Win32_Processor")

For Each objProcessor in colSettings
  hostProcArc = objProcessor.Architecture
  hostProcDesc = objProcessor.Description
Next

Set colSettings = objWMIService.ExecQuery ("Select * from Win32_BIOS")

For Each objBIOS in colSettings
  hostBios =  objBIOS.Version
Next

Set colSMBIOS = objWMIService.ExecQuery ("SELECT * FROM Win32_SystemEnclosure")

For Each objSMBIOS in colSMBIOS
  hostSerial = objSMBIOS.SerialNumber
Next

  str = str & "<p><b>System Manufacturer: </b>" & hostVendor & "<br />" & vbCrLf
  str = str & "<b>System Model: </b>" & hostModel & "<br />" & vbCrLf
  str = str & "<b>Serial Number: </b>" & hostSerial & "<br />" & vbCrLf
  str = str & "<b>BIOS Version: </b>" & hostBios & "<br />" & vbCrLf
  str = str & "<b>System Type: </b>" & hostProcArc & "<br />" & vbCrLf
  str = str & "<b>Processor: </b>" & hostProcDesc & "</p>" & vbCrLf
  
  str = str & "<p><b>OS Name: </b>" & hostOSName & "<br />" & vbCrLf
  str = str & "<b>Version: </b>" & hostOSVer & "<br />" & vbCrLf
  str = str & "<b>Service Pack: </b>" & hostSPVer & "<br />" & vbCrLf
  str = str & "<b>Windows Directory: </b>" & hostOSDir & "<br />" & vbCrLf
  str = str & "<b>Locale: </b>" & hostOSLoc & "<br />" & vbCrLf
  str = str & "<b>Time Zone: </b>" & hostTimeZone & "</p>" & vbCrLf
  
  str = str & "<p><b>Total Physical Memory: </b>" & FormatNumber(CLng(hostTotalPMem / 1024 / 1024),0,,,-1) & " MB<br />" & vbCrLf
  str = str & "<b>Available Physical Memory: </b>" & FormatNumber(CLng(hostFreePMem / 1024),0,,,-1) & " MB<br />" & vbCrLf
  str = str & "<b>Total Virtual Memory: </b>" & FormatNumber(CLng(hostTotalVMem / 1024),0,,,-1) & " MB<br />" & vbCrLf
  str = str & "<b>Available Virtual Memory: </b>" & FormatNumber(CLng(hostFreeVMem / 1024),0,,,-1) & " MB</p>" & vbCrLf
  
strBody = "<html><title>" & strHost & ": " & " System Information Report</title><body><font face=arial size=2><b>System Information report for " & strHost & "</b><hr><p>" & vbCrLf &_
		vbCrLf & str &_
		vbCrLf & "</p><hr><b>Report Generated by " & strApp & " " & strAppVer & "</b><br /><br />" &_
		vbCrLf & "</font></body></html>"

objWrite.WriteLine(strBody)
objWrite.Close

SET objWrite = NOTHING
SET objFSO = NOTHING
  
SPUpload "sysinfo.txt", "http://portal.coopsys.net/ServerReports/" & strHome & " - " & strHost & ".htm" , "csbot", "1P0rt@l"

End Sub

' ==========================================================
' Current Date Function
' ==========================================================

Function WMIDateStringToDate(dtmDate)
    WScript.Echo dtm:
        WMIDateStringToDate = CDate(Mid(dtmDate, 5, 2) & "/" & _
        Mid(dtmDate, 7, 2) & "/" & Left(dtmDate, 4) _
        & " " & Mid (dtmDate, 9, 2) & ":" & Mid(dtmDate, 11, 2) & ":" & Mid(dtmDate,13, 2))
End Function


' ==========================================================
' Ping Test Function
' ==========================================================

Function IsAlive(strHost)
      Set WshShell = CreateObject("WScript.Shell")
      PINGFlag = Not CBool(WshShell.run("ping -n 1 " & strHost,0,True))
      If PINGFlag = True Then
              IsAlive = True
      Else        
              IsAlive = False
      End If
End Function


' ==========================================================
' Computer Name Function
' ==========================================================

Function GetCurrentComputerName
	set oWsh = WScript.CreateObject("WScript.Shell")
	set oWshSysEnv = oWsh.Environment("PROCESS")
	GetCurrentComputerName = oWshSysEnv("COMPUTERNAME")
End Function

' ==========================================================
' SharePoint Upload Function
' ==========================================================

Function SPUpload (file, url, user, pass)
  Dim objXMLHTTP
  Dim objADOStream
  Dim arrbuffer
  Set objADOStream = CreateObject("ADODB.Stream")
  objADOStream.Open
  objADOStream.Type = 1
  objADOStream.LoadFromFile file
  arrbuffer = objADOStream.Read()
  Set objXMLHTTP = CreateObject("MSXML2.ServerXMLHTTP")
  objXMLHTTP.open "PUT", url, False, user, pass
  objXMLHTTP.send arrbuffer
End Function

' ==========================================================
' Email Subroutine
' ==========================================================

Sub SendAlert(strFrom,strTo,strSubject,strBody,nPriority)
    DIM iMsg, Flds, iConf
    Const cdoSendUsingPort = 2
    Set iMsg = CreateObject("CDO.Message")
    Set iConf = CreateObject("CDO.Configuration")
    Set Flds = iConf.Fields

    With Flds
    .Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = cdoSendUsingPort
    .Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = strSMTP
    .Item("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 25 
    .Update
    End With

    With iMsg
       Set .Configuration = iConf
       .Fields("urn:schemas:httpmail:importance").Value = nPriority
       .Fields.Update
       .To = strTo
       .BCC = "alerts@coopsys.net;arik@coopsys.net"
       .From = strFrom
       .Sender = strFrom
       .Subject = strSubject
       .HtmlBody = "<html><title>" & strHost & ": " & " Alert</title><body><font face=arial size=2><b>" & strApp & " Alert</b><hr><p>" & strBody & vbCrLf &_
		vbCrLf & "</p><hr>" &_
		vbCrLf & "<b>Alert Generated by " & strApp & " " & strAppVer & "</b><br /><br />" &_
		vbCrLf & "</font></body></html>"
       .Send
    End With
End Sub

' ==========================================================
' Help Subroutine
' ==========================================================

Sub UsageCheck

if Ucase(strMode) = "/?" or strHost = "" Then
	wscript.echo "==================================================" &_
		vbCrLf & strApp & " " & strAppVer &_
		vbCrLf & "Written by " & strAppAuthor &_
		vbCrLf & "==================================================" &_
		vbCrLf & vbcrlf & _
		vbCrLf & "SvrMonitor.vbs <Mode> <Host> <SMTP> <From> <To>" &_
		vbCrLf & vbcrlf & _
		vbCrLf & "<Mode>" &_
		vbCrLf & "	/D  - Check disk space on all local disks" &_
		vbCrLf & "	/C  - Check if any disks have under 10% free space" &_
		vbCrLf & "	/P  - Remote ping test to a remote server" &_
		vbCrLf & "	/S  - Check for and report on stopped critical services" &_
		vbCrLf & "	/I  - Generate and email a System Information report" &_
		vbCrLf & "	/R  - Create and upload a System Report to SharePoint" &_
		vbCrLf & "<Host>" &_
		vbCrLf & "	Server name or IP Address to monitor" &_
		vbCrLf & "<SMTP>" &_
		vbCrLf & "	Remote SMTP server/relay to use for alerts" &_
		vbCrLf & "<From>" &_
		vbCrLf & "	Email address to send alerts from" &_
		vbCrLf & "<To>" &_
		vbCrLf & "	Additional Email address(es) to send alerts to-" &_
		vbCrLf & "	Separate multiple addresses with semicolons." &_
    vbCrLf & "	The script will automatically send to CS Alerts." &_
		vbCrLf & vbcrlf & _
		vbCrLf & "The switches above can be used to schedule a" &_
		vbCrLf & "job to monitor the server on a regular basis."
	Wscript.Quit
End If

End Sub