strComputer = "."
Set objWMIService = GetObject("winmgmts:" _
    & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
Set colSMBIOS = objWMIService.ExecQuery _
    ("SELECT * FROM Win32_SystemEnclosure")
For Each objSMBIOS in colSMBIOS
Wscript.Echo objSMBIOS.SerialNumber
Next