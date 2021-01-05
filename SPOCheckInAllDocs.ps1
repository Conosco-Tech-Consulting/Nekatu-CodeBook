#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
  
#PowerShell to Bulk check in all documents
Function CheckIn-AllDocuments([String]$SiteURL)
{
    Try{
        #Setup the context
        $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
        $Ctx.Credentials = $Credentials
 
        #Get the Web
        $Web = $Ctx.Web
        $Ctx.Load($Web)
        $Ctx.Load($Web.Webs)
        $Ctx.ExecuteQuery()
 
        #Get All Lists from the web
        $Lists = $Web.Lists
        $Ctx.Load($Lists)
        $Ctx.ExecuteQuery()
  
        #Prepare the CAML query
        $Query = New-Object Microsoft.SharePoint.Client.CamlQuery
        $Query.ViewXml = "@
        <View Scope='RecursiveAll'>
            <Query>
                <Where>
                    <IsNotNull><FieldRef Name='CheckoutUser' /></IsNotNull>
                </Where>
            </Query>
            <RowLimit Paged='TRUE'>2000</RowLimit>
        </View>"
 
        #Array to hold Checked out files
        $CheckedOutFiles = @()
        Write-host -f Yellow "Processing Web:"$Web.Url
         
        #Iterate through each document library on the web
        ForEach($List in ($Lists | Where-Object {$_.BaseTemplate -eq 101 -and $_.Hidden -eq $False}) )
        {
            Write-host -f Yellow "`t Processing Document Library:"$List.Title
 
                #Batch Process List items 
                Do {
                    $ListItems = $List.GetItems($Query)
                    $Ctx.Load($ListItems)
                    $Ctx.ExecuteQuery()
 
                    $Query.ListItemCollectionPosition = $ListItems.ListItemCollectionPosition
 
                    #Get All Checked out files
                    ForEach($Item in $ListItems)
                    {
                        #Get the Checked out File data
                        $File = $Web.GetFileByServerRelativeUrl($Item["FileRef"])
                        $Ctx.Load($File)
                        $CheckedOutByUser = $File.CheckedOutByUser
                        $Ctx.Load($CheckedOutByUser)
                        $Ctx.ExecuteQuery()
 
                        Write-Host -f Green "`t`t Found a Checked out File '$($File.Name)' at $($Web.url)$($Item['FileRef']), Checked Out By: $($CheckedOutByUser.LoginName)"
 
                        #Check in the document
                        $File.CheckIn("Checked-in By Administrator through PowerShell!", [Microsoft.SharePoint.Client.CheckinType]::MajorCheckIn)      
                        $Ctx.ExecuteQuery()
                        Write-Host -f Green "`t`t File '$($File.Name)' Checked-In Successfully!"
                    }
                }While($Query.ListItemCollectionPosition -ne $Null)
        }
 
        #Iterate through each subsite of the current web and call the function recursively
        ForEach($Subweb in $Web.Webs)
        {
            #Call the function recursively to process all subsites underneaththe current web
            CheckIn-AllDocuments -SiteURL $Subweb.URL
        }
    }
    Catch {
        write-host -f Red "Error Check In Files!" $_.Exception.Message
    }
}
 
#Config Parameters
  
#Setup Credentials to connect
$Cred= Get-Credential
$Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.Username, $Cred.Password)
  
