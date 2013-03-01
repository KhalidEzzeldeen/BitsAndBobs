import sys, os, re
global Delim
Delim="~"
#
#
#This function is responsible for creating the External
#Key List used for updating the database.  The file path should
#to the .txt file containing the current manifestation of the DB
#Uee to create the file of keys for the Database to be
#used to check new entries against externally.
def KeyFileMaker(in_file_path,out_file_dir,Delim):
    KeyList = []
    KeyLoc = [0,1,3,4,5]
    ##Get info from current db, as .txt, with Delim
    f1 = open(in_file_path)
    for line in f1:
        raw = re.split(Delim,f1.next())
        NewKey = []
        if len(raw)>1:
            for Key in KeyLoc:
                NewKey.append(raw[Key])
            KeyList.append(NewKey)
    f1.close()
    #Create phone list and email list, sep.
    #CAUTION: This over-writes existing files!!!
    f2P = open(out_file_dir+"KeyPhoneList.txt",'w')
    f2E = open(out_file_dir+"KeyEmailList.txt",'w')
    ##Add address file as well...
    for Entry in KeyList:
        if Entry[1]!='' and Entry[3]!='':
            f2P.write(Entry[0]+Delim+Entry[1]+\
                      Delim+''.join(re.split("-",Entry[3]))+"\n")
            if Entry[4]!='':
                f2P.write(Entry[0]+Delim+Entry[1]+\
                      Delim+''.join(re.split("-",Entry[4]))+"\n")
        if Entry[2]!='':
            f2E.write(Entry[0]+Delim+Entry[2]+"\n")
    f2P.close()
    f2E.close()
#
#
#Checks to see if newly acquired data pertains to indivs
#already in the database, or if the individual needs to be
#added to the database
#MIL is the path for the Market Index List
def KeyCheckNew(new_key_list,FileDir,KeyTypeList,MILPath):
    #Define the ML,NML
    #MatchList is list of IDs for matched cases
    #NonMatchList is list of IDs with data not in at least one key list
    MatchList=[]
    NonMatchList=[]
    #Assign IDs to new data lacking IDs, get Omega
    Omega = GetMaxID(FileDir,KeyTypeList)
    Omega = max([int(Omega),max(int(entry[0][0]) for entry in new_key_list)])
    Omega=Omega+1
    new_key_list = IDAssign(new_key_list,Omega)
    Omega=Omega+1
##    print len(set(entry[0][0] for entry in new_key_list))
##    print len(new_key_list)
    #Get list of markets in new_data
    print "Obtaining list of Markets present in data: "
    MarketList = sorted(set(int(k[-1][0]) for k in new_key_list))
    print MarketList
    print "\nSearching current database by market for existing individuals:  "
    #By market, search for matching entries:
    tot = 0
    for Market in MarketList:
        old = []
        new = []
        print "Searching Market " + str(Market)
        #Get new_key_list in market
        newKeys=[kk for kk in new_key_list if int(kk[-1][0])==Market]
##        print len(newKeys)
        tot = tot+len(newKeys)
        curMarIDs = GetIDsMarket(Market,MILPath)
        #Create the current market Key list
        for KeyType in KeyTypeList:
            MLT,NMLT = CompareKeys(newKeys,KeyType, \
                        GetKeysMarket(curMarIDs,KeyType,FileDir))
            old = list(set([entry[0] for entry in MLT]+old))
            new = list(set([entry[0] for entry in NMLT if entry]+new))
            MatchList.extend(MLT)
            NonMatchList.extend(NMLT)
        print "There were "+str(len(old))+" matched people and "+\
              str(len(new))+\
              " instances of\nnew information found."
