strComputer = "."
Set objArgs = WScript.Arguments
username = objArgs(0)
   
Set objWMI = GetObject("winmgmts:\\" & strComputer & "\root\directory\LDAP")
Set objUsers = objWMI.ExecQuery("SELECT * FROM ds_user where ds_samaccountname = 'username' ")

If objUsers.Count = 0 Then
   WScript.Echo "No matching objects found"
Else
   
For Each objUser in objUsers
  Wscript.Echo objUser.ds_givenName & " " & objUser.ds_Sn
  WScript.Echo ""
  Wscript.Echo objUser.ds_physicalDeliveryOfficeName
  Wscript.Echo "Email: " & objUser.ds_Mail
  Wscript.Echo "Tel:   " & objUser.ds_TelephoneNumber
Next

End If
