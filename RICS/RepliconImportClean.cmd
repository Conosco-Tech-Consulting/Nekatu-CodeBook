@echo off

REM ======================================
SET title=ODI Replicon Import Cleanup Script
REM Copyright (c) Arik Fletcher, Cooperative Systems
REM ======================================

REM Change History
REM 1.0 - Initial release
REM 1.1 - Template generation bug fix
REM 1.2 - Template format update
REM 1.3 - CSV indexing improvement
REM 1.4 - Duplicate detection and removal
REM 1.5 - New project/task validation

:INIT
REM ======================================
TITLE %title% - Initialising Script...
REM ======================================

cls

ECHO.
REM -----------------
ECHO * Initalising Working Directory...
REM -----------------

	if "%1"=="" goto :EOF

	set LIVE=%1
	set WORK=\\odi9\it\IT\RepliconCleanup

	IF NOT EXIST %WORK%\_TEMPLATES\. (MD %WORK%\_TEMPLATES) else (del /s /q %WORK%\_TEMPLATES\*.*)
	IF NOT EXIST %WORK%\_UPLOAD\. (MD %WORK%\_UPLOAD) else (del /s /q %WORK%\_UPLOAD\*.*)
	IF NOT EXIST %WORK%\_IMPORT\. (MD %WORK%\_IMPORT) else (del /s /q %WORK%\_IMPORT\*.*)
	IF NOT EXIST %WORK%\_EXPORT\. (MD %WORK%\_EXPORT) else (del /s /q %WORK%\_EXPORT\*.*)
	IF NOT EXIST %WORK%\_ARCHIVE\. MD %WORK%\_ARCHIVE

REM -----------------
ECHO * Importing CSV files...
REM -----------------

	copy %LIVE%\*.csv %WORK%\_IMPORT

:TEMPLATESs
REM ======================================
TITLE %title% - Creating Templates...
REM ======================================

cls

ECHO.
REM -----------------
ECHO * Generating ALLTEAMDEL template...
REM -----------------

	echo #PROJECTTEAMDEL,ProjectName,ProjectTeamType>%WORK%\_TEMPLATES\ALLTEAMDEL.csv

ECHO.
REM -----------------
ECHO * Generating PROJECTADD template...
REM -----------------

	echo #PROJECTADD,ProjectCode,ProjectName,ProjectDescription,ProjectLeaderLoginName,TimeEntryAllowed,ExpenseEntryStartDate,ExpenseEntryEndDate,projectinfo2,projectinfo1>%WORK%\_TEMPLATES\PROJECTADD.csv

ECHO.
REM -----------------
ECHO * Generating PROJECTEXPENSECODEDEL template...
REM -----------------

	echo #PROJECTEXPENSECODEDEL,ProjectName,ExpenseCode>%WORK%\_TEMPLATES\PROJECTEXPENSECODEDEL.csv

ECHO.
REM -----------------
ECHO * Generating PROJECTTASKADD template...
REM -----------------

	echo #PROJECTTASKADD,ProjectName,TaskNameLevel1,TaskCode,EstimatedHours,TimeEntryAllowed,EntryStartDate,EntryEndDate,TaskInfo2,TaskInfo1>%WORK%\_TEMPLATES\PROJECTTASKADD.csv

ECHO.
REM -----------------
ECHO * Generating PROJECTTASKUPD template...
REM -----------------

	echo #PROJECTTASKUPD,ProjectName,TaskNameLevel1,TaskCode,EstimatedHours,TimeEntryAllowed,EntryStartDate,EntryEndDate,TaskInfo2,TaskInfo1>%WORK%\_TEMPLATES\PROJECTTASKUPD.csv

ECHO.
REM -----------------
ECHO * Generating PROJECTTEAMADD template...
REM -----------------

	echo #PROJECTTEAMADD,ProjectName,ProjectTeamType,LoginName>%WORK%\_TEMPLATES\PROJECTTEAMADD.csv

