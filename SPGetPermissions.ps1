#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"

#Get Credentials to connect
$Cred= Get-Credential
    
#Function to Export List Permissions to CSV
Function Export-SPOListPermission([String]$SiteURL, [String]$ListName, [String]$CSVPath)
{
    Try{
 
        #Setup the context
        $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
        $Ctx.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.Username, $Cred.Password)
        
        #Get the List
        $List = $Ctx.Web.Lists.GetByTitle($ListName)
        $Ctx.Load($List)
        $Ctx.ExecuteQuery()
   
        #Get permissions assigned to the List
        $RoleAssignments = $List.RoleAssignments
        $Ctx.Load($RoleAssignments)
        $Ctx.ExecuteQuery()
   
        #Loop through each permission assigned and extract details
        $PermissionCollection = @()
        Foreach($RoleAssignment in $RoleAssignments)
        {
            $Ctx.Load($RoleAssignment.Member)
            $Ctx.executeQuery()
   
            #Get the Principal Type: User, SP Group, AD Group
            $PermissionType = $RoleAssignment.Member.PrincipalType
   
            #Get the Permission Levels assigned
            $Ctx.Load($RoleAssignment.RoleDefinitionBindings)
            $Ctx.ExecuteQuery()
            $PermissionLevels = ($RoleAssignment.RoleDefinitionBindings | Select -ExpandProperty Name) -join ","
               
            #Get SharePoint group members
            If($PermissionType -eq "SharePointGroup")
            {
                #Get Group Members
                $Group = $Ctx.web.SiteGroups.GetByName($RoleAssignment.Member.LoginName)
                $Ctx.Load($Group)
                $GroupMembers= $Group.Users
                $Ctx.Load($GroupMembers)
                $Ctx.ExecuteQuery()
                Foreach ($Member in $GroupMembers)
                {
                    #Add the Data to Object
                    $Permissions = New-Object PSObject
                    $Permissions | Add-Member NoteProperty Name($Member.Title)
                    $Permissions | Add-Member NoteProperty Type($PermissionType)
                    $Permissions | Add-Member NoteProperty PermissionLevels($PermissionLevels)
                    $Permissions | Add-Member NoteProperty GrantedThrough("SharePoint Group: $($RoleAssignment.Member.LoginName)")
                    $PermissionCollection += $Permissions
                }
            }
            Else
            {
                #Add the Data to Object
                $Permissions = New-Object PSObject
                $Permissions | Add-Member NoteProperty Name($RoleAssignment.Member.Title)
                $Permissions | Add-Member NoteProperty Type($PermissionType)
                $Permissions | Add-Member NoteProperty PermissionLevels($PermissionLevels)
                $Permissions | Add-Member NoteProperty GrantedThrough("Direct Permissions")
                $PermissionCollection += $Permissions
            }
 
        }
        $PermissionCollection
         
        #Export List Permissions to CSV File
        $PermissionCollection | Export-CSV $CSVPath -NoTypeInformation
        write-host -f Green "List Permissions Exported Successfully!"
    }
    Catch {
    write-host -f Red "Error Exporting List Permissions!" $_.Exception.Message
    }
}
 
