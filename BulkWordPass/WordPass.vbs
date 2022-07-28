PathToUse = InputBox("Path To Use?", "Path", "C:\My Documents\Path\To\Docs\")
sPassword = InputBox("Enter Password")

On Error Resume Next
Documents.Close SaveChanges:=wdPromptToSaveChanges
FirstLoop = True
myFile = Dir$(PathToUse & "*.doc")
While myFile <> ""
    Set myDoc = Documents.Open(PathToUse & myFile)
    If FirstLoop Then
        With ActiveDocument
        .Password = sPassword
        .WritePassword = sPassword
        End With
        FirstLoop = False

        Response = MsgBox("Do you want to process " & _
        "the rest of the files in this folder", vbYesNo)
        If Response = vbNo Then Exit Sub
    Else
        With ActiveDocument
        .Password = sPassword
        .WritePassword = sPassword
        End With
    End If
    myDoc.Close SaveChanges:=wdSaveChanges
    myFile = Dir$()
Wend
End Sub