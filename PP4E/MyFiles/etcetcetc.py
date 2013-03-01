import time

def getDate():
    mon = time.localtime().tm_mon
    day = time.localtime().tm_mday
    yer = time.localtime().tm_year
    mons = {1:'Jan', 2:'Feb', 3:'Mar', 4:'Apr', 5:'May', 6:'Jun',
            7:'Jul', 8:'Aug', 9:'Sep', 10:'Oct', 11:'Nov', 12:'Dec'}
    return mons[mon]+str(day)+'_'+str(yer)
