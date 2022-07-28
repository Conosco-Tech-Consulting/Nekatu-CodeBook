'Script:   SPReport.vbs
'Created:  08/08/2012
'Version:  1.2
'Author:   Arik Fletcher
'Contact:  arikf@micronicity.co.uk
'--------------------------------------------
'Description: This script will scan a given
'			 folder tree for objects that
'			 do not meet document library
'			 character rules.
'
'Usage: wscript.exe <path>\SPReport.vbs
'============================================
'
'Copyright (c) Arik Fletcher

on error resume next

Dim fso
Dim ObjOutFile
Dim objShell

Set objShell = WScript.CreateObject ("WScript.shell")

Const READONLY = 1
Const HIDDEN = 2 

'Creating File System Object
Set fso = CreateObject("Scripting.FileSystemObject")
 
'Create an output file
Set ObjOutFile = fso.CreateTextFile(wscript.arguments(0) & "\" & "SharePointFileCheck.csv")

'Writing CSV headers
ObjOutFile.WriteLine("FOLDER,FILE NAME,128 LIMIT,HIDDEN,&,_,%20,..,. ,#,%,[,],--")
 
'Call the GetFile function to get all files
GetFiles(wscript.arguments(0))
 
'Close the output file
ObjOutFile.Close
 
objShell.run "excel " & wscript.arguments(0) & "\" & "SharePointFileCheck.csv"
Set objShell = Nothing
 
Function GetFiles(FolderName)
	On Error Resume Next
	 
	Dim ObjFolder
	Dim ObjSubFolders
	Dim ObjSubFolder
	Dim ObjFiles
	Dim ObjFile
 
	Set ObjFolder = fso.GetFolder(FolderName)
	Set ObjFiles = ObjFolder.Files
	 
'Write all files to output files
 For Each ObjFile In ObjFiles

	' check if the file name is longer than 128 characters
	if (Len(objFile.name)) >= 128 Then 
		strLength = "Over: " & (Len(objFile.Name))
	Else
		strLength = "Under"
	End If

	' check if the file is hidden
	If objFile.Attributes AND HIDDEN Then
        	objFile.Attributes = objFile.Attributes XOR HIDDEN
		strP0 = "Y"
	Else
		strP0 = "N"
    	End If 

	' check if the file name contains "&"
	If InStr(1, objFile.name, "&") <> 0 Then
		strP1 = "Y"
	Else
		strP1 = "N"
	End If

	' check if the file name contains "_"
	If InStr(1, objFile.name, "_") <> 0 Then
		strP2 = "Y"
	Else
		strP2 = "N"
	End If

	' check if the file name contains "%20"
	If InStr(1, objFile.name, "%20") <> 0 Then
		strP3 = "Y"
	Else
		strP3 = "N"
	End If

	' check if the file name contains ".."
	If InStr(1, objFile.name, "..") <> 0 Then
		strP4 = "Y"
	Else
		strP4 = "N"
	End If

	' check if the file name contains ". "
	If InStr(1, objFile.name, ". ") <> 0 Then
		strP5 = "Y"
	Else
		strP5 = "N"
	End If

	' check if the file name contains "#"
	If InStr(1, objFile.name, "#") <> 0 Then
		strP6 = "Y"
	Else
		strP6 = "N"
	End If

	' check if the file name contains "%"
	If InStr(1, objFile.name, "%") <> 0 Then
		strP7 = "Y"
	Else
		strP7 = "N"
	End If

	' check if the file name contains "["
	If InStr(1, objFile.name, "[") <> 0 Then
		strP8 = "Y"
	Else
		strP8 = "N"
	End If

	' check if the file name contains "]"
	If InStr(1, objFile.name, "]") <> 0 Then
		strP9 = "Y"
	Else
		strP9 = "N"
	End If

	' check if the file name contains "--"
	If InStr(1, objFile.name, "--") <> 0 Then
		strP10 = "Y"
	Else
		strP10 = "N"
	End If

	ObjOutFile.WriteLine(",""" & ObjFile.Name & """," & strLength & "," & strP0 & "," & strP1 & "," & strP2 & "," & strP3 & "," & strP4 & "," & strP5 & "," & strP6 & "," & strP7 & "," & strP8 & "," & strP9 & "," & strP10 )

	Next

	'Getting all subfolders
	Set ObjSubFolders = ObjFolder.SubFolders
	 
	For Each ObjFolder In ObjSubFolders

		strCount = objFiles.count
	
	if (Len(objFolder.name)) >= 128 Then 
		strLength = "Over: " & (Len(objFolder.Name))
	Else
		strLength = "Under"
	End If

	' check if the file is hidden
	If objFolder.Attributes AND HIDDEN Then
        	objFolder.Attributes = objFolder.Attributes XOR HIDDEN
		strP0 = "Y"
	Else
		strP0 = "N"
    	End If 

	' check if the Folder name contains "&"
	If InStr(1, objFolder.name, "&") <> 0 Then
		strP1 = "Y"
	Else
		strP1 = "N"
	End If

	' check if the Folder name contains "_"
	If InStr(1, objFolder.name, "_") <> 0 Then
		strP2 = "Y"
	Else
		strP2 = "N"
	End If

	' check if the Folder name contains "%20"
	If InStr(1, objFolder.name, "%20") <> 0 Then
		strP3 = "Y"
	Else
		strP3 = "N"
	End If

	' check if the Folder name contains ".."
	If InStr(1, objFolder.name, "..") <> 0 Then
		strP4 = "Y"
	Else
		strP4 = "N"
	End If

	' check if the Folder name contains ". "
	If InStr(1, objFolder.name, ". ") <> 0 Then
		strP5 = "Y"
	Else
		strP5 = "N"
	End If

	' check if the Folder name contains "#"
	If InStr(1, objFolder.name, "#") <> 0 Then
		strP6 = "Y"
	Else
		strP6 = "N"
	End If

	' check if the Folder name contains "%"
	If InStr(1, objFolder.name, "%") <> 0 Then
		strP7 = "Y"
	Else
		strP7 = "N"
	End If

	' check if the Folder name contains "["
	If InStr(1, objFolder.name, "[") <> 0 Then
		strP8 = "Y"
	Else
		strP8 = "N"
	End If

	' check if the Folder name contains "]"
	If InStr(1, objFolder.name, "]") <> 0 Then
		strP9 = "Y"
	Else
		strP9 = "N"
	End If

	' check if the Folder name contains "--"
	If InStr(1, objFolder.name, "--") <> 0 Then
		strP10 = "Y"
	Else
		strP10 = "N"
	End If

	ObjOutFile.WriteLine("-----------------------------")
	ObjOutFile.WriteLine("""" & ObjFolder.Name & """," & strCount & " FILES," & strLength & "," & strP0 & "," & strP1 & "," & strP2 & "," & strP3 & "," & strP4 & "," & strP5 & "," & strP6 & "," & strP7 & "," & strP8 & "," & strP9 & "," & strP10 )
	ObjOutFile.WriteLine(",")

		'Getting all Files from subfolder
		GetFiles(ObjFolder.Path)
   Next
	 
End Function