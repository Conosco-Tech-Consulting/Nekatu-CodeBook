strComputer = "."
    
Set oWMI = GetObject( _
  "winmgmts:{impersonationLevel=impersonate}!\\" & strComputer & "\root\SecurityCenter")
  
Set colItems = oWMI.ExecQuery("Select * from AntiVirusProduct")

For Each objItem in colItems
  With objItem
    WScript.Echo .companyName
    WScript.Echo .displayName
    WScript.Echo .instanceGuid
    WScript.Echo .onAccessScanningEnabled
    WScript.Echo .pathToSignedProductExe
    WScript.Echo .productHasNotifiedUser
    WScript.Echo .productState
    WScript.Echo .productUptoDate
    WScript.Echo .productWantsWscNotifications
    WScript.Echo .versionNumber  
  End With
Next