##        print len(MatchList)
##        print len(NonMatchList)
        print "\n"
    MatchList = [MatchList[[kk[0] for kk in MatchList].index(ID)]\
             for ID in set(entry[0] for entry in MatchList)]
    #Reassign IDs in new_key_list and NML based on findings from MatchList
    print "\nUpdating new_key_list IDs. Watch for errors!"
    if new_key_list!=[]:
        new_key_list=IDUpdate(new_key_list,MatchList)
    print "Updating NML IDs."
    if NonMatchList!=[]:
        NonMatchList=IDUpdate(NonMatchList,MatchList)
    #Update the Key lists accordingly for entries in ML and NML:
    print "Updating the Key Lists for future use:"
    NewIDMarketList=UpdateKeys(NonMatchList,new_key_list,FileDir)
    #Update the MIL with new_ID list, above.
    print "Updating the MIL for future use:"
    UpdateMIL(NewIDMarketList,FileDir,MILPath)
    #Kick out new_key_list so that IDs can be updated based on matches found.
    for kk in range(len(new_key_list)):
        if int(new_key_list[kk][0][0])>=Omega:
            #New individual
            new_key_list[kk] = new_key_list[kk]+[1]
        elif int(new_key_list[kk][0][0])<Omega:
            #Existing individual
            new_key_list[kk] = new_key_list[kk]+[0]
    return new_key_list
#
#
#Retrieves the IDs corresponding to a particular market
#IDs = COMain.GetIDsMArket(Market_Num,MILPath_Full)
def GetIDsMarket(Market,MILPath):
    f1 = open(MILPath,'r')
    IDs=[]
    stop=0
    #Check for market in MIL file selected.
    for line in f1:
        if re.split("\t",line[:10])[0] == str(Market):
            IDs = re.split("\t",line)[1:]
    #If market selected is not found, notify user.
    if len(IDs)==0:
        print str(Market) + " is not a valid market or is a new market."
    f1.close()
    return IDs
#
#
##Retrieves bounceback mails from provided file
def GetBouncebackEmails(file_path):
    f1 = open(file_path,'r')
    Emails = [re.split("\t",entry)[0] \
              for entry in re.split("\n",f1.read())]
    f1.close()
    cont=True
    while cont:
        try:
            Emails.remove('')
        except ValueError:
            cont=False
    Emails = list(set(email.lower().strip() for email in Emails))
    return Emails
#
#
#Retrieves IDs corresponding to the list of bounceback emails provides
def GetIDsforEmails(Emails,FileDir):
    #Get Email key list, split into chunks, sep. IDs,Keys
    Keys = [re.split("~",entry) for entry in \
            re.split("\n",GetKeyList("E","r",FileDir).read())]
    IDs,Keys = [Key[0] for Key in Keys],[Key[1] for Key in Keys if Key!=['']]
    #Find list of IDs corresponding to emails
    KeepList = []
    for Email in Emails:
        try:
            KeepList.append([IDs[Keys.index(Email)],Email])
        except ValueError:
            pass
    #Return list of IDs
    return KeepList
        
#
#
#Retrieves the Keys from PorE files for the given IDs            
def GetKeysMarket(IDs,PorE,FileDir):
    global Delim
    #Get Files:
    f1 = GetKeyList(PorE,'r',FileDir)
    Keys = []
    #Check for curID in list of IDs in Market
    for line in f1:
        try:
            #Check to see if ID in list, remove if it is,...
            IDs.index(re.split(Delim,line[:10])[0])
            #Add line to Keys; double split is left over from
            #formating of original set-up.
            Keys.append([re.split(":",str(entry)) for \
                    entry in re.split(Delim,line[:-1])])
        except ValueError:
            #...move on if it's not.
            pass
    f1.close()
    return Keys
#
#
##Just opens KeyList in the desired mode, returns file handle
def GetKeyList(PorE,Mode,FileDir):
    if PorE=="P":
        f1 = open(FileDir+"KeyPhoneList.txt",Mode)
    elif PorE=="E":
        f1 = open(FileDir+"KeyEmailList.txt",Mode)
    return f1
#
#
##Obtains the maximum ID value assigned thus far by
##looking through the Key files
def GetMaxID(FileDir,KeyTypeList):
    Omega = -999
    for KeyType in KeyTypeList:
        f1 = GetKeyList(KeyType,'r',FileDir)
        for line in f1:
            if int(re.split(Delim,line)[0])>Omega:
                Omega = int(re.split(Delim,line)[0])
        f1.close()
    return Omega
