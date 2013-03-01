import os, sys
sys.path.append('/Users/sinn/Documents/Python/PP4E/MyFiles/')
from tkinter import *
from buttonbars import Radiobar, Checkbar
from fileformrows import Dirbar
from etcetcetc import getDate

extr_opts = [
    ('Pin Extraction',
     ('Raw Data Path', 'Survey List', 'Output Dir', 'Out File Name')),
    ('Data Extraction', ('Raw Data Path', 'Survey List'))]
max_len = max(max(len(ent) for ent in entry[1]) for entry in extr_opts)


def extrModeDialog(initial=[]):
    win = Toplevel()
    win.title('Choose Extraction Mode')
    Button(win, text='OK', command=win.destroy).pack(side=BOTTOM)
    rad = Radiobar(parent=win,
                   picks=[options[0] for options in extr_opts],
                   orientation='VERT', value=getInitial('mode', initial))
    rad.pack()
    win.grab_set()
    win.focus_set()                 # go modal: mouse grab, key focus, wiat
    win.wait_window()               # wait till destroy; else returns now
    return rad.state()

def extrPinsDialog(initial=[]):
    win = Toplevel()
    win.title('Select Paths for Pin Extraction')
    toolbar = Frame(win)
    toolbar.pack(side=BOTTOM)
    col = Frame(win)
    
    raw_path = Dirbar(extr_opts[0][1][0], widthB=max_len, name='raw',
                      parent=col, expand=YES, fill=X,
                      side=TOP, padx=15)
    sur_file = Dirbar(extr_opts[0][1][1], widthB=max_len, name='sur',
                      parent=col,expand=YES, fill=X, DorF='file',
                      side=TOP, padx=15)
    out_dir = Dirbar(extr_opts[0][1][2], widthB=max_len, name='outd',
                      parent=col, expand=YES, fill=X, padx=15)
    out_file = Dirbar(extr_opts[0][1][3], widthB=max_len, name='outf',
                      parent=col,expand=YES, fill=X, DorF=None,
                      side=BOTTOM, padx=15)
    chk = Checkbar(parent=win,
                   picks=['MF', 'USAMP', 'TSN'])
    for item in [raw_path, sur_file, out_dir, out_file]:
        setInitial(item, initial)
    rstCmd = (lambda arg1=raw_path, arg2=sur_file,
              arg3=out_dir, arg4=out_file: \
              Restart([arg1, arg2, arg3, arg4], ('mode','Pin Extraction'), win))
    Button(toolbar, text='OK', command=win.destroy).pack(side=LEFT)
    Button(toolbar, text='BACK', command=rstCmd).pack(side=RIGHT)
    
    chk.pack(side=LEFT, padx=15)
    col.pack(expand=YES, fill=X)
    win.grab_set()
    win.focus_set()                 # go modal: mouse grab, key focus, wiat
    win.wait_window()               # wait till destroy; else returns now
    return raw_path.get_loc(), sur_file.get_loc(),\
           os.path.join(out_dir.get_loc(), out_file.get_loc()),\
           chk.state()

def extrDataDialog(initial=[]):
    win = Toplevel()
    win.title('Select Paths for Data Extraction')
    toolbar = Frame(win)
    toolbar.pack(side=BOTTOM)
    col = Frame(win)
    col.pack(expand=YES, fill=X)
    raw_path = Dirbar(extr_opts[1][1][0], widthB=max_len, name='raw',
                      parent=col, expand=YES, fill=X, side=TOP, padx=15)
    sur_file = Dirbar(extr_opts[1][1][1], widthB=max_len, name='sur',
                      parent=col,expand=YES, fill=X, DorF='file',
                      side=BOTTOM, padx=15)
    rstCmd = (lambda arg1=raw_path, arg2=sur_file: \
              Restart([arg1, arg2], ('mode','Data Extraction'), win))
    Button(toolbar, text='OK', command=win.destroy).pack(side=LEFT)
    Button(toolbar, text='BACK', command=rstCmd).pack(side=RIGHT)
    for item in [raw_path, sur_file]:
        setInitial(item, initial)    
    win.grab_set()
    win.focus_set()                 # go modal: mouse grab, key focus, wiat
    win.wait_window()               # wait till destroy; else returns now
    return raw_path.get_loc(), sur_file.get_loc()

def runExtrDialog(initial={}):
    mode = extrModeDialog(initial)
    if mode == 'Pin Extraction':
        raw, sur, out, comp = extrPinsDialog(initial)
    elif mode == 'Data Extraction':
        raw, sur = extrDataDialog(initial)
        out = 'no out; data mode'
        comp = 'none'
    if raw != '' and sur != '' and out != '':
        print('Mode is:', mode)
        print('Raw dir:', raw)
        print('Sur dir:', sur)
        print('Out file:', out)
        print(comp)

def Restart(dir_args, mode, parent_win):
    """
    Forces restart of process if at some point user decides that input params
    up to this point are not what they desire. Essentially just re-runs
    runExtrDialog, with initial set to what has been selected up to this
    point.
    """
    parent_win.destroy()
    initial = {}
    initial[mode[0]] = mode[1]
    for arg in dir_args:
        initial[arg.name] = arg.get_loc()
    runExtrDialog(initial)

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

    
if __name__=='__main__':
    root = Tk()
    initial = {'mode':'Data Extraction', 'outd':'/Users/sinn/Documents',
               'outf':getDate()+'Pins.txt'}
    cmd = (lambda initial = initial:runExtrDialog(initial))
    Button(root, text='popup', command=cmd).pack(fill=X)
    Button(root, text='bye', command=root.destroy).pack(fill=X)
    root.mainloop()
