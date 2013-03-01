import sys, os, re
#
#
#
##Get info from Database / HarkerResearch /CL surveys
def DBExtractPI(file_path,Dir,Market):
    ##Basic loading:
    try:
        with open(file_path,'r') as f1:
            tokens = re.split("\n",f1.read())
    
        #Figure out where headers are, which headers are present
        IndexList,IndexListSet,NonMatchList=GetHeaderIndexes(tokens,Dir)

        #Determine if important info present, where it is, modify stations stuff
        Term = GetTermLoc(IndexListSet)
        try:
            tt = [list(pair)[0] for pair in IndexListSet].index(9)
            StationLoc,IndexListSet = GetStationsLoc(IndexListSet,tokens,Dir)
            IndexList = [list(entry)[1] for entry in IndexListSet]
        except ValueError:
            StationLoc=999
        
        Important = GetImportantLoc(IndexListSet)

        #Get info corresponding to desired fields from raw data
        Info = []
        for entry in tokens[2:]:
            entry = re.split("\t",entry)
            entry = ["".join(re.split("\x00",sub_entry)).strip('"')\
                     for sub_entry in entry]
            if len(entry)>1:
                #Get the raw info
                temp = GetPplInfo(entry,IndexList)
                #Again, locate Stations data to pull actual stations
                if StationLoc<999:
                    temp = GetStations(temp,\
                                       StationLoc,\
                                       GetStationList(Dir,Market))
                #Check if termed or not, check if blank or not
                temp = CheckTermBlank(temp,Term,Important)
                if temp != '':
                    Info.append(temp)

        #Inform which fields are missing from the file:
        if len(NonMatchList) > 0:
            print file_path + " is missing the following fields:"
            print [entry for entry in GetHeaderList(NonMatchList,"Key",Dir)]
        return Info,IndexListSet       
    except IOError:
        Info = []
        IndexListSet = []
        print "The survey " + file_path + " does not exist."
        return Info,IndexListSet
        
#
#
##This merges the info. for people from the DB with the same IDs               
##Could make this shorter, but not worring about it now...
def MergePpl(NewTokens,Method,Clean):
    KeepList = []
    if Clean==1:
        #Fix messy stuff
        NewTokens = StandardData(NewTokens)

    if Method=="IDs":
        #Get NewPplList
        KeepList = [k for k in range(len(NewTokens))\
                if NewTokens[k][0]=='-999']
        #Determine which ppl are repeated, get freshest info
        Whole = [int(Token[0]) for Token in NewTokens]
        Unique = set(entry for entry in Whole if entry > 0)
        Type=0
    elif Method=="Email":
        #Get OldPplList
        KeepList = [k for k in range(len(NewTokens))\
                if NewTokens[k][0]!='-999']
        #Get email keys, check for same ppl
        Whole = [Token[20].upper().strip() for Token in NewTokens]
        Unique = [Whole[k] for k in range(len(NewTokens))\
                  if NewTokens[k][0]=='-999']
        Unique = set(entry for entry in Unique if entry != "")
        Type=1
    elif Method=="Phone":
        #Get OldPplList
        KeepList = [k for k in range(len(NewTokens))\
                if NewTokens[k][0]!='-999']
        #Get phone keys, check for same ppl
        Whole = [(Token[1].upper().strip()+" "+\
                  Token[18].upper().strip()).strip()\
                  for Token in NewTokens]
        Unique = [Whole[k] for k in range(len(NewTokens))\
                  if NewTokens[k][0]=='-999']
        Unique = set(entry for entry in Unique if entry != "")
        Type=1
        
        
    #Combine people that are indistinguishable
    NewTokens=CheckOverSet(Unique,Whole,KeepList,NewTokens,Type)
    return NewTokens
#
#
##This condenses the process for determining the column
##corresponding to a particular header    
def GetFieldIndex(line,name_list,FL=0):
    if type(name_list[0])==str:
        try:
            if FL==0:
                Val = line.index(name_list[0])
            elif FL==1:
                line.reverse()
                Val = len(line)-line.index(name_list[0])
        except ValueError:
            if len(name_list[1:])>0:
                Val = GetFieldIndex(line,name_list[1:])
            else:
                Val = "NA"
    elif type(name_list[0])==list:
        Val = [0 for k in range(len(name_list[0]))]
        count = 0
        for entry in name_list[0]:
            Val[count] = GetFieldIndex(line,entry)
            count+=1
    elif type(name_list[0])==int:
        Val = line.index(name_list[0])    
    return Val
