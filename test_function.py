base_dict = {
        1:1,
        2:2,
        3:4,
        4:8
    }
def colored_blocks(n):
    global base_dict 
    if n in base_dict:
        return base_dict[n]
    else:
        tiles_arranging = colored_blocks(n-1) + colored_blocks(n-2) + colored_blocks(n-3) + colored_blocks(n-4)
        base_dict[n] = tiles_arranging
        return tiles_arranging
print(colored_blocks(50))