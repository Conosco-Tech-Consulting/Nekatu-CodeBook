Option Explicit
Dim objNetwork, strDrive, objShell, objUNC, objArgs
Dim strRemotePath, strDriveLetter, strNewName
 
Set objArgs = WScript.Arguments
Set objShell = CreateObject("Shell.Application")

strDriveLetter = objArgs(0)
strNewName = objArgs(1)


objShell.NameSpace(strDriveLetter).Self.Name = strNewName

WScript.Quit