#
#
##This is used when the data is know to be from an individual
##already in the DB.  Checks to see if the new into they've
##provided matches previous info, or if it needs to be updated.
def CompareKeys(newKeys,PorE,Keys):
    #Assume newKeys[k] = [[newID],[Name],[Email],[Phone],[Market]]
    #Keys = [[ID],[name/email],[numbers/**]] (i.e., list of lists)
    MatchList = []
    NonMatchList=[]
    #Quick check for ID match:
    IDMatches = set(newKey[0][0] for newKey in newKeys).intersection(\
        set(Key[0][0] for Key in Keys))
    #Add to match list
    MatchList = [[ID,ID] for ID in IDMatches]
    #Iterate over remaining keys to check for non-id matches:
    #Check for which type of info currently being checked.
    #Remove ppl from consideration if they have no / missing info
##    print "Start nK "+str(len(newKeys))
    if PorE=="P":
        newKeys = [[newKey[0][0],(newKey[1][0].strip().lower()\
                                  +' '+newKey[3][0].strip()).strip()]\
                   for newKey in newKeys if\
                   (newKey[1][0].strip()!='' and newKey[3][0].strip()!='')]
        Keys = [[Key[0][0],(Key[1][0].strip().lower()\
                            +' '+Key[2][0].strip()).strip()]\
                   for Key in Keys]
    elif PorE=="E":
        newKeys = [[newKey[0][0],newKey[2][0].strip().lower()]\
                   for newKey in newKeys if\
                   newKey[2][0].strip()!='']
        Keys = [[Key[0][0],Key[1][0].strip().lower()]\
                   for Key in Keys]
    #Iterate over newKeys to check for Key matches
    rawKeys = [entry[1] for entry in Keys]
    for entry in newKeys:
	try:
            MatchList.append([entry[0],\
                        Keys[rawKeys.index(entry[1])][0]])
	except ValueError:
	    NonMatchList.append([entry[0],PorE])
    MatchList = [MatchList[[kk[0] for kk in MatchList].index(ID)]\
                 for ID in set(entry[0] for entry in MatchList)]
##    print "End nK "+str(len(newKeys))
##    print "ML "+str(len(MatchList))
    return MatchList,NonMatchList
#
#
##Handler file for UpdateKeysFile.  Performs prelim stuff away
##from main KeyCheckNew file.
def UpdateKeys(NonMatchList,new_keys_list,FileDir):
    #List of strings that are numbers
    IDList = [entry[0][0] for entry in new_keys_list]
    #Update all data at once:
    for PorE in list(set(entry[1] for entry in NonMatchList)):
        TempIndex = [entry[0] for entry in NonMatchList if entry[1]==PorE]
        List = [new_keys_list[IDList.index(str(ID))] for ID in TempIndex]
        UpdateKeysFile(List,PorE,FileDir)
    ##Pass new ID w/ markets list:
    NewIDMarketList = [[entry[0][0],entry[-1][0]] for entry in new_keys_list]
    return NewIDMarketList
#
#
##Updates the selected Key file given an update List
def UpdateKeysFile(List,PorE,FileDir):
    #Update Key files for NonMatchList entries
    print "Appending the "+PorE+" key file with new people."
    #Set up list for writing
    if PorE == "P":
        List = [Delim.join([';'.join(entry[i])\
                              for i in [0,1,3]])\
                for entry in List]
    elif PorE == "E":
        List = [Delim.join([';'.join(entry[i])\
                              for i in [0,2]])\
                for entry in List]
    #Get File:
    f1 = GetKeyList(PorE,'a',FileDir)
    #Append new entries to Key List
    for entry in List:
        f1.write(entry+"\n")
    f1.close()
