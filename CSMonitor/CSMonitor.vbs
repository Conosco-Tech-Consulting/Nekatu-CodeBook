' ----------------------------------------------------------
	strApp = "Co-Operative Systems Monitoring Script"
	strAppVer = "v2.7"
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
' 		1.8 - Incorporated SQL database check
'		1.9 - Added Terminal Server logon check
'		2.0 - Alerts to SQL database added
'		2.1 - SQL Stored Procedure Call and Alert Restructure
'		2.2 - Added Printer Status Check
'		2.3 - Fusion variables and batch mode added
'		2.4 - Include code added to read from external INI file
'		2.5 - Added SQL server TCP check
'		2.6 - Included code to generate results log file
'		2.7 - Replaced INI config with static variable
' ----------------------------------------------------------

' ==========================================================
' Initialise variables
' ==========================================================

On Error Resume Next

Const wbemFlagReturnImmediately = &h10
Const wbemFlagForwardOnly = &h20
Const adParamInput = 1
Const adVarChar = 200
Const adInteger = 10
Const Unknown = 0
Const Removable = 1
Const Fixed = 2
Const Remote = 3
Const CDROM = 4
Const RAMDisk = 5
Const LOCAL_HARD_DISK = 3

Dim strMode, strHost, strUser, strSvr, strHome, strDNS, strDB, strUN, strPW
Dim strCheck, strResult
Dim objItem, objWMIService, colItems, objFSO, objWrite
Dim strSubject, strBody, strFrom, strTo, strSMTP, strText
Dim hostOSName, hostOSVer, hostSPVer, hostOSDir, hostOSLoc, hostFreePMem, hostTotalVMem, hostFreeVMem
Dim hostVendor, hostModel, hostTimeZone, hostTotalPMem, hostProcArc, hostProcDesc, hostBios, hostSerial
Dim objPrinter, colPrinters, strPrinter, strWMIQuery, sCurPath
Dim strFusId, strFusPC, strFusDC, strFusTS, strFusGW, strFusDB

Set oShell=CreateObject( "WScript.Shell" )
Set objFSO=CreateObject("Scripting.FileSystemObject")

sCurPath=CreateObject("Scripting.FileSystemObject").GetAbsolutePathName(".")

strUser=oShell.ExpandEnvironmentStrings("%UserName%")
strHome=oShell.ExpandEnvironmentStrings("%UserDomain%")
strDNS=oShell.ExpandEnvironmentStrings("%UserDNSDomain%")
strSvr=oShell.ExpandEnvironmentStrings("%ComputerName%")

strLog=sCurPath & "\CSMonitor.log"
Set objFile = objFSO.CreateTextFile(strLog,True)

' ==========================================================
' FUSION VARIABLES
' ==========================================================

strFusID = "BickelsYard"
strFusPC = "LOCALHOST"
strFusDC = "10.255.255.10"
strFusTS = "10.255.255.11"
strFusGW = "10.255.255.254"
strFusDB = "10.255.255.5"
strPrinter = "Microsoft XPS Document Writer"

' ==========================================================
' FUSION BATCH Mode
' ==========================================================

if strMode = "" Then

	strHost=strFusPC
	strSMTP=""
	strFrom=""
	strTo=""
	strUN=""
	strPW=""

	PingCheck strFusDC,"DC"
	PingCheck strFusGW,"Gateway"
	RDPCheck strFusTS
	SQLQuery strFusDB
'	DBQuery
	PrinterCheck strFusPC,strPrinter

	objFile.Close

End If

' ==========================================================
' Command Line Mode
' ==========================================================

'UsageCheck

'strMode=Wscript.Arguments(0)
'strHost=UCase(Wscript.Arguments(1))
'strSMTP=Wscript.Arguments(2)
'strFrom=LCase(Wscript.Arguments(3))
'strTo=LCase(Wscript.Arguments(4))
'strPrinter=Wscript.Arguments(2)

'if Ucase(strMode) = "/P" Then
'	PingCheck strHost,strFrom,strTo,strSubject,strBody,nPriority
'	Wscript.Quit
'End If

'If Ucase(strMode) = "/D" Then
'	DiskCheck strHost,strFrom,strTo,strSubject,strBody,nPriority
'	Wscript.Quit
'End If

