========================================================
|A|B|S| - Automated Backup Script for Windows 2k/XP/2k3
========================================================
Copyright (c) Arik Fletcher, some components copyright 
(c) their various owners and/or publishers.

Version:  2.0.7
Author:   Arik Fletcher
Contact:  arikf@micronicity.co.uk

DESCRIPTION:

ABS performs an automated NTBackup based on several
environmental variables set within the ABS script.
Throughout the session, a report is generated in
either plain text or HTML and emailed to a specified
email address once the backup session has completed.

ABS will also move the NTBackup log to a specified
location and compress it into a .zip file to reduce
the file size. Before compressing the log file, ABS 
analyses the backup log and reports whether or not
the backup was successful, the number of errors
encountered will also be reported. At each stage of
the backup the time will to taken to aid in the
overall logging process.

At present this script runs on all versions of NTBackup
from Windows 2000 upwards, one of the first actions
performed by ABS is to detect the operating system
version. This is important as there are a number of
differences between the versions of NTBackup in each
operating system. Once the operating system has been
detected the correct commands will be used for that
version of NTBackup.

The script is pretty much self explanatory, basically
just extract the .zip to location you wish to run ABS
from (e.g. E:\Backups), then run "INSTALL.BAT", this
will start the ABS Installation wizard to configure
the individual settings for your system.

Version History:
1.0.0 - gold release (with variables)
1.1.0 - basic error checking feature added
1.2.0 - email report feature added
1.3.0 - automated update feature added
1.4.0 - operating system detection
1.5.0 - backup log compression for report email
1.6.0 - skipped (open) objects detection
1.7.0 - improved installation and reporting
1.8.0 - minor installation bugfixes
1.9.0 - fixed scheduling agent for Windows 2000
2.0.0 - registry-based config settings added
2.0.1 - html email report & debug mode added
2.0.2 - OS reporting bug fix & time calculations
2.0.3 - windows 2000 installation bug fixes
2.0.4 - backup selection file generator fix
2.0.5 - updated installion process
2.0.6 - enhanced error checking system
2.0.7 - bug fixes and backup selection file update

Usage:
  ABS.CMD [Operation]

Valid Operations:
  Remove ABS  - ABS.CMD /UNINSTALL
  Update ABS  - ABS.CMD /UPDATE
  File Backup - ABS.CMD /BACKUP TAPE
  Tape Backup - ABS.CMD /BACKUP FILE

For development and troubleshooting purposes it is now
possible to run ABS in 'debugging' mode via the /DEBUG 
switch. To run ABS in debug mode, enter 'ABS.CMD /DEBUG' 
followed by the operation you wish to perform, e.g. 
'ABS.CMD /DEBUG /UPDATE' to run the ABS Update tool under
debug mode or 'ABS.CMD /DEBUG /BACKUP TAPE' to run a tape
backup operation under debug mode. Debug mode will run
your chosen ABS operation and save all command output to 
a log file in the ABS install location called 
'ABSDebug.log'. Open the log in NOTEPAD to troubleshoot
backup issues then examine the backup logs in the ABS
'LOGS' folder for further details.

==================================================================

Modifications to the script are not permitted unless express 
permission is granted by the author. Please forward requests for 
new features to the author at the email address specified above.

==================================================================