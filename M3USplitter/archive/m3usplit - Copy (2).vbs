strFile = "playlist.m3u"
 
Set objFSO = CreateObject("Scripting.FileSystemObject")
Const intForAppending = 8
Const intForReading = 1, intForWriting = 2
 
Set objFile = objFSO.OpenTextFile(strFile, intForReading, False)
strplaylistTitle = "#" & wscript.arguments(0)
strCurrentplaylist = "#" & wscript.arguments(0) - 1
While Not objFile.AtEndOfStream
	strLine = objFile.ReadLine
	If Left(strLine, 9) = "#" & wscript.arguments(0) Then
		strplaylistTitle = Mid(strLine, 10)
	End If
	If Left(strLine, 9) = "#" & wscript.arguments(0) + 1 Then
		wscript.quit
	End If
	If strplaylistTitle <> strCurrentplaylist Then
		strCurrentplaylist = strplaylistTitle
		Set objplaylist = objFSO.CreateTextFile("playlist" & wscript.arguments(0) & ".m3u", True)
		objplaylist.WriteLine strLine
		objplaylist.Close
		Set objplaylist = Nothing
	Else
		Set objplaylist = objFSO.OpenTextFile("playlist" & wscript.arguments(0) & ".m3u", intForAppending, False)
		objplaylist.WriteLine strLine
		objplaylist.Close
		Set objplaylist = Nothing		
	End If
Wend
objFile.Close