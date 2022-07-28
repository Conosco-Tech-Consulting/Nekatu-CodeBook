@echo off

:LAUNCH

TITLE Hydra Password Script - Co-Operative Systems

REM ==============================================
REM Hydra Password Script
REM (c) Arik Fletcher
REM ==============================================
REM Script:	  hydra.cmd
REM Created:	  11/03/2008
REM Modified:	  11/03/2008
REM Version:	  1.0
REM Author:	  Arik Fletcher
REM Contact:	  arik@micronicity.co.uk
REM --------------------------------------------
REM Description: This script resets the local
REM              administrator passwords to one
REM              of ten values at random each time
REM              the computer starts up.
REM --------------------------------------------



:INIT

REM ==============================================
REM This section generates two random numbers to
REM determine which password to set. If the numbers
REM match then it will generate a different set.
REM ==============================================

SET min=0
SET max=9
SET range=10
SET minrand=0
SET maxrand=32767 
SET rangerand=32767

SET /A check=((%random% - %minrand%) * %range% )/ (%rangerand% + %min%)
SET /A token=((%random% - %minrand%) * %range% )/ (%rangerand% + %min%)

IF "%token%"=="%check%" goto :INIT



:SECRETPATH

REM ==============================================
REM This section sets the location that the 'shared
REM secret' file will be stored in. This should be
REM somewhere that all users have easy access to.
REM If the path does not exist it will be created.
REM ==============================================

set ssnpath=%allusersprofile%\Start Menu\Programs\Admin Access
if not exist "%ssnpath%\." md "%ssnpath%"


:SECRETLIST

REM ==============================================
REM This section selects the shared secret and the
REM password based on the randon number generated
REM at the start of the script. If a number has not
REM been generated then the script will exit.
REM ==============================================

if "%token%"=="0" (
set ssn=Alpha
set psw=Defenestrate
goto :SECRETCHECK
)

if "%token%"=="1" (
set ssn=Beta
set psw=Garbology
goto :SECRETCHECK
)

if "%token%"=="2" (
set ssn=Gamma
set psw=Digerati
goto :SECRETCHECK
)

if "%token%"=="3" (
set ssn=Delta
set psw=Antipodes
goto :SECRETCHECK
)

if "%token%"=="4" (
set ssn=Epsilon
set psw=Hallux
goto :SECRETCHECK
)

if "%token%"=="5" (
set ssn=Zeta
set psw=Otiose
goto :SECRETCHECK
)

if "%token%"=="6" (
set ssn=Eta
set psw=Cullet
goto :SECRETCHECK
)

if "%token%"=="7" (
set ssn=Theta
set psw=Pellucid
goto :SECRETCHECK
)

if "%token%"=="8" (
set ssn=Iota
set psw=Borborygmus
goto :SECRETCHECK
)

if "%token%"=="9" (
set ssn=Kappa
set psw=Expropriate
goto :SECRETCHECK
)

GOTO :EOF


:SECRETCHECK

REM ==============================================
REM This section compares the existing secret file
REM to the new secret. If these match then the
REM script will loop until a new secret is created.
REM ==============================================

if exist "%ssnpath%\%ssn%.nfo" goto :INIT


:SESSION

REM ==============================================
REM This section clears the existing secret file
REM and then creates a new secret file in the
REM previously specified location.
REM ==============================================

attrib -r -s "%ssnpath%\*.nfo"
del "%ssnpath%\*.nfo"

echo.> "%ssnpath%\%ssn%.nfo"
attrib +r +s "%ssnpath%\%ssn%.nfo"


:TASK

REM ==============================================
REM This section checks for an existing Hydra task
REM in Scheduled Tasks. If this does not exist a
REM new task is created to run at system startup.
REM ==============================================

if not exist %systemroot%\tasks\lockdown.job (
schtasks /create /sc ONSTART /ru Administrator /rp "%psw%" /tn "Lockdown" /tr "%systemroot%\system32\hydra.cmd"
)

goto :SETPASS


:SETPASS

REM ==============================================
REM This section sets the password based and then
REM updates the hydra task with the new password.
REM ==============================================

net user administrator %psw%
schtasks /change /ru "Administrator" /rp "%psw%" /tn "Lockdown"

GOTO :EOF
