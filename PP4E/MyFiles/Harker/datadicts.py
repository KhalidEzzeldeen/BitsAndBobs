
def dataDict(data_map):
    temp = dict()
    for (key, item_type) in data_map:
        temp[key]=eval(item_type)
    return temp

def getDataMap(file, sep=None):
    try:
        data_map = open(file, 'r').readlines()[:-1]
        data_map = [entry[:-1] for entry in data_map]
        sep = data_map[0] if not sep else sep
        data_map = data_map[1:] if not sep else data_map
        data_map = [(entry1, entry2) for entry in data_map\
                    for (entry1, entry2) in entry.split(sep)]
        return data_map
    except IOError:
        return 'file does not exist'
    except:
        return 'something shitty happened'

def saveDataMap(file, sep=':', data_map):
    with open(file, 'w') as f_hand:
        f_hand.write(sep + '\n')
        for entry in data_map:
            f_hand.writeline(sep.join(entry) + '\n')
