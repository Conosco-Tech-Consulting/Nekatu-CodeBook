@echo off
cls

:LAUNCH

TITLE System Health Report - Co-Operative Systems

ECHO ==============================================
ECHO.
ECHO System Health Report
ECHO (c) Co-operative Systems
ECHO.
ECHO ==============================================
ECHO Script:	  SHR_Main,cmd (and ./bin contents)
ECHO Created:	  19/02/2008
ECHO Modified:	  20/02/2008
ECHO Version:	  1.0
ECHO Author:	  Arik Fletcher
ECHO Contact:	  arikf@coopsys.net
ECHO --------------------------------------------
ECHO Description: This script (and the sub-scripts)
ECHO              collect information on the local
ECHO              system and generate an HTML file
ECHO              containing the current state of
ECHO              the machine. This report is then
ECHO              emailed to a specified address
ECHO              via a specified email server.
ECHO. 
ECHO Usage: SHR_main.cmd [email address] [email server]
ECHO --------------------------------------------
echo.

:INIT

ECHO.
ECHO ---------------------------------------------
ECHO Initialise SHR System
ECHO ---------------------------------------------

SET SHR_Stage=INIT
CALL ./bin/SHR_Init.cmd
CLS


:SYSINFO

ECHO.
ECHO ---------------------------------------------
ECHO Collect System Information
ECHO ---------------------------------------------

SET SHR_Stage=SYSINFO
CALL ./bin/SHR_SysInfo.cmd
CLS


:SESSION

ECHO.
ECHO ---------------------------------------------
ECHO Collect SHR Session Information
ECHO ---------------------------------------------

SET SHR_Stage=SESSION
CALL ./bin/SHR_Session.cmd
CLS


:LOCADMIN

ECHO.
ECHO ---------------------------------------------
ECHO Enumerate Local Administrators and Power Users
ECHO ---------------------------------------------

SET SHR_Stage=LOCADMIN

CALL ./bin/SHR_LocAdmin.cmd
CLS


:TMPCLN

ECHO.
ECHO ---------------------------------------------
ECHO Clear Temporary Files
ECHO ---------------------------------------------

SET SHR_Stage=TMPCLN
CALL ./bin/SHR_TmpCln.cmd
CLS

:FRAGNAL

ECHO.
ECHO ---------------------------------------------
ECHO Analyse Local Disk Fragmentation
ECHO ---------------------------------------------

SET SHR_Stage=FRAGNAL
CALL ./bin/SHR_Fragnal.cmd
CLS


:DSKSPC

ECHO.
ECHO ---------------------------------------------
ECHO Analyse Local Disk Space
ECHO ---------------------------------------------

SET SHR_Stage=DSKSPC
CALL ./bin/SHR_DskSpc.cmd
CLS


:EVNTARC

ECHO.
ECHO ---------------------------------------------
ECHO Archive and Clear Event Logs
ECHO ---------------------------------------------

SET SHR_Stage=ENVTARC
CALL ./bin/SHR_EvntArc.cmd
CLS


:MAILSEND

ECHO.
ECHO ---------------------------------------------
ECHO Email report and event logs
ECHO ---------------------------------------------

SET SHR_Stage=MAILSEND
CALL ./bin/SHR_MailSend.cmd
CLS


:CLEANUP
ECHO.
ECHO ---------------------------------------------
ECHO Post-Report Clean Up
ECHO ---------------------------------------------

SET SHR_Stage=CLEANUP
REM CALL ./bin/SHR_Cleanup.cmd
CLS