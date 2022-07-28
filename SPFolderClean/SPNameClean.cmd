@echo off

setlocal ENABLEDELAYEDEXPANSION

if "%~1"=="" (

            echo # ERROR - supply the directory from which to begin the search for
            echo           filenames containing the ampersand symbol.  Any file
            echo           encountered with have the ampersand replaced by 'and'.
            goto :EOF

)

 

if not exist "%~1" (

            echo # ERROR - directory NOT found
            echo          = '%~1'
            goto :EOF

)

if "%~1" == "%systemdrive%" goto :EOF

goto %2

:P0

echo.
echo - Pass 0 - Removing "hidden" attribute from all files and folders
echo.

for /f "tokens=1 delims=" %%a in ('dir /b /s /a:h "%~1"') do (

attrib -s -h "%%a"

)


GOTO :EOF


:P1

echo.
echo - Pass 1 - Replacing '^&' with 'and'
echo.

for /f "tokens=*" %%F in ('dir "%~1" /s/b') do (

            set fileNAME=%%F
            set newFILEname=!fileNAME:^&=and!
            if not "!newFILEname!"=="!fileNAME!" (

                        for /f "tokens=*" %%N in ("!newFILENAME!") do (
                                    echo   + renaming "!fileNAME!" to "!newFILEname!"
                                    ren "!fileNAME!" "%%~nxN"
                                    if not errorlevel 1 (

                                                echo     - SUCCESS

                                    ) else (

                                                echo     # FAILED to rename "!fileNAME!"

                                    )

                        )

            )

)

 

GOTO :EOF

 

:P2

echo.
echo - Pass 2 - Replacing '_' with '-'
echo.

for /f "tokens=*" %%F in ('dir "%~1" /s/b') do (

            set fileNAME=%%F
            set newFILEname=!fileNAME:^_=-!
            if not "!newFILEname!"=="!fileNAME!" (

                        for /f "tokens=*" %%N in ("!newFILENAME!") do (
                                    echo   + renaming "!fileNAME!" to "!newFILEname!"
                                    ren "!fileNAME!" "%%~nxN"
                                    if not errorlevel 1 (

                                                echo     - SUCCESS

                                    ) else (

                                                echo     # FAILED to rename "!fileNAME!"

                                    )

                        )

            )

)

 
GOTO :EOF


:P3

 

echo.

echo - Pass 3 - Replacing '%20' with '-'

echo.

 

for /f "tokens=*" %%F in ('dir "%~1" /s/b') do (

            set fileNAME=%%F

            set newFILEname=!fileNAME:%%20=-!

            if not "!newFILEname!"=="!fileNAME!" (

                        for /f "tokens=*" %%N in ("!newFILENAME!") do (

                                    echo   + renaming "!fileNAME!" to "!newFILEname!"

                                    ren "!fileNAME!" "%%~nxN"

                                    if not errorlevel 1 (

                                                echo     - SUCCESS

                                    ) else (

                                                echo     # FAILED to rename "!fileNAME!"

                                    )

                        )

            )

)

 

GOTO :EOF

 

:P4

 

echo.

echo - Pass 4 - Replacing '..' with '.'

echo.

 

for /f "tokens=*" %%F in ('dir "%~1" /s/b') do (

            set fileNAME=%%F

            set newFILEname=!fileNAME:..=.!

            if not "!newFILEname!"=="!fileNAME!" (

                        for /f "tokens=*" %%N in ("!newFILENAME!") do (

                                    echo   + renaming "!fileNAME!" to "!newFILEname!"

                                    ren "!fileNAME!" "%%~nxN"

                                    if not errorlevel 1 (

                                                echo     - SUCCESS

                                    ) else (

                                                echo     # FAILED to rename "!fileNAME!"

                                    )

                        )

            )

)

 

GOTO :EOF

 

 

:P5

 

echo.

echo - Pass 5 - Replacing '. ' with '.'

echo.

 

