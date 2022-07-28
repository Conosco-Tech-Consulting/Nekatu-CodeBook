On Error Resume Next

if wscript.arguments(0) = "" Then
	file = inputbox("Please enter the path to the file you wish to upload:")
	url = inputbox("Please enter uRL and file name you wish to upload to:")
	user = inputbox("Please enter the username for the remote URL:")
	pass = inputbox("Please enter the password for the remote URL:")
Else
	file = wscript.arguments(0)
	url = wscript.arguments(1)
	user =wscript.arguments(2)
	pass = wscript.arguments(3)
End If

WebUploadFile file, url, user, pass

Function WebUploadFile (file, url, user, pass)
  Dim objXMLHTTP
  Dim objADOStream
  Dim arrbuffer
  Set objADOStream = CreateObject("ADODB.Stream")
  objADOStream.Open
  objADOStream.Type = 1
  objADOStream.LoadFromFile file
  arrbuffer = objADOStream.Read()
  Set objXMLHTTP = CreateObject("MSXML2.ServerXMLHTTP")
  objXMLHTTP.open "PUT", url, False, user, pass
  objXMLHTTP.send arrbuffer
End Function
