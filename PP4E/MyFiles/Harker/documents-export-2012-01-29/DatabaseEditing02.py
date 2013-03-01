import re, os, sys, numpy

#
#
##
def RunDBEdit(Path,file_name):
    Delim = "~"
    #Get tbl_Respondents:
    f1 = open(Path+file_name+'.txt','r')
    tokens = re.split("\n",f1.read())
    f1.close()
    Fields = re.split(Delim,tokens[0])
    tokens = [re.split(Delim,token) for token in tokens[1:]]
    #
    cont = 0
    while cont==0:
        try:
            tokens.remove([''])
        except ValueError:
            cont=1
    #Change all blank points fields to 0
    for kk in range(len(tokens)):
        if tokens[kk][50]=='':
            tokens[kk][50]='0'
    
    #Get rid of dupes
    NewTokens = DBMergePpl(tokens,Path)
    #Save file:
    f2 = open(Path+file_name+"DEDUPED.txt",'w')
    for token in NewTokens:
        f2.write("~".join(token)+"\n")
    f2.close()
    #create key list, with no dupes
    new_key_list = DBKeyExtract(NewTokens,[1,21,27,28,23,25,3])
    #Create MIL:
    MIL = DBMILCreate(new_key_list,Path,file_name)
    #Create File Key Lists:
    DBKeyListsCreate(new_key_list,Path)
    

#
#
##Clean and convert DB entries into something uniform
##Also, check for valid data (email and phone) and write out
##file to denote where erron. data occurs
def DBClean(Path,file_name):
    Delim = "~"
    #Get tbl_Respondents:
    f1 = open(Path+file_name+'.txt','r')
    tokens = re.split("\n",f1.read())
    f1.close()
    tokens = [re.split("=",token) for token in tokens]
    #get rid of shit
    badlist = []
    for kk in range(len(tokens)):
	if len(tokens[kk])!=68:
		badlist.append(kk)
    Index = list(set(range(len(tokens))).difference(set(badlist)))
    tokens = [tokens[kk] for kk in Index]
    #Fields = tokens[0]
    #tokens = tokens[1:]
    #Clean tokens
    #Create list where 'bad' data is stored for later consideration.
    CorruptDataIDs = []
    #From Dive Into Python, Mark Pilgrim 2004.  Modded.
    phonePattern = re.compile(r"(\d{3})\D*(\d{3})\D*(\d{4})\D*$")
    for entryNum in range(len(tokens)):
        entry = tokens[entryNum]
        if len(entry)>1:
            ID = entry[1]
            #Fix Market ID:
            entry[3] = re.split("\.",entry[3])[0]
            if entry[3]=='':
                CorruptDataIDs.append((ID,'No market specified'))
            #Fix Date/Time things:
            for index in [16,30,31,32,33]:
                entry[index] = re.split(" ",entry[index])[0]
            #Check email, phone info, fix, etc.
            email1 = re.split(";",entry[27])[0].lower().strip(';').strip()
            try:
                email2=re.split(";",entry[27])[1].lower().strip(';').strip()
            except IndexError:
                email2 = re.split(";",entry[28])[0].lower().strip(';').strip()
            if invalid(email1) and email1!='':
                CorruptDataIDs.append((ID,'Nonvalid email address.',email1))
                email1=email2
                email2=''
            if invalid(email1) and email1!='':
                CorruptDataIDs.append((ID,'Nonvalid email address.',email1))
                email1=''
            phone1 = entry[23].upper().strip(';').strip()
            phone2 = entry[25].upper().strip(';').strip()
            #Check that email is not a phone num and phone not an email (no way to know validity, h.e.)
            if not invalid(phone1.lower().strip()):
                if email1=='':
                    email1=phone1
                    phone1 = ''
                else:
                    email2 = phone1
            elif not invalid(phone2.lower().strip()):
                if email1=='':
                    email1=phone2
                    phone2 = ''
                elif email2=='':
                    email2=phone2
            elif email1 != '' and invalid(email1):
                #Strip all unwanted chars, check to see if a length-10 numeric string
                try:
                    temp = ''.join(phonePattern.search(email1).groups())
                    if re.search(r'[0-9]{10}',''.join(temp)):
                       if phone1 == '':
                           phone1 = email1
                           email1 = ''
                       elif phone2 == '':
                           phone2 = email1
                           email1 = ''
                except AttributeError:
                    pass
            #Extract what looks like a phone number from field.
            if phone1 != '':
                try:
                    phone1=''.join(phonePattern.search(phone1).groups())
                    if len(phone1) != 10:
                        CorruptDataIDs.append((ID,"Not a valid phone number.",phone1))
                        phone1 = ''
                except AttributeError:
                    CorruptDataIDs.append((ID,"Not a valid phone number.",phone1))
                    phone1 = ''
            if phone2 != '':
                try:
                    phone2=''.join(phonePattern.search(phone2).groups())
                    if len(phone2) != 10:
                        CorruptDataIDs.append((ID,"Not a valid phone number.",phone2))
                    elif phone1 == '':
                        phone1=phone2
                        phone2=''
                except AttributeError:
                    CorruptDataIDs.append((ID,"Not a valid phone number.",phone2))
                    phone2 = ''
            #Reassign cleaned values
            entry[27] = email1
            entry[28] = email2
            entry[23] = phone1
            entry[25] = phone2
            if email1 == '' and phone1 == '':
                CorruptDataIDs.append((ID,"No phone or email information."))
            tokens[entryNum] = entry
    #Write out corrupt data file:
    if CorruptDataIDs != []:
        f2 = open(Path+file_name+"CData.txt",'w')
        for Entry in CorruptDataIDs:
            for jj in Entry:
                f2.write(str(jj)+"\t")
            f2.write("\n")
        f2.close()
    #Write out cleaned tokens 
    f2 = open(Path+file_name+"CLEANED.txt",'w')
    for token in tokens:
        f2.write(Delim.join(token)+"\n")
