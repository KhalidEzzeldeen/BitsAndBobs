import re, os


def GetPins(Survey,Type,FileName,DateLower,DateUpper,Month,Dir,OutDirec,Ext=[]):
    MasterPins = []
    #Finding revelent files within a given directory
    #dirname = '/Volumes/HARKER/Harker/'
    #dirname = "C:/Documents and Settings/thomas/Desktop/TempFiles/"
    dirname = Dir
    Pass=1
    #Get the current survey list
    if Type==1:
        try:
            SurveyList = GetSurveyList(FileName)
            StationList = sorted(set(
                [SurveyList[i] for i in range(0,len(SurveyList)-1,2)]))
            num_S = len(StationList)
        except IOError:
            print "The Survey List File you entered does not exist.\n\
Please enter an actual file and run program again..."
            Pass=0
    elif Type==2 or Type==3:
        if len(DateLower)==3 and len(DateUpper)==3:
            StationList = [os.path.normcase(f) for f
                       in os.listdir(dirname+'/Callout/')]
            StationStr = "|".join(StationList)
            print len(StationList)
        else:
            print "Insufficient inputs to dates. "
    else:
        print "Insufficient inputs."
    
    if Pass==1:
        #RawPatt = re.compile(r'WDSY'+RotList+r'(mf|tsn|usamp)[.txt|.TXT]')
        if Survey == 'mf':
            #mf
            if Ext==[]:
                Ext="(mf)"
            OutDirec = OutDirec+"MFPins"+Month+".txt"
            if Type==2 or Type==3:
                RawPatt = re.compile(r'['+StationStr+"|"+StationStr.lower()
                                     +r'](\d{4})'+Ext+'.csv')
        elif Survey == 'tsn':
            #tsn
            if Ext==[]:
                Ext="(sn|tsn|tsna)"
            OutDirec = OutDirec+"TSNPins"+Month+".txt"
            if Type==2 or Type==3:
                RawPatt = re.compile(r'['+StationStr+"|"+StationStr.lower()
                                     +r'](\d{4})'+Ext+'.csv')
        elif Survey == 'usamp':
            #usamp
            if Ext==[]:
                Ext="(usamp|usamp)"
            OutDirec = OutDirec+"USAMPPins"+Month+".txt"
            if Type==2 or Type==3:
                RawPatt = re.compile(r'['+StationStr+"|"+StationStr.lower()
                                     +r'](\d{4})'+Ext+'.csv')

        count=0
        if Type == 1:
            for kk in range(0,len(SurveyList)-1,2):
                temp_terms = 0
                try:
                    f1 = open(dirname+"/Callout/"+SurveyList[kk]+
                              "/"+SurveyList[kk]+SurveyList[kk+1]+Survey+".csv")
                    raw = f1.read()
                    f1.close()
                    MasterPins,count=GetCompletes(raw,MasterPins,Type,'','',SurveyList[kk],count)
                except IOError:
                    print "The survey " + SurveyList[kk]+SurveyList[kk+1]+Survey+".csv" + \
                          " does not exist."
        elif Type==2 or Type==3:
            for Station in StationList:
                #print Station
                filelist = [os.path.normcase(f) for f in os.listdir(dirname+"/Callout/"+Station)]
                RawList = []
                for k in filelist:
                   try:
                          RawList.append(RawPatt.search(k).groups())
                   except AttributeError:
                          RawList.append(('',''))
                  
                #Get rev. files names and rot. numbers
                FileNames = []
                for i,j in set(RawList):
                    FileNames.append(i+j)
                FileNames.remove('')
                
                #Getting rev. data from those files and sending to another file
                for Name in FileNames:
                    f1 = open(dirname+"/Callout/"+Station+"/"+Station+Name+'.csv','r')
                    raw = f1.read()
                    f1.close()
                    MasterPins,count=GetCompletes,count(raw,MasterPins,Type,DateLower,DateUpper,Station,count)

        f2 = open(OutDirec, "w")
        MasterPins = GetUnique(MasterPins,1,4,2)
        for k in MasterPins:
            f2.write(k[0]+"\t"+k[1]+"\t"+k[2]+"\t"+k[3]+"\n")
        f2.close()
        print "Process is complete for "+Survey+"."
    else:
        pass
                

def GetFileNames(Survey):                      
    #Finding revelent files within a given directory
    dirname = '/Volumes/HARKER/Harker/'
    StationList = [os.path.normcase(f) for f
                   in os.listdir(dirname+'/Callout/')]
    StationStr = "|".join(StationList)

    #RawPatt = re.compile(r'WDSY'+RotList+r'(mf|tsn|usamp)[.txt|.TXT]')
    if Survey == 'mf':
        #mf
        RawPatt = re.compile(r'['+StationStr+r'][\d*](mf)(.*).csv$')
    elif Survey == 'tsn':
        #tsn
        RawPatt = re.compile(r'['+StationStr+r'|'+StationStr.lower()+r'|'+StationStr.upper()+r'][\d*](tsn|tsna)(.*).csv$')
    elif Survey == 'usamp':
        #usamp
        RawPatt = re.compile(r'['+StationStr+r'](\d{4})(usamp)(.*).csv$')

    FileNames = []
    for Station in StationList:
        #print Station
        filelist = [os.path.normcase(f)
                    for f in os.listdir(dirname+"/Callout/"+Station)]
        RawList = []
        for k in filelist:
            try:
                RawList.extend(RawPatt.search(k).groups())
            except AttributeError:
                RawList.extend(('','',''))
                #print k
         
        #Get rev. files names and rot. numbers
        FileNames.extend(RawList)

    #FileNames = GetUnique(FileNames,2,3)
    FileNames = sorted(set(FileNames))
    return FileNames


