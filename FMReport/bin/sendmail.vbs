repFile = WScript.Arguments(0)
repSubj = WScript.Arguments(1)
repRcpt = WScript.Arguments(2)
repMore = WScript.Arguments(3)

Const ForReading = 1, ForWriting = 2, ForAppending = 8
Dim fso, f
Set fso = CreateObject("Scripting.FileSystemObject")
Set f = fso.OpenTextFile(repFile , ForReading)
BodyText = f.ReadAll
f.Close
Set f = Nothing
Set fso = Nothing

Set objMessage = CreateObject("CDO.Message")
objMessage.Subject = repSubj
objMessage.From = "closeout@coopsys.net"
objMessage.To = repRcpt
objMessage.CC = repMore
objMessage.HTMLBody = BodyText
objMessage.Send