#        
#
##This condenses iterating over IndexList for each entry
def GetPplInfo(entry,Index):
    if type(Index)==int and Index<len(entry):
        Val = entry[Index]
    elif type(Index)==list:
        Val = []
        for Ind in Index:
            Val.append(GetPplInfo(entry,Ind))
    elif type(Index)==str:
        Val = "NA"
    else:
        print Val
    return Val
#
#
##
def GetHeaderIndexes(tokens,Dir):
    ##Find fields of interest:
    Header00List = [0,24,25,26]
    Header01List = [26,1,2,3,4,6,9,18,20,12,13,14,15,16,27,33,34,37,38]
    Header00List = list(sorted(set(Header00List)))
    Header01List = list(sorted(set(Header01List)))
    #GetHeaderList does not maintain order HeaderXXList is in;
    #orders by increasing digit
    #Line0 info:
    IndexList00 = zip(Header00List,\
                  GetIndexList(GetHeaderList(Header00List,0,Dir),tokens[0]))
    #Line1 info:
    IndexList01 = zip(Header01List,\
                    GetIndexList(GetHeaderList(Header01List,1,Dir),tokens[1]))
    #Get IndexListSet; list of tuples (rel_Header_order, loc_in_token)
    IndexListSet,NonMatchList = CreateIndexList(IndexList00,\
                                IndexList01,Header00List,Header01List)
    IndexList = [list(entry)[1] for entry in IndexListSet]

    return IndexList,IndexListSet,NonMatchList
#
#
##Simply find the positioning of the Ref. Friend's Name field in the
##SurveyHeadersKey.txt file
def GetRefOffset(Dir):
    with open(Dir+"SurveyHeadersKey.txt",'r') as f1:
        headers = re.split("\n",f1.read())
    loc = headers.index("FRIENDS NAME")
    return loc    
#
#
##Gets the list of appropriate column headers from the SurveyHeadersKey file
def GetHeaderList(NamesIndex,HeadLine,Dir):
    #Set output:
    HeaderList = []
    #Open appropriate header file
    if HeadLine==0:
        f1 = open(Dir + "SurveyHeadersFileLn00.TXT")
    elif HeadLine==1:
        f1 = open(Dir + "SurveyHeadersFileLn01.TXT")
    elif HeadLine=="Key":
        f1 = open(Dir + "SurveyHeadersKey.TXT")
    count=0
    for line in f1:
        try:
            NamesIndex.index(count)
            HeaderList.append([re.split(r'\+',entry)[0]\
                               for entry in re.split("~",line.strip("\n"))])
        except ValueError:
            pass
        count+=1
    return HeaderList
#
#
##Finds where the specified fields are given the HeaderLists
def GetIndexList(field_names,header,FL=0):
    IndexList = [0 for k in range(len(field_names))]
    header = re.split("\t",header)
    header =["".join(re.split("\x00",entry)).strip('"') for entry in header]
    count=0
    for field in field_names:
        #Cute, I think :)
        IndexList[count]=GetFieldIndex(header,field,FL)
        count+=1
    return IndexList
#
#
##Given a particular station, retrieves which Market it is in
def GetMrkStation(Station,Dir):
    #Get MarketID stuff:
    f1 = open(Dir+"tbl_StationCityList.csv",'r')
    tokens1 = re.split("\n",f1.read())
    f1.close()
    f1 = open(Dir+"tbl_MarketsIDList.csv",'r')
    tokens2 = re.split("\n",f1.read())
    f1.close()
    StatCityTup = zip([re.split(",",entry)[0] for entry in tokens1[1:-1]],\
                      [re.split(",",entry)[1] for entry in tokens1[1:-1]])
    IDCityTupe = zip([re.split(",",entry)[0] for entry in tokens2[1:-2]],\
                     [re.split(",",entry)[1] for entry in tokens2[1:-2]])
    try:
        MrkID = [city[0] for city in IDCityTupe][[city[1].upper().strip() for city in \
                    IDCityTupe].index([stat[0].upper().strip() for stat in\
                    StatCityTup][[stat[1].upper().strip() for stat in\
                    StatCityTup].index(Station.upper().strip())])]
    except ValueError:
        print "Current station, "+Station+\
              " is not associated with a market."
        MrkID = "0"
    #Pass value
    return MrkID
