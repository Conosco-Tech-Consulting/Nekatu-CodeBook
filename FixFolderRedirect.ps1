# ================================================
# Off Domain Redirected Folder Fix
# Version: 1.0
# Author: Arik Fletcher, Conosco
# ================================================

#Init
get-psdrive
set-location -path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders\'

# Set Paths
$RegPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders'
$FolderPath = \\SSFLON03\Redirection

# Reset AppData Path
$appInput = "25,00,55,00,53,00,45,00,52,00,50,00,52,00,4f,00,46,00,49,00,4c,00,45,00,25,00,5c,00,41,00,70,00,70,00,44,00,61,00,74,00,61,00,5c,00,52,00,6f,00,61,00,6d,00,69,00,6e,00,67,00,00,00"
$appHex = $appInput.Split(',') | % { "0x$_"}
New-ItemProperty -Path $RegPath -Name 'AppData' -PropertyType Binary -Value ([byte[]]$appHex)

# Reset Cache Path
$cacheInput = "25,00,55,00,53,00,45,00,52,00,50,00,52,00,4f,00,46,00,49,00,4c,00,45,00,25,00,5c,00,41,00,70,00,70,00,44,00,61,00,74,00,61,00,5c,00,52,00,6f,00,61,00,6d,00,69,00,6e,00,67,00,00,00"
$cacheHex = $cacheInput.Split(',') | % { "0x$_"}
New-ItemProperty -Path $RegPath -Name 'Cache' -PropertyType Binary -Value ([byte[]]$cacheHex)

# Reset Desktop Path
$deskopInput = "25,00,55,00,53,00,45,00,52,00,50,00,52,00,4f,00,46,00,49,00,4c,00,45,00,25,00,5c,00,44,00,65,00,73,00,6b,00,74,00,6f,00,70,00,00,00"
$desktopHex = $desktopInput.Split(',') | % { "0x$_"}
New-ItemProperty -Path $RegPath -Name 'Desktop' -PropertyType Binary -Value ([byte[]]$desktopHex)

# Reset Favorites Path
$favoriteInput = "25,00,55,00,53,00,45,00,52,00,50,00,52,00,4f,00,46,00,49,00,4c,00,45,00,25,00,5c,00,46,00,61,00,76,00,6f,00,72,00,69,00,74,00,65,00,73,00,00,00"
$favoriteHex = $favoriteInput.Split(',') | % { "0x$_"}
New-ItemProperty -Path $RegPath -Name 'Favorites' -PropertyType Binary -Value ([byte[]]$favoriteHex)

# Reset History Path
$historyInput = "25,00,55,00,53,00,45,00,52,00,50,00,52,00,4f,00,46,00,49,00,4c,00,45,00,25,00,5c,00,41,00,70,00,70,00,44,00,61,00,74,00,61,00,5c,00,4c,00,6f,00,63,00,61,00,6c,00,5c,00,4d,00,69,00,63,00,72,00,6f,00,73,00,6f,00,66,00,74,00,5c,00,57,00,69,00,6e,00,64,00,6f,00,77,00,73,00,5c,00,48,00,69,00,73,00,74,00,6f,00,72,00,79,00,00,00"
$historyHex = $historyInput.Split(',') | % { "0x$_"}
New-ItemProperty -Path $RegPath -Name 'History' -PropertyType Binary -Value ([byte[]]$historyHex)

# Reset Local AppData Path
$localAppInput = "25,00,55,00,53,00,45,00,52,00,50,00,52,00,4f,00,46,00,49,00,4c,00,45,00,25,00,5c,00,41,00,70,00,70,00,44,00,61,00,74,00,61,00,5c,00,4c,00,6f,00,63,00,61,00,6c,00,00,00"
$localAppHex = localAppInput.Split(',') | % { "0x$_"}
New-ItemProperty -Path $RegPath -Name 'Local AppData' -PropertyType Binary -Value ([byte[]]$localAppHex)

# Reset My Music Path
$musicInput = "25,00,55,00,53,00,45,00,52,00,50,00,52,00,4f,00,46,00,49,00,4c,00,45,00,25,00,5c,00,4d,00,75,00,73,00,69,00,63,00,00,00"
$musicHex = musicInput.Split(',') | % { "0x$_"}
New-ItemProperty -Path $RegPath -Name 'My Music' -PropertyType Binary -Value ([byte[]]$musicHex)

# Reset My Pictures Path
$picturesInput = "25,00,55,00,53,00,45,00,52,00,50,00,52,00,4f,00,46,00,49,00,4c,00,45,00,25,00,5c,00,50,00,69,00,63,00,74,00,75,00,72,00,65,00,73,00,00,00"
$picturesHex = picturesInput.Split(',') | % { "0x$_"}
New-ItemProperty -Path $RegPath -Name 'My Pictures' -PropertyType Binary -Value ([byte[]]$picturesHex)