for /f "tokens=*" %%F in ('dir "%~1" /s/b') do (

            set fileNAME=%%F

            set newFILEname=!fileNAME:. =.!

            if not "!newFILEname!"=="!fileNAME!" (

                        for /f "tokens=*" %%N in ("!newFILENAME!") do (

                                    echo   + renaming "!fileNAME!" to "!newFILEname!"

                                    ren "!fileNAME!" "%%~nxN"

                                    if not errorlevel 1 (

                                                echo     - SUCCESS

                                    ) else (

                                                echo     # FAILED to rename "!fileNAME!"

                                    )

                        )

            )

)

 

GOTO :EOF

 

:P6

 

echo.

echo - Pass 6 - Replacing '#' with '-'

echo.

 

for /f "tokens=*" %%F in ('dir "%~1" /s/b') do (

            set fileNAME=%%F

            set newFILEname=!fileNAME:#=-!

            if not "!newFILEname!"=="!fileNAME!" (

                        for /f "tokens=*" %%N in ("!newFILENAME!") do (

                                    echo   + renaming "!fileNAME!" to "!newFILEname!"

                                    ren "!fileNAME!" "%%~nxN"

                                    if not errorlevel 1 (

                                                echo     - SUCCESS

                                    ) else (

                                                echo     # FAILED to rename "!fileNAME!"

                                    )

                        )

            )

)

 

GOTO :EOF
 

:P7

 

echo.

echo - Pass 7 - Replacing '%' with '-'

echo.

 

for /f "tokens=*" %%F in ('dir "%~1" /s/b') do (

            set fileNAME=%%F

            set newFILEname=!fileNAME:%%=-!

            if not "!newFILEname!"=="!fileNAME!" (

                        for /f "tokens=*" %%N in ("!newFILENAME!") do (

                                    echo   + renaming "!fileNAME!" to "!newFILEname!"

                                    ren "!fileNAME!" "%%~nxN"

                                    if not errorlevel 1 (

                                                echo     - SUCCESS

                                    ) else (

                                                echo     # FAILED to rename "!fileNAME!"

                                    )

                        )

            )

)

GOTO :EOF


:P8

 

echo.

echo - Pass 8 - Replacing '[' with '('

echo.

 

for /f "tokens=*" %%F in ('dir "%~1" /s/b') do (

            set fileNAME=%%F

            set newFILEname=!fileNAME:[=^(!

            if not "!newFILEname!"=="!fileNAME!" (

                        for /f "tokens=*" %%N in ("!newFILENAME!") do (

                                    echo   + renaming "!fileNAME!" to "!newFILEname!"

                                    ren "!fileNAME!" "%%~nxN"

                                    if not errorlevel 1 (

                                                echo     - SUCCESS

                                    ) else (

                                                echo     # FAILED to rename "!fileNAME!"

                                    )

                        )

            )

)

GOTO :EOF


:P9

 

echo.

echo - Pass 9 - Replacing ']' with ')'

echo.

 

for /f "tokens=*" %%F in ('dir "%~1" /s/b') do (

            set fileNAME=%%F

            set newFILEname=!fileNAME:]=^)!

            if not "!newFILEname!"=="!fileNAME!" (

                        for /f "tokens=*" %%N in ("!newFILENAME!") do (

                                    echo   + renaming "!fileNAME!" to "!newFILEname!"

                                    ren "!fileNAME!" "%%~nxN"

                                    if not errorlevel 1 (

                                                echo     - SUCCESS

                                    ) else (

                                                echo     # FAILED to rename "!fileNAME!"

                                    )

                        )

            )

)

GOTO :EOF



:PX


echo.

echo - Pass X - Replacing '--' with '-'

echo.

 

for /f "tokens=*" %%F in ('dir "%~1" /s/b') do (

            set fileNAME=%%F

            set newFILEname=!fileNAME:--=-!

            if not "!newFILEname!"=="!fileNAME!" (

                        for /f "tokens=*" %%N in ("!newFILENAME!") do (

                                    echo   + renaming "!fileNAME!" to "!newFILEname!"

                                    ren "!fileNAME!" "%%~nxN"

                                    if not errorlevel 1 (

                                                echo     - SUCCESS

                                    ) else (

                                                echo     # FAILED to rename "!fileNAME!"

                                    )

                        )

            )

)

GOTO :EOF

echo - COMPLETE