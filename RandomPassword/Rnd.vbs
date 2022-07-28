Set objFSO = CreateObject("Scripting.FileSystemObject")

Title = "Co-Operative System Password Generator"

Phase1 = Left(MonthName(Month(now)),2)
Phase2 = LCase(Left(WeekdayName(Weekday(Now)),2))
Phase3 = LCase(Left(right(objFSO.GetTempName, InStr(objFSO.GetTempName,".")),5))
Phase4 = "!"

PassGen =  Phase1 & Phase2 & Phase3 & Phase4

InputBox "Run the script again to generate another password" & vbcrlf & vbCrlf & _
	 "Press CTRL + C to copy the generated password" & vbcrlf & _
         "to your clipboard. Please ensure that you have" & vbcrlf & _
	 "documented this password if you intend to use it"  & vbcrlf & _
	 "as it will not be repeated." & vbCrlf, Title, PassGen