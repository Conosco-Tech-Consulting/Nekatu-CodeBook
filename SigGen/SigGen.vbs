'====================
'
' VBScript: <Signatures.vbs>
' AUTHOR: Peter Aarts
' Contact Info: peter.aarts@l1.nl
' Version 2.04
' Date: January 20, 2006
' Tested on Vista, XP, XP64 and office 2003 and 2007. 

' Modified By Brad Marsh
' Contact: gentex@tpg.com.au
' Date: 19 feb 08
' Now works with both 2003 and 2007 outlook 

' Modified by Arik Fletcher
' Contact: arik@coopsys.net
' Date: 21 October 2008
' 	Updated with specific AD fields for Skype and MSN
' Date: 16 March 2009
' 	Added international codes to Telephone and Fax fields

'====================  

'Option Explicit
On Error Resume Next  

Dim qQuery, objSysInfo, objuser
Dim FullName, EMail, Title, PhoneNumber, MobileNumber, FaxNumber, OfficeLocation, Department
Dim web_address, FolderLocation, HTMFileString, StreetAddress, Town, State, Company
Dim ZipCode, PostOfficeBox, UserDataPath, FaxMail, Ext  

' Read LDAP(Active Directory) information to asigns the user's info to variables.
'====================
Set objSysInfo = CreateObject("ADSystemInfo")
objSysInfo.RefreshSchemaCache
qQuery = "LDAP://" & objSysInfo.Username
Set objuser = GetObject(qQuery)  

FullName = objuser.displayname
EMail = objuser.mail
Title = objuser.title
PhoneNumber = objuser.TelephoneNumber
FaxNumber = objuser.facsimileTelephoneNumber
StreetAddress = objuser.streetaddress
ZipCode = objuser.postalcode
Town = objuser.l
MobileNumber = objuser.Mobile
Ext = objuser.IPPhone
FaxMail = objuser.pager
web_address = objUser.wWWHomePage
Company = objuser.Company

' This section creates the signature files names and locations.
'====================
' Corrects Outlook signature folder location. Just to make sure that
' Outlook is using the purposed folder defined with variable : FolderLocation
' Example is based on Dutch version.
' Changing this in a production enviremont might create extra work
' all employees are missing their old signatures
'====================
Dim objShell, RegKey, RegKey07, RegKeyParm
Set objShell = CreateObject("WScript.Shell")
RegKey = "HKEY_CURRENT_USER\Software\Microsoft\Office\11.0\Common\General"
RegKey07 = "HKEY_CURRENT_USER\Software\Microsoft\Office\12.0\Common\General"
RegKey07 = RegKey07 & "\Signatures"
RegKey = RegKey & "\Signatures"
objShell.RegWrite RegKey , "AD_LVAC"
objShell.RegWrite RegKey07 , "AD_LVAC"
UserDataPath = ObjShell.ExpandEnvironmentStrings("%appdata%")
FolderLocation = UserDataPath &"\Microsoft\AD_LVAC\"
HTMFileString = FolderLocation & "LVAC.htm"  

' This section disables the change of the signature by the user.
'====================
'objShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Office\11.0\Common\MailSettings\NewSignature" , "LVAC"
'objShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Office\11.0\Common\MailSettings\ReplySignature" , "LVAC"
'objShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Office\11.0\Outlook\Options\Mail\EnableLogging" , "0", "REG_DWORD"  

' This section checks if the signature directory exits and if not creates one.
'====================
Dim objFS1
Set objFS1 = CreateObject("Scripting.FileSystemObject")
If (objFS1.FolderExists(FolderLocation)) Then
Else
Call objFS1.CreateFolder(FolderLocation)
End if  

' The next section builds the signature file
'====================
Dim objFSO
Dim objFile,afile
Dim aQuote
aQuote = chr(34)  

' This section builds the HTML file version
'====================
Set objFSO = CreateObject("Scripting.FileSystemObject")  

' This section deletes to other signatures.
' These signatures are automatically created by Outlook 2003.
'====================
'Set AFile = objFSO.GetFile(Folderlocation&"LVAC.rtf")
'aFile.Delete
'Set AFile = objFSO.GetFile(Folderlocation&"LVAC.txt")
'aFile.Delete  

Set objFile = objFSO.CreateTextFile(HTMFileString,True)
objFile.Close
Set objFile = objFSO.OpenTextFile(HTMFileString, 2)  

