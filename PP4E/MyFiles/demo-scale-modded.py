from tkinter import *

class Demo(Frame):
    def __init__(self, parent=None, **options):
        Frame.__init__(self, parent, **options)
        self.pack()
        # set up 1st scale
        self.scl1Var = IntVar()
        Scale(self, from_=-100, to=100, label='Num1',
                  tickinterval=50, resolution=10,
                  variable=self.scl1Var, command=self.setScl3)\
                  .pack(expand=YES, fill=Y, side=LEFT)
        # set up 2nd scale
        self.scl2Var = IntVar()
        Scale(self, from_=-100, to=100, label='Num2',
                    tickinterval=50, resolution=10,
                    variable=self.scl2Var, command=self.setScl3)\
                    .pack(expand=YES, fill=Y, side=LEFT)
        # set up 3rd scale
        self.scl3Var = IntVar()
        Scale(self, from_=-10000, to=10000, label='Prod',
                    tickinterval=5000, resolution=10,
                    variable=self.scl3Var)\
                    .pack(expand=YES, fill=Y, side=LEFT)
        # set up button...
        Button(self, text='state', command=self.report).pack(side=RIGHT)

    def report(self): 
        print(self.scl1Var.get(), self.scl2Var.get(), self.scl3Var.get())

    def setScl3(self, value):
        self.scl3Var.set(self.scl1Var.get()*self.scl2Var.get())

if __name__=='__main__':
    Demo().mainloop()