'If Ucase(strMode) = "/C" Then
'	CriticalSpaceCheck strHost,strFrom,strTo,strSubject,strBody,nPriority
'	Wscript.Quit
'End If

'If Ucase(strMode) = "/S" Then
'	SvcCheck strHost,strFrom,strTo,strSubject,strBody,nPriority
'	Wscript.Quit
'End If

'if Ucase(strMode) = "/T" Then
'	RDPCheck strHost,strUN,strPW,strFrom,strTo,strSubject,strBody,nPriority
'	Wscript.Quit
'End If

'If Ucase(strMode) = "/Q" Then
'	DBQuery strHost
'	Wscript.Quit
'End If

'If Ucase(strMode) = "/L" Then
'	PrinterCheck strHost,strPrinter
'	Wscript.Quit
'End If

'If Ucase(strMode) = "/I" Then
'	SystemInfo strHost,strFrom,strTo,strSubject,strBody,nPriority
'	Wscript.Quit
'End If

'If Ucase(strMode) = "/R" Then
'	SystemInfoSP strHost
'	Wscript.Quit
'End If

' ==========================================================
' Ping Check Subroutine
' ==========================================================

Sub PingCheck(strHost,strText)

	strCheck = "Ping - " & strText

	If Not IsAlive(strHost) Then
		strSubject = strHost & ": " & "Server Not Responding!"
		strBody = "&nbsp;&nbsp;Server Monitor has detected that <b>" & strHost & "</b> is not responding.<br />" & vbCrLf & "&nbsp;&nbsp;Please check the server to confirm if there is a problem."
		strResult = 0
'		SendAlert strFrom,strTo,strSubject,strBody,2
		wscript.echo strCheck & ": " & StrResult
		objFile.Write Now & "	" & strCheck & ": " & StrResult & vbcrlf
		RecordAlert strFusID,StrCheck,StrResult
	Else
		strResult = 1
		wscript.echo strCheck & ": " & StrResult
		objFile.Write Now & "	" & strCheck & ": " & StrResult & vbcrlf
		RecordAlert strFusID,StrCheck,StrResult
	End If

End Sub

' ==========================================================
' RDP Check Subroutine
' ==========================================================

Sub RDPCheck(strHost)

	strCheck = "RDP - " & strHost
	
	If Not TSListen(strHost) Then
		strSubject = strHost & " not accessible!"
		strBody = "&nbsp;&nbsp;Server Monitor has detected that <b>" & strHost & "</b> is not accessible.<br />" & vbCrLf & "&nbsp;&nbsp;Please check the server to confirm if there is a problem."
		strResult = 0
'		SendAlert strFrom,strTo,strSubject,strBody,2
		wscript.echo strCheck & ": " & StrResult
		objFile.Write Now & "	" & strCheck & ": " & StrResult & vbcrlf
		RecordAlert strFusID,StrCheck,StrResult
	Else 
		strResult = 1
		wscript.echo strCheck & ": " & StrResult
		objFile.Write Now & "	" & strCheck & ": " & StrResult & vbcrlf
		RecordAlert strFusID,StrCheck,StrResult
	End If

End Sub

' ==========================================================
' SQL Server Check Subroutine
' ==========================================================

Sub SQLCheck(strHost)

	strCheck = "SQL - " & strHost
	
	If Not SQLListen(strHost) Then
		strSubject = strHost & " not accessible!"
		strBody = "&nbsp;&nbsp;Server Monitor has detected that <b>" & strHost & "</b> is not accessible.<br />" & vbCrLf & "&nbsp;&nbsp;Please check the server to confirm if there is a problem."
		strResult = 0
'		SendAlert strFrom,strTo,strSubject,strBody,2
		wscript.echo strCheck & ": " & StrResult
		objFile.Write Now & "	" & strCheck & ": " & StrResult & vbcrlf
		RecordAlert strFusID,StrCheck,StrResult
	Else 
		strResult = 1
		wscript.echo strCheck & ": " & StrResult
		objFile.Write Now & "	" & strCheck & ": " & StrResult & vbcrlf
		RecordAlert strFusID,StrCheck,StrResult
	End If

End Sub

' ==========================================================
' Disk Space Subroutine
' ==========================================================

Sub DiskCheck(strHost,strFrom,strTo,strSubject,strBody,nPriority)

	strCheck = "Disk Space Report"

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
	