objfile.write "<!DOCTYPE html PUBLIC " & aQuote & "-//W3C//DTD XHTML 1.0 Transitional//EN" & aQuote & " " & aQuote & "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" & aQuote & ">" & vbCrLf
objfile.write "<html xmlns=" & aQuote & "http://www.w3.org/1999/xhtml" & aQuote & ">" & vbCrLf
objfile.write "<head>" & vbCrLf
objfile.write "<meta content=" & aQuote & "text/html; charset=utf-8" & aQuote & " http-equiv=" & aQuote & "Content-Type" & aQuote & " />" & vbCrLf
objfile.write "<title>LVAC Signature</title>" & vbCrLf
objfile.write "<style type=" & aQuote & "text/css" & aQuote & ">" & vbCrLf
objfile.write ".style0 {border-right-style: solid;	border-right-width: 1px; border-right-color: black; width: 173px; text-align: center;}" & vbCrLf
objfile.write ".style1 {font-family: Arial;	font-size: 10px;}" & vbCrLf
objfile.write ".style2 {font-family: Arial;	font-size: 10px; font-weight: bold}" & vbCrLf
objfile.write ".style3 {font-family: Arial;	font-size: 12px;}" & vbCrLf
objfile.write ".style4 {font-family: Arial;	font-size: 12px; font-weight:bold;}" & vbCrLf
objfile.write "</style>" & vbCrLf
objfile.write "</head>" & vbCrLf
objfile.write "<body>" & vbCrLf
objfile.write "<table style=" & aQuote & "width: 100%" & aQuote & " cellpadding=" & aQuote & "5" & aQuote & " cellspacing=" & aQuote & "0" & aQuote & " class=" & aQuote & "style7" & aQuote & ">" & vbCrLf
objfile.write "<tr><td class=" & aQuote & "style0" & aQuote & ">" & vbCrLf
objfile.write "<img alt=" & aQuote & "" & aQuote & " height=" & aQuote & "100" & aQuote & " src=" & aQuote & "http://mail.lambethvac.org.uk/lvac.png" & aQuote & " width=" & aQuote & "173" & aQuote & " />" & vbCrLf
objfile.write "<span class=" & aQuote & "style2" & aQuote & "><br /><br />Registered Charity No. 1046917</span>" & vbCrLf
objfile.write "</td><td>" & vbCrLf
objfile.write "<span class=" & aQuote & "style4" & aQuote & ">" & FullName & "<br /></span>" & vbCrLf
objfile.write "<span class=" & aQuote & "style3" & aQuote & ">" & title & "<br /><br /></span>" & vbCrLf
objfile.write "<span class=" & aQuote & "style2" & aQuote & ">Lambeth Voluntary Action Council<br /></span>" & vbCrLf
objfile.write "<span class=" & aQuote & "style1" & aQuote & ">95 Acre Lane, Brixton, London, SW2 5TU<br /><br /></span>" & vbCrLf
objfile.write "<span class=" & aQuote & "style2" & aQuote & ">T:</span>&nbsp;&nbsp;<span class=" & aQuote & "style1" & aQuote & ">" & PhoneNumber & "<br />" & vbCrLf
objfile.write "<span class=" & aQuote & "style2" & aQuote & ">F:</span>&nbsp;&nbsp;<span class=" & aQuote & "style1" & aQuote & ">" & FaxNumber & "<br /></span>" & vbCrLf
objfile.write "<span class=" & aQuote & "style2" & aQuote & ">E:</span>&nbsp;&nbsp;<span class=" & aQuote & "style1" & aQuote & "><a href=" & aQuote & "mailto:" & email & aQuote & ">" & Email & "<br /></span>" & vbCrLf
objfile.write "<span class=" & aQuote & "style2" & aQuote & ">W:</span>&nbsp;&nbsp;<span class=" & aQuote & "style1" & aQuote & "><a href=" & aQuote & "http://www.lambethvac.org.uk" & aQuote & ">www.lambethvac.org.uk</a></span>" & vbCrLf
objfile.write "</p>" & vbCrLf
objfile.write "</td>" & vbCrLf
objfile.write "</tr>" & vbCrLf
objfile.write "</table><br />" & vbCrLf
objfile.write "<p class=" & aQuote & "style2" & aQuote & ">The content of this email, including any attachments, is confidential and is intended only for the person or entity to which it is addressed.  If you are not the intended recipient you should not disseminate, distribute or copy this email. Please notify the sender immediately if you have received this e-mail in error and delete the message from your system.  Unless otherwise specified, any views or opinions expressed herein are solely those of the author and do not necessarily represent those of LVAC.  E-mail transmission cannot be guaranteed to be secure or error-free as information could be intercepted, corrupted, lost, destroyed, arrive late or incomplete.  LVAC therefore does not accept liability for any errors or omissions in the contents of this message, which arise as a result of e-mail transmission.  Although LVAC operates anti-virus programs, it does not accept responsibility for any damage whatsoever caused by viruses being passed.</p>" & vbCrLf
objfile.write "<img alt=" & aQuote & "" & aQuote & " height=" & aQuote & "60" & aQuote & " src=" & aQuote & "http://mail.lambethvac.org.uk/tbyp.jpg" & aQuote & " width=" & aQuote & "300" & aQuote & " />" & vbCrLf
objfile.write "</body></html>" & vbCrLf
objFile.Close
' ===========================
' This section readsout the current Outlook profile and then sets the name of the default Signature
' ===========================
' Use this version to set all accounts
' in the default mail profile
' to use a previously created signature  

