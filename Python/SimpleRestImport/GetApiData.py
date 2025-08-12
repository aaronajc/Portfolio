######################################################
######Get API Return Json String or error#############
######################################################
import requests
import json
import pandas as pd

class GetApi:

    ###############Pass url to class on load###########
    def __init__(self,url):
        self.url = url 

#####################Could add extra methods to post data to URL########################
    def readAPi(self):
        try:
            response = requests.get(self.url)
            rjson =json.loads(response.text)
            return rjson
        except requests.RequestException as rx:
            return f"Request Error {rx}" 
        except Exception as ex:
            return f"Could not resolve error {ex}"