'Script:   Crossword.vbs
'Created:  01/08/2009
'Modified: 01/06/2014
'Version:  4.0
'Author:   Arik Fletcher
'Contact:  arikf@micronicity.co.uk
'--------------------------------------------
'Usage: wscript.exe <path>\crossword.vbs
'--------------------------------------------
'
'Copyright (c) Arik Fletcher


on error resume next

MsgBox "This tool will generate a complex password based on two" & vbcrlf & _
	"user-specified values. The password will be secured by" & vbcrlf & _
	"combining the words and encoding then obfuscating them." & vbcrlf & vbcrlf & _ 
	"At the end of the process you will be reminded of your" & vbcrlf & _
	"chosen 'shared secrets'. Please make a note of these as" & vbcrlf & _
	"they will be required in order to retrieve the password.",64, _
	"Welcome to the Crossword Secure Password Tool v4.0"

phrase1 = InputBox("This should be a simple word no more than 6 characters long and should not contain special characters, numbers, capitals or spaces.", _
	"Please enter the first Shared Secret")

if phrase1 = "" then 
	wscript.echo "INVALID ENTRY - Please run script again"
	wscript.quit
end if

phrase2 = InputBox("This should be a simple word no more than 5 characters long and should not contain special characters, numbers, capitals or spaces.", _
	"Please enter the second Shared Secret")

if phrase2 = "" then 
	wscript.echo "INVALID ENTRY - Please run script again"
	wscript.quit
end if

cipher1 = trim(rot13(lcase(phrase1)))
cipher2 = trim(rot13(lcase(phrase2)))

For count = 1 to 50
  code1 = mid(cipher1,count,1)
  code2 = mid(cipher2,count,1)

  if code1 = "a" then
     code1 = "4"
  elseif code1 = "b" then
     code1 = "8"   
  elseif code1 = "e" then
     code1 = "3"   
  elseif code1 = "g" then
     code1 = "9"   
  elseif code2 = "i" then
     code1 = "1"   
  elseif code2 = "o" then
     code1 = "0"   
  elseif code2 = "s" then
     code1 = "5"   
  elseif code1 = "t" then
     code1 = "7"   
  elseif code1 = "z" then
     code1 = "2"   
  end If

  if code2 = "a" then
     code2 = "@"
  elseif code2 = "b" then
     code2 = "&"   
  elseif code2 = "e" then
     code2 = "%"   
  elseif code2 = "h" then
     code2 = "#"   
  elseif code2 = "i" then
     code2 = "!"   
  elseif code2 = "o" then
     code2 = "*"   
  elseif code2 = "s" then
     code2 = "$"   
  end If

  pswd = pswd & lcase(code1) & ucase(code2)
Next


Finish = InputBox("The shared secrets for this password are:" & VbCrLf & _
		VbCrLf & "'" & phrase1 & "' and '" & phrase2 & "'" & VbCrLf & _
		VbCrLf & "The secure password can be copied from here:","Secure Password Created",pswd)


Function rot13(rot13text)
   rot13text_rotated = ""
   For i = 1 to Len(rot13text)
      j = Mid(rot13text, i, 1)
      k = Asc(j) ' find out the character code
      if k >= 97 and k =< 109 then
         k = k + 13
      elseif k >= 110 and k =< 122 then
         k = k - 13
      elseif k >= 65 and k =< 77 then
         k = k + 13
      elseif k >= 78 and k =< 90 then
         k = k - 13
      end if

rot13text_rotated = rot13text_rotated & Chr(k)

   Next

rot13 = rot13text_rotated

End Function