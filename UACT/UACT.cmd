@ECHO off
TITLE  User Account Creation Tool (BETA)

:START
CALL :CLEANUP
REM -------------------------------------------------------------------------------
REM Script:    UACT.cmd (and ./bin contents)
REM Created:   29/07/2008
REM Modified:  29/07/2008
REM Author:    Arik Fletcher
REM -------------------------------------------------------------------------------
REM Description: This script creates user accounts and mailboxes.
REM -------------------------------------------------------------------------------

IF NOT "%1"=="" (
CALL :BULKCHECK %1
GOTO :EXIT
)

:USER
CALL :BANNER
ECHO.
ECHO Please enter the following information:
ECHO.

SET /P FName=- First Name: 
SET /P LName=- Last Name:  
SET /P UPswd=- Password:   
SET UName=%FName:~0,1%%LName%


:GROUP
CALL :BANNER
ECHO.
ECHO Please confirm the group this user will be part of:
ECHO.
ECHO * Accounts	* ALNAP		* Director
ECHO * Fellowship	* FPEG		* FutureOfAid
ECHO * HPG		* HPN		* IEDG
ECHO * PPPG		* RAPID		* Reception
ECHO * RPEG		* IT		* ExternalPartners
ECHO.

SET /P ADOrg=- Group: 
SET ADGrp=%ADOrg%Group
IF /i "%ADOrg%"=="IT" set ADGrp=%ADOrg%
IF /i "%ADOrg%"=="ExternalPartners" set ADGrp=%ADOrg%

SET /P Intern=- Is this user an Intern? [Y/n] 

IF /i "%Intern%"=="y" (
SET Intern=Yes
)

IF /i "%Intern%"=="n" (
SET Intern=No
)


:EMAIL
CALL :BANNER
ECHO.
ECHO Please confirm the email settings:
ECHO.
SET /P ExMail=- Does this user require an Exchange Mailbox? [Y/n] 
ECHO.

IF /i "%ExMail%"=="n" (
SET ExMail=No
ECHO - If the user has an external email address, please enter it here:
SET /P ExAddr=  [e.g. %uname%@hotmail.com] 
)

IF /i "%ExMail%"=="y" (
SET ExMail=Yes
set ExStor=ODI3:First Storage Group:Central Staff Mailbox Store (ODI3)
IF "%ADOrg%"=="Accounts" set ExStor=ODI3:Second Storage Group:FinHR
IF "%ADOrg%"=="IEDG" set ExStor=ODI3:Second Storage Group:IEDG
IF "%ADOrg%"=="ALNAP" set ExStor=ODI3:Second Storage Group:ALNAP
IF "%ADOrg%"=="RAPID" set ExStor=ODI3:Second Storage Group:Partcom
IF "%ADOrg%"=="HPG" set ExStor=ODI3:First Storage Group:HPG
IF "%ADOrg%"=="PPPG" set ExStor=ODI3:First Storage Group:PPPG
IF "%ADOrg%"=="RPGG" set ExStor=ODI3:First Storage Group:RPGG
IF "%ADOrg%"=="" set ExStor=ODI3:First Storage Group:RPGG
)


:CONFIRM
CALL :BANNER 
ECHO.
ECHO Please confirm the user information:
ECHO.
ECHO - Full Name:	%fname% %lname%
ECHO - Department:	%adorg%
ECHO - Intern User:	%intern%
ECHO.
ECHO - User Name:	%uname%
ECHO - Password:	%upswd%
ECHO.
ECHO - Mailbox:	%ExMail%
IF DEFINED ExADDR ECHO - Email:	%ExAddr%
ECHO.

SET /P Confirm=Are the above settings correct? [Y/n]
IF /i "%Confirm%"=="Y" GOTO :CREATEUSER
IF /i "%Confirm%"=="n" GOTO :START
GOTO :CONFIRM

GOTO :EOF

:CREATE
REM dsadd user "CN=%Fname% %Lname%,OU=%ADOrg%,OU=odi,DC=org,DC=uk" -samid %Uname% -upn %Uname% -fn %Fname% -ln %Lname% -display "%Fname% %Lname%" -pwd odi753 -memberof "CN=%ADGrp%,OU=%ADOrg%,OU=odi,DC=org,DC=uk" -hmdir \\ODI5\Home\%Uname% -hmdrv P: %Specifics%
REM exchmbx -b "CN=%Fname% %Lname%,OU=%ADOrg%,OU=odi,DC=org,DC=uk" -cr "%ExStor%"
REM MD "G:\Users Shared Folders\%Fname%.%Lname%"
REM fileacl.exe "G:\Users Shared Folders\%Fname%.%Lname%" /S "%Fname%.%Lname%":F

GOTO :EOF

:EXIT
CALL :CLEANUP
GOTO :EOF

:BANNER
CLS
ECHO ===============================================================================
ECHO.
ECHO  User Account Creation Tool (BETA)
ECHO  Copyright (c) Co-Operative Systems
ECHO.
ECHO ===============================================================================
GOTO :EOF

:BULKCHECK

FOR /F "tokens=1-10 delims=," %%a in (%1) do (

CALL :BANNER
ECHO.
ECHO Bulk User Mode
ECHO.

SET FNAME=%%a
SET LNAME=%%b
SET UNAME=%%c
SET UPSWD=%%d
SET ADORG=%%e
SET ADGRP=%%f
SET INTERN=%%g
SET EXMAIL=%%h
SET EXADDR=%%i
SET EXSTOR=%%j

ECHO.
ECHO - Full Name:	%fname% %lname%
ECHO - Department:	%adorg%
ECHO - Intern User:	%intern%
ECHO.
ECHO - User Name:	%uname%
ECHO - Password:	%upswd%
ECHO.
ECHO - Mailbox:	%ExMail%
IF DEFINED ExADDR ECHO - Email:	%ExAddr%
ECHO.

CALL :CREATE

SET COUNT=%count%+1
ECHO %count% User^(s^) Created
)

GOTO :EOF

:CLEANUP
SET FNAME=
SET LNAME=
SET UNAME=
SET UPSWD=
SET ADORG=
SET ADGRP=
SET INTERN=
SET EXMAIL=
SET EXADDR=
SET EXSTOR=
SET COUNT=
SET CONFIRM=
GOTO :EOF