def GetCompletes(raw,MasterPins,Type,DateLower,DateUpper,Station,count):
    CurrentPins=[]
    #Meat of program.  Didn't want to have 2x in code..
    tokens = re.split("\n",raw)
    #f2 = open(OutDirec, "a")
    #Determine where ID.Date and ID.Site are
    line = re.split("\t",tokens[0])
    temp = ["".join(re.split("\x00",entry)).strip('"') for entry in line]
    try: DateI = temp.index("ID.date")
    except ValueError: 
        try: DateI = temp.index("ID.endDate")
        except ValueError:
            DateI = 1
    try: PinsI = temp.index("ID.site")
    except ValueError: PinsI = 3
    try: TermI = temp.index("V1:1")
    except ValueError:
        try: TermI = temp.index("V1")
        except ValueError: TermI = -2

    #Decide if data is rev. and write to CurrentPins if so
    MassAdd=0
    for k in tokens[2:]:
        line = re.split("\t",k)
        try:
           temp = ["".join(re.split("\x00",line[TermI])).strip('"'),
                   "".join(re.split("\x00",line[PinsI])).strip('"'),
                   "".join(re.split("\x00",line[DateI])).strip('"')]
           #print temp
           date = re.split("/",temp[2])
        except IndexError:
            temp = ["-1","-1","-1"]
            date = ["9999","99","99"]
        add=0
        if len(date)==3 and temp[0] == '1' and temp[1] != '':
            #Reports from schedule.
            if Type == 1:
                add = 1
            #Reports by date.
            elif Type == 2:
                if len(date[0])==1: date[0]="0"+date[0]
                if len(date[1])==1: date[1]="0"+date[1]
                if (int("".join([date[2],date[0],date[1]])) <=
                    int("".join(DateUpper))
                    and int("".join([date[2],date[0],date[1]])) >=
                    int("".join(DateLower))):
                    add = 1
            elif Type == 3:
                add=1
                if len(date[0])==1: date[0]="0"+date[0]
                if len(date[1])==1: date[1]="0"+date[1]
                if MassAdd == 0:
                    if (int("".join([date[2],date[0],date[1]])) <=
                        int("".join(DateUpper))
                        and int("".join([date[2],date[0],date[1]])) >=
                        int("".join(DateLower))):
                            MassAdd=1
        #If pass, or USAMP stuff, add to current pins
        if add == 1:
               CurrentPins.append(temp[0])
               if temp[1]=="":
                   temp[1]="Missing"+str(count)
                   count=count+1
               CurrentPins.append(temp[1])
               CurrentPins.append(date[1]+"/"+date[0]+"/"+date[2])
               CurrentPins.append(Station)
               
    if Type <> 3 or MassAdd==1:
        CurrentPins = GetUnique(CurrentPins,1,4,1)
        MasterPins.extend(CurrentPins)
    return MasterPins,count


def GetUnique(List,FrstOcc,Repeat,Type):
    #Standard List
    if Type == 1:
        NewList = [List[k] for k in range(FrstOcc,len(List),Repeat)]
    #Nested List
    elif Type == 2:
        NewList = [List[k][FrstOcc] for k in range(len(List))]
    try:
        Holder = sorted(set(NewList))
    except TypeError:
        print List[:5]
        print NewList[:5]
        #print Station+Name
    try: Holder.remove('')
    except ValueError: Holder=Holder
    #print "Value Error"
    Index = [NewList.index(k) for k in Holder]
    if Type == 1:
        tempCP = [List[(k*Repeat+1)-1:(k+1)*Repeat] for k in Index]
##        tempCP = [List[(k*Repeat+1)-1:(k+1)*Repeat]
##                  for k in range(0,len(NewList))]
    elif Type == 2:
        tempCP = [List[k] for k in Index]
    List = tempCP
    return List


def GetSurveyList(FileName):
    #Load file containing current month's surveys:
    f1 = open(FileName)
    SurveyList = re.split("\n|,",f1.read()) 
    f1.close()
    
    return SurveyList


####f2 = open("/Volumes/HARKER/Harker/USAMPPinsJul.txt",'r')
####>>> test = re.split("\t|\n",f2.read())
####>>> Pins2 = [test[k] for k in range(1,len(test),4)]
####>>> Missing = []
####>>> for k in Pins2:
####	try: holder =Pins.index(k)
####	except ValueError:
####		Missing.append(Pins2.index(k))
####
####		
####>>> len(Missing)
####64
####>>> Missing = []
####>>> for k in Pins:
####	try: holder = Pins2.index(k)
####	except ValueError:
####		Missing.append(Pins.index(k))
