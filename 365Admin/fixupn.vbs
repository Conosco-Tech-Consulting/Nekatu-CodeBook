On Error Resume Next

Const ADS_SCOPE_SUBTREE = 2

Set objConnection = CreateObject("ADODB.Connection")
Set objCommand =   CreateObject("ADODB.Command")
objConnection.Provider = "ADsDSOObject"
objConnection.Open "Active Directory Provider"
Set objCommand.ActiveConnection = objConnection

objCommand.Properties("Page Size") = 1000
objCommand.Properties("Searchscope") = ADS_SCOPE_SUBTREE 

objCommand.CommandText = _
    "SELECT AdsPath,samAccountName,userPrincipalName FROM " & _
        "'LDAP://dc=watfordutc,dc=org' WHERE objectCategory='user'"  
Set objRecordSet = objCommand.Execute

objRecordSet.MoveFirst
Do Until objRecordSet.EOF
    strUser = objRecordSet.Fields("ADsPath").Value
    strNewUPN = objRecordSet.Fields("samAccountName").Value & "@" & "watfordutc.org"
    Set objUser =  GetObject(strUser)
    objUser.userPrincipalName = strNewUPN
    objUser.SetInfo
    objRecordSet.MoveNext
Loop