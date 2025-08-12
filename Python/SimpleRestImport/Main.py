######################################################
######Get API Return Json String or error#############
######################################################
import GetApiData as api
import pandas as pd
import ProcessData as da 
import datetime 

####################################################
################Variables Here######################
####################################################
url = "https://open.er-api.com/v6/latest/GBP"
#url = "x" #Uncomment to raise error 
datepatteren = "%Y-%m-%d %H:%M:%S"
destination = "[StagingAPI].[ExchangeRates]"
loadDate = datetime.datetime.now().strftime(datepatteren)

####################################################
###################Program##########################
####################################################
request = api.GetApi(url) #Call api and return the results as a string 
rjson = request.readAPi() 
if type(rjson)==str: # Check if error or data frame
    print(rjson)
else : 
    df = pd.DataFrame(rjson) #add results to a data frame 
    r = da.processDataFrame(df) #call process data class 
    strout = r.ProcessData(loadDate,url,destination)  
    print(strout)
    


