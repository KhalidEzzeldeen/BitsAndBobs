"forks child processes until you type 'q'"

import os

def child():
    print('Hello from child', 'Pid is ' + str(os.getpid())\
          , 'Parent pid is ' + str(os.getppid()))
    os._exit(0) #else goes back to parent loop

def parent():
    while True:
        newpid = os.fork()
        if newpid==0:
            child()
        else:
            print('Hello from parent', 'Pid is ' + str(os.getpid())\
                  , 'New child pid is ' + str(newpid))
        if input() == 'q': break

parent()
