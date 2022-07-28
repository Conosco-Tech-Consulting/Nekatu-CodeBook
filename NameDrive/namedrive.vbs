'Script:   NameDrive
'Created:  05/01/2006
'Version:  2.0
'Author:   Arik Fletcher
'Contact:  arikf@micronicity.co.uk
'--------------------------------------------------------------------
'Description: 	Basic script to rename a mapped drive to a specified
'		value to simplify navigation and improve the overall
'		user desktop experience.
'
'Usage: cscript.exe <path>\NameDrive.vbs [DriveLetter:] [Drive Name]
'====================================================================
'
'Copyright (c) Arik Fletcher

Option Explicit
Dim objNetwork, strDrive, objShell, objUNC, objArgs
Dim strRemotePath, strDriveLetter, strNewName
 
Set objArgs = WScript.Arguments
Set objShell = CreateObject("Shell.Application")

strDriveLetter = objArgs(0)
strNewName = objArgs(1)

objShell.NameSpace(strDriveLetter).Self.Name = strNewName

WScript.Quit