#
#
##Assigns actual station values to cume yes/no, merges into single entry,
##updates value for info accordingly.
def GetStations(info,StationLoc,StationList):
    if StationList!=[]:
        temp = info[StationLoc]
        new_temp = []
        for kk in range(len(temp)):
            if str(temp[kk])=='1':
                new_temp.append(StationList[kk])
    else: new_temp=[]
    #Assign new value to info
    info[StationLoc] = ", ".join(new_temp)
    #kick out info
    return info
#
#
##Obtain the list of stations (dial form) from the StationList file given the
##station the survey is from.
def GetStationList(Dir,Market):
    StationList = []
    with open(Dir+"StationLists.txt",'r') as f1:
        temp = f1.readline()
        if re.split("\t",temp)[0].upper().strip()==Market.upper().strip():
            try:
                StationList = re.split("\t",temp)[1:]
            except IndexError:
                pass
    return StationList
#
#
##
def GetTermLoc(IndexListSet):
    #Find where term info is located.
    try:
        #Determine where Term category is located
        Term = [list(pair)[0] for pair in IndexListSet].index(26)
    except ValueError:
        print "No way to determine which entries are terms."
        Term = ''
    return Term
#
#
##
def GetStationsLoc(IndexListSet,tokens,Dir):
    #Find where stations info is located.
    #Replace location of 1st instance with list of all
    #instances (i.e., all "In the past week..." questions)
    try:
        Stations = [list(pair)[0] for pair in IndexListSet].index(9)
        StartIndex = GetIndexList(GetHeaderList([9],1,Dir),tokens[1])[0]
        LastIndex = GetIndexList(GetHeaderList([9],1,Dir),tokens[1],1)[0]
        IndexListSet[Stations] = (list(IndexListSet[Stations])[0],\
                                  range(StartIndex,LastIndex))
    except ValueError:
        Stations = []
    return Stations,IndexListSet
#
#
##
def GetImportantLoc(IndexListSet):
    #Determine where "essential" info is located:
    Important = []
    for imp_pos in [0,1,18,20,24]:  #[ID, FIRST NAME, PHONE 1, EMAIL 1,DATES]
        try:
            Important.append([list(pair)[0] \
                                for pair in IndexListSet].index(imp_pos))
        except ValueError:
            pass
    return Important
#
#
##Determines if data is a term or not, if it contains useful data or not
def CheckTermBlank(entry,Term,Important):
    #Check if it contains any info:
    if "".join(entry[val] for val in Important) != '':
        #Set to term or no term:
        try:
            entry[Term]=str(int(int(entry[Term])>0))
            if int(entry[Term])>0:
                entry[Important[-1]+1]=entry[Important[-1]]
            else:
                entry[Important[-1]+1]=''
        except ValueError:
            entry[Term]=str(0)
            entry[Important[-1]+1]=''
    else:
        entry = ''
    return entry
#
#
##Checks which entry has freshest date,yo
def CheckDates(date1,date2):
    date1 = re.split("/",date1)
    date2 = re.split("/",date2)
    if len(date1)==3:
        if len(date1[0])==1: date1[0]="0"+date1[0]
        if len(date1[1])==1: date1[1]="0"+date1[1]
        date1=int("".join([date1[2],date1[0],date1[1]]))
    else:
        date1 = 00000000
    if len(date2)==3:
        if len(date2[0])==1: date2[0]="0"+date2[0]
        if len(date2[1])==1: date2[1]="0"+date2[1]
        date2=int("".join([date2[2],date2[0],date2[1]]))
    else:
        date2 = 00000000
    #Compare YYYYMMDD
    if date1>=date2:
            return 0
    else: return 1
#
#
##Check to see if Dir exists:
def CheckDEPath(Path):
    if os.path.exists(Path)==False:
        print "The directory you have entered for CallOut does not exist.\n\
Please fix this and rerun."
        Pass=False
    else:
        Pass=True

    return Pass
#
#
##
def CheckOverSet(Unique,Whole,KeepList,tokens,Type):
    for entry in Unique:
        temp = Whole.index(entry)
        #don't add temp to KeepList if it's not a '-999' ID
        if tokens[temp][0]=='-999' and Type==1:
            KeepList.append(temp)
        elif Type==0:
            KeepList.append(temp)
        cont = True
        start = temp+1
        while cont:
            try:
                new=Whole.index(entry,start)
                tokens = DoMerge(tokens,temp,new)
                start = new+1
                if Type==1 and tokens[new][0]!='-999':
                    KeepList.remove(new)
            except ValueError:
                cont=False
        
    #Kick out modified lists
    tokens = [tokens[entry] for entry in KeepList]
    return tokens
