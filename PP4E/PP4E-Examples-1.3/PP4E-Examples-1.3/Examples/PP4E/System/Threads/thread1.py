"spawn threads until you type 'q'"

import _thread, os

def child(tid):
    print('Hello from thread', tid, str(os.getpid()))

def parent():
    print('current id is ' + str(os.getpid()))
    i = 0
    while True:
        i += 1
        _thread.start_new_thread(child, (i,))
        if input() == 'q': break

parent()
