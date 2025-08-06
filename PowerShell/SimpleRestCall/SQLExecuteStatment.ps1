   <#
        Define parameters here 
   
   #> 
param(
        [string] $SQLServer = ""
        ,[string] $SQLDBName = ""
        ,[string] $uid =""
        ,[string] $pword = ""
        ,[string] $SQLQuery = ""
    )

   <#
   Build SQL connection here 
   
   #> 
   $SQLCon = New-Object System.Data.SqlClient.SqlConnection
   $SQLCon.ConnectionString = "Server = $SQLServer; Database = $SQLDBName; User ID = $uid; Password = $pword;"
   $SQLCommand = New-Object System.Data.SqlClient.SqlCommand
   $SQLCommand.CommandText = $SQLQuery
   $SQLCommand.CommandType = [System.Data.CommandType]::Text 
   $SQLCommand.Connection = $SQLCon
   <#
    Try catch block with finally    
   #> 
   try 
    {
        $SQLCon.Open()
        $SQLCommand.ExecuteNonQuery()
    }
   catch [System.Data.SqlClient.SqlException] ,[System.Data.DataException] 
   {
        Write-Host "SQL Error occured $($_.exception.message)"
        Write-Host "SQL Command :$SQLQuery"
   }
   catch 
   {
        Write-Host "Error could not be resovled"
   }
   finally 
   {
        $sqlconn.Close()
   }
  