#
#
##Consolidate lists, make list of fields not matching...
def CreateIndexList(IndexList00,IndexList01,Header00List,Header01List):
    #Merge the lists:
    CommonInds = set(Header00List).intersection(set(Header01List))
    #This is going to be the only index list...
    IndexList = []
    #Things that were supposed to match, but didn't...
    NonMatchList = []
    IndsList = list(set(Header00List+Header01List))
    for entry in IndsList:
        try:
            #Is it in the top line list?
            IL00 = list(IndexList00[Header00List.index(entry)])
            try:
                #Is it in the top and 2nd line list?
                IL01 = list(IndexList01[Header01List.index(entry)])
                if IL00[1]==IL01[1]:
                    if IL00[1]!="NA":
                        #Same, valid
                        IndexList.extend(zip([entry],[IL00[1]]))
                    else:
                        #Missing value
                        NonMatchList.append(entry)
                elif IL00[1]!="NA" and IL01[1]!="NA":
                    #Rock, paper, scissor, shoot!
                    if entry==26:            #V1 stuff
                        IndexList.extend(zip([entry],[IL00[1]]))
                    else:
                        IndexList.extend(zip([entry],[min(IL00[1],IL01[1])]))
                elif IL00[1]!="NA":
                    #Only stuff in line 0 found
                    IndexList.extend(zip([entry],[IL00[1]]))
                elif IL01[1]!="NA":
                    #Only stuff in line 1 found
                    IndexList.extend(zip([entry],[IL01[1]]))
            except ValueError:
                #Only in top line:
                if IL00[1]!="NA":
                    IndexList.extend(zip([entry],[IL00[1]]))
                else:
                    #Missing value
                    NonMatchList.append(entry)
        except ValueError:
            #Not in top
            try:
                #Is it only in 2nd line list? (Better be at this point...)
                IL01 = list(IndexList01[Header01List.index(entry)])
                #Only in 2nd line
                if IL01[1]!="NA":
                    IndexList.extend(zip([entry],[IL01[1]]))
                else:
                    #Missing value
                    NonMatchList.append(entry)
            except ValueError:
                print "Really strange issue here..."
                print entry

    return IndexList,NonMatchList
#
#
##Function to merge entries w/ same ID before looking @ key list
def DoMerge(tokens,Sink,Source):
    #Check date:
    New = [Sink,Source][CheckDates(tokens[Sink][24],tokens[Source][24])]
    Old = list(set([Sink,Source]).difference(set([New])))[0]
    DataList = [1,2,3,4,5,6,8,12,13,14,15,16,18,19,20,24,25,26,27]
    #Replace:
    for entry in [1,2,3,4,5,6,12,13,14,15,16,17,24,27]:
        if tokens[New][entry]!='':
            tokens[Sink][entry] = tokens[New][entry]
        elif tokens[Old][entry]!='':
            tokens[Sink][entry] = tokens[Old][entry]
    #Merge:
    for entry in [8,25]:
        tokens[Sink][entry] =  " ".join(list((re.split(" ",tokens[New][entry])+\
                               re.split(" ",tokens[Old][entry]))))
    #Check and replace (phone and email):
    for entry in [18,20]:
        if tokens[New][entry]!='':
            if tokens[Sink][entry]!=tokens[New][entry]:
                tokens[Sink][entry+1]=tokens[Sink][entry]
                tokens[Sink][entry]=tokens[New][entry]
            else:
                tokens[Sink][entry+1]=tokens[Old][entry]
        else:
            tokens[Sink][entry]=tokens[Old][entry]
    #Sum (points)
    tokens[Sink][26]=str(int(tokens[Sink][26])+int(tokens[Source][26]))
        
    return tokens
#
#
##Standarizes data from raw stuff
def StandardData(NewTokens):
    #Stand. people w/o IDs
    for Token in NewTokens:
        #Set ID to '-999' if none
        if Token[0]=='' or Token[0]==' ':
            Token[0]='-999'
        #Set points to '0' if none
        if Token[26]=='' or Token[26]==' ':
            Token[26]='0'

    return NewTokens
