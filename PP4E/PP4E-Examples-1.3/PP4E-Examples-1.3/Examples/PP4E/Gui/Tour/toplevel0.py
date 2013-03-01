import sys
from tkinter import Toplevel, Button, Label

win1 = Toplevel()                  # two independent windows
win2 = Toplevel()                  # but part of same process

Button(win1, text='Spam', command=sys.exit).pack(padx=1)
Button(win2, text='SPAM', command=sys.exit).pack(padx=1)

Label(text='Popups').pack(padx=20)        # on default Tk() root window
win1.mainloop()
