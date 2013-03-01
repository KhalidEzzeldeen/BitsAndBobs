import os, sys, math, re

'''
Basic crap dealing with where files are located, who the user is, password,
etc.  All this stuff would ideally be entered in a GUI, along with data types
(provided a preview of the data file), and so on.
'''
var_type_dict = {'int':'INT', 'dec':'DEC', 'dbl':'FLOAT',\
                 'str':'STRING','NULL':'N', 'bool':'BOOL'}
db = "HealthCareSAS"
table_name = "ShootoutData"

header_file = \
            "/Volumes/NO NAME/ShootoutHealthcare/2010 sas shootout dataset headers.txt"
header_file_new = os.path.join(os.path.splitext(header_file)[0] \
                             + '_new' + \
                             os.path.splitext(header_file)[1])
data_file = "/Volumes/NO NAME/ShootoutHealthcare/2010 sas shootout dataset.txt"
data_file_new = os.path.join(os.path.splitext(data_file)[0] \
                             + '_new' + \
                             os.path.splitext(data_file)[1])
terminal_cmd_path = "/Users/sinn/Documents/MySQL/temp_create_table.txt"
user = 'sinn'
password = '5ucky*ma'
logging_path = '/Users/sinn/Desktop/session.txt'

"""
These functions handle the process of determining the size of the various
variables in the data, e.g., string length, range of numbers, presence of
null values, etc.  From this info, a MySQL variable string is created
that creates a variable column of the given type with appropriate settings.
"""
null_list = ['NULL', 'null', 'Null']


def getargs():
    """
    Get and verify directory name arguments, mode argument, returns default
    None on errors
    Portions inspired / borrowed from "Programming Python" 4th Ed 2011, Mark Lutz
    """
    try:
        args = sys.argv[1:]
    except:
        pass
    else:
        newargs = []
        for arg in args:
            temp = arg.split(":")
            newargs.append(temp)
            if temp[0] in ['NULL', 'null', 'Null']:
                null_list.append(temp[1])
        return newargs


def _getdigits(num):
    if num == 0:
        digits = 1
    else:
        digits = int(math.log10(abs(num)))+1
    return digits

def _getmax(data):
    return max(float(entry) for entry in data if not _getnull(entry))

def _getmin(data):
    return min(float(entry) for entry in data if not _getnull(entry))

def _getnull(entry):
    return entry in null_list

def _getnullany(data):
    return max(_getnull(entry) for entry in data)

def _getdec(data):
    INT_TYPE = True
    DEC = max(len(entry.split('.')[1*(len(entry.split('.'))==2)])*\
              (len(entry.split('.'))==2) for entry in data)
    if DEC==0:
        # check for '.'
        for entry in data:
            if entry.find('.')>-1:
                INT_TYPE = False
                break
    else: INT_TYPE = False
    return INT_TYPE, DEC

def _geteoldelim(line):
    if line.endswith('\r\n'):
        # remove last 2 chars from each
        toremove = -2
    elif line.endswith('\n'):
        # remove last char from each
        toremove = -1
    else:
        # remove none
        toremove = len(line)
    return toremove

def _removeeoldelim(line):
    return line[:_geteoldelim(line)]
    

def _getdecdetails(dets, name):
    MAX, MIN, INT_TYPE, DEC, NULL = dets
    if INT_TYPE:
        string = _getintdetails((MAX,MIN,NULL), name)
    else:
        if abs(MAX) <= 1 and MIN >= 0:
            string = 'DEC(%d,%d) UNSIGNED' % (1+DEC+1, DEC+1) 
        elif MIN >= 0:
            m = _getdigits(MAX) + DEC + 1
            string = 'DEC(%d,%d) UNSIGNED' % (m, DEC+1)
        else:
            m = max([_getdigits(MAX), _getdigits(MIN)]) + DEC + 1
            string = 'DEC(%d,%d) SIGNED' % (m, DEC+1)
        # check if addl details for nulls/not
    if NULL:
        print "WARNING: NULL values allowed in " + name
              
    else:
        string += " NOT NULL"
        
    # return final value
    return string

def _getintdetails(dets, name):
    MAX, MIN, NULL = dets
    if MIN > 0:
        if MAX < 256:
            string = "TINYINT UNSIGNED"
        elif MAX < 16777215:
            string = "INT UNSIGNED"
        else:
            print "WARNING:  BIGINT being assigned to " +\
                  head_det[i][0]
            string = "BIGINT UNSIGNED"
    else:
        if MAX < 129 and MIN > -128:
            string = "TINYINT SIGNED"
        elif MAX < 8200000 and MIN > -8100000:
            string = "INT SIGNED"
    # check if addl details for nulls/not
    if NULL:
        print "WARNING: NULL values allowed in " + name
              
    else:
        string += " NOT NULL"

    # return final value
    return string

