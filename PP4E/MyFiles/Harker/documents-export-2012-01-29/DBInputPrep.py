import sys, os, re
global Delim
Delim = "~"

#
#
##
def PrepInputFile(file_path,FileDir,Out):
    global Delim
    #Assume it's a .txt file
    f1 = open(file_path,'r')
    tokens = re.split("\n",f1.read())
    f1.close()
    #Create a copy
    copy_tokens = tokens
    #Dedupe, edit file (i.e., save over original)
    tokens = [tokens[0]]+list(set(tokens[1:]))
    tokens = [token for token in tokens if token != '']
    f1 = open(file_path,'w')
    for token in tokens:
        f1.write(token+"\n")
    f1.close()
    #Edit tokens to match correct order, blanks present
    NewTokens = []
    NewTokens,Pass,RefList,RL = \
            PrepDataForm(tokens,NewTokens,FileDir,file_path)
    if not RL:
        #Save copy version if this is the first time this file has been accessed
        f2 = open(FileDir+"OutputFile01_ORIGCOPY.txt",'w')
        for token in copy_tokens:
            f2.write(token+"\n")
        f2.close()
    if Pass==1:
        #Make sure all people have Market ID information,
        #and at least 1 form of Key info (Name+Phone | Email)
        new_key_list,Pass = CheckDataContent(NewTokens,FileDir,Pass)
        if Pass==0:
            print "Process has been terminated due to missing information.\n\
Please update and re-run"
    elif Pass=="HEADER":
        print "Process has been terminated due to nonmatching headers.\n\
Please update and re-run"
        Pass=0
        new_key_list = []
    elif Pass=="EMAIL":
        print "Process has been terminated due to invalid emails.\n\
Please update and re-run."
        Pass=0
        new_key_list = []
    #output required variables 
    return new_key_list,Pass,RefList
#
#
##Updates the IDs for all new data assigned / matched in the COMain file
def PrepUpdateIDs(new_key_list,file_path,FileDir,RefList):
    #NewIDs are ordered the same as the entries in the file_path
    #Determine which are new and which are old
    OldList = []
    NewList = []
    count=0
    RefSubList = [pair[0] for pair in RefList]
    for entry in new_key_list:
        if entry[-1]==0:
            #Old
            OldList.append(count)
            count+=1
        elif entry[-1]==1:
            NewList.append(count)
            count+=1
            #New
    #Get list of headings in T UpdateTable
    f1 = open(FileDir+"DBHeadersKey.txt",'r')
    Fields = re.split("\n",f1.read())
    f1.close()
    #Get existing info
    f1 = open(file_path,'r')
    tokens = re.split("\n",f1.read())
    f1.close()
    #Update and write file for old individuals:
    f2 = open(FileDir+"DBInputOldUp.txt",'w')
    f2.write(Delim.join(Fields)+"\n")
    for Index in OldList:
        temp = re.split(Delim,tokens[Index])
        temp[0] = new_key_list[Index][0][0]
        #Put dashes ("-") back in phone numbers
        if temp[18]!='':
            temp[18] = temp[18][:3]+"-"+temp[18][3:6]+"-"+temp[18][6:]
            if temp[19]!='':
                temp[19] = temp[19][:3]+"-"+temp[19][3:6]+"-"+temp[19][6:]
        f2.write(Delim.join(temp)+"\n")
    f2.close()
    #Update and write file for new individuals:
    f2 = open(FileDir+"DBInputNewApp.txt",'w')
    f2.write(Delim.join(Fields)+"\n")
    for Index in NewList:
        temp = re.split(Delim,tokens[Index])
        #Put dashes ("-") back in phone numbers
        if temp[18]!='':
            temp[18] = temp[18][:3]+"-"+temp[18][3:6]+"-"+temp[18][6:]
            if temp[19]!='':
                temp[19] = temp[19][:3]+"-"+temp[19][3:6]+"-"+temp[19][6:]
        temp[0] = new_key_list[Index][0][0]
        #Check if index was a referral from someone else, update RefID
        try:
            temp[32]=new_key_list[RefList[RefSubList.index(Index)][1]][0][0]
        except ValueError:
            pass
        f2.write(Delim.join(temp)+Delim+"\n")
    f2.close()
