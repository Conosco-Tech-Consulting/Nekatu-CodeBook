Set o = CreateObject("Excel.Application")
o.Visible = True
o.AutomationSecurity=1
o.Workbooks.Open "\\coop-ltpdp\audit\Audits v8b.xls"