def _createtermfiles(head_det):
    '''
    This module creates the files necessary to initiate and populate
    the MySQL data table from a terminal window, given the header file
    with basic data-type tags and data file supplied.
    '''
    # this is the terminal command that runs the table create / pop file
    terminal_cmd = "mysql -h localhost -u %s -p%s < %s" \
                   % (user, password, terminal_cmd_path)
    # this is the start /stop mysql log to see if shit goes wrong
    initiate_logging_str = 'tee %s' % (logging_path)
    end_logging_str = 'notee'
    # switches to desired database in mysql
    select_db_str = "USE %s" % db
    # creates table with header names and datatypes
    create_table_str = \
                     "CREATE TABLE %s (%s);" % (table_name, \
                       ",\n".join(e[0] + ' ' + e[-1] for e in head_det))
    # populates the newly created table with data_table info
    pop_table_str = "LOAD DATA LOCAL INFILE '%s' INTO TABLE %s;" \
                         % (data_file_new, table_name)
    # creates the file with the above strings in it that is fed into mysql...
    with open(terminal_cmd_path, 'w') as f1:
        f1.write(initiate_logging_str + '\n')
        f1.write(select_db_str + '\n')
        f1.write(create_table_str + '\n')
        f1.write(pop_table_str + '\n')
        f1.write(end_logging_str + '\n')
    # ...by this string
    with open('/Users/sinn/Desktop/mysql_tablecreate', 'w') as f1:
        f1.write(terminal_cmd)

def _getfile(path, omit=[]):
    output = []
    with open(path, 'r') as f1:
        for line in f1:
            line = _removeeoldelim(line)
            temp = line.split('\t')
            temp = [temp[i] for i in range(len(temp)) if i not in omit]
            output.append(temp)
    return output

def _getfileswitch(path, num_fields, omit=[], header=0):
    output = [[] for i in range(num_fields)]
    with open(path, 'r') as f1:
        for j,line in enumerate(f1):
            if j > header:
                line = _removeeoldelim(line)
                temp = line.split('\t')
                for i,entry in enumerate(temp):
                    if i not in omit:
                        output[i].append(entry)
    return output

def _convertNull(data):
    for i,line in enumerate(data):
        for j,e in enumerate(line):
            if e in set(null_list):
                line[j] = "\N"
        data[i] = line
    return data

def processhead(head_det):
    for i,e in enumerate(head_det):
        head_det[i][0] = '_'.join(re.split(r' |\\|/|\.|-', head_det[i][0])).lower()
    return head_det




if __name__=='__main__':
    """
    This is where the processing of the import files takes place.  The extracted
    info is passed to the processing modules (above) to create the appropriate
    MySQL strings for creating the variables found in data_file.
    """
    args = getargs()
    if not (os.path.isfile(header_file) and os.path.isfile(data_file)):
        print 'Invalid file paths given.  Please fix.'
        # break
    else:
        # get headers from header file, data from data file
        head_det = _getfile(header_file)
        head_det = processhead(head_det)
        data_table = _getfileswitch(data_file, len(head_det))

        # real work done here:  analyze data to see what everything looks like...
        for i,d in enumerate(head_det):
            try:
                d_type = var_type_dict[d[1].split()[0]]
                if d_type=="STRING":
                    # get max str length
                    string = 'VARCHAR(%d)' % \
                             (max(len(entry) for entry in data_table[i])+5)
                elif d_type=="DEC":
                    MAX = _getmax(data_table[i])
                    MIN = _getmin(data_table[i])
                    NULL = _getnullany(data_table[i])
                    INT_TYPE, DEC = _getdec(data_table[i])
                    string = _getdecdetails((MAX,MIN,INT_TYPE,DEC,NULL),\
                                              head_det[i][0])

                elif d_type=="INT":
                    MAX = _getmax(data_table[i])
                    MIN = _getmin(data_table[i])
                    NULL = _getnullany(data_table[i])
                    string = _getintdetails((MAX,MIN,NULL),\
                                            head_det[i][0])
                    

                elif d_type=="BOOL":
                    string = 'BOOL'
                else:
                    string = ''

                # append data type specification string to header
                head_det[i].append(string)

            except KeyError:
                print d[0] + ' does not have a valid data type listed'

        # based on updated header, remove un-used columns from data
        # and the write out data file to be used for import
        omit = [i for i in range(len(head_det)) if head_det[i][-1]=='']
        head_det = [e for e in head_det if e[-1]!='']
        data_table = _getfile(data_file, omit=omit)
        data_table = _convertNull(data_table)
        # write out updated header and data files
        with open(header_file_new, 'w') as f1:
            for entry in head_det:
                f1.write('\t'.join(entry) + '\n')
        with open(data_file_new, 'w') as f1:
            for entry in data_table:
                f1.write('\t'.join(entry) + '\n')
        # create, write out prep file
        _createtermfiles(head_det)
            

