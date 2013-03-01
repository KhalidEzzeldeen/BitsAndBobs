# define a name:callback demos table

from tkinter.filedialog   import askopenfilename        # get standard dialogs
from tkinter.colorchooser import askcolor               # they live in Lib\tkinter
from tkinter.messagebox   import askquestion, showerror
from tkinter.simpledialog import askfloat, askinteger, askstring

demos = {
    'Open':  askopenfilename,
    'Color': askcolor,
    'Query': lambda: askquestion('Warning', 'You typed "rm *"\nConfirm?'),
    'Error': lambda: showerror('Error!', "He's dead, Jim"),
    'Input 1': lambda: askinteger('Entry 1', 'Enter credit card number'),
    'Input 2': lambda: askfloat('Entry 2', 'Enter your fav pie'),
    'Input 3': lambda: askstring('Entry 3', 'Enter your fav SPAMSPAMSPAM')
}
