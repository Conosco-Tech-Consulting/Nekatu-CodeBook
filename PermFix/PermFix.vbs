Dim Act
Set Act = CreateObject("Wscript.Shell")
Do while infiniteloop=0
    a = minute(time())
    intResult = a Mod 2
    Act.AppActivate("Error Applying Security")
    Act.SendKeys "%C"
    Wscript.Sleep 50
   Loop
   