## Design and implement a simple API as done in class.

For this task, I created a scenario whereby a running club wanted to be able to submit members' race results to a database and then view all the results (including filtered by date). **You can find the relevant files inside the '4th' directory.**

In order to run the API, you will need to install the following foreign libraries: MySQL Connector, requests.
You will need to create the database in mySQL and edit the config.py file to include your HOST, USER and PASSWORD details (further instructions included in the file notes).
You must first run the app.py file to establish a connection with the DB and then run main.py. 
You should be given the option to input a new result, or, if not, to view results (including by date). 


You should:
+ Implement 2 API endpoints with appropriate functionality **--> in the app.py file, endpoints include /results and /results/<date>.**
+ Implement one additional endpoint of your choice (can be POST or GET but with a different implementation) **--> /submit**
+ Implement client-side for each of the 3 API endpoints you have created. **--> see main.py**
+ Create a MySQL database with at least 1 table **--> see results table in runners DB**
+ Have a config file (do not leave your private information here) **--> config.py**
+ Have db_utils file and use exception handling **--> see db_utils.py**
+ Use appropriate SQL queries to interact with the database in your Flask application, and demonstrate at least two different queries. **--> SELECT * FROM results, SELECT runnerName, date, distance, time FROM results WHERE date = '{}'**
+ In main.py have a run() function/call the functions to simulate the planned interaction with the API. **--> main.py**
+ Have correct but minimal imports per file **-> throughout**
+ Document how to run your API in a markdown file including editing the config file, any installation requirements up until how to run the code and what is supposed to happen. **--> see above.** 
+ Submit in GitHub as a Pull Request
