dim strFile, strplaylisttitle, strcuttentplaylist, strdestpath

strFile = wscript.arguments(0)
 
Set objFSO = CreateObject("Scripting.FileSystemObject")
Const intForAppending = 8
Const intForReading = 1, intForWriting = 2
 
Set objFile = objFSO.OpenTextFile(strFile, intForReading, False)
strplaylistTitle = "#" & wscript.arguments(1)
strCurrentplaylist = "#" & wscript.arguments(1) - 1
strDestPath = objFSO.GetParentFolderName(strFile)
While Not objFile.AtEndOfStream
	strLine = objFile.ReadLine
	If Left(strLine, 9) = "#" & wscript.arguments(1) Then
		strplaylistTitle = Mid(strLine, 10)
	End If
	If Left(strLine, 9) = "#" & wscript.arguments(1) + 1 Then
		wscript.quit
	End If
	If strplaylistTitle <> strCurrentplaylist Then
		strCurrentplaylist = strplaylistTitle
		Set objplaylist = objFSO.CreateTextFile(strDestPath & "\playlist" & wscript.arguments(1) & ".tmp", True)
		objplaylist.WriteLine strLine
		objplaylist.Close
		Set objplaylist = Nothing
	Else
		Set objplaylist = objFSO.OpenTextFile(strDestPath & "\playlist" & wscript.arguments(1) & ".tmp", intForAppending, False)
		objplaylist.WriteLine strLine
		objplaylist.Close
		Set objplaylist = Nothing		
	End If
Wend
objFile.Close