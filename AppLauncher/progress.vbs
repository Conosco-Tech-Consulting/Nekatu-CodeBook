Dim bar, i
    Set bar = new IEProgBar
      With bar 
           .Move 450, 300, 400, -1
           .Units = 30
           .Show
             For i = 0 to 29
                WScript.Sleep 1024
                .Advance
             Next
       End With       
     Set bar = Nothing    

'--------  Start Progress bar Class  ----------------------------------
Class IEProgBar
  Private FSO, IE, BCol, TCol, ProgCol, ProgNum, ProgCaption, Pic, Q2, sTemp, iProg, ProgTitle

   Private Sub Class_Initialize()
      On Error Resume Next
         Set FSO = CreateObject("Scripting.FileSystemObject")
            sTemp = FSO.GetSpecialFolder(2)
       Set IE = CreateObject("InternetExplorer.Application") 
          With IE
              .AddressBar = False
              .menubar = False
              .ToolBar = False
              .StatusBar = False
              .width = 400
              .height = 120
              .resizable = False
          End With    
       BCol = "E0E0E4"   '--background color.
       TCol = "000000"   '--caption text color.
       ProgCol = "0000A0"    '--progress color.
       ProgNum = 20          'number of progress units.
       ProgCaption = "Loading your Desktop... Please Wait..."
       ProgTitle = Wscript.Arguments(0)
       Q2 = chr(34)
       iProg = 0       '--to track progress.
   End Sub
          
   Private Sub Class_Terminate()
        On Error Resume Next
      IE.Quit
      Set IE = Nothing   
      Set FSO = Nothing  
   End Sub
   
  Public Sub Show()
    Dim s, i, TS
        On Error Resume Next
     s = "<HTML><HEAD><TITLE>" & ProgTitle & "</TITLE></HEAD>"
     s = s & "<BODY SCROLL=" & Q2 & "NO" & Q2 & " BGCOLOR=" & Q2 & "#" & BCol & Q2 & " TEXT=" & Q2 & "#" & TCol & Q2 & ">"
       If (Pic <> "") Then 
           s = s & "<IMG SRC=" & Q2 & Pic & Q2 & " ALIGN=" & Q2 & "Left" & Q2 & ">"
       End If
          If (ProgCaption <> "") Then
             s = s & "<FONT FACE=" & Q2 & "arial" & Q2 & " SIZE=2>" & ProgCaption & "</FONT><BR><BR>"
          Else
             s = s & "<BR>"
          End If
     s = s & "<TABLE BORDER=1><TR><TD><TABLE BORDER=0 CELLPADDING=0 CELLSPACING=0><TR>"
          For i = 1 to ProgNum
              s = s & "<TD WIDTH=16 HEIGHT=16 ID=" & Q2 & "P" & Q2 & ">"
          Next
     s = s & "</TR></TABLE></TD></TR></TABLE><BR><BR></BODY></HTML>"         
       Set TS = FSO.CreateTextFile(sTemp & "\progress.htm", True)
         TS.Write s
         TS.Close
       Set TS = Nothing
           IE.Navigate "file:///" & sTemp & "\progress.htm"
           IE.visible = True
  End Sub
   
'-- Advance method colors one progress unit. iProg variable tracks how many
'--  units have been colored. Each progress unit is a <TD> with ID="P". They can be
'-- accessed in sequence through Document.All.Item.

  Public Sub Advance()
       On Error Resume Next
     If (iProg < ProgNum) and (IE.Visible = True) Then
         IE.Document.All.Item("P", (iProg)).bgcolor = Q2 & "#" & ProgCol & Q2
         iProg = iProg + 1
     End If   
  End Sub
  
   '--resize and/or position window. Use -1 For any value Not being Set.
  Public Sub Move(PixLeft, PixTop, PixWidth, PixHeight)
     On Error Resume Next
      If (PixLeft > -1) Then IE.Left = PixLeft
      If (PixTop > -1) Then IE.Top = PixTop
      If (PixWidth > 0) Then IE.Width = PixWidth
      If (PixHeight > 0) Then IE.Height = PixHeight
  End Sub
  
  '--remove Registry settings that  display advertising in the IE title bar.
  '-- This change won't show up the first time it's used because the IE
  '-- instance has already been created when the method is called.
  
  Public Sub CleanIETitle()
    Dim sR1, sR2, SH
        On Error Resume Next
      sR1 = "HKLM\Software\Microsoft\Internet Explorer\Main\Window Title"
      sR2 = "HKCU\Software\Microsoft\Internet Explorer\Main\Window Title"
      Set SH = CreateObject("WScript.Shell") 
        SH.RegWrite sR1, "", "REG_SZ"
        SH.RegWrite sR2, "", "REG_SZ"
      Set SH = Nothing  
  End Sub
  
  '------------- Set background color: ---------------------
  
 Public Property Let BackColor(sCol)
    If (TestColor(sCol) = True) Then BCol = sCol
 End Property
 
 '------------- Set caption color: ---------------------
  
 Public Property Let TextColor(sCol)
    If (TestColor(sCol) = True) Then TCol = sCol
 End Property
 
 '------------- Set progress color: ---------------------
  
 Public Property Let ProgressColor(sCol)
    If (TestColor(sCol) = True) Then ProgCol = sCol
 End Property
 
 '------------- Set icon: ---------------------
  
 Public Property Let Icon(sPath)
    If (FSO.FileExists(sPath) = True) Then Pic = sPath
 End Property
 
 '------------- Set title text: ---------------------
  
 Public Property Let Title(sCap)
    ProgTitle = sCap
 End Property
 
 '------------- Set caption text: ---------------------
  
 Public Property Let Caption(sCap)
    ProgCaption = sCap
 End Property
 
'------------- Set number of progress units: ---------------------
  
 Public Property Let Units(iNum)
    ProgNum = iNum
 End Property
 
'--confirm that color variables are valid 6-character hex color codes:
'-- If Not 6 characters Then TestColor = False
'-- If any character is Not 0-9 or A-F Then TestColor = False

Private Function TestColor(Col6)
  Dim iB, sB, iB2, Boo1
       On Error Resume Next
           TestColor = False
         If (Len(Col6) <> 6) Then Exit Function
      For iB = 1 to 6
         sB = Mid(Col6, iB, 1)
         iB2 = Asc(UCase(sB))
         If ((iB2 > 47) and (iB2 < 58)) or ((iB2 > 64) and (iB2 < 71)) Then
             Boo1 = True
         Else
             Boo1 = False
             Exit For
         End If
      Next
          If (Boo1 = True) Then TestColor = True    
End Function

End Class