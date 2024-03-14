def merge(array_one,array_two):
    temporary_array = []
    while len(array_one) > 0 and len(array_two) >0:
        if array_one[0] > array_two[0]:
            temporary_array.append(array_two[0])
            array_two.remove(array_two[0])
        else:
            temporary_array.append(array_one[0])
            array_one.remove(array_one[0])
    while len(array_one) > 0: 
        temporary_array.append(array_one[0])
        array_one.remove(array_one[0])
    while len(array_two) > 0:
        temporary_array.append(array_two[0])
        array_two.remove(array_two[0])  
    return temporary_array

def mergesort(array):
    array_stored = []
    if len(array) == 1:
        return array
    array1 = []
    array2 = []
    for num in range(len(array)):
        if num < len(array)/2:
            array1.append(array[num])
        else:
            array2.append(array[num])
        array_stored.append(array2)
    array1 = mergesort(array1)

    print(merge(array1,array2))
    while len(array_stored) > 0:
        mergesort(array_stored)
mergesort([6, 5, 5, 7, 4])