# Reset My Video Path
$videoInput = "25,00,55,00,53,00,45,00,52,00,50,00,52,00,4f,00,46,00,49,00,4c,00,45,00,25,00,5c,00,56,00,69,00,64,00,65,00,6f,00,73,00,00,00"
$videoHex = videoInput.Split(',') | % { "0x$_"}
New-ItemProperty -Path $RegPath -Name 'My Video' -PropertyType Binary -Value ([byte[]]$videoHex)

# Reset NetHood Path
$hoodInput = "25,00,55,00,53,00,45,00,52,00,50,00,52,00,4f,00,46,00,49,00,4c,00,45,00,25,00,5c,00,41,00,70,00,70,00,44,00,61,00,74,00,61,00,5c,00,52,00,6f,00,61,00,6d,00,69,00,6e,00,67,00,5c,00,4d,00,69,00,63,00,72,00,6f,00,73,00,6f,00,66,00,74,00,5c,00,57,00,69,00,6e,00,64,00,6f,00,77,00,73,00,5c,00,4e,00,65,00,74,00,77,00,6f,00,72,00,6b,00,20,00,53,00,68,00,6f,00,72,00,74,00,63,00,75,00,74,00,73,00,00,00"
$hoodHex = hoodInput.Split(',') | % { "0x$_"}
New-ItemProperty -Path $RegPath -Name 'NetHood' -PropertyType Binary -Value ([byte[]]$hoodHex)

# Reset Personal Path
$personalInput = "25,00,55,00,53,00,45,00,52,00,50,00,52,00,4f,00,46,00,49,00,4c,00,45,00,25,00,5c,00,44,00,6f,00,63,00,75,00,6d,00,65,00,6e,00,74,00,73,00,00,00"
$personalHex = personalInput.Split(',') | % { "0x$_"}
New-ItemProperty -Path $RegPath -Name 'Personal' -PropertyType Binary -Value ([byte[]]$personalHex)

# Reset Programs Path
$programsInput = "25,00,55,00,53,00,45,00,52,00,50,00,52,00,4f,00,46,00,49,00,4c,00,45,00,25,00,5c,00,41,00,70,00,70,00,44,00,61,00,74,00,61,00,5c,00,52,00,6f,00,61,00,6d,00,69,00,6e,00,67,00,5c,00,4d,00,69,00,63,00,72,00,6f,00,73,00,6f,00,66,00,74,00,5c,00,57,00,69,00,6e,00,64,00,6f,00,77,00,73,00,5c,00,53,00,74,00,61,00,72,00,74,00,20,00,4d,00,65,00,6e,00,75,00,5c,00,50,00,72,00,6f,00,67,00,72,00,61,00,6d,00,73,00,00,00"
$programsHex = programsInput.Split(',') | % { "0x$_"}
New-ItemProperty -Path $RegPath -Name 'Programs' -PropertyType Binary -Value ([byte[]]$programsHex)

# Reset Recent Path
$recentInput = "25,00,55,00,53,00,45,00,52,00,50,00,52,00,4f,00,46,00,49,00,4c,00,45,00,25,00,5c,00,41,00,70,00,70,00,44,00,61,00,74,00,61,00,5c,00,52,00,6f,00,61,00,6d,00,69,00,6e,00,67,00,5c,00,4d,00,69,00,63,00,72,00,6f,00,73,00,6f,00,66,00,74,00,5c,00,57,00,69,00,6e,00,64,00,6f,00,77,00,73,00,5c,00,52,00,65,00,63,00,65,00,6e,00,74,00,00,00"
$recentHex = recentInput.Split(',') | % { "0x$_"}
New-ItemProperty -Path $RegPath -Name 'Recent' -PropertyType Binary -Value ([byte[]]$recentHex)

# Reset SendTo Path
$sendToInput = "25,00,55,00,53,00,45,00,52,00,50,00,52,00,4f,00,46,00,49,00,4c,00,45,00,25,00,5c,00,41,00,70,00,70,00,44,00,61,00,74,00,61,00,5c,00,52,00,6f,00,61,00,6d,00,69,00,6e,00,67,00,5c,00,4d,00,69,00,63,00,72,00,6f,00,73,00,6f,00,66,00,74,00,5c,00,57,00,69,00,6e,00,64,00,6f,00,77,00,73,00,5c,00,53,00,65,00,6e,00,64,00,54,00,6f,00,00,00"
$sendToHex = sendToInput.Split(',') | % { "0x$_"}
New-ItemProperty -Path $RegPath -Name 'SendTo' -PropertyType Binary -Value ([byte[]]$sendToHex)