#
#
##Arranges data in correct order and puts in blanks where fields are lacking
##Takes .csv type file by default, w/ header
def PrepDataForm(tokens,NewTokens,FileDir,file_path):
    #Check to see if this is a re-run or not
    Header,RL = CheckRL(tokens[0])
    #Get list of headings in T UpdateTable
    f1 = open(FileDir+"DBHeadersKey.txt",'r')
    Fields = re.split("\n",f1.read())
    RefOffset = Fields.index("FRIENDS NAME")
    f1.close()
    OrderIndex = []
    Pass=1
    #Create index for where columns should be placed
    for header in Header:
        try:
            OrderIndex.append(Fields.index(header.upper()))
        except ValueError:
            if Pass==1:
                cont = raw_input("You've entered a header,"+header+", that does not \n \
correspond to an existing data field.\n\
If you contunue, data in this field will be ignored.\n\
Continue? Y/N?:  ")
                cont = cont.upper()
                if cont == "NO" or cont =="N":
                    Pass="HEADER"
            elif Pass=="HEADER":
                print header+" also does not match."
                
    if Pass==1:
        if RL:
            #Get old RefList info
            temptokens = [re.split("\t",token) for token in tokens]
            tempRefList = [[int(token[0]),int(token[1])] for\
                           token in temptokens[1:] if token != '']
            NIL = [entry[0] for entry in tempRefList]
            tempRefList = [entry for entry in tempRefList \
                           if entry[1]>-1]
            tempRefList = [[NIL.index(entry[0]),NIL.index(entry[1])]\
                           for entry in tempRefList]
            tokens = ["\t".join(token[2:]) for token in temptokens]
        #Remove duplicates in the data: (pot. comp. expensive)
        #tokens = [tokens[0]]+list(set(tokens[1:]))
        #Get data in desired form, get referrals, look for bad info
        NewTokens,RefList,InvalidEmailList = \
                        GetTokenInfo(tokens,Fields,OrderIndex,NewTokens,1,"",RefOffset)
        #Change RefList to previous version if this is a re-run 
        if RL:
            RefList = tempRefList
            
        #Write out file so that numbers match; pre-pend Rel IDs and Ref Lists
        f1 = open(file_path,'w')
        f1.write("REL IDS"+"\t"+"REL REF LIST"+"\t"+"\t".join(Fields)+"\n")
        RelInd = [entry[0] for entry in RefList]
        count = 0
        for Token in NewTokens:
            try:
                RefID = str(RefList[RelInd.index(count)][1])
            except ValueError:
                RefID = "-1"
            f1.write(str(count)+"\t"+RefID+"\t"+"\t".join(Token)+"\n")
            count = count+1
        f1.close()
        
        if InvalidEmailList != []:
            print "These people have invalid email addresses:"
            print [value+2 for value in InvalidEmailList]
            print "Please fix these and re-run."
            Pass="EMAIL"
    else:
        NewTokens = []
        RefList=[]
    #output required variables
    return NewTokens,Pass,RefList,RL
#
#
##Checks to make sure input data has enough info. to ID individuals
def CheckDataContent(NewTokens,FileDir,Pass):
    global Delim
    Pass = 1
    NonPass = []
    count=1
    for Token in NewTokens:
        #MrkID
        if Token[7]=="":
            Pass=0
            NonPass.append(count)
        #Email and (Name or Phone)
        elif Token[20]=="" and (Token[1]=="" or Token[18]=="")\
             and (Token[0]=="-999" or Token[0]==""):
            Pass=0
            NonPass.append(count)
        count=count+1
    #Check for value of "Pass"
    if Pass==1:
        #Open output file; overwrites existing version
        f2 = open(FileDir+"tempPreKeysDB.txt",'w')
        for Token in NewTokens:
            #Write each new Token to file with 
            f2.write(Delim.join(Token)+"\n")
        f2.close()
        #Create input file for KeyCheck, Key Update
        #Just need ID,First Name,Emails,Phones,Market
        f2 = open(FileDir+"PreKeyCheck.txt",'w')
        KeyInfoIndex = [0,1,20,18,7]
        for Token in NewTokens:
            f2.write(Delim.join([Token[key] for key in KeyInfoIndex])+"~\n")
        f2.close()
        #Do you want output?
        new_key_list=[]
        for Token in NewTokens:
                new_key_list.append([[Token[key]] for key in KeyInfoIndex])
                
    else:
        print "These people are missing Market ID info,\n\
-OR- they do not have enough identifying contact info.\n\
Please enter this information or remove these individuals\n\
and run program again.  Edit input file."
        print [member+1 for member in NonPass]
        new_key_list=[]
    #output required variables    
    return new_key_list,Pass
#
#
##Checks if this is  are-run or not
def CheckRL(tokens0):
    #Get Header, parse...
    Header = re.split("\t",tokens0)
    #Check if this is a re-run after data has been updated:
    if Header[0]== "REL IDS" and Header[1]=="REL REF LIST":
        Header = Header[2:]
        RL = True
    else:
        RL = False
    #Spit out header, RL
    return Header,RL
