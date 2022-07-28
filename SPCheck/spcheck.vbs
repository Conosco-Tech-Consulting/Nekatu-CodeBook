'*********************************************************
' Purpose: Tests to make sure a website is online.
' Created By: Michael White
' Notes: This script will scan a website and send an alert
' email out when there is either no ping or no content.
' It also keeps a log of each scan.
'
' I recommend setting up a scheduled task to run this
' script regularly.
'*********************************************************
Option Explicit
'Configure the script here
Dim strLogFile, strEmailHost, strFromEmail, strToEmail, strSubjectMsg, strWebsite
strLogFile = "log.txt"
strEmailHost = "smtp.ntlworld.com"
strFromEmail = "support@coopsys.net"
strToEmail = "arik@coopsys.net"
strSubjectMsg = "SharePoint Alert" 
strWebsite = "192.168.10.10:3389"

'Tests the website for both ping and content
Dim strAlert, strWebStatus
If PingSite ( strWebsite ) Then
	Dim strWebContent
	strWebContent = GetDataFromURL(strWebsite, "GET", "")
	If len(strWebContent) > 100 Then
		SendToLog( "Up" )
	Else
		SendToLog( "Down" )
		strAlert = "No Content"
		strWebStatus = "Down"
	End IF
Else
	SendToLog ( "Down" )
	strAlert = "No Ping"
	strWebStatus = "Down"
End If

If strWebStatus = "Down" Then
	SendEmail
End If


'Creates a record in the log
Function SendToLog ( strStatus )
Dim dtmTimeStamp, objFSO, objLogFile
dtmTimeStamp = now()
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objLogFile = objFSO.OpenTextFile(strLogFile, 8, TRUE)
objLogFile.Write "Time: " & dtmTimeStamp & " Status: " & strStatus & vbCrLf
End Function

'Gets web content
Function GetDataFromURL ( strURL, strMethod, strPostData )
Dim lngTimeout, strUserAgentString, intSslErrorIgnoreFlags, blnEnableRedirects
Dim blnEnableHttpsToHttpRedirects, strHostOverride, strLogin, strPassword
Dim strResponseText, objWinHttp
  lngTimeout = 59000
  strUserAgentString = "http_requester/0.1"
  intSslErrorIgnoreFlags = 13056 ' 13056: ignore all err, 0: accept no err
  blnEnableRedirects = True
  blnEnableHttpsToHttpRedirects = True
  strHostOverride = ""
  strLogin = ""
  strPassword = ""
  Set objWinHttp = CreateObject("WinHttp.WinHttpRequest.5.1")
  objWinHttp.SetTimeouts lngTimeout, lngTimeout, lngTimeout, lngTimeout
  objWinHttp.Open strMethod, strURL
  If strMethod = "POST" Then
    objWinHttp.setRequestHeader "Content-type", _
      "application/x-www-form-urlencoded"
  End If
  If strHostOverride <> "" Then
    objWinHttp.SetRequestHeader "Host", strHostOverride
  End If
  objWinHttp.Option(0) = strUserAgentString
  objWinHttp.Option(4) = intSslErrorIgnoreFlags
  objWinHttp.Option(6) = blnEnableRedirects
  objWinHttp.Option(12) = blnEnableHttpsToHttpRedirects
  If (strLogin <> "") And (strPassword <> "") Then
    objWinHttp.SetCredentials strLogin, strPassword, 0
  End If    
  On Error Resume Next
  objWinHttp.Send(strPostData)
  If Err.Number = 0 Then
    If objWinHttp.Status = "200" Then
      GetDataFromURL = objWinHttp.ResponseText
    Else
      GetDataFromURL = "HTTP " & objWinHttp.Status & " " & _
        objWinHttp.StatusText
    End If
  Else
    GetDataFromURL = "Error " & Err.Number & " " & Err.Source & " " & _
      Err.Description
  End If
  On Error GoTo 0
  Set objWinHttp = Nothing
 End Function
 
'Pings websites and returns a status
Function PingSite( myWebsite )
    Dim intStatus, objHTTP
    Set objHTTP = CreateObject( "WinHttp.WinHttpRequest.5.1" )
    objHTTP.Open "GET", "http://" & myWebsite & "/", False
    objHTTP.SetRequestHeader "User-Agent", "Mozilla/4.0 (compatible; MyApp 1.0; Windows NT 5.1)"
    On Error Resume Next
    objHTTP.Send
    intStatus = objHTTP.Status
    On Error Goto 0

    If intStatus = 200 Then
        PingSite = True
    Else
        PingSite = False
    End If

    Set objHTTP = Nothing
End Function

'Sends email alerts
Function SendEmail
	Dim strCDOSchema, strCDOConfig, strCDOMessage
    strCDOSchema = "http://schemas.microsoft.com/cdo/configuration/"  
    Set strCDOConfig = CreateObject("CDO.Configuration") 
 
    With strCDOConfig.Fields 
        .Item(strCDOSchema & "sendusing") = 2 ' cdoSendUsingPort 
        .Item(strCDOSchema & "smtpserver") = strEmailHost
        .update 
    End With 
	
    Set strCDOMessage = CreateObject("CDO.Message") 
 
    With strCDOMessage 
        Set .Configuration = strCDOConfig 
		.From = strFromEmail
        .To = strToEmail 
        .Subject = strSubjectMsg
		.TextBody = strWebsite & " is down!" & vbCrLf & "Alert Type: " & strAlert
        .Send 
    End With
End Function