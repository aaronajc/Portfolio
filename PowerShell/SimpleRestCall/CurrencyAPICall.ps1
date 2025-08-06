param(
        [string] $SQLServer = ""
        ,[string] $SQLDBName = ""
        ,[string] $uid =""
        ,[string] $pword = ""
    )

<#
    First Clear down the table from the last run 
#>
$SQLTruncate = "TRUNCATE TABLE [StagingAPI].[ExchangeRates]"    
.\SQLExecuteStatment.ps1 -SQLServer $SQLServer -SQLDBName $SQLDBName -uid $uid -pword $pword -SQLQuery $SQLTruncate
<#
    Call uri 
#>    

$Uri = "https://open.er-api.com/v6/latest/GBP"

$response = Invoke-RestMethod -Uri $Uri -Method 'Get'
$sdate =Get-Date -Format "yyyy-MM-dd HH:mm:ss"

<#
    Loop through response and update server 
#> 
foreach($item in $response)
{
   $provider = $item.provider
   $result = $item.Result
   $documentation = $item.documentation
   $termsOfUse = $item.terms_of_use
   $TimeLastUpdateUTC =Get-Date  $item.time_last_update_utc -Format "yyyy-MM-dd HH:mm:ss"
   $TimeNextUpdateUTC =Get-Date $item.time_next_update_utc -Format "yyyy-MM-dd HH:mm:ss"
   $CurrencyBaseCode = $item.base_code #.ToString()
}

foreach($v in $response.rates.psobject.Properties)
{
   $CurrencyCodeName = $v.name
   $CurrencyCodeValue = $v.value
   $SQLCommand = "INSERT INTO [StagingAPI].[ExchangeRates]([DateLoaded],[Source0],[Result],[Provider0],[documentation],[TermsOfUse],[TimeLastUpdateUTC],[TimeNextUpdateUTC],[CurrencyBaseCode],[CurrencyCodeName],[CurrencyCodeValue]) VALUES({ts'$sdate'},'$Uri','$result','$provider','$documentation','$termsOfUse',TRY_CAST('$TimeLastUpdateUTC'AS DATE),TRY_CAST('$TimeNextUpdateUTC'AS DATE),'$CurrencyBaseCode','$CurrencyCodeName',$CurrencyCodeValue)"
   #"INSERT INTO [StagingAPI].[ExchangeRates]([DateLoaded],[Source0],[Result],[Provider0],[documentation],[TermsOfUse],[TimeLastUpdateUTC],[TimeNextUpdateUTC],[CurrencyBaseCode],[CurrencyCodeName],[CurrencyCodeValue]) VALUES($sdate,'$Uri','$result','$provider','$documentation','$termsOfUse','$TimeLastUpdateUTC','$TimeNextUpdateUTC','$CurrencyBaseCode','$CurrencyCodeName',$CurrencyCodeValue)"
   .\SQLExecuteStatment.ps1 -SQLServer $SQLServer -SQLDBName $SQLDBName -uid $uid -pword $pword -SQLQuery $SQLCommand
}




#$values.psobject.properties.name
#$values.psobject.properties.value
#$values