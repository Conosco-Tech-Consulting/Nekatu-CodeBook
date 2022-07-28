'Script:   AddToZip.vbs
'Created:  05/01/2006
'Version:  2.0
'Author:   Arik Fletcher
'Contact:  arikf@joskos.com
'--------------------------------------------
'Description: This script will compress a
'             specified folder into a user-
'             specified .zip file.
'
'Usage: wscript.exe <path>\AddToZip.vbs
'============================================
'
'Copyright (c) Joskos Limited

Option Explicit

Const ForReading = 1, ForWriting = 2, ForAppending = 8

Dim ZipHex, ZipBinary, ZipSource, ZipTarget
Dim oShell, oApp, oFolder, oCTF, oFile, i
Dim oFileSys

ZipSource = WScript.Arguments(0)
ZipTarget = WScript.Arguments(1)

ZipHex = Array(80, 75, 5, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)

For i = 0 To UBound(ZipHex)
ZipBinary = ZipBinary & Chr(ZipHex(i))
Next

Set oShell = CreateObject("WScript.Shell")
Set oFileSys = CreateObject("Scripting.FileSystemObject")

'Create the basis of a zip file.
Set oCTF = oFileSys.CreateTextFile(ZipTarget, True)
oCTF.Write ZipBinary
oCTF.Close
Set oCTF = Nothing

Set oApp = CreateObject("Shell.Application")

'Copy the files to the compressed folder
Set oFolder = oApp.NameSpace(ZipSource)
If Not oFolder Is Nothing Then
oApp.NameSpace(ZipTarget).CopyHere oFolder.Items
End If

'Wait for compressing to begin
wScript.Sleep(5000)

'wait for lock to release
Set oFile = Nothing
On Error Resume Next
Do While (oFile Is Nothing)
'Attempt to open the file, this causes an Err 70, Permission Denied when the file is already open
Set oFile = oFileSys.OpenTextFile(ZipTarget, ForAppending, False)
If Err.number <> 0 then
Err.Clear
wScript.Sleep 3000
End If
Loop

Set oFile=Nothing
Set oFileSys=Nothing
