============================
Joskos Application Launcher
============================


PROJECT BRIEF
--------------

A single unified script capable of mounting a virtual CD image, setting compatibility flags, changing resolutions, and running an application.

This will replace the current method of creating a new script for each application as there will be a single script that will read unique application settings from a config file. The config files will contain five lines:

APPNAME=Name of the application (e.g. Science Explorer 2)
ISOPATH=Full path/UNC to the ISO image (e.g. c:\SCI.ISO)
EXEPATH=Full path/UNC to the executable (e.g. c:\explore.exe)
RESFIX=Resolution settings for CHRes (e.g. 800 600 32 60)
COMPAT=Windows compatibility flags (e.g. Win98, 256Color)

Once run, the unified application launcher script (AppLauncher.cmd) will display an HTML progress bar on the screen explaining the program is loading and that the user should wait until loading is complete.


REQUIREMENTS
-------------

The Joskos Application Launcher Script requires that CHRes be in the %systemroot%\system32 folder. Progress.vbs is also required in either the system32 folder or in the same folder as the AppLauncher script. Progress.vbs is the tool that is used to generate the HTML progress bar during application loads.

When running AppLauncher, simply enter the full path to AppLauncher and the config file that you wish to load. Example:

"\\SERVER\SOFTWARE$\AppLaunch\AppLauncher.cmd" "C:\Config\SCI.ini"

This is what should be entered into any application shortcuts for the end user. If you do not specify a config file AppLauncher will prompt for a config file when you attempt to run it.


CONFIG FILES
-------------

Sample config files are supplied in the CONFIGS folder to get you started. Once AppLauncher has gone gold there will be a CONFIGS section on the support site where we will store all completed config files for use on new and existing sites when new builds are required. This will also help in creating a software compatibility database.