'	SendAlert strFrom,strTo,strSubject,strBody,nPriority
	wscript.echo strCheck & ": " & StrResult
	objFile.Write Now & "	" & strCheck & ": " & StrResult & vbcrlf
	RecordAlert strFusID,StrCheck,StrResult

End Sub


' ==========================================================
' Critical Disk Space Check
' ==========================================================

Sub CriticalSpaceCheck(strHost,strFrom,strTo,strSubject,strBody,nPriority)

	strCheck = "Free Space Check"

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

	strResult = 0
	
'	SendAlert strFrom,strTo,strSubject,strBody,2
	wscript.echo strCheck & ": " & StrResult
	objFile.Write Now & "	" & strCheck & ": " & StrResult & vbcrlf
	RecordAlert strFusID,StrCheck,StrResult

	Else

	strResult = 1
	wscript.echo strCheck & ": " & StrResult
	objFile.Write Now & "	" & strCheck & ": " & StrResult & vbcrlf
	RecordAlert strFusID,StrCheck,StrResult

	End If
	Next 

End Sub


' ==========================================================
' Service Check Subroutine
' ==========================================================

Sub SvcCheck(strHost,strFrom,strTo,strSubject,strBody,nPriority)

	strCheck = "Service Check"

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

		strResult = 1
		wscript.echo strCheck & ": " & StrResult
		objFile.Write Now & "	" & strCheck & ": " & StrResult & vbcrlf
		RecordAlert strFusID,StrCheck,StrResult

         	Else	
                strSubject = strHost & ": " & objItem.DisplayName  & " service " & UCase(objItem.State)
                strBody = "&nbsp;&nbsp;Reports indicate that the following service on <b>" & strHost & "</b> has stopped:" & vbCrLf & vbCrLf
                strBody = strBody & "<p>&nbsp;&nbsp;&nbsp;&nbsp;<b>Service Name:</b> 		" & objItem.DisplayName & "<br />" & vbCrLf
                strBody = strBody & "<b>&nbsp;&nbsp;&nbsp;&nbsp;Path Name:</b>&nbsp;&nbsp;" & objItem.PathName & "<br />" & vbCrLf
                strBody = strBody & "<b>&nbsp;&nbsp;&nbsp;&nbsp;State:</b>&nbsp;&nbsp;" & objItem.State & "<br />" & vbCrLf
                strBody = strBody & "<b>&nbsp;&nbsp;&nbsp;&nbsp;Status:</b>&nbsp;&nbsp;" & objItem.Status & "<br />" & vbCrLf
                strBody = strBody & "<b>&nbsp;&nbsp;&nbsp;&nbsp;Exit Code:</b>&nbsp;&nbsp;" & objItem.ExitCode & "<br />" & vbCrLf
                strBody = strBody & "<b>&nbsp;&nbsp;&nbsp;&nbsp;Service Exit Code:</b>&nbsp;&nbsp;" & objItem.ServiceSpecificExitCode & "</p>" & vbCrLf
				
		strResult = 0
	'	SendAlert strFrom,strTo,strSubject,strBody,2
		wscript.echo strCheck & ": " & StrResult
		objFile.Write Now & "	" & strCheck & ": " & StrResult & vbcrlf
		RecordAlert strFusID,StrCheck,StrResult

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
' Printer Check
' ==========================================================

Sub PrinterCheck(strHost,strPrinter)

