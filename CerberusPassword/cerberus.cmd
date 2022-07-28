@REM off

:LAUNCH

TITLE Cerberus Password Script - Co-Operative Systems

REM ==============================================
REM Cerberus Password Script
REM (c) Co-operative Systems
REM ==============================================
REM Script:	  cerberus.cmd
REM Created:	  07/03/2008
REM Modified:	  07/03/2008
REM Version:	  1.0
REM Author:	  Arik Fletcher
REM Contact:	  arik@coopsys.net
REM --------------------------------------------
REM Description: This script resets the local
REM              administrator passwords to one
REM              of three values each time it is
REM              run. It is recommended that the
REM              script be run at system startup.
REM --------------------------------------------

:INIT

set p1=routine
set p2=random
set p3=destroy

:PASS1

if exist %systemroot%\system32\p1.tmp (
set pswd=%p1%
del %systemroot%\system32\p1.tmp
echo.> %systemroot%\system32\p2.tmp
goto :SETPASS
)

PASS2

if exist %systemroot%\system32\p2.tmp (
set pswd=%p2%
del %systemroot%\system32\p2.tmp
echo.> %systemroot%\system32\p3.tmp
goto :SETPASS
)

:PASS3

if exist %systemroot%\system32\p3.tmp (
set pswd=%p3%
del %systemroot%\system32\p3.tmp
echo.> %systemroot%\system32\p1.tmp
goto :SETPASS
)

:FAILOVER

set pswd=%p1%
del %systemroot%\system32\p1.tmp
echo.> %systemroot%\system32\p2.tmp
goto :SETPASS

:SETPASS

net user administrator %pswd%