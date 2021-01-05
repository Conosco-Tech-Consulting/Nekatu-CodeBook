#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
    
#Function to Get all documents Libraries in a SharePoint Online Site Collection
Function Get-SPODocumentLibrary($SiteURL)
{
    Try {
        #Setup the context
        $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
        $Ctx.Credentials = $Credentials
    
        #Get the web and Its subsites from given URL
        $Web = $Ctx.web
        $Ctx.Load($Web)
        $Ctx.Load($Web.Lists)
        $Ctx.Load($web.Webs)
        $Ctx.executeQuery()
  
        Write-host -f Yellow "Processing Site: $SiteURL"
  
        #sharepoint online powershell list all document libraries
        $Lists = $Web.Lists | Where {$_.BaseType -eq "DocumentLibrary" -and $_.Hidden -eq $False}
 
        #Loop through each document library and Get the Title
        Foreach ($List in $Lists)
        {
            Write-host $List.Title
        }
   
        #Iterate through each subsite of the current web and call the function recursively
        ForEach ($Subweb in $Web.Webs)
        {
            #Call the function recursively to process all subsites
            Get-SPODocumentLibrary($Subweb.url)
        }
    }
    Catch {
        write-host -f Red "Error Getting Document Libraries!" $_.Exception.Message
    }
}
   
#Setup Credentials to connect
$Cred= Get-Credential
$Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.Username, $Cred.Password)
   
