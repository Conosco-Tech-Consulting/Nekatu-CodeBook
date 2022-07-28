' ==================================================================
' |A|B|S| - Automated Backup Script for Windows 2000/XP/2003
' ==================================================================
' Copyright (c) Arik Fletcher, some components copyright (c) their
' various owners and/or publishers. See README.TXT for more info.
' ==================================================================
' Modifications to the script are not permitted unless express 
' permission is granted by the author. Please forward requests for 
' new features to the author at the email address specified above.
' ==================================================================

Option Explicit
'On Error Resume Next

Dim objIE, WSHShell, k, x, i, IETitle, blnFlag, objWMIService, colOperatingSystems, FSO, File, objItem, ABSOperation
Dim ABSVer, ABSDir, ABSSMTPSvr, ABSSend, ABSrcpt, ABSLogs, ABSSelect, ABSSelection, BckpRprt, BckpStatus, objOperatingSystem
Dim BckpSite, BckpLogDir, BckpTapeDst, BckpFileDst, BckpLog, BckpZip, BckpSharepoint, BckpDate, BckpSkipped, OSName
Dim OSVer, StartTime, Sharepoint, HTMLReports, TMPLogs, TMPDir, objMessage, BckpHostname, BckpType, ABSAction, BckpMail

Set WSHShell = Wscript.CreateObject("WScript.Shell")

' ==================================================================
' Check OS Compatibility
' ==================================================================

'CheckCompat

' ==================================================================
' Get settings from Registry and Initialise ABS
' ==================================================================

'ABSInit

' ==================================================================
' Check command line switches
' ==================================================================

ABSHeader

If WScript.Arguments.Count = 1 Then

 ABSOperation = WScript.arguments.item(0)
 ABSAction = WScript.arguments.item(1)

 if ABSOperation = "/?" then ABSHelp
 if ABSOperation = "/help" then ABSHelp
 if ABSOperation = "/check" then ABSCheck

Else
 
 ABSHelp
 Wscript.Quit

End If


' ==================================================================
' Generate Backup Selection File(s)
' ==================================================================

'AutoGenSelect

' ==================================================================
' Send report email
' ==================================================================

'ABSReadReport
'ABSSendEmail

' ==================================================================
' Clean Up and Exit
' ==================================================================

'CleanUp

' ==================================================================
' Sub Functions
' ==================================================================


sub ABSInit

	BckpDate = Day(Now()) & "-" & Month(Now()) &  "-" & Year(Now())
	StartTime = FormatDateTime(Now(), vbShortTime)
	ABSVer = WSHShell.RegRead("HKLM\Software\Joskos Solutions\ABS\CurrentVersion")
	ABSDir = WSHShell.RegRead("HKLM\Software\Joskos Solutions\ABS\InstallPath")
	ABSSMTPSvr = WSHShell.RegRead("HKLM\Software\Joskos Solutions\ABS\MailServerAddress")
	ABSSend = WSHShell.RegRead("HKLM\Software\Joskos Solutions\ABS\MailSender")
	ABSrcpt = WSHShell.RegRead("HKLM\Software\Joskos Solutions\ABS\MailReceiver")
	BckpSite = WSHShell.RegRead("HKLM\Software\Joskos Solutions\ABS\BackupSite")
	BckpLogDir = WSHShell.RegRead("HKLM\Software\Joskos Solutions\ABS\BackupReportsPath")
	BckpTapeDst = WSHShell.RegRead("HKLM\Software\Joskos Solutions\ABS\BackupTapeDevice")
	BckpFileDst = WSHShell.RegRead("HKLM\Software\Joskos Solutions\ABS\BackupFilesPath")
	HTMLReports = WSHShell.RegRead("HKLM\Software\Joskos Solutions\ABS\HTMLReports")
	Sharepoint = WSHShell.RegRead("HKLM\Software\Joskos Solutions\ABS\BackupSharepoint")
	ABSLogs = ABSDir & "\Logs"
	TMPDir = "%USERPROFILE%\Local Settings\Application Data\Microsoft\Windows NT\NTBackup\data"
	TMPLogs = "%USERPROFILE%\Local Settings\Application Data\Microsoft\Windows NT\NTBackup\data\*.log"
	BckpRprt = BckpLogDir & "\" & BckpDate & "-Report-" & BckpType & ".htm"
	BckpLog = BckpLogDir & "\" & BckpDate & "-Log-" & BckpType & ".log"
	BckpZip = BckpLogDir & "\" & BckpDate & "-Log-" & BckpType & ".zip"
	BckpSharepoint = "%SystemDrive%\SharePointBackup.spb"
	
	IETitle = "|A|B|S| - Automated Backup Script for Windows 2000/XP/2003" '& String(40, "-")
	blnFlag = True
	InitIE "Program Initializing"
	
