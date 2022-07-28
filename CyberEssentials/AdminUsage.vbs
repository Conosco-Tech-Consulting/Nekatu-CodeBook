Option Explicit
Dim objShell,grouplistD,ADSPath,userPath,listGroup
On Error Resume Next

set objShell = WScript.CreateObject("WScript.Shell")
 
' *****************************************************
' MessageBox to pop up if user is an Administrator
' *****************************************************

If isMember("Administrators") Then
       MsgBox "Please note that it is against the Network Security Policy and Government Cyper Essentials guidelines to use an administrative account for standard user activities." & vbCrLf & vbCrLf & "This includes casual internet browsing, use of email applications or web services, and any general application usage beyond installation and configuration." & vbCrLf & vbCrLf & "Continued use of this session confirms your acceptance of this policy.",vbOKOnly,"Network Security Notice"
End If
 
' *****************************************************
' Function to check if the user is part of the group
' *****************************************************

Function IsMember(groupName)
    If IsEmpty(groupListD) then
        Set groupListD = CreateObject("Scripting.Dictionary")
        groupListD.CompareMode = 1
        ADSPath = EnvString("userdomain") & "/" & EnvString("username")
        Set userPath = GetObject("WinNT://" & ADSPath & ",user")
        For Each listGroup in userPath.Groups
            groupListD.Add listGroup.Name, "-"
        Next
    End if
    IsMember = CBool(groupListD.Exists(groupName))
End Function
' *****************************************************
 
' *****************************************************
' Function to determine user and domain name
' *****************************************************
Function EnvString(variable)
    variable = "%" & variable & "%"
    EnvString = objShell.ExpandEnvironmentStrings(variable)
End Function
' *****************************************************
 
Set objShell = Nothing