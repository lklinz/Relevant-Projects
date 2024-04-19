def getting_info(name_file,distance_file):

    '''reading name file into list of string'''

    with open(f'{name_file}','r') as readfile:
        cities_list = readfile.read().splitlines()

    '''reading distance file into list of float'''

    with open(f'{distance_file}') as readfile:
        distance_str = readfile.read()
        distance_str = distance_str.split()
    distance_flt = []
    for string in distance_str:
        string = float(string)
        distance_flt.append(string)

    '''creating dictionary (city i,city j):distance from i to j'''

    names_distance = {}
    flag_dist = 0
    for name1 in cities_list:
        for name2 in cities_list:
            names_distance[name1,name2] = distance_flt[flag_dist]
            flag_dist += 1
    return cities_list,names_distance

''' calculate the distance of a route'''

def getting_distance(name_list,dict):
    distance = 0
    for i in range(len(name_list)):
        if i == (len(name_list)-1):
            distance += dict[name_list[i],name_list[0]]
        else:
            distance += dict[name_list[i],name_list[i+1]]
    return round(distance,1)

import random

def tsp_mutation(name_file, distance_file):
    
    '''INITIALIZATION'''

    '''creating parent route and dictionary of city names and distances'''

    parent_route, names_distance = getting_info(name_file,distance_file)
    parent_distance = getting_distance(parent_route,names_distance)
    stagnation = 0
    solution_s = {}

    '''TERMINATE'''

    '''if encoutering 5 stagnations, escape the while loop'''
    while stagnation < 5:

        ''' assuming best offspring is parent route and distance'''

        best_offspring_route = parent_route
        best_offspring_distance = parent_distance

        '''MUTATE'''

        for offspring in range(10):

            '''randomly choose 2 city from parent route'''

            picked_city1 = random.choice(parent_route)

            '''avoid having duplicate city names'''

            ''' making copy for adjustion'''

            best_offspring_route_copy = parent_route.copy()
            best_offspring_route_copy.remove(picked_city1)
            best_offspring_route_copy.append(picked_city1)
            candidate_offspring = getting_distance(best_offspring_route_copy,names_distance) 

            '''SELECT'''

            '''update the best offspring if meeting the condition'''

            if candidate_offspring < best_offspring_distance:
                best_offspring_route = best_offspring_route_copy
                best_offspring_distance = candidate_offspring

        '''encounter stagnation and mutate 3 times away from it'''

        if best_offspring_distance == parent_distance:

            '''update stagnation and solution_s dict'''

            stagnation += 1
            solution_s[tuple(best_offspring_route)] = best_offspring_distance 

            '''INITIALIZE'''

            stagnation_parent = best_offspring_route

            '''mutate three times'''
            
            for s in range(3):

                picked_city2 = random.choice(stagnation_parent)

                stagnation_copy = stagnation_parent.copy()
                stagnation_copy.remove(picked_city2)
                stagnation_copy.append(picked_city2)

                stagnation_distance = getting_distance(stagnation_copy,names_distance)

            '''update parent route and distance accepting the worse solution after 3 times of mutation'''

            parent_route = stagnation_copy
            parent_distance = stagnation_distance
        
        else:
            parent_route = best_offspring_route
            parent_distance = best_offspring_distance
    
    '''find the shortest route amongst stagnation and its distance'''
   
    for key in solution_s.keys():
        if solution_s[key] == min(solution_s.values()):
            print(f'For mutation, TSP is {key} and {solution_s[key]} in distance')


'''create a global variable to assign the shortest route'''
tsp = []

def tsp_backtracking(name_file,distance_file):

    '''reading the text files into meaningful lists and make the dictionary with names and distance as a global variable'''

    global names_distance
    remaining_c,names_distance = getting_info(name_file,distance_file)

    ''' create a partial route list with the last city in the remaining list'''

    partial_route = []
    partial_route.append(remaining_c.pop())

    '''checking all the possible routes starting with each city in the city list'''

    for c in remaining_c:

        '''creating and updating the copy of partial route and remaining_c'''

        partial_route_copy = partial_route.copy()
        partial_route_copy.insert(0,c)

        remaining_copy = remaining_c.copy()
        remaining_copy.remove(c)

        tsp_recursion(partial_route_copy,remaining_copy)
    
    '''print the best tsp with its distance'''
    
    print(f'For backtracking, TSP is {tsp} and {tsp_distance} in distance')

def tsp_recursion(partial_route,remaining_cities):
    
    global tsp

    '''checking the conditions and update the tsp'''

    if len(remaining_cities)==0 and (getting_distance(partial_route,names_distance) <= getting_distance(tsp,names_distance) or len(tsp)==0):
            tsp = partial_route
            global tsp_distance
            tsp_distance = getting_distance(tsp,names_distance)

    else:

        '''looping through the remaining city in the remaining_c list'''

        for city in remaining_cities:

            '''creating and updating the copy of partial route and remaining_city'''

            partial_route_copy = partial_route.copy()
            partial_route_copy.insert(-1,city)

            remaining_cities_copy = remaining_cities.copy()
            remaining_cities_copy.remove(city)

            tsp_recursion(partial_route_copy,remaining_cities_copy)


def tsp_greedy(name_file,distance_file):

    '''creating meaningful city list and dictionary to obtain distance between two cities'''

    city_names,names_distance = getting_info(name_file,distance_file)

    tsp_route = []

    '''set each city as the starting city'''

    for city in city_names:

        candidate_tsp = []
        candidate_tsp.append(city)

        '''greedily adding the remaining cities to the candidate'''

        for c in range(1,len(city_names)):

            min_distance = 0
            flag = 0

            for key in names_distance.keys():

                '''prevent invalid solution '''

                if key[0] == candidate_tsp[-1] and key[-1] not in candidate_tsp:
                    flag += 1
                    if names_distance[key] < min_distance or min_distance == 0:
                            min_distance = names_distance[key]
                            chosen_city = key[1]

                ''' break out of the loop if done with all the possible key'''
                if flag == len(city_names)-1:
                    break

            candidate_tsp.append(chosen_city) 
        
        '''update the tsp_route if candidate has shorter distance'''

        if getting_distance(candidate_tsp,names_distance)<getting_distance(tsp_route,names_distance) or len(tsp_route) == 0:
                tsp_route = candidate_tsp
                tsp_distance = getting_distance(candidate_tsp,names_distance)

    print(f'For greedy, TSP is {tsp_route} with {tsp_distance} in distance') 

tsp_greedy('thirty_cities_names.txt','thirty_cities_dist.txt')
print()
tsp_mutation('thirty_cities_names.txt','thirty_cities_dist.txt')
print()
tsp_backtracking('seven_cities_names.txt','seven_cities_dist.txt')