#Call the function to Export List Permissions
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/3MUpgrade -ListName "Documents" -CSVPath "D:\Output\3MUpgrade.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/ABBT2 -ListName "Documents" -CSVPath "D:\Output\ABBT2.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/abbott -ListName "Documents" -CSVPath "D:\Output\abbott.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/AcushnetPlanningCloseProject -ListName "Documents" -CSVPath "D:\Output\AcushnetPlanningCloseProject.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/AdtalemConsolidation -ListName "Documents" -CSVPath "D:\Output\AdtalemConsolidation.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/AdtalemPlanning -ListName "Documents" -CSVPath "D:\Output\AdtalemPlanning.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/AGGrowthTBLoadDemo -ListName "Documents" -CSVPath "D:\Output\AGGrowthTBLoadDemo.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/Alliance -ListName "Documents" -CSVPath "D:\Output\Alliance.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/Ameriprise -ListName "Documents" -CSVPath "D:\Output\Ameriprise.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/AmexPOCTeam -ListName "Documents" -CSVPath "D:\Output\AmexPOCTeam.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/AMG -ListName "Documents" -CSVPath "D:\Output\AMG.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/Analytics -ListName "Documents" -CSVPath "D:\Output\Analytics.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/Analytics230 -ListName "Documents" -CSVPath "D:\Output\Analytics230.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/AnalyticsontheLVCloud -ListName "Documents" -CSVPath "D:\Output\AnalyticsontheLVCloud.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/AnalyticsSupportTeam -ListName "Documents" -CSVPath "D:\Output\AnalyticsSupportTeam.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/AnalyticsTeam -ListName "Documents" -CSVPath "D:\Output\AnalyticsTeam.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/Ansys -ListName "Documents" -CSVPath "D:\Output\Ansys.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/Anysys -ListName "Documents" -CSVPath "D:\Output\Anysys.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/Astec -ListName "Documents" -CSVPath "D:\Output\Astec.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/Astec-LVTaxImplementation -ListName "Documents" -CSVPath "D:\Output\Astec-LVTaxImplementation.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/A-Team -ListName "Documents" -CSVPath "D:\Output\A-Team.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/ATNI -ListName "Documents" -CSVPath "D:\Output\ATNI.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/AuditPrepmeeting -ListName "Documents" -CSVPath "D:\Output\AuditPrepmeeting.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/AuditSOCControls -ListName "Documents" -CSVPath "D:\Output\AuditSOCControls.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/BBOU -ListName "Documents" -CSVPath "D:\Output\BBOU.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/Beta-Longview.com -ListName "Documents" -CSVPath "D:\Output\Beta-Longview.com.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/Betriebsrat -ListName "Documents" -CSVPath "D:\Output\Betriebsrat.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/BlueLink-Phase1-WorkforceCalcs -ListName "Documents" -CSVPath "D:\Output\BlueLink-Phase1-WorkforceCalcs.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/BMO -ListName "Documents" -CSVPath "D:\Output\BMO.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/Capstone327 -ListName "Documents" -CSVPath "D:\Output\Capstone327.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/Cargill -ListName "Documents" -CSVPath "D:\Output\Cargill.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/Cascades -ListName "Documents" -CSVPath "D:\Output\Cascades.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/Cenovus -ListName "Documents" -CSVPath "D:\Output\Cenovus.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/ChannelFinance -ListName "Documents" -CSVPath "D:\Output\ChannelFinance.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/CinciBell -ListName "Documents" -CSVPath "D:\Output\CinciBell.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/CloseandPlanWebinar-Fall19 -ListName "Documents" -CSVPath "D:\Output\CloseandPlanWebinar-Fall19.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/CloseDemoEnhancements -ListName "Documents" -CSVPath "D:\Output\CloseDemoEnhancements.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/CloudOps -ListName "Documents" -CSVPath "D:\Output\CloudOps.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/CoherentTax -ListName "Documents" -CSVPath "D:\Output\CoherentTax.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/CoherentTax637 -ListName "Documents" -CSVPath "D:\Output\CoherentTax637.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/Coinbase -ListName "Documents" -CSVPath "D:\Output\Coinbase.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/TeamFrance -ListName "Documents" -CSVPath "D:\Output\TeamFrance.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/ConnectedFinanceDemo -ListName "Documents" -CSVPath "D:\Output\ConnectedFinanceDemo.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/ConvertexistingCarlstadtDRtoAWS -ListName "Documents" -CSVPath "D:\Output\ConvertexistingCarlstadtDRtoAWS.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/CoreTaxEditors -ListName "Documents" -CSVPath "D:\Output\CoreTaxEditors.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/coreteam -ListName "Documents" -CSVPath "D:\Output\coreteam.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/CornellPerformanceQ12020 -ListName "Documents" -CSVPath "D:\Output\CornellPerformanceQ12020.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/CoyoteLogistics -ListName "Documents" -CSVPath "D:\Output\CoyoteLogistics.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/CreditSuisse -ListName "Documents" -CSVPath "D:\Output\CreditSuisse.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/CustomerSuccess -ListName "Documents" -CSVPath "D:\Output\CustomerSuccess.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/CustomerUpgradeTeam -ListName "Documents" -CSVPath "D:\Output\CustomerUpgradeTeam.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/DailyGrind -ListName "Documents" -CSVPath "D:\Output\DailyGrind.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/DailyGrind444 -ListName "Documents" -CSVPath "D:\Output\DailyGrind444.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/DataQualityImprovement -ListName "Documents" -CSVPath "D:\Output\DataQualityImprovement.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/DE-IT-Migration -ListName "Documents" -CSVPath "D:\Output\DE-IT-Migration.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/DemandGeneration -ListName "Documents" -CSVPath "D:\Output\DemandGeneration.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/DesignerforTaxTraining -ListName "Documents" -CSVPath "D:\Output\DesignerforTaxTraining.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/Dialog2020 -ListName "Documents" -CSVPath "D:\Output\Dialog2020.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/DominionEnergy -ListName "Documents" -CSVPath "D:\Output\DominionEnergy.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/DomtarConsolidation -ListName "Documents" -CSVPath "D:\Output\DomtarConsolidation.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/Dover -ListName "Documents" -CSVPath "D:\Output\Dover.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/DumbQuestionsanswered -ListName "Documents" -CSVPath "D:\Output\DumbQuestionsanswered.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/Weyerhaeusercopy -ListName "Documents" -CSVPath "D:\Output\Weyerhaeusercopy.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/eLearningKCPS -ListName "Documents" -CSVPath "D:\Output\eLearningKCPS.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/Encore -ListName "Documents" -CSVPath "D:\Output\Encore.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/Energizer -ListName "Documents" -CSVPath "D:\Output\Energizer.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/EnergyTransfer -ListName "Documents" -CSVPath "D:\Output\EnergyTransfer.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/ExecutiveTeam -ListName "Documents" -CSVPath "D:\Output\ExecutiveTeam.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/Filgo -ListName "Documents" -CSVPath "D:\Output\Filgo.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/Filgo-Sonic -ListName "Documents" -CSVPath "D:\Output\Filgo-Sonic.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/Fortum -ListName "Documents" -CSVPath "D:\Output\Fortum.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/FrenchTeam -ListName "Documents" -CSVPath "D:\Output\FrenchTeam.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/frontoffice-langenfeld -ListName "Documents" -CSVPath "D:\Output\frontoffice-langenfeld.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/GDPRGovernance -ListName "Documents" -CSVPath "D:\Output\GDPRGovernance.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/GlobalPSTeamLongviewAnalytics -ListName "Documents" -CSVPath "D:\Output\GlobalPSTeamLongviewAnalytics.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/HII -ListName "Documents" -CSVPath "D:\Output\HII.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/HIIQCPMImplementation -ListName "Documents" -CSVPath "D:\Output\HIIQCPMImplementation.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/HIPAAReadiness -ListName "Documents" -CSVPath "D:\Output\HIPAAReadiness.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/HomeOffice -ListName "Documents" -CSVPath "D:\Output\HomeOffice.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/hr -ListName "Documents" -CSVPath "D:\Output\hr.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/HSF -ListName "Documents" -CSVPath "D:\Output\HSF.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/HuntingtonIngalls-LVTaxImplementation -ListName "Documents" -CSVPath "D:\Output\HuntingtonIngalls-LVTaxImplementation.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/ImerysMay2019 -ListName "Documents" -CSVPath "D:\Output\ImerysMay2019.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/InsightGlobal-LVConsolidation -ListName "Documents" -CSVPath "D:\Output\InsightGlobal-LVConsolidation.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/InsightsonInsight -ListName "Documents" -CSVPath "D:\Output\InsightsonInsight.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/JW -ListName "Documents" -CSVPath "D:\Output\JW.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/KhalixQuestions -ListName "Documents" -CSVPath "D:\Output\KhalixQuestions.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/KnowledgeExchange -ListName "Documents" -CSVPath "D:\Output\KnowledgeExchange.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/LearningAdmin -ListName "Documents" -CSVPath "D:\Output\LearningAdmin.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/LearningTaxContentDev -ListName "Documents" -CSVPath "D:\Output\LearningTaxContentDev.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/LendingTree18 -ListName "Documents" -CSVPath "D:\Output\LendingTree18.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/Licensing -ListName "Documents" -CSVPath "D:\Output\Licensing.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/LifeFitness -ListName "Documents" -CSVPath "D:\Output\LifeFitness.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/LifeFitnessConsolidation -ListName "Documents" -CSVPath "D:\Output\LifeFitnessConsolidation.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/linkedin -ListName "Documents" -CSVPath "D:\Output\linkedin.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/Lockheed-2019Consolidation -ListName "Documents" -CSVPath "D:\Output\Lockheed-2019Consolidation.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/Lohika -ListName "Documents" -CSVPath "D:\Output\Lohika.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/longview -ListName "Documents" -CSVPath "D:\Output\longview.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/LongviewAnalytics-InformationDesign -ListName "Documents" -CSVPath "D:\Output\LongviewAnalytics-InformationDesign.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/LongviewDocumentation -ListName "Documents" -CSVPath "D:\Output\LongviewDocumentation.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/LongviewIT -ListName "Documents" -CSVPath "D:\Output\LongviewIT.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/LongviewLearningDialogTasks -ListName "Documents" -CSVPath "D:\Output\LongviewLearningDialogTasks.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/LongviewLearningMaterialPage -ListName "Documents" -CSVPath "D:\Output\LongviewLearningMaterialPage.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/LongviewLohikageneral -ListName "Documents" -CSVPath "D:\Output\LongviewLohikageneral.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/LongviewPartners -ListName "Documents" -CSVPath "D:\Output\LongviewPartners.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/LongviewPlanSupport -ListName "Documents" -CSVPath "D:\Output\LongviewPlanSupport.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/LongviewUI -ListName "Documents" -CSVPath "D:\Output\LongviewUI.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/LongviewWebinars -ListName "Documents" -CSVPath "D:\Output\LongviewWebinars.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/LumberLiquidators-ScopingProject -ListName "Documents" -CSVPath "D:\Output\LumberLiquidators-ScopingProject.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/LVPlanDemoEnhancements -ListName "Documents" -CSVPath "D:\Output\LVPlanDemoEnhancements.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/LVPlanFeatures -ListName "Documents" -CSVPath "D:\Output\LVPlanFeatures.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/LVC5OngoingPlan -ListName "Documents" -CSVPath "D:\Output\LVC5OngoingPlan.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/LVCloud77 -ListName "Documents" -CSVPath "D:\Output\LVCloud77.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/LVCloud82 -ListName "Documents" -CSVPath "D:\Output\LVCloud82.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/LVCloud37 -ListName "Documents" -CSVPath "D:\Output\LVCloud37.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/LVCloud73 -ListName "Documents" -CSVPath "D:\Output\LVCloud73.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/lvcloud -ListName "Documents" -CSVPath "D:\Output\lvcloud.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/lvcloud-private -ListName "Documents" -CSVPath "D:\Output\lvcloud-private.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/LVCloud76 -ListName "Documents" -CSVPath "D:\Output\LVCloud76.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/LVCloud86 -ListName "Documents" -CSVPath "D:\Output\LVCloud86.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/LVCloudGrp -ListName "Documents" -CSVPath "D:\Output\LVCloudGrp.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/LVISKnowledge -ListName "Documents" -CSVPath "D:\Output\LVISKnowledge.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/MATeam -ListName "Documents" -CSVPath "D:\Output\MATeam.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/ManulifeJohnHancockexpansion -ListName "Documents" -CSVPath "D:\Output\ManulifeJohnHancockexpansion.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/MariaDailyGrind -ListName "Documents" -CSVPath "D:\Output\MariaDailyGrind.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/MArketing -ListName "Documents" -CSVPath "D:\Output\MArketing.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/marketingcalendar -ListName "Documents" -CSVPath "D:\Output\marketingcalendar.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/MarketingTeam -ListName "Documents" -CSVPath "D:\Output\MarketingTeam.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/MarquardBahlsTaxImplementation -ListName "Documents" -CSVPath "D:\Output\MarquardBahlsTaxImplementation.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/medidata -ListName "Documents" -CSVPath "D:\Output\medidata.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/MeredithInc.Cloud -ListName "Documents" -CSVPath "D:\Output\MeredithInc.Cloud.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/MeridianReimplementation -ListName "Documents" -CSVPath "D:\Output\MeridianReimplementation.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/mmmteam -ListName "Documents" -CSVPath "D:\Output\mmmteam.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/MoogInc.Prospect -ListName "Documents" -CSVPath "D:\Output\MoogInc.Prospect.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/MyTeam2 -ListName "Documents" -CSVPath "D:\Output\MyTeam2.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/NationalFuel -ListName "Documents" -CSVPath "D:\Output\NationalFuel.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/NATIONALGAS -ListName "Documents" -CSVPath "D:\Output\NATIONALGAS.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/NationwidePerformanceEngagement -ListName "Documents" -CSVPath "D:\Output\NationwidePerformanceEngagement.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/NewPlan -ListName "Documents" -CSVPath "D:\Output\NewPlan.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/NewsFeed -ListName "Documents" -CSVPath "D:\Output\NewsFeed.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/NorbordAnalytics -ListName "Documents" -CSVPath "D:\Output\NorbordAnalytics.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/NorbordFinanceAnalyticsOpp -ListName "Documents" -CSVPath "D:\Output\NorbordFinanceAnalyticsOpp.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/NorthAmericaCSMTeam -ListName "Documents" -CSVPath "D:\Output\NorthAmericaCSMTeam.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/nutrien313 -ListName "Documents" -CSVPath "D:\Output\nutrien313.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/OateyClose -ListName "Documents" -CSVPath "D:\Output\OateyClose.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/OnCallSupportGroup -ListName "Documents" -CSVPath "D:\Output\OnCallSupportGroup.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/OpenAir -ListName "Documents" -CSVPath "D:\Output\OpenAir.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/Orange-LoadTestingFramework -ListName "Documents" -CSVPath "D:\Output\Orange-LoadTestingFramework.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/outlookhelp -ListName "Documents" -CSVPath "D:\Output\outlookhelp.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/PacificLife -ListName "Documents" -CSVPath "D:\Output\PacificLife.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/PenetrationTesting686 -ListName "Documents" -CSVPath "D:\Output\PenetrationTesting686.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/PersonalProjects -ListName "Documents" -CSVPath "D:\Output\PersonalProjects.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/Pfizer -ListName "Documents" -CSVPath "D:\Output\Pfizer.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/PlanningSupport -ListName "Documents" -CSVPath "D:\Output\PlanningSupport.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/platform -ListName "Documents" -CSVPath "D:\Output\platform.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/PolicyandProcedures -ListName "Documents" -CSVPath "D:\Output\PolicyandProcedures.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/PRA2019 -ListName "Documents" -CSVPath "D:\Output\PRA2019.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/Pre-Sales -ListName "Documents" -CSVPath "D:\Output\Pre-Sales.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/ProductManagementAnalytics -ListName "Documents" -CSVPath "D:\Output\ProductManagementAnalytics.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/ProfessionalServiceTeam -ListName "Documents" -CSVPath "D:\Output\ProfessionalServiceTeam.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/pwa -ListName "Documents" -CSVPath "D:\Output\pwa.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/ProviewTasks -ListName "Documents" -CSVPath "D:\Output\ProviewTasks.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/ps -ListName "Documents" -CSVPath "D:\Output\ps.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/PS94 -ListName "Documents" -CSVPath "D:\Output\PS94.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/PSDirectors -ListName "Documents" -CSVPath "D:\Output\PSDirectors.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/PSEMEA -ListName "Documents" -CSVPath "D:\Output\PSEMEA.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/PSMeeting -ListName "Documents" -CSVPath "D:\Output\PSMeeting.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/PSPlanningProcessImprovement -ListName "Documents" -CSVPath "D:\Output\PSPlanningProcessImprovement.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/QA -ListName "Documents" -CSVPath "D:\Output\QA.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/qualityassurance -ListName "Documents" -CSVPath "D:\Output\qualityassurance.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/Rafaelsteam -ListName "Documents" -CSVPath "D:\Output\Rafaelsteam.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/ReleaseDocumentationUpdate -ListName "Documents" -CSVPath "D:\Output\ReleaseDocumentationUpdate.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/RenewableEnergyGroup -ListName "Documents" -CSVPath "D:\Output\RenewableEnergyGroup.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/ResoluteFPAnalyticsPOC -ListName "Documents" -CSVPath "D:\Output\ResoluteFPAnalyticsPOC.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/ResoluteONProject -ListName "Documents" -CSVPath "D:\Output\ResoluteONProject.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/ResourceScalingProject -ListName "Documents" -CSVPath "D:\Output\ResourceScalingProject.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/RobertFamilyHoldingsFinancialPlanning -ListName "Documents" -CSVPath "D:\Output\RobertFamilyHoldingsFinancialPlanning.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/rollingthunder -ListName "Documents" -CSVPath "D:\Output\rollingthunder.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/Rooms -ListName "Documents" -CSVPath "D:\Output\Rooms.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/RoyalSunAlliance -ListName "Documents" -CSVPath "D:\Output\RoyalSunAlliance.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/RSA -ListName "Documents" -CSVPath "D:\Output\RSA.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/SalesMarketing -ListName "Documents" -CSVPath "D:\Output\SalesMarketing.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/MarketingCollateral -ListName "Documents" -CSVPath "D:\Output\MarketingCollateral.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/SalesEMEA -ListName "Documents" -CSVPath "D:\Output\SalesEMEA.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/SanMateo -ListName "Documents" -CSVPath "D:\Output\SanMateo.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/sandyspringBankUpgrade -ListName "Documents" -CSVPath "D:\Output\sandyspringBankUpgrade.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/SargentoTax -ListName "Documents" -CSVPath "D:\Output\SargentoTax.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/SBD -ListName "Documents" -CSVPath "D:\Output\SBD.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/SchenkerLongviewTeam -ListName "Documents" -CSVPath "D:\Output\SchenkerLongviewTeam.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/SCOPING -ListName "Documents" -CSVPath "D:\Output\SCOPING.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/ScotiabankTaxUpgrade -ListName "Documents" -CSVPath "D:\Output\ScotiabankTaxUpgrade.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/SecurityAlerts -ListName "Documents" -CSVPath "D:\Output\SecurityAlerts.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/SFDCupdates -ListName "Documents" -CSVPath "D:\Output\SFDCupdates.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/Sherritt -ListName "Documents" -CSVPath "D:\Output\Sherritt.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/sherritt529 -ListName "Documents" -CSVPath "D:\Output\sherritt529.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/SKO2020 -ListName "Documents" -CSVPath "D:\Output\SKO2020.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/SobeysSystemMergeandFoundationImplementation -ListName "Documents" -CSVPath "D:\Output\SobeysSystemMergeandFoundationImplementation.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/SOCHIPAAinterviewschedule -ListName "Documents" -CSVPath "D:\Output\SOCHIPAAinterviewschedule.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/SOCReadiness -ListName "Documents" -CSVPath "D:\Output\SOCReadiness.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/Solutions -ListName "Documents" -CSVPath "D:\Output\Solutions.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/Solutions10.3 -ListName "Documents" -CSVPath "D:\Output\Solutions10.3.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/Solutions10.4 -ListName "Documents" -CSVPath "D:\Output\Solutions10.4.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/Solutions10.5 -ListName "Documents" -CSVPath "D:\Output\Solutions10.5.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/Solutions10.6 -ListName "Documents" -CSVPath "D:\Output\Solutions10.6.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/Starbucks -ListName "Documents" -CSVPath "D:\Output\Starbucks.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/SunLife -ListName "Documents" -CSVPath "D:\Output\SunLife.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/SunLifePlanning -ListName "Documents" -CSVPath "D:\Output\SunLifePlanning.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/Support -ListName "Documents" -CSVPath "D:\Output\Support.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/SupportGermany -ListName "Documents" -CSVPath "D:\Output\SupportGermany.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/T100Class -ListName "Documents" -CSVPath "D:\Output\T100Class.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/T96859-missingapptabledata -ListName "Documents" -CSVPath "D:\Output\T96859-missingapptabledata.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/Tanium -ListName "Documents" -CSVPath "D:\Output\Tanium.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/TaxKnowledgeSharing -ListName "Documents" -CSVPath "D:\Output\TaxKnowledgeSharing.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/TAXPM -ListName "Documents" -CSVPath "D:\Output\TAXPM.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/TaxPSKnowledgeSharing -ListName "Documents" -CSVPath "D:\Output\TaxPSKnowledgeSharing.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/TaxQuickScope -ListName "Documents" -CSVPath "D:\Output\TaxQuickScope.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/TeamCore-DataTableRowDependencies -ListName "Documents" -CSVPath "D:\Output\TeamCore-DataTableRowDependencies.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/TeamRain -ListName "Documents" -CSVPath "D:\Output\TeamRain.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/TeamRuby -ListName "Documents" -CSVPath "D:\Output\TeamRuby.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/Ticketing -ListName "Documents" -CSVPath "D:\Output\Ticketing.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/TickingAuditRequirements -ListName "Documents" -CSVPath "D:\Output\TickingAuditRequirements.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/tidemark -ListName "Documents" -CSVPath "D:\Output\tidemark.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/CustomerSuccessTidemark-ClientTemplate -ListName "Documents" -CSVPath "D:\Output\CustomerSuccessTidemark-ClientTemplate.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/TidemarkDemoEnhancements -ListName "Documents" -CSVPath "D:\Output\TidemarkDemoEnhancements.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/tidemarkemea -ListName "Documents" -CSVPath "D:\Output\tidemarkemea.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/TidemarkIntegration -ListName "Documents" -CSVPath "D:\Output\TidemarkIntegration.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/TidemarkKX -ListName "Documents" -CSVPath "D:\Output\TidemarkKX.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/TidemarkPerformance -ListName "Documents" -CSVPath "D:\Output\TidemarkPerformance.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/TidemarkSOCReadiness -ListName "Documents" -CSVPath "D:\Output\TidemarkSOCReadiness.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/tidemark_engineering -ListName "Documents" -CSVPath "D:\Output\tidemark_engineering.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/tidemark-devops -ListName "Documents" -CSVPath "D:\Output\tidemark-devops.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/ToDos -ListName "Documents" -CSVPath "D:\Output\ToDos.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/TrainingforCompliance -ListName "Documents" -CSVPath "D:\Output\TrainingforCompliance.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/Transmaerica -ListName "Documents" -CSVPath "D:\Output\Transmaerica.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/Trustmark -ListName "Documents" -CSVPath "D:\Output\Trustmark.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/Tupperwareupgrade -ListName "Documents" -CSVPath "D:\Output\Tupperwareupgrade.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/UIinterview -ListName "Documents" -CSVPath "D:\Output\UIinterview.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/UnionPacificTaxImplementation -ListName "Documents" -CSVPath "D:\Output\UnionPacificTaxImplementation.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/UpgradeCampaign -ListName "Documents" -CSVPath "D:\Output\UpgradeCampaign.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/UPS-265Enhancements -ListName "Documents" -CSVPath "D:\Output\UPS-265Enhancements.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/Vale -ListName "Documents" -CSVPath "D:\Output\Vale.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/VertriebDACHMichael -ListName "Documents" -CSVPath "D:\Output\VertriebDACHMichael.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/Vertrieb-longview.com -ListName "Documents" -CSVPath "D:\Output\Vertrieb-longview.com.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/Weyerhaeuser -ListName "Documents" -CSVPath "D:\Output\Weyerhaeuser.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/WorldAcceptance -ListName "Documents" -CSVPath "D:\Output\WorldAcceptance.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/XPO- -ListName "Documents" -CSVPath "D:\Output\XPO-.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/XPOLogistics -ListName "Documents" -CSVPath "D:\Output\XPOLogistics.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/XPOMemoryIssueS87008 -ListName "Documents" -CSVPath "D:\Output\XPOMemoryIssueS87008.csv"
Export-SPOListPermission -SiteURL https://longview365.sharepoint.com/sites/Zimmer -ListName "Documents" -CSVPath "D:\Output\Zimmer.csv"