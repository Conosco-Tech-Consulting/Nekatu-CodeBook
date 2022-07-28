on error resume next

Const wbemFlagReturnImmediately = &h10
Const wbemFlagForwardOnly = &h20

Const Unknown = 0
Const Removable = 1
Const Fixed = 2
Const Remote = 3
Const CDROM = 4
Const RAMDisk = 5
Const LOCAL_HARD_DISK = 3

Dim strMode, strHost, strUser, strSvr, strHome, strDNS
Dim objItem, objWMIService, colItems, objFSO, objWrite
Dim strSubject, strBody, strFrom, strTo, strSMTP
Dim hostOSName, hostOSVer, hostSPVer, hostOSDir, hostOSLoc, hostFreePMem, hostTotalVMem, hostFreeVMem
Dim hostVendor, hostModel, hostTimeZone, hostTotalPMem, hostProcArc, hostProcDesc, hostBios, hostSerial

Set oShell = CreateObject( "WScript.Shell" )

strUser=oShell.ExpandEnvironmentStrings("%UserName%")
strHome=oShell.ExpandEnvironmentStrings("%UserDomain%")
strDNS=oShell.ExpandEnvironmentStrings("%UserDNSDomain%")
strSvr=oShell.ExpandEnvironmentStrings("%ComputerName%")

strHost = UCase(Wscript.Arguments(0))
strFile = UCase(Wscript.Arguments(1))

Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objWrite = objFSO.OpenTextFile(strFile, 2, True)

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
		vbCrLf & "</p><hr><br /><br />" &_
		vbCrLf & "</font></body></html>"

objWrite.WriteLine(strBody)
objWrite.Close

SET objWrite = NOTHING
SET objFSO = NOTHING