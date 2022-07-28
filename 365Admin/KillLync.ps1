$msolcred = get-credential
connect-msolservice -credential $msolcred
$temp= New-MsolLicenseOptions -AccountSkuId stmartinsschool:STANDARDWOFFPACK_STUDENT -DisabledPlans MCOSTANDARD
$temp.GetType()
Get-MsolUser | Set-MsolUserLicense –LicenseOptions $temp