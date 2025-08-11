import io
import datetime
import SQLCommands
from os import path
#file path 
filePath = "./sleep_score.csv"
#Dest table 
destTable = "[StagingFitBit].[UnformattedData]"
#Get file name 
sourceFile = path.basename(filePath)
#Get StartDate 
loadDate = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
#print(f"FileName:{sourceFile}, LoadDate:{loadDate}")
ln = 1

#Define SQL Bits 
table = "[StagingFitBit].[UnformattedData]"
query = f"SELECT [RowID],[DateLoaded],[Source0],[RowData],[RowHash],[RowType] FROM [StagingData].{table}"
sql = SQLCommands.executeSQL(query)
trunc = sql.truncateTable(table)
braceOpen ="{"
braceClose="}"
print(trunc)

#open file stream 
binobject = open(filePath,"+r")
for line in binobject:
        if ln > 1:
         rowType = "D"
        else:
         rowType = "H"
        sqlinsert = sql.insertSQLLong(f"INSERT INTO {destTable}([Source0],[DateLoaded],[RowType],[RowData])Values('{sourceFile}',{braceOpen}ts'{loadDate}'{braceClose},'{rowType}','{line.replace(",","|")}')")
        #print(sqlinsert)
        #print(f"INSERT INTO {destTable}([Source0],[DateLoaded],[RowType],[RowData])Values('{sourceFile}',{braceOpen}ts'{loadDate}'{braceClose},'{rowType}','{line.replace(",","|")}')")
        ln = ln+1
#Close File Stream
binobject.close()

#############Print Table results 
results = sql.selectSQL()
for r in results:
    print(r)