strCheck = "Printer - " & strPrinter
strWMIQuery = "SELECT * FROM Win32_Printer WHERE name=""" & strPrinter & """"

set objWMIService = GetObject ("winmgmts:\\" & strHost & "\root\CIMV2")

set colPrinters = objWMIService.ExecQuery(strWMIQuery)

for each objPrinter in colPrinters

    Select Case objPrinter.PrinterStatus 
        Case 1 
		strResult = 0
		wscript.echo strCheck & ": " & StrResult
		objFile.Write Now & "	" & strCheck & ": " & StrResult & vbcrlf
		RecordAlert strFusID,StrCheck,StrResult
        Case 2 
		strResult = 0
		wscript.echo strCheck & ": " & StrResult
		objFile.Write Now & "	" & strCheck & ": " & StrResult & vbcrlf
		RecordAlert strFusID,StrCheck,StrResult 
        Case 3 
		strResult = 1
		wscript.echo strCheck & ": " & StrResult
		objFile.Write Now & "	" & strCheck & ": " & StrResult & vbcrlf
		RecordAlert strFusID,StrCheck,StrResult
        Case 4 
		strResult = 1
		wscript.echo strCheck & ": " & StrResult
		objFile.Write Now & "	" & strCheck & ": " & StrResult & vbcrlf
		RecordAlert strFusID,StrCheck,StrResult
        Case 5 
		strResult = 1
		wscript.echo strCheck & ": " & StrResult
		objFile.Write Now & "	" & strCheck & ": " & StrResult & vbcrlf
		RecordAlert strFusID,StrCheck,StrResult
    End Select 

next

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
  
'	SendAlert strFrom,strTo,strSubject,strBody,nPriority
	wscript.echo strCheck & ": " & StrResult
	objFile.Write Now & "	" & strCheck & ": " & StrResult & vbcrlf
	RecordAlert strFusID,StrCheck,StrResult

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
' RDP Test Function
' ==========================================================

Function TSListen(strHost)
      Set WshShell = CreateObject("WScript.Shell")
      RDPFlag = Not CBool(WshShell.run("portqry -n " & strHost & " -e 3389 -p tcp -q",0,True))
      If RDPFlag = True Then
              TSListen = True
      Else        
              TSListen = False
      End If
End Function

' ==========================================================
' SQL Server Test Function
' ==========================================================

Function SQLListen(strHost)
      Set WshShell = CreateObject("WScript.Shell")
      SQLFlag = Not CBool(WshShell.run("portqry -n " & strHost & " -e 1433 -p tcp -q",0,True))
      If SQLFlag = True Then
              SQLListen = True
      Else        
              SQLListen = False
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
' SQL Report Insert Subroutine
' ==========================================================

Sub RecordAlert(strFusID,strCheck,strResult)

	Dim cmd
	Dim sp
	Dim par1
	Dim par2
	Dim par3

	sp = "monitoringdbupdateproc"

	Set cmd = CreateObject("ADODB.Command")
	set par1 = CreateObject("ADODB.Parameter")
	set par2 = CreateObject("ADODB.Parameter")
	set par3 = CreateObject("ADODB.Parameter")

	par1.Direction=adParamInput
	par1.name="SiteName"
	par1.Size=50
	par1.Type=adVarChar
	par1.Value=strFusID

	par2.Direction=adParamInput
	par2.name="CheckName"
	par2.Size=50
	par2.Type=adVarChar
	par2.Value=strCheck

	par3.Direction=adParamInput
	par3.name="Result"
	par3.Size=10
	par3.Type=adVarChar
	par3.Value=strResult

	With cmd
		.ActiveConnection = "Provider=sqloledb;Data Source=fusion-sql2;Initial Catalog=monitoringdb;Integrated Security=SSPI"
		.CommandType = 4
		.CommandText = sp
		.Parameters.Append par1 
		.Parameters.Append par2
		.Parameters.Append par3
		.Execute
	End With

	Set cmd = Nothing
	set par1 = Nothing
	set par2 = Nothing
	set par3 = Nothing

end sub

' ==========================================================
' SQL Database Query Subroutine
' ==========================================================

Sub DBQuery

	strCheck = "SQL - MonitoringDB"
	Set objCon = CreateObject("ADODB.Connection")
	objCon.Open "Provider=sqloledb;Data Source=fusion-sql2;Initial Catalog=monitoringdb;Integrated Security=SSPI"
	if err.number <> 0 then
		strResult = 0
		wscript.echo strCheck & ": " & StrResult
		RecordAlert strFusID,StrCheck,StrResult
	else
		strResult = 1
		wscript.echo strCheck & ": " & StrResult
		RecordAlert strFusID,StrCheck,StrResult
	end if

End Sub

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
' INI Subroutine
' ==========================================================

Sub Include(sInstFile)
	Dim f, s, oFSO
	Set oFSO = CreateObject("Scripting.FileSystemObject")
	On Error Resume Next
	If oFSO.FileExists(sInstFile) Then
		Set f = oFSO.OpenTextFile(sInstFile)
		s = f.ReadAll
		f.Close
		ExecuteGlobal s
	End If
	On Error Goto 0
	Set f = Nothing
	Set oFSO = Nothing
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