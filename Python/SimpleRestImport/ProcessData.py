import pandas as pd
from datetime import datetime
import SQLCommands

class processDataFrame:
    ###############Pass url to class on load###########
    def __init__(self,dataFrame):
        self.dataFrame = dataFrame

####################Could add extra methods to output to file ect####################
    def ProcessData(self,dateloaded,soure0,destination):
        braceOpen ="{"
        braceClose="}"
        dtPatteren = '%a, %d %b %Y %H:%M:%S %z'
        df = pd.DataFrame(self.dataFrame)
        sql = SQLCommands.executeSQL()
        trunc = sql.truncateTable(destination)
        RowIn = 0 
        for index, row in df.iterrows():
                LastUpdate = datetime.strptime(row.time_last_update_utc ,dtPatteren)
                NextUpdate = datetime.strptime(row.time_next_update_utc,dtPatteren)
                qry=(f"INSERT INTO {destination}([DateLoaded],[Source0],[Result],[Provider0],[documentation],[TermsOfUse] ,[TimeLastUpdateUTC] ,[TimeNextUpdateUTC] ,[CurrencyBaseCode],[CurrencyCodeName],[CurrencyCodeValue])VALUES({braceOpen}ts'{dateloaded}'{braceClose},'{soure0}','{row.result}','{row.provider}','{row.documentation}','{row.terms_of_use}','{LastUpdate}','{NextUpdate}','{row.base_code}','{row.name}',{row.rates})")
                Isert = sql.insertSQLLong(qry)
                RowIn = RowIn+1
        totRowSTR = str(RowIn)       
        totalWritten = f"RowsWritten {totRowSTR}"    
        return totalWritten

             

                            