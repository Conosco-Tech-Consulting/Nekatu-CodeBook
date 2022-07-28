& $env:ExchangeInstallPath\Scripts\Install-AntiSpamAgents.ps1
Restart-Service MSExchangeTransport
Add-IPBlockListProvider -name zen.spamhaus.org -lookupdomain zen.spamhaus.org
Add-IPBlockListProvider -name bb.barracudacentral.org -lookupdomain bb.barracudacentral.org
Add-IPBlockListProvider -name ix.dnsbl.manitu.net -lookupdomain ix.dnsbl.manitu.net
Add-IPBlockListProvider -name bl.spamcop.net -lookupdomain bl.spamcop.net
Add-IPBlockListProvider -name combined.njabl.org -lookupdomain combined.njabl.org
Add-IPAllowListProvider -name swl.spamhaus.org -lookupdomain swl.spamhaus.org
Add-IPAllowListProvider -name iadb.isipp.com -lookupdomain iadb.isipp.com
Add-IPAllowListProvider -name query.bondedsender.org -lookupdomain query.bondedsender.org
Add-IPAllowListProvider -name hul.habeas.com -lookupdomain hul.habeas.com
Set-SenderIDConfig -SpoofedDomainAction StampStatus
Set-SenderReputationConfig -SenderBlockingEnabled $true -SrlBlockThreshold 6 -SenderBlockingPeriod 36
Set-SenderFilterConfig -BlankSenderBlockingEnabled $true
Set-ContentFilterConfig -SCLQuarantineThreshold 6
Set-ContentFilterConfig -SCLDeleteEnabled $true
Set-ContentFilterConfig -SCLQuarantineEnabled $true -QuarantineMailbox ethanm@nekatu.blogdns.net
Set-ContentFilterConfig -SCLRejectEnabled $false