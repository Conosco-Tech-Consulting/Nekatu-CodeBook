'============================================
' m3u Playlist Splitter v1.06
' Copyright © 2010 Arik Fletcher
'
' Please run this script with m3usplit.cmd
'============================================

dim strFile, strThisPlaylist, strNextPlaylist, strDestPath, strDestFile

strFile = wscript.arguments(0)
 
Set objFSO = CreateObject("Scripting.FileSystemObject")
Const intForAppending = 8
Const intForReading = 1, intForWriting = 2
 
Set objFile = objFSO.OpenTextFile(strFile, intForReading, False)
strThisPlaylist = "C:\Q\Powergold4\Hour" & wscript.arguments(1) & ".mp3"
strNextPlaylist = "C:\Q\Powergold4\Hour" & wscript.arguments(2) & ".mp3"
strDestPath = objFSO.GetParentFolderName(strFile)
strDestFile = objFSO.GetBaseName(strFile) & "." & wscript.arguments(1) & ".tmp"
While Not objFile.AtEndOfStream
	strLine = objFile.ReadLine
	If Left(strLine, 26) = "C:\Q\Powergold4\Hour" & wscript.arguments(1) & ".mp3" Then
		strThisPlaylist = Mid(strLine, 27)
	End If
	If Left(strLine, 26) = "C:\Q\Powergold4\Hour" & wscript.arguments(2) & ".mp3" Then
		wscript.quit
	End If
	If strThisPlaylist <> strNextPlaylist Then
		strNextPlaylist = strThisPlaylist
		Set objplaylist = objFSO.CreateTextFile(strDestFile, True)
		objplaylist.WriteLine strLine
		objplaylist.Close
		Set objplaylist = Nothing
	Else
		Set objplaylist = objFSO.OpenTextFile(strDestFile, intForAppending, False)
		objplaylist.WriteLine strLine
		objplaylist.Close
		Set objplaylist = Nothing		
	End If
Wend
objFile.Close