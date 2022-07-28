WebUploadFile wscript.arguments(0), wscript.arguments(1), wscript.arguments(2), wscript.arguments(3)

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