ECHO.
REM -----------------
ECHO * Generating PROJECTUPD template...
REM -----------------

	echo #PROJECTUPD,ProjectCode,ProjectName,ProjectDescription,ProjectLeaderLoginName,TimeEntryAllowed,ExpenseEntryStartDate,ExpenseEntryEndDate,projectinfo2,projectinfo1>%WORK%\_TEMPLATES\PROJECTUPD.csv

ECHO.
REM -----------------
ECHO * Generating TASKASSIGNMENTADD template...
REM -----------------

	echo #TASKASSIGNMENTADD,ProjectName,TaskNameLevel1,AssignmentType,LoginName>%WORK%\_TEMPLATES\TASKASSIGNMENTADD.csv

ECHO.
REM -----------------
ECHO * Generating TASKASSIGNMENTUPD template...
REM -----------------

	echo #TASKASSIGNMENTUPD,ProjectName,TaskNameLevel1,AssignmentType,LoginName>%WORK%\_TEMPLATES\TASKASSIGNMENTUPD.csv

ECHO.
REM -----------------
ECHO * Generating USERADD template...
REM -----------------

	echo #USERADD,FirstName,LastName,EmployeeID,Email,LoginName,Password,IsUserDisabled,DeptNameLevel1,DeptNameLevel2,SupervisorLoginName,EmployeeTypeName,StartDate,EndDate,TimesheetApprovalPath,ExpenseApprovalPath,UserInfo1,UserInfo2,UserInfo3,HoursPerDay,AddUserPermission,AddUserPermission,AddUserPermission,AddSeatAssignment,AddSeatAssignment>%WORK%\_TEMPLATES\USERADD.csv

ECHO.
REM -----------------
ECHO * Generating USERUPD template...
REM -----------------

	echo #USERUPD,FirstName,LastName,EmployeeID,Email,LoginName,Password,IsUserDisabled,DeptNameLevel1,DeptNameLevel2,SupervisorLoginName,EmployeeTypeName,StartDate,EndDate,TimesheetApprovalPath,ExpenseApprovalPath,UserInfo1,UserInfo2,UserInfo3,HoursPerDay,AddUserPermission,AddUserPermission,AddUserPermission,AddSeatAssignment,AddSeatAssignment>%WORK%\_TEMPLATES\USERUPD.csv

ECHO.
REM -----------------
ECHO * Copying templates to UPLOAD folder...
REM -----------------

copy %WORK%\_TEMPLATES\*.csv %WORK%\_EXPORT /y


:MERGE
REM ======================================
TITLE %title% - Merging and Cleaning...
REM ======================================

cls

ECHO.
REM -----------------
ECHO * Sorting CSV files into named folders...
REM -----------------

	for /f "tokens=1 delims=-" %%a in ('dir /b %WORK%\_IMPORT\*.csv') do (

		cls

		ECHO.
		REM -----------------
		ECHO - Sorting %%a CSV files...
		REM -----------------

		if not exist %WORK%\%%a\. md %WORK%\_IMPORT\%%a
		move /y %WORK%\_IMPORT\%%a*.csv %WORK%\_IMPORT\%%a

	)

	for /f "tokens=1 delims=." %%a in ('dir /b %WORK%\_TEMPLATES\*.csv') do (

		cls

		ECHO.
		REM -----------------
		ECHO - Merging %%a CSV files into Upload files...
		REM -----------------
		ECHO.

		for /f %%b in ('dir /b %WORK%\_IMPORT\%%a\*.csv') do (

			REM -----------------
			ECHO + Merging %%b...
			REM -----------------
		
			type %WORK%\_IMPORT\%%a\%%b | find /v "#" >> "%WORK%\_EXPORT\%%a.csv"

		)

	)


CLS
ECHO.
REM -----------------
ECHO * Checking for duplicate entries...
REM -----------------
ECHO.

	for /f "tokens=1 delims=." %%a in ('dir /b %WORK%\_EXPORT\*.csv') do (
		call :DEDUPE %WORK%\_EXPORT\%%a.csv %WORK%\_UPLOAD\%%a.csv
	)


