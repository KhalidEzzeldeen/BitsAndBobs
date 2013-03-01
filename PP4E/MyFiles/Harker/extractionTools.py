import sys, os

def DBExtractPI(file_path,Dir):
    ##Basic loading:
    with open(file_path,'r') as f1:
        tokens = f1.read().split('n')
    if tokens[-1]==' ': tokens = tokens[:-1]

    headDict00 = getReverseDict(getHeaderDict(file00))
    headDict01 = getReverseDict(getHeaderDict(file01))
    locDict = getCatLocations(tokens[0], headDict00)
    locDict = getCatLocations(tokens[1], headDict01, locDict)

    if 'NEW POINTS' not in locDict.keys():
        print "No way to determine which entries are terms."

    #Get info corresponding to desired fields from raw data
    Info = []
    for entry in tokens[2:]:
        Info.append(processEntry(entry, locDict))
        
            
##        if len(entry)>1:
##            #Check if termed or not, check if blank or not
##            temp = GetPplInfo(entry,locDict)
##            temp = CheckTermBlank(temp,locDict)
##            if temp != '':
                

def processEntry(entry, locDict):
    entry = re.split("\t",entry)
    entry = ["".join(re.split("\x00",sub_entry)).strip('"')\
                 for sub_entry in entry]
    if len(entry)>1:
        return getInfo(entry, locDict)
    else: return None

def getInfo(entry, locDict):



def getHeaderDicts(file):
    temp = open(file, 'r').readlines()[-1]
    temp = [entry[:-1] for entry in temp]
    headDict = {}
    for entry in temp:
        key, names = entry.split('=')
        if names!='EMPTY':
            headDict[key] = names.split('~')
    return headDict

def getReverseDict(inDict):
    outDict = {}
    for key in inDict.keys():
        for entry in inDict[key]:
            outDict[entry]=key
    return outDict
        
def getCatLocations(headlist, headDict, posDict={}):
    for entry in headlist:
        if entry in posdict.keys():
            posDict[headDict[entry]].append(headlist.index(entry))
        else:
            posDict[headDict[entry]] =\
                                 list(set([headlist.index(entry)])
    return posDict
        
