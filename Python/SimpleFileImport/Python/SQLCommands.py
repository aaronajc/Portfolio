from os import getenv
from dotenv import load_dotenv
from pymssql import connect
from pymssql import _mssql
from pymssql import exceptions
load_dotenv()

class executeSQL:



    def __init__(self,query):
    #Load values form env 
      serv = getenv("serv") 
      db = getenv("db")
      usr = getenv("usr")
      pword = getenv("pword")
      #Define connect variable.... 
      self.dbc = connect(server=serv,database=db,user=usr,password=pword)
      self.query = query
    
#execute SQL statment   
    def selectSQL(self):
        dbc = self.dbc 
#Begin try here 
        try:            
            with dbc.cursor() as cursor:
                cursor.execute(self.query)
                results = cursor.fetchall()
                return results
#begin catch here 
        except Exception as err:
            dbc.rollback()
            raise err 

#Insert SQL Data 
    def insertSQL(self,rows,tableName):
        dbc = self.dbc
        fieldNames = rows[0].keys()
        fieldNamesStr = ', '.join(fieldNames)
        placeholderStr = ','.join('?'*len(fieldNames))
        insertSQL = f'INSERT INTO {tableName}({fieldNamesStr}) VALUES ({placeholderStr})'
        saved_autocommit = dbc.autocommit
        try:
            with dbc.cursor() as cursor:
                dbc.autocommit = False
                tuples = [ tuple((row[fieldName] for fieldName in fieldNames)) for row in rows ]
                cursor.executemany(insertSQL, tuples)
                cursor.commit()
        except Exception as exc:
            cursor.rollback()
            raise exc
        finally:
            dbc.autocommit = saved_autocommit
    
#Truncate SQL table 
    def truncateTable(self,tableRef):
        dbc = self.dbc
        trunQry = f'TRUNCATE TABLE {tableRef}'
        try:
            with dbc.cursor() as cursor:
                cursor.execute(trunQry)
                dbc.commit()
                return f"Table {tableRef} Truncated" 
        except _mssql.MSSQLDatabaseException as edb:
            return(f"Database Excepticption {edb.message}")
        except _mssql.MSSQLDriverException as edr:
            return(f"Database Excepticption {edr.message}")
        except _mssql.MSSQLException as exr:
            return f"Could Not truncate {exr.with_traceback}"
        except Exception as gex:
            return f"Could Not resolve truncate error {trunQry}"
            raise err 

#Insert SQL Data 
    def insertSQLLong(self,insertStmt):
        dbc = self.dbc
        try:
            with dbc.cursor() as cursor:
                cursor.execute(insertStmt)
                dbc.commit()
                return "Record Inserted"
        except _mssql.MSSQLDatabaseException as edb:
            return(f"Database Excepticption {edb.message}")
        except _mssql.MSSQLDriverException as edr:
            return(f"Database Excepticption {edr.message}")
        except _mssql.MSSQLException as exr:
            return f"Could Not Insert {exr.with_traceback}"
        except Exception as gex:
            dbc.rollback()
            return f"Could Not resolve insert error{gex.with_traceback} error {insertStmt}"
            
