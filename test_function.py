def merge(array_one,array_two):

    tempo_array = []
    flag1 = flag2 = 0

    while len(array_one) > flag1 and len(array_two) > flag2:
        if array_one[flag1] > array_two[flag2]:
            tempo_array.append(array_two[flag2])
            flag2 += 1
        else:
            tempo_array.append(array_one[flag1])
            flag1 += 1

    tempo_array.extend(array_one[flag1:])
    tempo_array.extend(array_two[flag2:])

    return tempo_array


def mergesort(array):

    if len(array) == 1:
        return array
    mid = len(array) //2
    array1 = array[:mid]
    array2 = array[mid:]



    array1 = mergesort(array1)
    array2 = mergesort(array2)
    return merge(array1,array2)

mergesort([6, 5, 5, 7, 4, 8, 3, 5, 1, 2, 9])