end sub


sub ABSHeader
end sub


sub CheckCompat

	BckpHostname = WSHShell.ExpandEnvironmentStrings("%COMPUTERNAME%")
	Set objWMIService = GetObject("winmgmts:\\" & BckpHostname & "\root\cimv2")
	Set colOperatingSystems = objWMIService.ExecQuery _
    ("Select * from Win32_OperatingSystem")
	For Each objOperatingSystem in colOperatingSystems
    	OSVer = objOperatingSystem.Version
    	OSName = objOperatingSystem.Caption
	Next
	If InStr(OSVer, "6.0.") > 0 Then
		wscript.echo vbCrLf & _
				 "The Windows Vista family is not supported in ABS 3.0" & vbCrLf & _
				 "ABS is only compatible with Windows 2000/XP/2003"
		wscript.quit
	end if

end sub


sub AutoGenSelect

	Set FSO=CreateObject("Scripting.FileSystemObject") 
	x = 1
		do
		ABSSelection = WSHShell.RegRead("HKLM\Software\Joskos Solutions\ABS\Selection" & x & "\" & "Select0")
		if len(ABSSelection) = 0 then exit do
		Set File=FSO.CreateTextFile(ABSDir & "\Selection" & x & ".bks", True, True)
		i = 0
		do
			ABSSelect = WSHShell.RegRead("HKLM\Software\Joskos Solutions\ABS\Selection" & x & "\" & "Select" & i)
			if len(ABSSelect) = 0 then exit do
			File.Write ABSSelect & vbCrLf
			ABSSelect = ""
			i = i + 1
		loop
		File.Close
		File = ""
			ABSSelection = ""
		x = x + 1
	Loop

end sub


sub ABSReadReport

	Const ForReading = 1, ForWriting = 2, ForAppending = 8
	Set FSO = CreateObject("Scripting.FileSystemObject")
	Set File = FSO.OpenTextFile(BckpRprt, ForReading)
	BckpMail = File.ReadAll
	File.Close

end sub


sub ABSSendEmail

	Set objMessage = CreateObject("CDO.Message") 
	objMessage.Subject = BckpStatus & " - " & BckpSkipped & " Skipped File(s)"
	objMessage.From = BckpSite & " <" & ABSSend & ">"
	objMessage.To = "Arik Fletcher <arikf@joskos.com>"
	objMessage.HTMLBody = BckpMail
	objMessage.AddAttachment (BckpZip)
	objMessage.Configuration.Fields.Item _
	("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2 
	objMessage.Configuration.Fields.Item _
	("http://schemas.microsoft.com/cdo/configuration/smtpserver") = ABSSMTPSvr
	objMessage.Configuration.Fields.Item _
	("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25 
	objMessage.Configuration.Fields.Update
	objMessage.Send

end sub


Sub MsgIE(strMsg)

    On Error Resume Next
    If (strMsg = "IE_Quit") Then
        blnFlag = False
        objIE.Quit
    Else
        objIE.Document.Body.InnerText = strMsg
        If (Err.Number <> 0) Then
            Err.Clear
            blnFlag = False
            Exit Sub
        End If
        WSHShell.AppActivate IETitle
    End If

End Sub


Sub InitIE(strMsg)

    Dim intWidth, intHeight, intWidthW, intHeightW
    Set objIE = CreateObject("InternetExplorer.Application")
    objIE.ToolBar = False
    objIE.StatusBar = False
    objIE.Resizable = False
    objIE.Navigate("about:blank")
    Do Until objIE.readyState = 4
        Wscript.Sleep 100
    Loop
    intWidth = objIE.document.ParentWindow.Screen.AvailWidth
    intHeight = objIE.document.ParentWindow.Screen.AvailHeight
    intWidthW = objIE.document.ParentWindow.Screen.AvailWidth * .40
    intHeightW = objIE.document.ParentWindow.Screen.AvailHeight * .40
    objIE.document.ParentWindow.resizeto intWidthW, intHeightW
    objIE.document.ParentWindow.moveto (intWidth - intWidthW)/2, (intHeight - intHeightW)/2
    objIE.document.Write "<body>" & strMsg & " </body></html>"
    objIE.document.ParentWindow.document.body.style.backgroundcolor = "#CCCCCC"
    objIE.document.ParentWindow.document.body.scroll="no"
    objIE.document.ParentWindow.document.body.style.Font = "bold 10pt 'Lucida Console'"
    objIE.document.Title = IETitle
    objIE.Visible = True
    Wscript.Sleep 100
    WSHShell.AppActivate IETitle

End Sub


sub CleanUp

	Set objIE = Nothing
	Set WSHShell = Nothing
	Set k = Nothing
	Set x = Nothing
	Set i = Nothing
	Set IETitle = Nothing
	Set blnFlag = Nothing
	Set objWMIService = Nothing
	Set colItems = Nothing
	Set FSO = Nothing
	Set File = Nothing
	Set objItem = Nothing
	Set ABSVer = Nothing
	Set ABSDir = Nothing
	Set ABSSMTPSvr = Nothing
	Set ABSSend  = Nothing
	Set ABSrcpt = Nothing
	Set ABSLogs = Nothing
	Set ABSSelect = Nothing
	Set ABSSelection = Nothing
	Set ABSAction = Nothing
	Set ABSOperation = Nothing
	Set BckpRprt = Nothing
	Set BckpStatus = Nothing
	Set BckpSite = Nothing
	Set BckpLogDir = Nothing
	Set BckpTapeDst = Nothing
	Set BckpFileDst = Nothing
	Set BckpLog = Nothing
	Set BckpZip = Nothing
	Set BckpSharepoint = Nothing
	Set BckpDate = Nothing
	Set BckpSkipped = Nothing
	Set OSVer = Nothing
	Set StartTime = Nothing
	Set Sharepoint = Nothing
	Set HTMLReports = Nothing
	Set TMPLogs = Nothing
	Set TMPDir = Nothing
	Set objMessage = Nothing
	Set BckpHostname = Nothing

end sub


sub ABSCheck

	wscript.echo _
	"==========================================================" & vbCrLf & _
	"|A|B|S| - Automated Backup Script for Windows 2000/XP/2003" & vbCrLf & _
	"==========================================================" & vbCrLf & _
	"Copyright (c) Arik Fletcher, some components copyright (c)" & vbCrLf & _
	"their various owners and/or publishers." & vbCrLf & _
	"==========================================================" & vbCrLf & vbCrLf & _
	"Backup Date:      " & BckpDate & vbCrLf & _
	"Start Time:       " & StartTime & vbCrLf & _
	"ABS Version:      " & ABSVer & vbCrLf & _
	"ABS Installation: " & ABSDir & vbCrLf & _
	"SMTP Server:      " & ABSSMTPSvr & vbCrLf & _
	"SMTP Sender:      " & ABSSend & vbCrLf & _
	"SMTP Recipient:   " & ABSrcpt & vbCrLf & _
	"Backup Site:      " & BckpSite & vbCrLf & _
	"Backup Logs:      " & BckpLogDir & vbCrLf & _
	"Backup Pool:      " & BckpTapeDst & vbCrLf & _
	"Backup Files:     " & BckpFileDst & vbCrLf & _
	"HTML Reports:     " & HTMLReports & vbCrLf & _
	"Sharepoint:       " & Sharepoint & vbCrLf & _
	"ABS Logs:         " & ABSLogs & vbCrLf & _
	"Temp Folder:      " & TMPDir & vbCrLf & _
	"Temp Logs:        " & TMPLogs & vbCrLf & _
	"Backup Log:       " & BckpLog & vbCrLf & _
	"backup Log Zip:   " & BckpZip & vbCrLf & _
	"Sharepoint File:  " & BckpSharepoint

end sub


sub ABSHelp

	Wscript.echo _
	"==============================================" & vbCrLf & _
	"|A|B|S| - Automated Backup Script for Windows 2000/XP/2003" & vbCrLf & _
	"==============================================" & vbCrLf & vbCrLf & _
	"Copyright (c) Arik Fletcher, some components copyright (c)" & vbCrLf & _
	"their various owners and/or publishers." & vbCrLf & vbCrLf & _
	"==============================================" & vbCrLf & vbCrLf & _
	"Usage:" & vbCrLf & vbCrLf & _
	"ABS.EXE [Operation Type] [Operation]" & vbCrLf & vbCrLf & _
	"Valid Backup (/B) Operations:" & vbCrLf & vbCrLf & _
	"    - File Backup       - ABS.EXE /B /T" & vbCrLf & _
	"    - Tape Backup       - ABS.EXE /B /F" & vbCrLf & _
	"    - Test ABS          - ABS.EXE /B [/T or /F] /TEST" & vbCrLf & vbCrLf & _
	"Valid Admin (/A) Operations:" & vbCrLf & vbCrLf & _
	"    - ABS Admin Console - ABS.EXE /A /C" & vbCrLf & _
	"    - Remove ABS        - ABS.EXE /A /R" & vbCrLf & _
	"    - FTP Update ABS    - ABS.EXE /A /U" & vbCrLf & vbCrLf & _
	"=============================================="

end sub
