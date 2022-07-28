code = lcase(trim(wscript.arguments(0)))

'Wscript.Echo rot13(code)
Wscript.Echo encrypt(code)

Function encrypt(phrase)
   encrypted = ""
   For i = 1 to Len(phrase)
      j = Mid(code, i, 1)
	if j = 97 then
	  j = "@"
	elseif j = 98 then
	  j = "8"
	elseif j = 101 then
	  j = "3"
	elseif j = 103 then
	  j = "9"
	elseif j = 104 then
	  j = "4"
	elseif j = 105 then
	  j = "1"
	elseif j = 111 then
	  j = "0"
	elseif j = 115 then
	  j = "5"
	elseif j = 117 then
	  j = "7"
	elseif j = 122 then
	  j = "2"
	End If
   Next

encrypted = encrypted & chr(j)

encrypt = encrypted

End Function


Function rot13(rot13text)
   rot13text_rotated = ""
   For i = 1 to Len(rot13text)
      j = Mid(rot13text, i, 1)
      k = Asc(j)
      if k >= 97 and k =< 109 then
         k = lcase(k + 13) ' a ... m inclusive become n ... z
      elseif k >= 110 and k =< 122 then
         k = ucase(k - 13) ' n ... z inclusive become a ... m
      elseif k >= 65 and k =< 77 then
         k = lcase(k + 13) ' A ... m inclusive become n ... z
      elseif k >= 78 and k =< 90 then
         k = ucase(k - 13) ' N ... Z inclusive become A ... M
      end if


   rot13text_rotated = rot13text_rotated & Chr(k)

   Next

rot13 = rot13text_rotated

End Function