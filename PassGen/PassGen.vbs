'==========================================================================
'
' NAME: RandomPasswordGenerator.vbs
'
' AUTHOR: Mark D. MacLachlan , The Spider's Parlor
' URL: http://www.thespidersparlor.com
' DATE  : 7/29/2004
' MODIFICATIONS:
'         9/2/2008 Added dictionary object to ensure
'                  uniqueness of passwords
'
' COMMENT: Generates Random Passwords meeting "Complex" Requirements
'          By default will generate a 6 digit password.
'          Edit line passLen = 6 to change length
'==========================================================================
Option Explicit

Dim pGenNum, newpass, passList, inFlag, pgLength, x, fso, ts, passLen
Const ForWriting = 2
passLen = 8

'Give inFlag (input Flag) an initial value to ensure we run once
inFlag = "Seed"

Do While inFlag <> pGenNum
    pGenNum = "1"
        
    'Now clear inFlag so we can compare it to the pGenInput going forward
    inFlag = ""
    pgLength = Len(pGenNum)
    'Enumerate each character to ensure we only have numbers
    For x = 1 To pgLength
        If Asc(Mid(pGenNum,x,1)) < 48 Or Asc(Mid(pGenNum,x,1)) > 57 Then
            inFlag = ""
        Else
            'Build inFlag one character at a time if it is a number.
            inFlag = inFlag & Mid(pGenNum,x,1)
        End If
    Next
    'We made it through each character.  If not equal prompt for a number.
    If inFlag <> pGenNum Then inFlag = ""
Loop

'Generate the number of required passwords.
'Use a dictionary object to ensure uniqueness.
Dim objDict
Set objDict = CreateObject("Scripting.Dictionary")
Do Until objDict.Count = CInt(pGenNum)
    newpass = generatePassword(passLen)
    If Not objDict.Exists(newpass) Then
           objDict.Add newpass, "Unique Password"
        passList = passList & newpass & vbCrLf
    End If
Loop

'Now save it all to a text file.
Set fso = CreateObject("Scripting.FileSystemObject")
Set ts = fso.CreateTextFile ("PasswordList.txt", ForWriting)
ts.write passList
MsgBox "Passwords saved to PasswordList.txt",,"Passwords Generated"
set ts = nothing
set fso = nothing



Function generatePassword(PASSWORD_LENGTH)

Dim NUMLOWER, NUMUPPER, LOWERBOUND, UPPERBOUND, LOWERBOUND1, UPPERBOUND1, SYMLOWER, SYMUPPER
Dim newPassword, count, pwd
Dim pCheckComplex, pCheckComplexUp, pCheckComplexLow, pCheckComplexNum, pCheckComplexSym, pCheckAnswer


 NUMLOWER    = 48  ' 48 = 0
 NUMUPPER    = 57  ' 57 = 9
 LOWERBOUND  = 65  ' 65 = A
 UPPERBOUND  = 90  ' 90 = Z
 LOWERBOUND1 = 97  ' 97 = a
 UPPERBOUND1 = 122 ' 122 = z
 SYMLOWER    = 33  ' 33 = !
 SYMUPPER    = 46  ' 46 = .
 pCheckComplexUp  = 0 ' used later to check number of character types in password
 pCheckComplexLow = 0 ' used later to check number of character types in password
 pCheckComplexNum = 0 ' used later to check number of character types in password
 pCheckComplexSym = 0 ' used later to check number of character types in password
 
 
 ' initialize the random number generator
 Randomize()

 newPassword = ""
 count = 0
 DO UNTIL count = PASSWORD_LENGTH
   ' generate a num between 2 and 10
  
 ' if num <= 2 create a symbol
   If Int( ( 10 - 2 + 1 ) * Rnd + 2 ) <= 2 Then
    pwd = Int( ( SYMUPPER - SYMLOWER + 1 ) * Rnd + SYMLOWER )

   ' if num is between 3 and 5 create a lowercase
   Elseif Int( ( 10 - 2 + 1 ) * Rnd + 2 ) > 2 And  Int( ( 10 - 2 + 1 ) * Rnd + 2 ) <= 5 Then
    pwd = Int( ( UPPERBOUND1 - LOWERBOUND1 + 1 ) * Rnd + LOWERBOUND1 )

    ' if num is 6 or 7 generate an uppercase
   Elseif Int( ( 10 - 2 + 1 ) * Rnd + 2 ) > 5 And  Int( ( 10 - 2 + 1 ) * Rnd + 2 ) <= 7 Then
    pwd = Int( ( UPPERBOUND - LOWERBOUND + 1 ) * Rnd + LOWERBOUND )

   Else
       pwd = Int( ( NUMUPPER - NUMLOWER + 1 ) * Rnd + NUMLOWER )
   End If

  newPassword = newPassword + Chr( pwd )
  
  count = count + 1
  
  'Check to make sure that a proper mix of characters has been created.  If not discard the password.
  If count = (PASSWORD_LENGTH) Then
      For pCheckComplex = 1 To PASSWORD_LENGTH
          'Check for uppercase
          If Asc(Mid(newPassword,pCheckComplex,1)) >64 And Asc(Mid(newPassword,pCheckComplex,1))< 90 Then
                  pCheckComplexUp = 1
          'Check for lowercase
          ElseIf Asc(Mid(newPassword,pCheckComplex,1)) >96 And Asc(Mid(newPassword,pCheckComplex,1))< 123 Then
                  pCheckComplexLow = 1
          'Check for numbers
          ElseIf Asc(Mid(newPassword,pCheckComplex,1)) >47 And Asc(Mid(newPassword,pCheckComplex,1))< 58 Then
                  pCheckComplexNum = 1
          'Check for symbols
          ElseIf Asc(Mid(newPassword,pCheckComplex,1)) >32 And Asc(Mid(newPassword,pCheckComplex,1))< 47 Then
                  pCheckComplexSym = 1
          End If
      Next
      
      'Add up the number of character sets.  We require 3 or 4 for a complex password.
      pCheckAnswer = pCheckComplexUp+pCheckComplexLow+pCheckComplexNum+pCheckComplexSym
            
      If pCheckAnswer < 3 Then
          newPassword = ""
          count = 0
      End If
  End If
 Loop
'The password is good so return it
 generatePassword = newPassword
End Function