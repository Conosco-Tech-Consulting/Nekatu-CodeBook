@echo off
SET TZ=GHO+00:00
prompt $p$g
\net\netbind.com
MOUSE.COM
SMARTDRV.EXE
MSCDEX /d:BootCD /l:X
cd \dos\ghost
GHOST.EXE 
goto END
:END

