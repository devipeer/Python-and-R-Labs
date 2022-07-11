# task 1
from enum import unique
from turtle import position
from weakref import KeyedRef


def findPositions(string, *keys):
    positions = dict()
    for key in keys:
        pos = 0
        last_pos = 0
        string2 = string
        for i in range(len(string)):
            pos = string2.find(key)
            if pos != -1:
                positions.setdefault(key, []).append(pos + last_pos)
                string2 = string2[pos+1:]
                last_pos = pos + 1
            else:
                break
    return positions

# def positionsToTupleList(dict):
#     tpl = []
#     for key in dict:
#         for val in dict[key]:
#             tpl.append((val, key))
#     return sorted(tpl)

# def positionsToTupleList_comprehension(dict):
#     tpl = [(val, key) for key in dict for val in dict[key]]
#     return sorted(tpl)

def dictSortedGenerator(dict):
    return ((key, val) for key, val in sorted(dict.items()))

def drawHisto(dict):
    new_dict = dict
    for key, val in dictSortedGenerator(dict):
        print(key, "*"*len(val))

def convertToUnique(ilist):
    return list(set(ilist))

def Jaccard(set_1, set_2):
    return len(set_1 & set_2) / len(set_1 | set_2)

if __name__ == "__main__":
    pos = findPositions("test"*2 + "xD", "a", "e", "s", "x")
    # L = positionsToTupleList(pos)
    # print(L)
    # L = positionsToTupleList_comprehension(pos)
    # print(L)
    # for a, b in dictSortedGenerator({5: 1, 1: 5}):
    #     print(f"k={a}, v={b}")
    #drawHisto(pos)
    print(convertToUnique([1, 2, 1, 2, 6, 7, 6, 9, 9, 9, 10]))
    