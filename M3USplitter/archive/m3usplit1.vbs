strFile = "report.m3u"
 
Set objFSO = CreateObject("Scripting.FileSystemObject")
Const intForAppending = 8
Const intForReading = 1, intForWriting = 2
 
Set objFile = objFSO.OpenTextFile(strFile, intForReading, False)
strReportTitle = wscript.arguments(0)
'strCurrentReport = "0"
While Not objFile.AtEndOfStream
	strLine = objFile.ReadLine
	If Left(strLine, 9) = "REPORT : " Then
		strReportTitle = Mid(strLine, 10)
	End If
		Set objReport = objFSO.OpenTextFile("Report" & strReportTitle & ".txt", intForAppending, False)
		objReport.WriteLine strLine
		objReport.Close
		Set objReport = Nothing		
Wend
objFile.Close
MsgBox "Done"