"""
constructs the GUI interface for the Simply Sync program in synccopy;
uses various elements from ML's book; result is file handles and
preference options that are then fed into the base sync program
"""

import os
from tkinter import *
from tkinter.messagebox import *
from buttonbars import Radiobar, Checkbar
from fileformrows import Dirbar
import synccopy_plus

sync_options = [('Copy Sync', ('Source Dir', 'Sink Dir')),
                ('Two-way w/ Dom', ('Dir 1 (dom)', 'Dir 2')),
                ('Two-way', ('Dir 1', 'Dir 2'))]
max_len = max(max(len(ent) for ent in entry[1]) for entry in sync_options)


def updateDirLab(dir1, dir2, state):
    state_=[option[0] for option in sync_options].index(state)
    dir1.updatelabel(sync_options[state_][1][dir1.pos])
    dir2.updatelabel(sync_options[state_][1][dir2.pos])


def filesDialog(initial):
    win = Toplevel()
    win.title('Choose Sync Directories and Mode')
    toolbar = Frame(win)
    toolbar.pack(side=BOTTOM)
    col = Frame(win)
    dir1 = Dirbar(sync_options[0][1][0], widthB=max_len, name='dir1',
                  parent=col, pos=0,
                  expand=YES, fill=X)
    dir2 = Dirbar(sync_options[0][1][1], widthB=max_len, name='dir2',
                  parent=col, pos=1,
                  expand=YES, fill=X)
    # silly update function for label names;
    func = (lambda dir1=dir1, dir2=dir2: \
            updateDirLab(dir1, dir2, mode.state()))
    mode = Radiobar(parent=win,
             picks=[options[0] for options in sync_options],
             side=LEFT, orientation='VERT',
             func=func)
    mode.name = 'mode'
    # for some reason, this sets th vars as the string 'None', not a None
    QUIT = (lambda dir1=dir1, dir2=dir2, mode=mode:\
            (dir1.set_(None), dir2.set_(None), mode.set_(None), \
             win.destroy()))
    Button(toolbar, text='OK', command=win.destroy).pack(side=LEFT)
    Button(toolbar, text='QUIT', command=QUIT).pack(side=RIGHT)
    for item in [dir1, dir2, mode]:
        setInitial(item, initial)
    
    dir1.pack(side=TOP, padx=15)
    dir2.pack(side=BOTTOM, padx=15)
    mode.pack(side=LEFT, padx=15)
    col.pack(side=RIGHT, expand=YES, fill=X)
    win.grab_set()
    win.focus_set()                 # go modal: mouse grab, key focus, wiat
    win.wait_window()               # wait till destroy; else returns now
    return dir1, dir2, mode


def confirmDialog(dir1, dir2, mode):
    dir1_label = sync_options[[s[0] for s in sync_options].index(mode)][1][0]
    dir2_label = sync_options[[s[0] for s in sync_options].index(mode)][1][1]
    message="Continue with these settings? \n" + \
             "Mode: " + str(mode) + "\n" + \
             str(dir1_label) + ": " + str(dir1) + "\n" + \
             str(dir2_label) + ": " + str(dir2)
    confirm = askyesno('Confirm', message)
    return confirm


def setInitial(var, initial):
    try:
        var.set_(initial[var.name])
    except:
        pass


def getInitial(name, initial):
    try:
        return initial[name]
    except:
        return None


def errorDialog(error_nature, dirs=None, other=None):
    if error_nature=='directories':
        if len(dirs) > 0:
            msg = 'The directories' + '\n'.join(di for di in dirs) +\
                  'do not exist.  Please edit.'
        else:
            msg = 'The directory ' + dirs[0] + '\n' +\
                  'does not exist.  Please edit.'
    if other:
        msg = msg + '\n' + other
        ok = showerror('Dir Error', msg)

def Restart(dir_args, mode, parent_win=None):
    """
    Forces restart of process if at some point user decides that input params
    up to this point are not what they desire. Essentially just re-runs
    runExtrDialog, with initial set to what has been selected up to this
    point.
    """
    if parent_win: parent_win.destroy()
    initial = {}
    initial[mode[0]] = mode[1]
    for arg in dir_args:
        initial[arg.name] = arg.get_loc()
    runFilesDiag(initial)


def runFilesDiag(initial={}, parent=None):
    dir1, dir2, mode = filesDialog(initial)
    if os.path.isdir(dir1.get_loc()):
        if os.path.isdir(dir2.get_loc()):
            # run as normal
            confirm = confirmDialog(dir1.get_loc(),
                                    dir2.get_loc(),
                                    mode.state())
            if confirm:
                runSync(dir1, dir2, mode)
            else:
                Restart([dir1, dir2], ('mode', mode.state()))
        elif mode.state()=='Copy Sync':
            # ask to create sink directory...
            msg = 'The sink directory' + dir1 + 'does not exist.\n' + \
                  'Would you like to create it?'
            if askyesno('Create Directory', msg):
                os.mkdir(dir2.get_loc())
                synccopy_plus.createindex(dir1.get_loc(),
                                          dir2.get_loc(), ('date',))
                synccopy_plus.runFromGui(dir1.get_loc(), dir2.get_loc(),
                                         mode.state())
            else:
                # return to data entry screen...
                Restart([dir1, dir2], ('mode',mode.state()))

        else:
            # no dir2 and not Copy Sync mode
            errorDialog('directories',[dir2.get_loc()],
                        other='Both directories must exist for this mode')
            Restart([dir1, dir2], ('mode',mode.state()))
    else:
        if os.path.isdir(dir2.get_loc()):
            # only dir 1 does not exist
            errorDialog('directories',[dir1])
            Restart([dir1, dir2], ('mode',mode.state()))
        elif (dir1.get_loc()=='None' and dir2.get_loc()=='None'\
              and mode.state()=='None'):
            # 'QUIT' command was sent...
            if parent:
                parent.destroy()
        else:
            # neither dir exists
            errorDialog('directories', [dir1.get_loc(), dir2.get_loc()])
            Restart([dir1, dir2], ('mode',mode.state()))


def runSync(dir1, dir2, mode, parent=None):
    win=Toplevel()
    win.title('Syncing...')
    #synccopy_plus.runFromGui(parent, dir1, dir2, mode)
    
        
if __name__=='__main__':
    root = Tk()
    initial = {}
    run_shit = (lambda initial=initial, parent=root:\
                runFilesDiag(initial=initial, parent=parent))
    Button(root, text='popup', command=run_shit).pack(fill=X)
    Button(root, text='bye', command=root.destroy).pack(fill=X)
    root.mainloop()

