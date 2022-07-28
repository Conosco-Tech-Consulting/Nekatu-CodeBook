'Script:   ADImport.vbs
'Created:  20/05/2004
'Modified: 16/01/2007
'Version:  3
'Author:   Arik Fletcher
'Contact:  arikf@joskos.com
'--------------------------------------------
'Description: This is a bulk importing ADSI
'             script that will import users
'             from an excel spreadsheet. The
'             script will also create home
'             folders and set user permissions
'             and ownership to each folder.
'
'Usage: wscript.exe <path>\ADImport.vbs
'--------------------------------------------
'Files: ADImport.vbs, SubInAcl.exe, userlist.xls
' ============================================
'
'Copyright (c) Joskos Limited


Option Explicit

Dim objExcel, objSheet, strExcelPath, strExcelPathPrompt, strExcelPathQuestion
Dim strLastName, strFirstName, strInitials, strPasswd, intRow, intCol
Dim strGroupDN, objUser, objGroup, objContainer, strUPN, strParentOU
Dim strCN, strNTName, strContainerDN, strDispName, StrFullName, strTitle
Dim strHomeFolder, strHomeDrive, objFSO, objShell, strParentOUQuestion
Dim intRunError, strNetBIOSDomain, strDNSDomain, strLogonServer, strParentOUPrompt
Dim objRootDSE, objProcEnv, objTrans, strSubOU, strSubOUPrompt, strSubOUQuestion

' Constants for the NameTranslate object.
Const ADS_NAME_INITTYPE_GC = 3
Const ADS_NAME_TYPE_NT4 = 3
Const ADS_NAME_TYPE_1779 = 1

Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objShell = CreateObject("Wscript.Shell")
Set objProcEnv = objShell.Environment("Process")

strLogonServer = objProcEnv("LogonServer")

' Determine DNS domain name from RootDSE object.
Set objRootDSE = GetObject("LDAP://RootDSE")
strDNSDomain = objRootDSE.Get("DefaultNamingContext")

' Use the NameTranslate object to find the NetBIOS domain name
' from the DNS domain name.
Set objTrans = CreateObject("NameTranslate")
objTrans.Init ADS_NAME_INITTYPE_GC, ""
objTrans.Set ADS_NAME_TYPE_1779, strDNSDomain
strNetBIOSDomain = objTrans.Get(ADS_NAME_TYPE_NT4)
' Remove trailing backslash.
strNetBIOSdomain = Left(strNetBIOSDomain, Len(strNetBIOSDomain) - 1)


' Specify spreadsheet
strExcelPathPrompt = "Please specify the location of the excel spreadsheet"
strExcelPathQuestion = "e.g. E:\NetworkAdmin\Tools\ADImport\users.xls"
strExcelPath = InputBox(strExcelPathQuestion, strExcelPathPrompt)

if isEmpty(strExcelPath) then WScript.Quit

' Specify User Type
strV4Prompt = "Is this is a post-Summer 2006 build?"
strV4Question = "Y/N"
strV4 = InputBox(strV4Question, strV4Prompt)

if isEmpty(strV4) then WScript.Quit

if strV4 = "N" then

' Specify User Type
strParentOUPrompt = "Please specify the type of users you wish to import"
strParentOUQuestion = "e.g. Pupils or Staff"
strParentOU = InputBox(strParentOUQuestion, strParentOUPrompt)

if isEmpty(strParentOU) then WScript.Quit

' Specify Intake Year
strSubOUPrompt = "Please specify the staff type/pupil intake year for the users you wish to import"
strSubOUQuestion = "e.g. for Staff use Teachers or Admin. For Pupils use 1999, 2000, 2001, 2002"
strSubOU = InputBox(strSubOUQuestion, strSubOUPrompt)

if isEmpty(strSubOU) then WScript.Quit

End If

if strV4 = "Y" then

stvParentOU = "Users"

