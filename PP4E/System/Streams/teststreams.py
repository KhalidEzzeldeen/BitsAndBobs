"read numbers till eof and show cubes"

def interact():
    print('Hello stream world')
    while True:
        try:
            reply = input('enter a num> ')
        except EOFError:
            break
        else:
            num = int(reply)
            print('%d cubed is %d' % (num, num ** 3))
    print('Bye')

if __name__=='__main__':
    interact()
