"""
check and radio button bar classes for apps that fetch state later;
pass a list of options, call state(), variable details automated
Portions inspired / borrowed from "Programming Python" 4th Ed 2011, Mark Lutz
Use:
    lng = Checkbar(root, ['Python', 'C#', 'Java', 'C++'])
    gui = Radiobar(root, ['win', 'x11', 'mac'], side=TOP, anchor=NW)
"""

from tkinter import *

ori_dict = {'VERT':'top', 'HORIZ':'left'}

class Checkbar(Frame):
    def __init__(self, parent=None, picks=[],
                 side=LEFT, anchor=W, orientation='VERT',
                 func=None):
        Frame.__init__(self, parent)
        self.vars = []
        for pick in picks:
            var = IntVar()
            chk = Checkbutton(self, text=pick, variable=var)
            chk.pack(side=ori_dict[orientation],
                     anchor=anchor, expand=YES)
            self.vars.append(var)
    def state(self):
        return [var.get() for var in self.vars]
    
    def set_(self, value):
        self.var.set(value)

class Radiobar(Frame):
    def __init__(self, parent=None, picks=[],
                 side=LEFT, anchor=W, orientation='VERT',
                 func=None, value=None):
        Frame.__init__(self, parent)
        self.func = func
        self.var = StringVar()
        self.var.set(value if value else picks[0])
        self.varlist = picks
        for pick in picks:
            rad = Radiobutton(self, text=pick, value=pick,
                              variable=self.var,
                              command=func)
            rad.pack(side=ori_dict[orientation],
                     anchor=anchor, expand=YES)
    def state(self):
        return self.var.get()

    def set_(self, value):
        self.var.set(value)

class Confirm(Frame):
    def __init__(self, parent=None, message='Confirm settings?',
                 func_confirm=None, func_change=None, msg_options=None):
        Frame.__init__(self, parent)
        self.pack()
        win = Frame(self)
        win.pack(side=BOTTOM)
        widget01 = Button(win, text='Confirm', command=func_confirm)
        widget02 = Button(win, text='Make Changes', command=func_change)
        widget01.pack(side=LEFT)
        widget02.pack(side=RIGHT)
        msg = Message(self, text=message)
        msg.config(**msg_options)
        msg.pack(side=TOP)