#
#
##Create files for comparing database entries
##new_key_list = [[ID,FName,Email1,Email2,Phone1,Phone2,MrkID]...]
def DBKeyExtract(tokens,KeyInfoIndex):
    #Get info for comparison:
    new_key_list=[]
    for token in tokens:
        new_key_list.append([token[key] for key in KeyInfoIndex])
    #Return list
    return new_key_list
#
#
##Create the Key Lists that will be used to check new entries:
def DBKeyListsCreate(new_key_list,Path):
    Delim="~"
    #Emails:
    f2 = open(Path+"KeyEmailList.txt",'w')
    emails = [[key_list[0],key_list[2]] for key_list in new_key_list\
               if key_list[2]!='']+\
             [[key_list[0],key_list[3]] for key_list in new_key_list\
               if key_list[3]!='']
    for entry in emails:
        f2.write(Delim.join(entry)+"\n")
    f2.close()
    #Names and Phones:
    f2 = open(Path+"KeyPhoneList.txt",'w')
    phones = [[key_list[0],key_list[1],key_list[4]]\
              for key_list in new_key_list\
              if key_list[4]!='']+\
             [[key_list[0],key_list[1],key_list[5]]\
              for key_list in new_key_list\
              if key_list[5]!='']
    for entry in phones:
        f2.write(Delim.join(entry)+"\n")
    f2.close()
#
#
##Extract market info and create MIL
def DBMILCreate(new_key_list,Path,file_name):
    Markets = set(new_key[-1] for new_key in new_key_list \
                  if new_key[-1].strip()!='')
    MIL = []
    for Market in Markets:
        #Get IDs for all people in that market
        MIL.append([Market]+[new_key[0] for new_key in new_key_list\
                    if new_key[-1]==Market])
    #Write out new MIL file:
    f2 = open(Path+file_name+"DBMIL01.txt",'w')
    for mil in MIL:
        f2.write("\t".join(mil)+"\n")
    #return MIL for next portion
    return MIL

#
#
##This merges the info. for people from the DB with the same IDs
##Could make this shorter, but not worring aboutit now...
def DBMergePpl(tokens,Path):
    #Get current key_list
    new_key_list = DBKeyExtract(tokens,[1,21,27,28,23,25,3])
    DupeList = []
    #Iterate over markets:
    Markets = set(key[-1] for key in new_key_list)
    for Market in Markets:
        temp_keys = [key for key in new_key_list if \
                       key[-1]==Market]
        
        #Get email keys, check for same ppl
        Whole = [key[2].lower().strip() for key in temp_keys]+\
                [key[3].lower().strip() for key in temp_keys]
        #Unique = [Whole[k] for k in range(len(temp_keys))]
        Unique = set(entry for entry in Whole if entry != "")
        #find ppl with same emails in market
        DupeList = CheckOverSet(Unique,Whole,temp_keys,DupeList)
        #Get phone keys, check for same ppl
        Whole = [(key[1].upper().strip()+' '+key[4].upper().strip()).strip()\
                  for key in temp_keys]+\
                [(key[1].upper().strip()+' '+key[5].upper().strip()).strip()\
                  for key in temp_keys]
        #Make sure one of the fields is not blank before putting it in unique
        SelectWhole =\
                [(key[1]=='')*(key[4]=='') for key in temp_keys]+\
                [(key[1]=='')*(key[5]=='') for key in temp_keys]
        Unique = set(Whole[k] for k in range(len(Whole)) if\
                     SelectWhole[k]==1)
        #find ppl with same name+phone in market
        DupeList = CheckOverSet(Unique,Whole,temp_keys,DupeList)

    #Sort Dupe list by 2nd entry first..
    DupeList = [re.split("~",entry) for entry in \
                        set(Dupe[0]+"~"+Dupe[1] for Dupe in DupeList)]
    DupeList = sorted([k for k in DupeList],key=lambda k: int(k[1]))
    print len(DupeList)
    #Save DupeList
    f2 = open(Path+"DupeList.txt",'w')
    for Dupe in DupeList:
        f2.write(Dupe[0]+"~"+Dupe[1]+"\n")
    f2.close()
    #Create ID List
    IDList = [token[1] for token in tokens]
    #Merge all the match cases found above:
    for Dupe in reversed(DupeList):
        tokens = DoMerge(tokens,\
                 IDList.index(Dupe[0]),IDList.index(Dupe[1]))
    #Keep only those entries that have not been merged with another
    Keep = set(range(len(IDList))).\
                    difference(set(IDList.index(mer[1]) for mer in DupeList))
    print len(Keep)
    NewTokens = [tokens[k] for k in Keep]
    #Kick out new tokens
    return NewTokens
