Dim fso
Dim ObjOutFile
Dim objShell

Set objShell = WScript.CreateObject ("WScript.shell")
 
'Creating File System Object
Set fso = CreateObject("Scripting.FileSystemObject")
 
'Create an output file
Set ObjOutFile = fso.CreateTextFile(wscript.arguments(0) & "\" & "SharePointFileCheck.csv")

'Writing CSV headers
ObjOutFile.WriteLine("File or Folder Name,Character Length,Full Path")
 
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
	if (Len(objFile.name)) >= 128 Then 
		ObjOutFile.WriteLine(ObjFile.Name & "," & (Len(objFile.Name)) & "," & ObjFile.Path)
        End If
    Next
     
    'Getting all subfolders
    Set ObjSubFolders = ObjFolder.SubFolders
     
    For Each ObjFolder In ObjSubFolders
        'Writing SubFolder Name and Path
	if (Len(objFolder.name)) >= 128 then 
		ObjOutFile.WriteLine(ObjFolder.Name & "," & (Len(objFolder.Name)) & "," & ObjFolder.Path)
        End If 
        'Getting all Files from subfolder
        GetFiles(ObjFolder.Path)
   Next
     
End Function