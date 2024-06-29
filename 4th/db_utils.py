import mysql.connector
from config import USER, PASSWORD, HOST

class DbConnectionError(Exception):
    pass

def _connect_to_db(db_name):
    cnx = mysql.connector.connect(
        host=HOST,
        user=USER,
        password=PASSWORD,
        auth_plugin='mysql_native_password',
        database=db_name
    )
    return cnx

def all_results():
    RESULT = [] #setting up an empty list
    try:
        db_name = 'runners'
        db_connection = _connect_to_db(db_name)
        cur = db_connection.cursor()
        print("Connected to DB: %s" % db_name)

        query = """
            SELECT *
            FROM results
            """

        cur.execute(query)

        db_response = cur.fetchall()  # this is a list containing db records where each record is a tuple

        for r in db_response: #converting tuples to a list
          list.append(RESULT, list(r))
          RESULT[-1][-1] = str(RESULT[-1][-1])
        cur.close()

    except Exception:
        raise DbConnectionError("Failed to read data from DB")

    finally:
        if db_connection:
            db_connection.close()
            print("DB connection is closed")

    return RESULT #returning the list (now filled)

def get_daily_results(date):
    result = []
    try:
        db_name = 'runners'
        db_connection = _connect_to_db(db_name)
        cur = db_connection.cursor()
        print("Connected to DB: %s" % db_name)

        query = """
            SELECT runnerName, date, distance, time
            FROM results
            WHERE date = '{}'
            """.format(date)

        cur.execute(query)

        db_response = cur.fetchall()  # this is a list with db records where each record is a tuple
        for r in db_response:
          list.append(result, list(r))
          result[-1][-1] = str(result[-1][-1])
        cur.close()
    except Exception:
        raise DbConnectionError("Failed to read data from DB")

    finally:
        if db_connection:
            db_connection.close()
            print("DB connection is closed")

        return result

def submit_result(runnerName, date, distance, time):
    try:
        db_name = 'runners'
        db_connection = _connect_to_db(db_name)
        cur = db_connection.cursor()
        print("Connected to DB: %s" % db_name)

        query = """
            INSERT INTO  results
                (runnerName,
                date,
                distance,
                time) 
            VALUES (
            '{runnerName}',
            '{date}',
            '{distance}',
            '{time}')
            """.format(runnerName=runnerName, date=date, distance=distance, time=time)

        cur.execute(query)
        db_connection.commit()
        cur.close()

    except Exception:
        raise DbConnectionError("Failed to read data from DB")

    finally:
        if db_connection:
            db_connection.close()
            print("DB connection is closed")
