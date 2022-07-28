strComputer = WScript.Arguments(0)
Set objWMIService = GetObject("winmgmts:" _
    & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
Set colDiskDrives = objWMIService.ExecQuery _
    ("Select * from Win32_PerfFormattedData_PerfDisk_LogicalDisk where " _
        & "Name <> '_Total'")
For Each objDiskDrive in colDiskDrives
    Wscript.Echo objDiskDrive.Name & "," & objDiskDrive.FreeMegabytes
Next