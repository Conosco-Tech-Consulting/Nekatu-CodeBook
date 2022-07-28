rem ==========================================
rem SDS Listen Again Rename and Archive Script
rem Version 1.0 - Copyright (c) Arik Fletcher
rem ==========================================

set file=%1
set file
set file=%file:"=%
set file

for /f "tokens=1,2,3 delims=/" %%x in ('echo %date%') do set stamp=%%z-%%y-%%x

ren "\\LS-CHL4C6\share\Archive Master\%file%\%file%.mp3" "%stamp%_%file%.mp3"
move "\\LS-CHL4C6\share\Archive Master\%file%\%stamp%_%file%.mp3" "\\LS-CHL4C6\share\Upload"
