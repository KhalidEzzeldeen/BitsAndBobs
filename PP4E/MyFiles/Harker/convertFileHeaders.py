

head = open('SurveyHeadersKey.TXT', 'r').readlines()
head00 = open('SurveyHeadersFileLn00.TXT', 'r').readlines()
head01 = open('SurveyHeadersFileLn01.TXT', 'r').readlines()
head00 = zip(head, head00)
head00 = [a + '=' + b for (a,b) in head00]
head01 = zip(head, head01)
head01 = [a + '=' + b for (a,b) in head01]
with open('SurveyHeadersFileLn00.TXT', 'w') as file:
	for line in head00:
                file.write(line)
                if line[-1] != '\n':
                        file.write('\n')
with open('SurveyHeadersFileLn01.TXT', 'w') as file:
	for line in head01:
                file.write(line)
                if line[-1] != '\n':
                        file.write('\n')