#
#
##Pulls the raw info from the input, adds spaces where needed to match
##expected input
def GetTokenInfo(tokens,Fields,OrderIndex,NewTokens,Type,MrkID,RefOffset):
#From Dive Into Python, Mark Pilgrim 2004.  Modded.
    phonePattern = re.compile(r"(\d{3})\D*(\d{3})\D*(\d{4})\D*$")
    RefList = []
    InvalidEmailList = []
    count=0
    for token in tokens[1:]:
        #Create tempory value for token, parse current structure
        if token!='':
            if type(token)==str:
                token = re.split("\t",token)
            temp = []
            for kk in range(len(Fields)):
                try:
                    #Place data in field if available
                    if kk==1:                    #locations of name fields
                        val = re.split(" ",token[OrderIndex.index(kk)].upper())[0]
                    elif kk==2:
                        try:
                            #Last name field?
                            val = token[OrderIndex.index(kk)].upper()
                        except ValueError:
                            if len(re.split(" ",token[OrderIndex.index(kk-1)].upper()))>1:
                                #Last name w/ first name?
                                val = re.split(" ",token[OrderIndex.index(kk-1)].upper())[-1]
                            else:
                                val = ""
                    #Get phone number and put in standard form.
                    elif kk==18 or kk==19 or kk==RefOffset+2:      #locations of num fields
                        try:
                            val = ''.join(phonePattern.search(\
                            token[OrderIndex.index(kk)]).groups())
                        except AttributeError:
                            val = ""
                    #Check for correct email syntax
                    elif kk==20 or kk==21 or kk==RefOffset+1:    #locations of emails
                        if token[OrderIndex.index(kk)] != "":
                            #Check if email has valid syntax
                            if not invalid(token[OrderIndex.index(kk)].strip().lower()):
                                val=token[OrderIndex.index(kk)].strip().lower()
                            else:
                                val=""
                                InvalidEmailList.append(count)
                        else:
                            val = ""
                    #Gender question; code
                    elif kk==3 or kk==RefOffset+3:
                        #Check if entry is a number
                        try:
                            code = int(token[OrderIndex.index(kk)])
                            if code==1:
                                val = "Male"
                            elif code==2:
                                val = "Female"
                            else:
                                val = str(code)
                        except ValueError:
                            val = token[OrderIndex.index(kk)]
                    #Ethnicity question; code
                    elif kk==6 or kk==RefOffset+5:
                        #Check if entry is a number
                        try:
                            code = int(token[OrderIndex.index(kk)])
                            if code==1:
                                val = "Caucasian"
                            elif code==2:
                                val = "African American"
                            elif code==3:
                                val = "Hispanic"
                            elif code==4:
                                val = "Asian American"
                            elif code==5:
                                val = "Other"
                            else:
                                val = str(code)
                        except ValueError:
                            val = token[OrderIndex.index(kk)]
                    #Market ID placement
                    elif kk==7 and Type==2 and MrkID!="":
                        val = MrkID
                    else:
                        #Check if referrals are present
                        if kk==RefOffset and token[OrderIndex.index(kk)]!="":
                            RefList.append(count)
                        #Place data in field if available
                        val = token[OrderIndex.index(kk)].upper()
                    #Append found value
                    temp.append(str(val))
                except ValueError:
                    if kk==0 and Type==1:
                        #Set '-999' as ID if none provided
                        temp.append("-999")
                    else:
                        #Insert space for missing data in file
                        temp.append("")
            NewTokens.extend([temp])
            count=count+1
    if Type==1:
        #Get info from referrals and add to NewTokensList
        RefList = [[kk+count,RefList[kk]] for kk in range(len(RefList))]
        for pair in RefList:
            temp = ['' for k in range(len(Fields))]
            temp[0]="-999"
            temp[1]=re.split(" ",NewTokens[pair[1]][RefOffset].strip())[0]     #First Name
            try:
                temp[2]=" ".join(re.split(" ",NewTokens[pair[1]][RefOffset])[1:]) #Last Name
            except IndexError:
                temp[2]=""
            temp[20]=NewTokens[pair[1]][RefOffset+1]     #Email
            temp[18]=NewTokens[pair[1]][RefOffset+2]     #Phone Number
            temp[3]=NewTokens[pair[1]][RefOffset+3]      #Gender
            temp[4]=NewTokens[pair[1]][RefOffset+4]      #Age
            temp[6]=NewTokens[pair[1]][RefOffset+5]      #Ethnicity
            temp[26]=str(0)                     #Points
            temp[7]=NewTokens[pair[1]][7]       #Market ID
            NewTokens.extend([temp])
        #Get rid of info in columns corresponding to referral data
        for kk in range(len(NewTokens)):
            NewTokens[kk] = NewTokens[kk][:RefOffset]+['' for k in range(6)]
        #Add complete date for people who completed survey
        for kk in range(len(NewTokens)):
            if type(NewTokens[kk][26])==str and NewTokens[kk][26]=='':
                NewTokens[kk][26]=str(0)
            elif int(NewTokens[kk][26])>0:
                NewTokens[kk][25]=NewTokens[kk][24]
    else:
        RefList=[]
            
    return NewTokens,RefList,InvalidEmailList

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
