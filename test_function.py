tilings = []

def generate_tilings(partial_tiling, length):
    if sum(partial_tiling) == length:
        global tilings
        tilings.append(partial_tiling)
    
    elif sum(partial_tiling) > length:
        return False

    else:

        for tile in range(1,length+1):

            partial_tiling_copy = partial_tiling.copy()
            partial_tiling_copy.append(tile)

            generate_tilings(partial_tiling_copy,length)
            
generate_tilings([],4)
print('Found tilings',tilings)