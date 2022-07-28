'Script:   redirect.vbs
'Created:  24/10/2005
'Modified: 20/04/2006
'Version:  2.0
'Author:   Arik Fletcher
'Contact:  arikf@joskos.com
'--------------------------------------------
'Description: This script provides registry-based
'             folder redirection  in addition to 
'             the options provided by Group Policy.
'             Folders such as Favorites, History, 
'             and Recent will be redirected to the 
'             location specified in the script for
'             the currently logged on user.
'
'Usage: wscript.exe <path>\redirect.vbs <group>
'--------------------------------------------
'
'Copyright (c) Joskos Limited

On Error Resume Next
Set WshShell = WScript.CreateObject("WScript.Shell")
Set objArgs = WScript.Arguments

IF objArgs(0) = "Staff" THEN
  wshshell.regwrite "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders\Favorites", "U:\InternetFavorites", "REG_EXPAND_SZ"
  wshshell.regwrite "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders\History", "U:\InternetHistory", "REG_EXPAND_SZ"
  wshshell.regwrite "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders\Recent", "U:\RecentDocuments", "REG_EXPAND_SZ"
END IF

IF objArgs(0) = "Pupils" THEN
  wshshell.regwrite "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders\Favorites", "S:\SharedInternetFavorites", "REG_EXPAND_SZ"
  wshshell.regwrite "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders\History", "U:\InternetHistory", "REG_EXPAND_SZ"
  wshshell.regwrite "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders\Recent", "U:\RecentDocuments", "REG_EXPAND_SZ"
END IF