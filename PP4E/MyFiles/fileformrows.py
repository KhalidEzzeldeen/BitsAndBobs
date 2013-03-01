from tkinter import *
from tkinter.filedialog import askdirectory, askopenfilename


class Dirbar(Frame):
    def __init__(self, label, widthB=None, widthE=50, DorF='dir',
                 parent=None, pos=0, name='', **options):
        Frame.__init__(self, parent)
        self.pos = pos
        self.loc = StringVar()
        self.label = StringVar()
        self.updatelabel(label)
        self.type = DorF
        self.name = name
        Button(self, textvariable=self.label, command=self.setloc,
               width=widthB)\
            .pack(side=LEFT, fill=BOTH)
        Entry(self, textvariable=self.loc, width=widthE)\
            .pack(side=LEFT, expand=YES, fill=X)
        self.pack(**options)

    def setloc(self):
        if self.type=='dir':
            self.loc.set(askdirectory())
        elif self.type=='file':
             self.loc.set(askopenfilename())
        else:
            self.loc.set(None)

    def updatelabel(self, label):
        self.label.set(label)

    def get_loc(self):
        return self.loc.get()

    def set_(self, value):
        self.loc.set(value)
        