#Call the function: sharepoint online powershell to check in all documents in a Site Collection
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-3mupgrade
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-abbtt2
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-abbott
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-acushnet
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-adtalem
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-adtalemplan
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-aggrowth
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-alliance
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-ameriprise
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-amexpoc
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-amg
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-analytics1
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-analytics2
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-analyticlvc
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-analyticssupport
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-analyticsteam
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-ansys
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-anysys
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-astec
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-taximplementation
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-ateam
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-atni
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-auditprep
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-auditsoc
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-bbou
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-betalongview
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-betriebsrat
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-bluelink1
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-bmo
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-capstone
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-cargill
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-cascades
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-cenovus
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-chanfin
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-cincibell
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-closeandplanwebinar19
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-closedemoenhancements
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-cloudops
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-coherenttax
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-coherenttaxint
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-coinbase
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-comtelligence
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-financedemo
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-convertdraws
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-coretax
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-coreteam
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-cornperfq120
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-coyotelogistics
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-creditsuisse
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-customersuccess
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-customerupgradeteam
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-dailygrind
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-dailygrind2
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-dataqualityimprovement
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-deitmigration
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-demandgeneration
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-designerfortaxtraining
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-dialog2020
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-domenergy
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-domtarcons
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-dover
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-dumbquestions
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-edlifesci
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-elearningkcps
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-emeacsandca
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-encore
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-energizer
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-energytransfer
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-execteam
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-filgo
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-filgosonic
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-fortum
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-frenchteam
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-frontofficelangenfeld
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-gdprgov
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-globalpsteamanalytics
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-hii
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-hiiqcpmimplementation
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-hipaareadiness
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-homeoffice
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-hr
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-hsf
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-huntingtoningallstaximplementation
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-imerysmay2019
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-insightconsolidation
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/longview-insightsoninsightsoftware
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-jw
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-khalixquestions
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-knowledgeexchange
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-learningadmin
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-learningtaxcontentdev
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-learningtree
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-licensing
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-lifefitness
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-lifefitnessconsolidation
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-linkedin
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-lockheed2019
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-lohika1
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-longview
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-longviewanalyticsinformationdesign
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-documentation
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-it
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-longviewlearningdialogtasks
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-learningmaterialpage
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-longviewlohikageneral
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-partners
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-plansupport
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-ui
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-webinars
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-lumberliquidatorsscopingproject
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-lvplandemoenhancements
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-planfeatures
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-lvc5ongoingplan
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-lvcloudadmin1
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-lvcloudadmin2
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-lvcloudgeneral
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-lvcloudprivate
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-lvcloud1
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-lvcloud2
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-lvcloud3
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-lvcloud4
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-lvcloudgrp
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-lvisknowledge
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-mateam
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-manulifejohnhancockexpansion
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-mariadailygrind
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-marketing
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-marketingcalendar
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-marketingteam
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-marquardandbahlstaximplementation
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-medidata
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-meredithinccloud
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-meridianfoundation
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-mmm
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-moogincprospect
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-myteam
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-nationalfuel
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-nationalgas
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-nationwideperformanceengagement
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-newplan
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-newsfeed
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-norbordanalytics
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-norbordfinanceanalyticsopp
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-northamericacsmteam
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-nutrien
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-oateyclose
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-oncallsupportgroup
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-openair
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-orangeloadtestingframework
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-outlookhelp
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-pacificlife
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-penetrationtesting
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-personalprojects
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-pfizer
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-planningsupport
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-platform1
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/longview-policyandprocedures
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-pra2019
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-presales
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-productmanagementanalytics
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-professionalserviceteam
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-pwa
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-proviewtasks
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-ps
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-psdirectors1
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-psemea
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-psmeeting
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-psplanningprocessimprovement
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-ps1
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-qa
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-qualityassurance
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-rafaelsteam
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-releasedocumentationupdate
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-renewableenergygroup
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-resolutefpanalyticspoc
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-resoluteonproject
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-resourcescalingproject
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-robertfamilyholdingsfinancialplanning
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-rollingthunder
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-rooms
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-royalsunalliance
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-rsa
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-salesmarketing
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-sandmp
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-salesemea
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-sanmateo
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-sandyspringbankupgrade
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-sargentotax
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-sbd
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-schenkerlongviewteam
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-scoping
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-scotiabanktaxupgrade
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-securityalerts
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-sfdcupdates
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-sherrit2
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-sherritt
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-sko2020
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-sobsysmergfoundimplement
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-sochipaainterviewschedule
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-socreadiness
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-solutions
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-solutions103
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-solutions104
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-solutions105
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-solutions106
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-starbucks
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv_main
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-sunlife
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-sunlifeplanning
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-support
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-supportgermany
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-t100class
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-t96859
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-tanium
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-taxknowledgesharing
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-taxpm
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-taxpsknowledgesharing
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-taxquickscope
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-teamcore
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-teamrain
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-teamruby
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-ticketingtraining
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-tickingauditrequirements
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-tidemark
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-tidemarkcsclienttemplate
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-tidemarkdemoenhancements
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-tidemarkdevops
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-tidemarkdevops1
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-tidemarkemea
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-tidemarkitsystemserviceintegration
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-tidemarkkx
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-tidemarkperformance
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-tidemarksocreadiness
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-tidemarkengineering
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-tidemarkdevops
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-todos
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-trainingforcompliance
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-transmaerica
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-trustmark
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-tupperwareupgrade
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-utinterview
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-unionpacifictaximplementation
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-upgradecampaign
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-ups265enhancements
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-vale
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-vertriebdachmichael
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-vertrieblongviewcom
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-weyerhaeuser
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-worldacceptance
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-xpo
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-xpologistics
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-xpomemoryissue
CheckIn-AllDocuments -SiteURL https://insightsw.sharepoint.com/sites/lv-zimmer
