# This is client-side.
import requests
import json

def all_results2():
    result = requests.get(
        'http://127.0.0.1:5001/results',
        headers={'content-type': 'application/json'}
    )
    return result.json()

def display_results(records):
    print("{:<15} {:<15} {:<15} {:<15} ".format(
        'NAME', 'date', 'distance', 'time'))
    for item in records:
        print("{:<15} {:<15} {:<15} {:<15} ".format(
            item[0], item[1], item[2], item[3] #using list indices: see all_results() in utils file.
        ))

def add_new_result(runnerName, date, distance, time):
    submission = {
        "runnerName": runnerName,
        "date": date,
        "distance": distance,
        "time": time,
    }
    headers ={'content-type': 'application/json'}
    result = requests.post(
        'http://127.0.0.1:5001/submit',
        headers=headers,
        data=json.dumps(submission)
    )
    print(result)
    return result.json()

def get_results_by_date(date):
    result = requests.get(
        'http://127.0.0.1:5001/results/{}'.format(date),
        headers={'content-type': 'application/json'}
    )
    return result.json()

#Function to simulate planned interaction with the API
def run():

    print('############################')
    print('Welcome to the Running Club.')
    print('############################')
    print()
    data = all_results2()
    variable = input('Do you want to input a new result (y/n)? ')
    print()
    if variable == 'n':
        var2 = input("Do you want to view results (y/n)? ")
        if var2 == "y":
            var3 = input("Do you want to view results from a specific date (y/n)? ")
            if var3 == "y":
                date_as_str = input("Which date do you wish to view (yyyy-mm-dd)? ")
                print(get_results_by_date(date_as_str))
            elif var3 == "n":
                print(display_results(data))
            else:
                print("Invalid input - enter y or n. ")
        elif var2 == 'n':
            print("We can't help you, sorry. ")
        else:
            print("Invalid input, sorry. ")

    elif variable == "y":

        try:
            runnerName = input("What is the runner's name? ")
            date = input("When did the race take place (yyyy-mm-dd)? ")
            distance = input("What was the race distance? ")
            time = input("What was their time (hh:mm:ss)? ")
            add_new_result(runnerName, date, distance, time)

        except json.decoder.JSONDecodeError as exc: #exception handling when database constraints not met.
            print("Error: Runner's name and/or race distance missing.")

        else:
            print("Result successfully added.")
    else:
        print("Response not valid, try again.")

if __name__ == '__main__':
    run()