#Call the function to get all document libraries in a site collection
Start-Transcript -Path "D:\Output\LibraryList-Full.csv" -NoClobber
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/3MUpgrade
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/ABBT2
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/abbott
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/AcushnetPlanningCloseProject
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/AdtalemConsolidation
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/AdtalemPlanning
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/AGGrowthTBLoadDemo
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/Alliance
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/Ameriprise
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/AmexPOCTeam
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/AMG
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/Analytics
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/Analytics230
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/AnalyticsontheLVCloud
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/AnalyticsSupportTeam
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/AnalyticsTeam
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/Ansys
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/Anysys
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/Astec
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/Astec-LVTaxImplementation
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/A-Team
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/ATNI
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/AuditPrepmeeting
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/AuditSOCControls
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/BBOU
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/Beta-Longview.com
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/Betriebsrat
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/BlueLink-Phase1-WorkforceCalcs
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/BMO
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/Capstone327
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/Cargill
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/Cascades
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/Cenovus
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/ChannelFinance
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/CinciBell
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/CloseandPlanWebinar-Fall19
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/CloseDemoEnhancements
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/CloudOps
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/CoherentTax
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/CoherentTax637
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/Coinbase
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/TeamFrance
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/ConnectedFinanceDemo
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/ConvertexistingCarlstadtDRtoAWS
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/CoreTaxEditors
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/coreteam
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/CornellPerformanceQ12020
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/CoyoteLogistics
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/CreditSuisse
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/CustomerSuccess
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/CustomerUpgradeTeam
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/DailyGrind
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/DailyGrind444
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/DataQualityImprovement
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/DE-IT-Migration
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/DemandGeneration
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/DesignerforTaxTraining
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/Dialog2020
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/DominionEnergy
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/DomtarConsolidation
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/Dover
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/DumbQuestionsanswered
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/Weyerhaeusercopy
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/eLearningKCPS
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/Encore
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/Energizer
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/EnergyTransfer
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/ExecutiveTeam
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/Filgo
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/Filgo-Sonic
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/Fortum
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/FrenchTeam
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/frontoffice-langenfeld
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/GDPRGovernance
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/GlobalPSTeamLongviewAnalytics
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/HII
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/HIIQCPMImplementation
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/HIPAAReadiness
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/HomeOffice
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/hr
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/HSF
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/HuntingtonIngalls-LVTaxImplementation
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/ImerysMay2019
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/InsightGlobal-LVConsolidation
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/InsightsonInsight
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/JW
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/KhalixQuestions
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/KnowledgeExchange
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/LearningAdmin
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/LearningTaxContentDev
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/LendingTree18
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/Licensing
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/LifeFitness
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/LifeFitnessConsolidation
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/linkedin
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/Lockheed-2019Consolidation
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/Lohika
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/longview
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/LongviewAnalytics-InformationDesign
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/LongviewDocumentation
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/LongviewIT
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/LongviewLearningDialogTasks
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/LongviewLearningMaterialPage
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/LongviewLohikageneral
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/LongviewPartners
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/LongviewPlanSupport
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/LongviewUI
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/LongviewWebinars
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/LumberLiquidators-ScopingProject
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/LVPlanDemoEnhancements
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/LVPlanFeatures
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/LVC5OngoingPlan
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/LVCloud77
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/LVCloud82
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/LVCloud37
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/LVCloud73
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/lvcloud
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/lvcloud-private
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/LVCloud76
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/LVCloud86
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/LVCloudGrp
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/LVISKnowledge
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/MATeam
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/ManulifeJohnHancockexpansion
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/MariaDailyGrind
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/MArketing
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/marketingcalendar
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/MarketingTeam
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/MarquardBahlsTaxImplementation
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/medidata
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/MeredithInc.Cloud
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/MeridianReimplementation
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/mmmteam
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/MoogInc.Prospect
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/MyTeam2
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/NationalFuel
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/NATIONALGAS
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/NationwidePerformanceEngagement
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/NewPlan
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/NewsFeed
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/NorbordAnalytics
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/NorbordFinanceAnalyticsOpp
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/NorthAmericaCSMTeam
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/nutrien313
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/OateyClose
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/OnCallSupportGroup
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/OpenAir
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/Orange-LoadTestingFramework
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/outlookhelp
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/PacificLife
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/PenetrationTesting686
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/PersonalProjects
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/Pfizer
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/PlanningSupport
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/platform
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/PolicyandProcedures
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/PRA2019
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/Pre-Sales
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/ProductManagementAnalytics
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/ProfessionalServiceTeam
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/pwa
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/ProviewTasks
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/ps
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/PS94
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/PSDirectors
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/PSEMEA
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/PSMeeting
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/PSPlanningProcessImprovement
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/QA
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/qualityassurance
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/Rafaelsteam
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/ReleaseDocumentationUpdate
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/RenewableEnergyGroup
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/ResoluteFPAnalyticsPOC
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/ResoluteONProject
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/ResourceScalingProject
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/RobertFamilyHoldingsFinancialPlanning
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/rollingthunder
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/Rooms
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/RoyalSunAlliance
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/RSA
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/SalesMarketing
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/MarketingCollateral
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/SalesEMEA
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/SanMateo
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/sandyspringBankUpgrade
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/SargentoTax
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/SBD
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/SchenkerLongviewTeam
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/SCOPING
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/ScotiabankTaxUpgrade
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/SecurityAlerts
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/SFDCupdates
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/Sherritt
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/sherritt529
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/SKO2020
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/SobeysSystemMergeandFoundationImplementation
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/SOCHIPAAinterviewschedule
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/SOCReadiness
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/Solutions
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/Solutions10.3
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/Solutions10.4
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/Solutions10.5
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/Solutions10.6
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/Starbucks
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/SunLife
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/SunLifePlanning
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/Support
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/SupportGermany
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/T100Class
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/T96859-missingapptabledata
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/Tanium
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/TaxKnowledgeSharing
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/TAXPM
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/TaxPSKnowledgeSharing
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/TaxQuickScope
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/TeamCore-DataTableRowDependencies
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/TeamRain
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/TeamRuby
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/Ticketing
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/TickingAuditRequirements
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/tidemark
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/CustomerSuccessTidemark-ClientTemplate
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/TidemarkDemoEnhancements
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/tidemarkemea
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/TidemarkIntegration
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/TidemarkKX
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/TidemarkPerformance
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/TidemarkSOCReadiness
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/tidemark_engineering
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/tidemark-devops
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/ToDos
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/TrainingforCompliance
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/Transmaerica
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/Trustmark
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/Tupperwareupgrade
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/UIinterview
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/UnionPacificTaxImplementation
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/UpgradeCampaign
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/UPS-265Enhancements
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/Vale
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/VertriebDACHMichael
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/Vertrieb-longview.com
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/Weyerhaeuser
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/WorldAcceptance
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/XPO-
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/XPOLogistics
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/XPOMemoryIssueS87008
Get-SPODocumentLibrary https://longview365.sharepoint.com/sites/Zimmer
Stop-Transcript