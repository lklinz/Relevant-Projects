sorted_array = []
def selection_recursive(array):
    max_flag = array[0]
    for num in array:
        if num > max_flag:
            max_flag = num
    add = array.count(max_flag)
    for i in range(add):
        array.remove(max_flag)
        sorted_array.insert(0,max_flag)
    while len(array) != 0:
        return selection_recursive(array)
    print(sorted_array)
selection_recursive([6, 5, 5, 7, 4, 8, 3, 5, 1, 2, 9])
