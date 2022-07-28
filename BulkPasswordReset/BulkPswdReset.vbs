'Script:   BulkPswdReset.vbs
'Created:  01/12/2005
'Modified: 19/02/2008
'Version:  1.0
'Author:   Arik Fletcher
'Contact:  arikf@micronicity.co.uk
'--------------------------------------------
'Description: This script resets all account
'             passwords within a specified
'             OU and SubOU. When run, the
'             script will prompt the admin
'             for the Parent OU, Sub OU, and
'             password. Once these have been
'             entered the script will reset
'             the password for all users in
'             the specified Sub OU to the
'             value provided by the admin.
'
'Usage: wscript.exe <path>\BulkPswdReset.vbs
'--------------------------------------------
'
'Copyright (c) Arik Fletcher


Option Explicit
Dim objOU, objUser, objRootDSE
Dim strContainer, strDNSDomain, intCounter
Dim StrParentOUPrompt, strParentOUQuestion, strParentOU
Dim strSubOUPrompt, strSubOUQuestion, strSubOU
Dim strPswdPrompt, strPswdQuestion, strPswd

strParentOUPrompt = "Please specify the Parent OU"
strParentOUQuestion = "e.g. Staff"
strParentOU = InputBox(strParentOUQuestion, strParentOUPrompt)

strSubOUPrompt = "Please specify the Sub OU"
strSubOUQuestion = "e.g. Finance"
strSubOU = InputBox(strSubOUQuestion, strSubOUPrompt)

strPswdPrompt = "Please specify the password you wish to assign to the users"
strPswdQuestion = "Recommended: at least 7 characters, mixed case"
strPswd = InputBox(strPswdQuestion, strPswdPrompt)

intCounter = 0

Set objRootDSE = GetObject("LDAP://RootDSE") 
strDNSDomain = objRootDSE.Get("DefaultNamingContext")
strContainer = "OU=" & strSubOU & ",OU=" & strParentOU & "," & strDNSDomain
set objOU = GetObject("LDAP://" & strContainer )

For each objUser in objOU
If objUser.class="user" then
objUser.SetPassword strPswd
objUser.SetInfo
intCounter = intCounter +1
End if
next

WScript.Echo "Password set to " & strPswd _
& vbCr & intCounter & " accounts updated."
WScript.Quit
