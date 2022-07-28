@echo off
REM Get information about user

Set /P FName=First Name?:
Set /P LName=Last Name?:

dsadd user "CN=%Fname% %Lname%,OU=London Users,OU=IEEP,DC=IEEP,DC=local" -samid %Fname%.%Lname% -upn %Fname%.%Lname% -fn %Fname% -ln %Lname% -display "%Fname% %Lname%" -pwd pa$$w0rd -memberof "CN=All IEEP,OU=Groups,OU=IEEP,DC=IEEP,DC=Local" -profile \\IEEP.Local\profiles$\%Fname%.%Lname% -loscr globalieepusers.bat -canchpwd no -pwdneverexpires yes
exchmbx -b "CN=%Fname% %Lname%,OU=USERS,OU=IEEP,DC=IEEP,DC=local" -cr "IEEP-DC:First Storage Group:Mailbox Store (IEEP-DC)"


MD "G:\Users Shared Folders\%Fname%.%Lname%"

fileacl.exe "G:\Users Shared Folders\%Fname%.%Lname%" /S "%Fname%.%Lname%":F

pause
