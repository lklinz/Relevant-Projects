sub_set = []

def subset_sum(partial_sum, remaining_ints, target):
    if sum(partial_sum) == target:
        global sub_set
        sub_set.append(partial_sum)

    else:
        for int in remaining_ints:

            partial_sum_copy = partial_sum.copy()
            if len(partial_sum_copy) == 0 or partial_sum_copy[-1] < int:
                partial_sum_copy.append(int)
                if sum(partial_sum_copy) <= target: 
                
                    remaining_ints_copy = remaining_ints.copy()
                    remaining_ints_copy.remove(int)
                    subset_sum(partial_sum_copy,remaining_ints_copy,target)
        
subset_sum([], [1, 2, 3, 4, 5, 6, 7], 6)
print('Sub Set Sum',sub_set)