# Reset Startup Path
$startupInput = "225,00,55,00,53,00,45,00,52,00,50,00,52,00,4f,00,46,00,49,00,4c,00,45,00,25,00,5c,00,41,00,70,00,70,00,44,00,61,00,74,00,61,00,5c,00,52,00,6f,00,61,00,6d,00,69,00,6e,00,67,00,5c,00,4d,00,69,00,63,00,72,00,6f,00,73,00,6f,00,66,00,74,00,5c,00,57,00,69,00,6e,00,64,00,6f,00,77,00,73,00,5c,00,53,00,74,00,61,00,72,00,74,00,20,00,4d,00,65,00,6e,00,75,00,5c,00,50,00,72,00,6f,00,67,00,72,00,61,00,6d,00,73,00,5c,00,53,00,74,00,61,00,72,00,74,00,75,00,70,00,00,00"
$startupHex = startupInput.Split(',') | % { "0x$_"}
New-ItemProperty -Path $RegPath -Name 'Startup' -PropertyType Binary -Value ([byte[]]$startupHex)

# Reset Start Menu Path
$startMenuInput = "25,00,55,00,53,00,45,00,52,00,50,00,52,00,4f,00,46,00,49,00,4c,00,45,00,25,00,5c,00,41,00,70,00,70,00,44,00,61,00,74,00,61,00,5c,00,52,00,6f,00,61,00,6d,00,69,00,6e,00,67,00,5c,00,4d,00,69,00,63,00,72,00,6f,00,73,00,6f,00,66,00,74,00,5c,00,57,00,69,00,6e,00,64,00,6f,00,77,00,73,00,5c,00,53,00,74,00,61,00,72,00,74,00,20,00,4d,00,65,00,6e,00,75,00,00,00"
$startMenuHex = startMenuInput.Split(',') | % { "0x$_"}
New-ItemProperty -Path $RegPath -Name 'Start Menu' -PropertyType Binary -Value ([byte[]]$startMenuHex)

# Reset Templates Path
$templatesInput = "25,00,55,00,53,00,45,00,52,00,50,00,52,00,4f,00,46,00,49,00,4c,00,45,00,25,00,5c,00,41,00,70,00,70,00,44,00,61,00,74,00,61,00,5c,00,52,00,6f,00,61,00,6d,00,69,00,6e,00,67,00,5c,00,4d,00,69,00,63,00,72,00,6f,00,73,00,6f,00,66,00,74,00,5c,00,57,00,69,00,6e,00,64,00,6f,00,77,00,73,00,5c,00,54,00,65,00,6d,00,70,00,6c,00,61,00,74,00,65,00,73,00,00,00"
$templatesHex = templatesInput.Split(',') | % { "0x$_"}
New-ItemProperty -Path $RegPath -Name 'Templates' -PropertyType Binary -Value ([byte[]]$templatesHex)

# Reset {374DE290-123F-4565-9164-39C4925E467B} Path
$guidInput = "25,00,55,00,53,00,45,00,52,00,50,00,52,00,4f,00,46,00,49,00,4c,00,45,00,25,00,5c,00,44,00,6f,00,77,00,6e,00,6c,00,6f,00,61,00,64,00,73,00,00,00"
$guidHex = guidInput.Split(',') | % { "0x$_"}
New-ItemProperty -Path $RegPath -Name '{374DE290-123F-4565-9164-39C4925E467B}' -PropertyType Binary -Value ([byte[]]$guidHex)

# Reset PrintHood Path
$printHoodInput = "25,00,55,00,53,00,45,00,52,00,50,00,52,00,4f,00,46,00,49,00,4c,00,45,00,25,00,5c,00,41,00,70,00,70,00,44,00,61,00,74,00,61,00,5c,00,52,00,6f,00,61,00,6d,00,69,00,6e,00,67,00,5c,00,4d,00,69,00,63,00,72,00,6f,00,73,00,6f,00,66,00,74,00,5c,00,57,00,69,00,6e,00,64,00,6f,00,77,00,73,00,5c,00,54,00,65,00,6d,00,70,00,6c,00,61,00,74,00,65,00,73,00,00,00"
$printHoodHex = printHoodInput.Split(',') | % { "0x$_"}
New-ItemProperty -Path $RegPath -Name 'PrintHood' -PropertyType Binary -Value ([byte[]]$printHoodHex)

# Relocate Files
#Copy-Item -Path $folderPath\$env:username -Destination 'c:\users\ + $env:username' –Recurse -Force