strSubOUPrompt = "Please specify the type of users you wish to import"
strSubOUQuestion = "e.g. Pupils or Staff"
strSubOU = InputBox(strSubOUQuestion, strSubOUPrompt)

if isEmpty(strSubOU) then WScript.Quit

End If


' Open spreadsheet.
Set objExcel = CreateObject("Excel.Application")

On Error Resume Next
objExcel.Workbooks.Open strExcelPath
If Err.Number <> 0 Then
  On Error GoTo 0
  Wscript.Echo "Unable to open spreadsheet " & strExcelPath
  Wscript.Quit
End If
On Error GoTo 0
Set objSheet = objExcel.ActiveWorkbook.Worksheets(1)

' Start with row 2 of spreadsheet.
' Assume first row has column headings.
intRow = 2

' Read each row of spreadsheet until a blank value
' encountered in column 5 (the column for cn).
' For each row, create user and set attribute values.

Do While objSheet.Cells(intRow, 5).Value <> ""

  ' Read values from spreadsheet for this user.
  strFirstName = Trim(objSheet.Cells(intRow, 1).Value)
  strInitials = Trim(objSheet.Cells(intRow, 2).Value)
  strLastName = Trim(objSheet.Cells(intRow, 3).Value)
  strTitle =  Trim(objSheet.Cells(intRow, 4).Value)
  strFullName = Trim(objSheet.Cells(intRow, 5).Value)
  strNTName = Trim(objSheet.Cells(intRow, 6).Value)
  strPasswd = Trim(objSheet.Cells(intRow, 7).Value)

if strV4 = "N" then 

  ' set other values for users
  strContainerDN = "OU=" & strSubOU & ",OU=" & strParentOU & "," & strDNSDomain
  strUPN = strNTName & "@" & strNetBIOSDomain & ".local"
  strDispName = strFullName
  strCN = strDispName
  strHomeFolder = strLogonServer & "\" & strParentOU & "$\UserFolders\" & strSubOU & "\" & strNTName
  strHomeDrive = "U:"

End If

if strV4 = "Y" then 

  ' set other values for users
  strContainerDN = "OU=" & strSubOU & ",OU=" & strParentOU & ",OU=Network," & strDNSDomain
  strUPN = strNTName & "@" & strNetBIOSDomain & ".local"
  strDispName = strFullName
  strCN = strDispName
  strHomeFolder = strLogonServer & "\UD$\" & strSubOU & "$\HomeFolders\" & "\" & strNTName
  strHomeDrive = "U:"

