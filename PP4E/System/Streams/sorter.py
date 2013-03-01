import sys

try:
    method = sys.argv[1]
except IndexError:
    method = None
lines = sys.stdin.readlines()
if method=='num':
    lines = [float(line) for line in lines]
    lines.sort()
    lines = [str(line)+"\n" for line in lines]
elif method=='exp':
    lines = [eval(line) for line in lines]
    lines.sort()
    lines = [str(line)+"\n" for line in lines]
else:
    lines.sort()

for line in lines: print(line, end='')
