"starts programs until you type 'q'"

import os, math

test  =['hi', 'ya', 'there', 'bloke']
parm = 0
while True:
    parm += 1
    pid = os.fork()
    if pid == 0:                                             # copy process
        os.execlp('python3', 'python3', 'child.py',\
                  str(test[int(math.fmod(parm,len(test)))]), str(parm)) # overlay program
        assert False, 'error starting program'               # shouldn't return
    else:
        print('Child is', pid)
        if input() == 'q': break
