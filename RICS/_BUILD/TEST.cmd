@echo off

:PROJECTS

for /f "tokens=1 delims=" %%a in (c:\test\replicon\_REFERENCE\Projects.csv) do (

type c:\test\replicon\_UPLOAD\PROJECTADD.csv | find /i /v "%%a" > c:\test\replicon\_UPLOAD\PROJECTADDX.csv

type c:\test\replicon\_UPLOAD\PROJECTADD.csv | find /i "%%a" >> c:\test\replicon\_UPLOAD\PROJECTUPD.csv

del c:\test\replicon\_UPLOAD\PROJECTADD.csv

ren c:\test\replicon\_UPLOAD\PROJECTADDX.csv PROJECTADD.csv

)

for /f "tokens=2 skip=1 delims=," %%a in (c:\test\replicon\_UPLOAD\PROJECTADD.csv) do (

echo %%a>>c:\test\replicon\_REFERENCE\Projects.csv

)

ren c:\test\replicon\_REFERENCE\Projects.csv Projects-NEW.csv 

call c:\test\replicon\_BUILD\dedupe.cmd c:\test\replicon\_REFERENCE\Projects-NEW.csv c:\test\replicon\_REFERENCE\Projects.csv

del c:\test\replicon\_REFERENCE\Projects-NEW.csv

:TASKS

for /f "tokens=1 delims=" %%a in (c:\test\replicon\_REFERENCE\Tasks.csv) do (

type c:\test\replicon\_UPLOAD\PROJECTTASKADD.csv | find /i /v ",%%a," > c:\test\replicon\_UPLOAD\PROJECTTASKADDX.csv

type c:\test\replicon\_UPLOAD\PROJECTTASKADD.csv | find /i "%%a" >> c:\test\replicon\_UPLOAD\PROJECTTASKUPD.csv

del c:\test\replicon\_UPLOAD\PROJECTTASKADD.csv

ren c:\test\replicon\_UPLOAD\PROJECTTASKADDX.csv PROJECTTASKADD.csv

)

for /f "tokens=3 skip=1 delims=," %%a in (c:\test\replicon\_UPLOAD\PROJECTTASKADD.csv) do (
echo %%a>>c:\test\replicon\_REFERENCE\Tasks.csv
)

ren c:\test\replicon\_REFERENCE\Tasks.csv Tasks-NEW.csv 

call c:\test\replicon\_BUILD\dedupe.cmd c:\test\replicon\_REFERENCE\Tasks-NEW.csv c:\test\replicon\_REFERENCE\Tasks.csv

del c:\test\replicon\_REFERENCE\Tasks-NEW.csv