#
#
##
def UpdateMIL(List,FileDir,MILPath):
    global Delim
    #Get list of markets represented in List
    Markets = list(set(entry[1] for entry in List))
    #List should be list of ['ID','Market'] pairs
    #Open MIL for reading 1st
    f1 = open(MILPath,'r')
    #Open temp file:
    f2 = open(FileDir+"tempFileUpdateMIL.txt",'w')
    #Iterate over lines in MIL to locate relevant lines
    for line in f1:
        try:
            #Try and find current market in List
            Index=Markets.index(re.split('\t',line)[0])
            #Get IDs from List in this market
            TempID = [entry[0] for entry in List \
                      if entry[1]==Markets[Index]]
            #Append the new IDs to the old Market ID List
            tempStr = "\t".join(list(set(re.split('\t',line[:-1])[1:]+TempID)))
            f2.write(Markets[Index]+"\t"+tempStr+'\n')
            #Remove the Market from Markets:
            Markets = Markets[:Index]+Markets[Index+1:]
        except ValueError:
            #Write old line if no new IDs for Market
            f2.write(line)
    if len(Markets)>0:
        cont = raw_input("It seems there are new markets.\n\
Do you wish to add them? Yes/No?: ")
        cont = cont.upper()
        if cont == "YES" or cont == "Y":
            #Append new markets and their IDs to MIL:
            for Market in Markets:
                #Get IDs from List in this market
                TempID = [entry[0] for entry in List \
                          if entry[1]==Market]
                #Append the new IDs to the old Marked ID List
                f2.write(Market+'\t'+'\t'.join(TempID)+'\n')
        elif cont == "NO" or cont =="N":
            #Do NOT append new markets / IDs to MIL:
            print "The new markets and the IDs associated with them have \n\
NOT been added."
    #Close and flush
    f1.close()
    f2.close()
    #Reopen, rewrite
    f1 = open(MILPath,'w')
    f2 = open(FileDir+"tempFileUpdateMIL.txt",'r')
    #Simple copy
    for line in f2:
        f1.write(line)
    f1.close()
    f2.close()
    #Clear f2
    f2 = open(FileDir+"tempFileUpdateMIL.txt",'w')
    f2.close()
#
#
##Assigns IDs for new data lacking IDs, based on max ID already assigned
def IDAssign(new_key_list,Omega):
    for ii in range(len(new_key_list)):
        if new_key_list[ii][0][0].strip()=='-999' \
           or new_key_list[ii][0][0].strip()=='':
            new_key_list[ii][0]=[str(Omega+1)]
            Omega=Omega+1
    return new_key_list
#
#
##Updates new, rando IDs assigned to data based on the MatchList
##compiled looking through Key info.
def IDUpdate(new_list,MatchList):
    Error = 0
    if type(new_list[0][0])==list:
        newIDs = [kk[0][0] for kk in new_list]
        for entry in MatchList:
            try:
                #If in list, switch old ID to one existing in KeyLists
                new_list[newIDs.index(entry[0])][0]=[entry[1]]
            except ValueError:
                #Occurs when new_list is NML and ID d/n correspond to existing person
                #This should not be reached if new_key_list is passed...
                Error = 1
    elif type(new_list[0][0])==str or type(new_list[0][0])==int:
        newIDs = [kk[0] for kk in new_list]
        for entry in MatchList:
            try:
                #Slightly different formatting here.
                new_list[newIDs.index(entry[0])][0]=entry[1]
            except ValueError:
                #Occurs when new_list is NML and ID d/n correspond to existing person
                #This should not be reached if new_key_list is passed...
                Error = 1

    if Error == 1:
        print "Error if updating new_key_list IDs."
    return new_list


##import sys, os, re
###sys.path.append("E:/Harker/Database")
##sys.path.append("/Volumes/NO NAME/Harker/Database/")
##import CODatabaseMaintenceTools as COMain
##Delim="~"
###Dir = "E:/Harker/Database/"
##Dir = "/Volumes/NO NAME/Harker/Database/"
##IDs = COMain.GetIDsMarket(17,Dir+"fredit_SMIL01.txt")
####Keys = COMain.GetKeysMarket(IDs,"P",Dir)
##f1 = open(Dir+"test_newKeyList.txt",'r')
##newKeyList = []
##for line in f1:
##    newKeyList.append([re.split(";",str(entry)) for \
##                    entry in re.split("~",line[:-1])])
##
##for line in f1:
##    newKeyList.append([re.split(";",str(entry)) for \
##                    entry in re.split("~",line[:-1])][:-1])
##f1.close() 
####MLT,NMLT,Keys = COMain.CompareKeys(newKeyList,"P",Keys)
##MLT,NMLT = COMain.CompareKeys(newKeyList,"P",COMain.GetKeysMarket(IDs,"P",Dir))
