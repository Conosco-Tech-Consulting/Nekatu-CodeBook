rem ==========================================
rem SDS Listen Again Upload Script Builder
rem Version 1.6 - Copyright (c) Arik Fletcher
rem ==========================================

for /f "tokens=1 delims=" %%a in (c:\sync\ListenAgain\_Shows_List.txt) do (

echo # Automatically answer all prompts negatively not to stall the script on errors > "c:\sync\ListenAgain\%%a Script.txt"
echo option batch on >> "c:\sync\ListenAgain\%%a Script.txt"
echo # Disable overwrite confirmations that conflict with the previous >> "c:\sync\ListenAgain\%%a Script.txt"
echo option confirm off >> "c:\sync\ListenAgain\%%a Script.txt"
echo # Connect using a password >> "c:\sync\ListenAgain\%%a Script.txt"
echo open ftp://u58080449-SAM:dumbass@s322000114.websitehome.co.uk >> "c:\sync\ListenAgain\%%a Script.txt"
echo # Force binary mode transfer >> "c:\sync\ListenAgain\%%a Script.txt"
echo option transfer binary >> "c:\sync\ListenAgain\%%a Script.txt"
echo mv "/listen/OLD - %%a.mp3" "/listen/OLDER - %%a.mp3" >> "c:\sync\ListenAgain\%%a Script.txt"
echo mv "/listen/%%a.mp3" "/listen/OLD - %%a.mp3" >> "c:\sync\ListenAgain\%%a Script.txt"
echo put "\\LS-CHL4C6\share\Archive Master\%%a\%%a.mp3" "/listen/%%a.mp3" >> "c:\sync\ListenAgain\%%a Script.txt"
echo # Disconnect >> "c:\sync\ListenAgain\%%a Script.txt"
echo close >> "c:\sync\ListenAgain\%%a Script.txt"
echo # Exit WinSCP >> "c:\sync\ListenAgain\%%a Script.txt"
echo Exit >> "c:\sync\ListenAgain\%%a Script.txt"

echo @ECHO off > "c:\sync\ListenAgain\%%a Sync.cmd"
echo cd c:\sync >> "c:\sync\ListenAgain\%%a Sync.cmd"
echo winscp.exe /console /script="c:\sync\ListenAgain\%%a Script.txt" /log="c:\sync\ListenAgain\%%a.log" >> "c:\sync\ListenAgain\%%a Sync.cmd"
echo c:\sync\ListenAgain\_File_Archiver.cmd "%%a" >> "c:\sync\ListenAgain\%%a Sync.cmd"
)