:END
REM ======================================
TITLE %title% - Validating new Projects and Tasks...
REM ======================================

CLS

:CHECKPROJECTS
REM -----------------
ECHO * Validating new Projects against reference file...
REM -----------------
ECHO.

	for /f "tokens=1 delims=" %%a in (%WORK%\_REFERENCE\Projects.csv) do (

		REM -----------------
		ECHO + Checking Project reference %%a...
		REM -----------------

		type %WORK%\_UPLOAD\PROJECTADD.csv | find /i /v "%%a," > %WORK%\_UPLOAD\PROJECTADDX.csv
		type %WORK%\_UPLOAD\PROJECTADD.csv | find /i "%%a," >> %WORK%\_UPLOAD\PROJECTUPD.csv
		del %WORK%\_UPLOAD\PROJECTADD.csv
		ren %WORK%\_UPLOAD\PROJECTADDX.csv PROJECTADD.csv
	)

REM -----------------
ECHO * Updating Projects reference File...
REM -----------------
ECHO.

	for /f "tokens=2 skip=1 delims=," %%a in (%WORK%\_UPLOAD\PROJECTADD.csv) do (
		echo %%a>>%WORK%\_REFERENCE\Projects.csv
	)

:CHECKTASKS
REM -----------------
ECHO * Validating new Tasks against reference file...
REM -----------------
ECHO.

	for /f "tokens=1 delims=" %%a in (%WORK%\_REFERENCE\Tasks.csv) do (

		REM -----------------
		ECHO + Checking Task reference %%a...
		REM -----------------

		type %WORK%\_UPLOAD\PROJECTTASKADD.csv | find /i /v ",%%a," > %WORK%\_UPLOAD\PROJECTTASKADDX.csv
		type %WORK%\_UPLOAD\PROJECTTASKADD.csv | find /i ",%%a," >> %WORK%\_UPLOAD\PROJECTTASKUPD.csv
		del %WORK%\_UPLOAD\PROJECTTASKADD.csv
		ren %WORK%\_UPLOAD\PROJECTTASKADDX.csv PROJECTTASKADD.csv
	)
	
REM -----------------
ECHO * Updating Tasks reference File...
REM -----------------
ECHO.

	for /f "tokens=3 skip=1 delims=," %%a in (%WORK%\_UPLOAD\PROJECTTASKADD.csv) do (
		echo %%a>>%WORK%\_REFERENCE\Tasks.csv
	)



ECHO.
REM -----------------
ECHO * Cleaning reference files...
REM -----------------

	ren %WORK%\_REFERENCE\Projects.csv Projects-NEW.csv 
	ren %WORK%\_REFERENCE\Tasks.csv Tasks-NEW.csv 

	call :DEDUPE %WORK%\_REFERENCE\Projects-NEW.csv %WORK%\_REFERENCE\Projects.csv
	call :DEDUPE %WORK%\_REFERENCE\Tasks-NEW.csv %WORK%\_REFERENCE\Tasks.csv

	del %WORK%\_REFERENCE\Projects-NEW.csv
	del %WORK%\_REFERENCE\Tasks-NEW.csv


:END
REM ======================================
TITLE %title% - Completing Run...
REM ======================================
CLS

ECHO.
REM -----------------
ECHO * Archiving Import files...
REM -----------------

	xcopy %WORK%\_IMPORT\*.* %WORK%\_ARCHIVE /v /e /y /h /i /c /d

ECHO.
REM -----------------
ECHO * Navigating to Upload folder...
REM -----------------

	start %WORK%\_UPLOAD

GOTO :EOF




REM ======================================
:DEDUPE

@echo off > %2

ECHO - Cleaning %1

	for /f "tokens=* delims= " %%a in (%1) do (
		find "%%a" < %2 > nul
		if errorlevel 1 echo %%a >> %2
	)

GOTO :EOF