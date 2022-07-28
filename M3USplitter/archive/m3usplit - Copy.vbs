strFile = "report.m3u"
 
Set objFSO = CreateObject("Scripting.FileSystemObject")
Const intForAppending = 8
Const intForReading = 1, intForWriting = 2
 
Set objFile = objFSO.OpenTextFile(strFile, intForReading, False)
strReportTitle = "#END" & wscript.arguments(0)
strCurrentReport = "#END" & wscript.arguments(0)
While Not objFile.AtEndOfStream
	strLine = objFile.ReadLine
	If Left(strLine, 9) = "#END" & wscript.arguments(0) Then
		strReportTitle = Mid(strLine, 10)
	End If
	If strReportTitle <> strCurrentReport Then
		strCurrentReport = strReportTitle
		Set objReport = objFSO.CreateTextFile("Report" & wscript.arguments(0) & ".m3u", True)
		objReport.WriteLine strLine
		objReport.Close
		Set objReport = Nothing
	Else
		Set objReport = objFSO.OpenTextFile("Report" & wscript.arguments(0) & ".m3u", intForAppending, False)
		objReport.WriteLine strLine
		objReport.Close
		Set objReport = Nothing		
	End If
Wend
objFile.Close