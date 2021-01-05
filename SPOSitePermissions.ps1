#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
   
#Setup Credentials to connect
$Cred = Get-Credential
$Cred = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.UserName,$Cred.Password)

Function Get-SPOUsers($SiteUrl)
 { 
 
Try {
    #Setup the context
    $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
    $Ctx.Credentials = $Cred
 
    #Get all Groups
    $Groups=$Ctx.Web.SiteGroups
    $Ctx.Load($Groups)
    $Ctx.ExecuteQuery()
 
    #Get Each member from the Group
    Foreach($Group in $Groups)
    {
        Write-Host "--- $($Group.Title) --- "
 
        #Getting the members
        $SiteUsers=$Group.Users
        $Ctx.Load($SiteUsers)
        $Ctx.ExecuteQuery()
        Foreach($User in $SiteUsers)
        {
            Write-Host "$($User.Title), $($User.Email), $($User.LoginName)"
        }
    }
}
Catch {
    write-host -f Red "Error getting groups and users!" $_.Exception.Message
}

}

Start-Transcript -Path "D:\Output\SPOUsers2.csv" -NoClobber
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-3mupgrade
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-abbtt2
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-abbott
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-acushnet
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-adtalem
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-adtalemplan
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-aggrowth
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-alliance
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-ameriprise
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-amexpoc
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-amg
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-analytics1
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-analytics2
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-analyticlvc
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-analyticssupport
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-analyticsteam
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-ansys
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-anysys
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-astec
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-taximplementation
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-ateam
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-atni
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-auditprep
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-auditsoc
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-bbou
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-betalongview
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-betriebsrat
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-bluelink1
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-bmo
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-capstone
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-cargill
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-cascades
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-cenovus
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-chanfin
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-cincibell
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-closeandplanwebinar19
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-closedemoenhancements
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-cloudops
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-coherenttax
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-coherenttaxint
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-coinbase
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-comtelligence
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-financedemo
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-convertdraws
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-coretax
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-coreteam
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-cornperfq120
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-coyotelogistics
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-creditsuisse
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-customersuccess
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-customerupgradeteam
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-dailygrind
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-dailygrind2
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-dataqualityimprovement
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-deitmigration
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-demandgeneration
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-designerfortaxtraining
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-dialog2020
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-domenergy
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-domtarcons
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-dover
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-dumbquestions
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-edlifesci
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-elearningkcps
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-emeacsandca
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-encore
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-energizer
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-energytransfer
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-execteam
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-filgo
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-filgosonic
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-fortum
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-frenchteam
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-frontofficelangenfeld
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-gdprgov
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-globalpsteamanalytics
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-hii
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-hiiqcpmimplementation
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-hipaareadiness
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-homeoffice
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-hr
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-hsf
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-huntingtoningallstaximplementation
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-imerysmay2019
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-insightconsolidation
Get-SPOUsers https://insightsw.sharepoint.com/sites/longview-insightsoninsightsoftware
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-jw
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-khalixquestions
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-knowledgeexchange
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-learningadmin
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-learningtaxcontentdev
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-learningtree
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-licensing
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-lifefitness
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-lifefitnessconsolidation
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-linkedin
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-lockheed2019
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-lohika1
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-longview
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-longviewanalyticsinformationdesign
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-documentation
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-it
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-longviewlearningdialogtasks
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-learningmaterialpage
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-longviewlohikageneral
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-partners
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-plansupport
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-ui
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-webinars
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-lumberliquidatorsscopingproject
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-lvplandemoenhancements
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-planfeatures
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-lvc5ongoingplan
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-lvcloudadmin1
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-lvcloudadmin2
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-lvcloudgeneral
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-lvcloudprivate
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-lvcloud1
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-lvcloud2
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-lvcloud3
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-lvcloud4
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-lvcloudgrp
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-lvisknowledge
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-mateam
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-manulifejohnhancockexpansion
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-mariadailygrind
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-marketing
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-marketingcalendar
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-marketingteam
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-marquardandbahlstaximplementation
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-medidata
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-meredithinccloud
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-meridianfoundation
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-mmm
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-moogincprospect
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-myteam
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-nationalfuel
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-nationalgas
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-nationwideperformanceengagement
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-newplan
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-newsfeed
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-norbordanalytics
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-norbordfinanceanalyticsopp
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-northamericacsmteam
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-nutrien
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-oateyclose
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-oncallsupportgroup
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-openair
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-orangeloadtestingframework
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-outlookhelp
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-pacificlife
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-penetrationtesting
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-personalprojects
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-pfizer
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-planningsupport
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-platform1
Get-SPOUsers https://insightsw.sharepoint.com/sites/longview-policyandprocedures
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-pra2019
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-presales
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-productmanagementanalytics
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-professionalserviceteam
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-pwa
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-proviewtasks
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-ps
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-psdirectors1
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-psemea
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-psmeeting
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-psplanningprocessimprovement
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-ps1
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-qa
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-qualityassurance
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-rafaelsteam
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-releasedocumentationupdate
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-renewableenergygroup
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-resolutefpanalyticspoc
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-resoluteonproject
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-resourcescalingproject
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-robertfamilyholdingsfinancialplanning
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-rollingthunder
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-rooms
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-royalsunalliance
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-rsa
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-salesmarketing
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-sandmp
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-salesemea
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-sanmateo
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-sandyspringbankupgrade
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-sargentotax
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-sbd
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-schenkerlongviewteam
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-scoping
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-scotiabanktaxupgrade
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-securityalerts
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-sfdcupdates
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-sherrit2
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-sherritt
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-sko2020
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-sobsysmergfoundimplement
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-sochipaainterviewschedule
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-socreadiness
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-solutions
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-solutions103
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-solutions104
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-solutions105
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-solutions106
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-starbucks
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv_main
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-sunlife
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-sunlifeplanning
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-support
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-supportgermany
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-t100class
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-t96859
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-tanium
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-taxknowledgesharing
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-taxpm
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-taxpsknowledgesharing
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-taxquickscope
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-teamcore
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-teamrain
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-teamruby
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-ticketingtraining
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-tickingauditrequirements
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-tidemark
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-tidemarkcsclienttemplate
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-tidemarkdemoenhancements
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-tidemarkdevops
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-tidemarkdevops1
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-tidemarkemea
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-tidemarkitsystemserviceintegration
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-tidemarkkx
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-tidemarkperformance
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-tidemarksocreadiness
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-tidemarkengineering
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-tidemarkdevops
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-todos
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-trainingforcompliance
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-transmaerica
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-trustmark
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-tupperwareupgrade
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-utinterview
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-unionpacifictaximplementation
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-upgradecampaign
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-ups265enhancements
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-vale
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-vertriebdachmichael
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-vertrieblongviewcom
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-weyerhaeuser
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-worldacceptance
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-xpo
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-xpologistics
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-xpomemoryissue
Get-SPOUsers https://insightsw.sharepoint.com/sites/lv-zimmer
Stop-Transcript