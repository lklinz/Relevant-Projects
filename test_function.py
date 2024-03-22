weight_value = {
    1:(11, 4),
2:(7, 1),
3:(18, 48),
4:(18, 19),
5:(5, 2),
6:(7, 30),
7:(20, 7),
8:(15, 30),
9:(5, 6),
10:(18, 12),
11:(17, 8),
12:(11, 3),
13:(20, 12),
14:(3, 23),
15:(10, 33),
16:(3, 22),
17:(3, 48),
18:(2, 23),
19:(18, 36),
20:(7, 9),
21:(7, 40),
22:(1, 30),
23:(9, 30),
24:(11, 49),
25:(19, 27),
26:(17, 4),
27:(10, 29),
28:(17, 48),
29:(5, 31),
30:(6, 17),
31:(3, 23),
32:(7, 6),
33:(12, 44),
34:(4, 5),
35:(7, 15),
36:(9, 50),
37:(9, 11),
38:(5, 38),
39:(16, 8),
40:(9, 8),
41:(16, 42),
42:(20, 40),
43:(3, 13),
44:(3, 12),
45: (18, 28), 
46: (17, 17),
47: (9, 39), 
48: (16, 39), 
49: (13, 37), 
50: (8, 11), 
51: (4, 15), 
52: (8, 47), 
53: (10, 39), 
54: (5, 34), 
55: (9, 12), 
56: (18, 37), 
57: (9, 43), 
58: (18, 8), 
59: (12, 14), 
60: (17, 3), 
61: (9, 49), 
62: (6, 27), 
63: (1, 28), 
64: (17, 32), 
65: (20, 41), 
66: (9, 8), 
67: (20, 14), 
68: (10, 30), 
69: (4, 26), 
70: (3, 4), 
71: (3, 29), 
72: (13, 36), 
73: (6, 37), 
74: (10, 2), 
75: (17, 15), 
76: (2, 46), 
77: (4, 31), 
78: (4, 31), 
79: (11, 33),
80: (13, 49), 
81: (5, 35), 
82: (1, 17), 
83: (5, 40), 
84: (6, 50), 
85: (4, 18), 
86: (20, 9), 
87: (9, 5), 
88: (10, 13), 
89: (10, 50), 
90: (13, 24), 
91: (9, 29), 
92: (1, 30), 
93: (20, 16), 
94: (11, 3), 
95: (18, 25), 
96: (13, 32), 
97: (16, 22), 
98: (11, 3), 
99: (7, 35), 
100: (1, 27)
}

def getting_value(items_list):
    value = 0
    for weight in items_list:
        value += weight_value[weight][1]
    return value
def getting_weight(items_list):
    weight = 0
    for w in items_list:
        weight += weight_value[w][0]
    return weight

import random

def knapsack(capacity):
    
    '''INITIALIZE'''

    parent_knapsack = []
    item = 1
    parent_knapsack_weight = getting_weight(parent_knapsack)
    while parent_knapsack_weight <= capacity:
        parent_knapsack.append(item)
        parent_knapsack_weight = getting_weight(parent_knapsack)
        if parent_knapsack_weight > capacity:
                parent_knapsack.remove(item)
                parent_knapsack_weight = getting_weight(parent_knapsack)
                break
        item +=1
    
    print('Initial',parent_knapsack,parent_knapsack_weight)

    parent_knapsack_value = getting_value(parent_knapsack)

    for gen in range(1,21):

        '''Assuming the best offspring is the clone of the parent'''
        best_offspring = parent_knapsack
        best_offspring_value = parent_knapsack_value

        '''creating 10 generation for each offspring'''

        for offspring in range(10):

            '''MUTATE'''
            picked = random.choice(best_offspring)

            best_offspring_copy = best_offspring.copy()
            best_offspring_copy.remove(picked)
            best_offspring_copy.append(random.randint(1,100))
            candidate_best_offspring_value = getting_value(best_offspring_copy)
            candidate_best_offspring_weight = getting_weight(best_offspring_copy) 

            '''SELECT'''

            if candidate_best_offspring_value > best_offspring_value and candidate_best_offspring_weight <= capacity:
                best_offspring_value = candidate_best_offspring_value
                best_offspring = best_offspring_copy
                parent_knapsack_weight = candidate_best_offspring_weight
        
        parent_knapsack = best_offspring
        parent_knapsack_value = best_offspring_value


        print(f'Generation {gen} knapsack are items: {parent_knapsack} worth {parent_knapsack_value} value and {parent_knapsack_weight} weight' )

knapsack(300)
