'Extract data from Word 2007 content control fields
Sub Word07CSVFormExport()
Dim DocList As String
Dim DocDir As String
Dim oTarget As Document
Dim oDoc As Document
Dim sCCName As String
Dim i As Long
Dim fName As String
Dim fDialog As FileDialog

Set fDialog = Application.FileDialog(msoFileDialogFolderPicker)
With fDialog
     .Title = "Select Folder containing the completed form documents and click OK"
     .AllowMultiSelect = False
     .InitialView = msoFileDialogViewList
     If .Show <> -1 Then
          MsgBox "Cancelled By User"
          Exit Sub
     End If
     DocDir = fDialog.SelectedItems.Item(1)
     If Right(DocDir, 1) <> "\" Then DocDir = DocDir + "\"
End With

DocList = Dir$(DocDir & "*.doc?")

Do While DocList <> ""
    Documents.Open DocDir & DocList
   
Set oDoc = ActiveDocument

   'Turn off screen updating to reduce flicker whilst opening/closing files
    Application.ScreenUpdating = False
    On Error Resume Next
fName = DocDir & "CSVExport.csv"
Set oTarget = Documents.Open(fName, False)
If Err.Number = 5174 Then

     'The file does not exist, so create a new one
     Set oTarget = Documents.Add
     'and add the header row comprising the content control names
     For i = 1 To oDoc.ContentControls.Count
          sCCName = oDoc.ContentControls(i).Title

          'If the content control has no name, create one
          If sCCName = "" Then
               sCCName = i
          End If
          oTarget.Range.InsertAfter Chr(34) & _
          sCCName & Chr(34)
          If i < oDoc.ContentControls.Count Then
               oTarget.Range.InsertAfter Chr(44)
          End If
          If i = oDoc.ContentControls.Count Then
               oTarget.Range.InsertAfter vbCr
          End If
     Next i
     'and save it as a text file
     oTarget.SaveAs fName, wdFormatText
End If

    For i = 1 To oDoc.ContentControls.Count
        'Add the content control content to the text file
    
        oTarget.Range.InsertAfter Chr(34) & _
        oDoc.ContentControls(i).Range & Chr(34)
        If i < oDoc.ContentControls.Count Then
            oTarget.Range.InsertAfter Chr(44)
        End If
        If i = oDoc.ContentControls.Count Then
            oTarget.Range.InsertAfter vbCr
        End If
    Next i
    'Save the data file
    oTarget.Save
    oDoc.Close
    'Restore screen updating
DocList = Dir$()
Loop

Application.ScreenUpdating = True
End Sub