End If


  ' Bind to container where users to be created.
  On Error Resume Next
  Set objContainer = GetObject("LDAP://" & strContainerDN)
  If Err.Number <> 0 Then
  On Error GoTo 0
  Wscript.Echo "Unable to bind to container: " & strContainerDN
  Wscript.Quit
  End If
  On Error GoTo 0

  ' Create user object.
  On Error Resume Next
  Set objUser = objContainer.Create("user", "cn=" & strCN)
  If Err.Number <> 0 Then
    On Error GoTo 0
    Wscript.Echo "Unable to create user with cn: " & strCN
  Else
    On Error GoTo 0

    ' Assign mandatory attributes and save user object.
    If strNTName = "" Then
      strNTName = strCN
    End If
    objUser.sAMAccountName = strNTName
    On Error Resume Next
    objUser.SetInfo
    If Err.Number <> 0 Then
      On Error GoTo 0
      Wscript.Echo "Unable to create user with NT name: " & strNTName
    Else

      ' Set password for user.
      objUser.SetPassword strPasswd
      If Err.Number <> 0 Then
        On Error GoTo 0
        Wscript.Echo "Unable to set password for user " & strNTName
      End If
      On Error GoTo 0

      ' Enable the user account.
      objUser.AccountDisabled = False
      If strFirstName <> "" Then
        objUser.givenName = strFirstName
      End If

      ' Assign values to remaining attributes.
      If strInitials <> "" Then
        objUser.initials = strInitials
      End If
      If strLastName <> "" Then
        objUser.sn = strLastName
      End If
      If strUPN <> "" Then
        objUser.userPrincipalName = strUPN
      End If
      If strDispName <> "" Then
	objUser.displayName = strDispName
      End If
      If strHomeDrive <> "" Then
        objUser.homeDrive = strHomeDrive
      End If
      If strHomeFolder <> "" Then
        objUser.homeDirectory = strHomeFolder
      End If

      ' If staff user, set 'user must change password' flag
      If strParentOU = "Staff" Then
      objUser.pwdLastSet = 0
      End If

      ' If pupil user, do not set 'user must change password' flag
      If strParentOU = "Pupils" Then
      objUser.pwdLastSet = -1
      End If

      ' Save changes.
      On Error Resume Next
      objUser.SetInfo
      If Err.Number <> 0 Then
        On Error GoTo 0
        Wscript.Echo "Unable to set attributes for user with NT name: " _
          & strNTName
      End If
      On Error GoTo 0

      ' Create home folder.
      If strHomeFolder <> "" Then
        If Not objFSO.FolderExists(strHomeFolder) Then
          On Error Resume Next
          objFSO.CreateFolder strHomeFolder
          If Err.Number <> 0 Then
            On Error GoTo 0
            Wscript.Echo "Unable to create home folder: " & strHomeFolder
          End If
          On Error GoTo 0
        End If
        If objFSO.FolderExists(strHomeFolder) Then

          ' Assign user permission to home folder.
          intRunError = objShell.Run("%COMSPEC% /c Echo Y| cacls """ _
            & strHomeFolder & """ /T /E /C /G """ & strNetBIOSDomain _
            & "\" & strNTName & """:F", 2, True)
          If intRunError <> 0 Then
            Wscript.Echo "Error assigning permissions for user " _
              & strNTName & " to home folder " & strHomeFolder
          End If
        End If
        If objFSO.FolderExists(strHomeFolder) Then

          ' Assign user ownership of home folder.
          intRunError = objShell.Run("%COMSPEC% /c subinacl /subdirectories """ & strHomeFolder & """ /setowner=""" & strNetBIOSDomain & "\" & strNTName & """", 2, True)
          If intRunError <> 0 Then
            Wscript.Echo "Error assigning ownership for user " _
              & strNTName & " to home folder " & strHomeFolder
          End If
        End If

      End If

      ' Group DN's start in column 8
      intCol = 8
      Do While objSheet.Cells(intRow, intCol).Value <> ""

if strV4 = "N" then 
        strGroupDN = "CN=" & Trim(objSheet.Cells(intRow, intCol).Value) & ",OU=" & strSubOU & ",OU=" & strParentOU & "," & strDNSDomain
End If

if strV4 = "Y" then 
        strGroupDN = "CN=" & Trim(objSheet.Cells(intRow, intCol).Value) & ",OU=" & strSubOU & ",OU=" & strParentOU & ",OU=Network," & strDNSDomain
End If

        On Error Resume Next
        Set objGroup = GetObject("LDAP://" & strGroupDN)
        If Err.Number <> 0 Then
          On Error GoTo 0
          Wscript.Echo "Unable to bind to group " & strGroupDN
        Else
          objGroup.Add objUser.AdsPath
          If Err.Number <> 0 Then
            On Error GoTo 0
          End If
        End If
        On Error GoTo 0
        intCol = intCol + 1
      Loop
    End If
  End If
  ' Increment to next user.
  intRow = intRow + 1
Loop

Wscript.Echo "Processing Complete"

' Clean up.
objExcel.ActiveWorkbook.Close
objExcel.Application.Quit
Set objUser = Nothing
Set objGroup = Nothing
Set objContainer = Nothing
Set objSheet = Nothing
Set objExcel = Nothing
Set objFSO = Nothing
Set objShell = Nothing
Set objTrans = Nothing
Set objRootDSE = Nothing