Call SetDefaultSignature("LVAC","")  

' Use this version (and comment the other) to
' modify a named profile.
'Call SetDefaultSignature _
' ("Signature Name", "Profile Name")  

Sub SetDefaultSignature(strSigName, strProfile)
Const HKEY_CURRENT_USER = &H80000001
strComputer = "."  

If Not IsOutlookRunning Then
Set objreg = GetObject("winmgmts:" & _
"{impersonationLevel=impersonate}!\\" & _
strComputer & "\root\default:StdRegProv")
strKeyPath = "Software\Microsoft\Windows NT\" & _
"CurrentVersion\Windows " & _
"Messaging Subsystem\Profiles\"
' get default profile name if none specified
If strProfile = "" Then
objreg.GetStringValue HKEY_CURRENT_USER, _
strKeyPath, "DefaultProfile", strProfile
End If
' build array from signature name
myArray = StringToByteArray(strSigName, True)
strKeyPath = strKeyPath & strProfile & _
"\9375CFF0413111d3B88A00104B2A6676"
objreg.EnumKey HKEY_CURRENT_USER, strKeyPath, _
arrProfileKeys
For Each subkey In arrProfileKeys
strsubkeypath = strKeyPath & "\" & subkey
objreg.SetBinaryValue HKEY_CURRENT_USER, _
strsubkeypath, "New Signature", myArray
objreg.SetBinaryValue HKEY_CURRENT_USER, _
strsubkeypath, "Reply-Forward Signature", myArray
Next
Else
'strMsg = "Please shut down Outlook before running this script."
'MsgBox strMsg, vbExclamation, "SetDefaultSignature"
End If
End Sub  

Function IsOutlookRunning()
strComputer = "."
strQuery = "Select * from Win32_Process " & _
"Where Name = 'Outlook.exe'"
Set objWMIService = GetObject("winmgmts:" _
& "{impersonationLevel=impersonate}!\\" _
& strComputer & "\root\cimv2")
Set colProcesses = objWMIService.ExecQuery(strQuery)
For Each objProcess In colProcesses
If UCase(objProcess.Name) = "OUTLOOK.EXE" Then
IsOutlookRunning = True
Else
IsOutlookRunning = False
End If
Next
End Function  

Public Function StringToByteArray _
(Data, NeedNullTerminator)
Dim strAll
strAll = StringToHex4(Data)
If NeedNullTerminator Then
strAll = strAll & "0000"
End If
intLen = Len(strAll) \ 2
ReDim arr(intLen - 1)
For i = 1 To Len(strAll) \ 2
arr(i - 1) = CByte _
("&H" & Mid(strAll, (2 * i) - 1, 2))
Next
StringToByteArray = arr
End Function  

Public Function StringToHex4(Data)
' Input: normal text
' Output: four-character string for each character,
' e.g. "3204" for lower-case Russian B,
' "6500" for ASCII e
' Output: correct characters
' needs to reverse order of bytes from 0432
Dim strAll
For i = 1 To Len(Data)
' get the four-character hex for each character
strChar = Mid(Data, i, 1)
strTemp = Right("00" & Hex(AscW(strChar)), 4)
strAll = strAll & Right(strTemp, 2) & Left(strTemp, 2)
Next
StringToHex4 = strAll  

End Function