#
#
##
def CheckOverSet(Unique,Whole,keys,DupeList):
    for entry in Unique:
        temp = Whole.index(entry)
        start = temp+1
        if temp>=len(keys):
            temp=temp-len(keys)-1
        cont = True
        #Try and find other instances of the particular key
        while cont:
            try:
                new=Whole.index(entry,start)
                if new>=len(keys):
                    start = new+1
                    new=new-len(keys)-1
                else:
                    start = new+1
                if new!=temp:
                    if keys[new][0]>keys[temp][0]:
                        DupeList.append([keys[temp][0],keys[new][0]])
                    else:
                        DupeList.append([keys[new][0],keys[temp][0]])
                
            except ValueError:
                cont=False
    #Kick out modified DupeList
    return DupeList
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
##Function to merge entries w/ same ID before looking @ key list
def DoMerge(tokens,Sink,Source):
    #Check date:
    New = [Sink,Source][CheckDates(tokens[Sink][31],tokens[Source][31])]
    Old = list(set([Sink,Source]).difference(set([New])))[0]
    #Replace / most recent:
    for entry in [0,2,3]+range(5,23)+[29,30,31,34,39,41,42,44,\
                                      45,46,47,49,53,54,55,56,57,\
                                      66,67]:
        if tokens[New][entry]!='':
            tokens[Sink][entry] = tokens[New][entry]
        elif tokens[Old][entry]!='':
            tokens[Sink][entry] = tokens[Old][entry]
    #MrkID and Market are equal...
    tokens[Sink][58]=tokens[Sink][3]
    #Merge:
    for entry in [4,12,13,36,38,43,52,59,60,61,62,63,64,65]:
        tokens[Sink][entry] =  \
                " ".join(list(set(re.split(" ",tokens[New][entry])+\
                re.split(" ",tokens[Old][entry]))))
    #Check and replace (phone and email);
    #accounts for 2 Phones and 2 Emails
    for entry in [23,27]:
        if tokens[New][entry]!='':
            if tokens[Sink][entry]!=tokens[New][entry]:
                tokens[Sink][entry+1+(entry==23)*1]=tokens[Sink][entry]
                tokens[Sink][entry]=tokens[New][entry]
            else:
                tokens[Sink][entry+1+(entry==23)*1]=tokens[Old][entry]
        else:
            tokens[Sink][entry]=tokens[Old][entry]
    #RFCL,Initial refusal,Card Sent:
    for kk in [33,35,51]:
        if tokens[Source][kk]==1:
            tokens[Sink][kk]=1
    #Set last attempted contact:
    tokens[Sink][32] = [tokens[Sink][32],tokens[Source][32]]\
                   [CheckDates(tokens[Sink][32],tokens[Source][32])]
    #Sum (points)
    tokens[Sink][50]=str(int(tokens[Sink][50])+int(tokens[Source][50]))
    #Kick out the new tokens
    return tokens
#
#
##via http://commandline.org.uk/post/343/
##Checks to see if the SYNTAX of the email address is valid;
##Not feasible to check if valid since many domains block checking, #spam
def invalid(emailaddress):
    
    GENERIC_DOMAINS = "aero", "asia", "biz", "cat", "com", "coop", \
    "edu", "gov", "info", "int", "jobs", "mil", "mobi", "museum", \
    "name", "net", "org", "pro", "tel", "travel"
    domains = GENERIC_DOMAINS
    """Checks for a syntactically invalid email address."""

    # Email address must be 7 characters in total. 
    if len(emailaddress) < 7:
        return True # Address too short.

    # Split up email address into parts.
    try:
        localpart, domainname = emailaddress.rsplit('@', 1)
        host, toplevel = domainname.rsplit('.', 1)
    except ValueError:
        return True # Address does not have enough parts. 
    
    # Check for Country code or Generic Domain.
    if len(toplevel) != 2 and toplevel not in domains:
        return True # Not a domain name.
    
    for i in '-_.%+.':
        localpart = localpart.replace(i, "")
    for i in '-_.':
        host = host.replace(i, "")
    
    if localpart.isalnum() and host.isalnum():
        return False # Email address is fine.
    else:
        return True # Email address has funny characters.
    
### Start the ball rolling.
##if __name__ == "__main__":
##    print invalid("warrior@example.com")
    
