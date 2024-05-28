#This programme allows you to interrogate the UK Govt's 2021 census data; specifically, the population totals (inc. by sex) at Local Authority level.

import json, requests, pprint, random #requests is not a native library. It must be installed, which in pycharm can be done via settings/python interpreter, rather than through the commandline

# Download JSON data from gov.uk's 2021 census API.

url = ('https://api.beta.ons.gov.uk/v1/datasets/TS008/editions/2021/versions/1/census-observations')
response = requests.get(url)
response.raise_for_status()
# Downloaded data stored in response.text
json_as_python = json.loads(response.text)

##print(json_as_python.keys())  #I used this to find out which key I wanted to query ('observations').

census_obs = (json_as_python['observations']) # this is the Local Authority data I want to work with.

file_object = open("print_results.txt", "w") #creating/opening file to write results to

#Now, transform the data:
# Transforming my data into a usable dictionary: census_obs is a dictionary for which each key ('dimensions') contains a list of three items (first two of which are dictionaries)
la_data = {}  #creating an empty dictionary
for data_point in census_obs:
    local_authority = data_point['dimensions'][0]['option'] #Get the name of the local authority
    sex_category = data_point['dimensions'][1]['option'] #Get the sex (m or f) the data belongs to

    if local_authority in la_data.keys():  # is 'option' (LA name) already in la_data's keys?
        la_data[local_authority][sex_category] = data_point['observation'] #If the LA name is found, it must already exist as a dictionary, so add the data to it as a k-v pair
    else:
        la_data[local_authority] = {sex_category: data_point['observation']} #if the LA name is not found, create it as a dictionary and add the data as a k-v pair

for item in la_data:
  la_data[item]['total_pop'] = la_data[item]['Female'] + la_data[item]['Male'] #adding total population data by summing.

##pprint.pprint(la_data) #to check data transformation is correct.

#User inputs etc:
def random_la():
    all_la = list(la_data.keys()) #this brings the keys (Local Authorities) back as a list.
    random_number = random.randint(0, len(all_la))
    return all_la[random_number] #return an item from the list, randomly

la_data_to_print = []
delimiter = ", "

while True:  #This while loop allows the user to interrogate the data for multiple LAs

    l_a = input("Which Local Authority's 2021 population data do you want to learn about? ")

    if l_a in la_data:
        print("Yes, we have the data for {}.".format(l_a))
        la_data_to_print.append(l_a)

    else:
        l_a = str(random_la())
        print("Sorry, we don't have that data. You can learn about this one instead: {}".format(l_a))
        la_data_to_print.append(l_a)

    while True: #This while loop ensures the user has made a valid input.

        population = input("Which population stats do you want? Male (m), female (f) or total (total)? ")

        if population in ('m', 'f', 'total'):

            if population == "m":
                male_data = la_data[l_a]['Male']
                with open("print_results.txt", "a") as f: #amending file with results
                    print("There are {} men in {}.".format(male_data, l_a), file=f)

            elif population == 'f':
                female_data = la_data[l_a]['Female']
                with open("print_results.txt", "a") as f: #amending file with results
                    print("There are {} women in {}.".format(female_data, l_a), file=f)

            else:
                total_data = la_data[l_a]['total_pop']
                with open("print_results.txt", "a") as f: #amending file with results
                    print("There are {} people in {}.".format(total_data, l_a), file=f)

            break

        else:
            print("Try again.")

        continue

    another_go = input("Do you want to learn about another Local Authority (y/n)? ")
    if another_go == "y":
        continue

    else:
        break

join_la_data_to_print = delimiter.join(la_data_to_print)

print("Thank you. You learned about the following Local Authorities: {}. You can find out more at: https://{} .".format(join_la_data_to_print, url[17:27])) #demonstrating string slicing