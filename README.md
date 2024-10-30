## Design and implement a simple API using Flask

For this task, I created a scenario whereby a running club could submit members' race results to a database and then view all the results (including filtered by date). 

### Requirements
To run the API, you will need to install the following libraries: MySQL Connector, requests.  
In addition, create the database (I used mySQL workbench) and edit the config.py file to include your HOST, USER and PASSWORD details.  
You must first run the app.py file to establish a connection with the DB and then run main.py. You should be given the option to input a new result, or, if not, to view results (including by date).

### Files:
config.py : config file  
app.py : endpoints  
main.py : client-side for the three endpoints  
db_utils.py : functions and exception handling  
Runners_DB.sql : database  
init__.py : empty file 


