#!/usr/bin/python2.7
import sys
while (1):
	sys.stdout.write (str("Enter a number: \n"))
	help = raw_input()
	help = str(help)[:-1] if str(help)[-1] == '\n' else help
	if (float(help) % float(4) != 0):
		sys.stdout.write (str(""+str(help)+" is not divisible by 4\n"))
		continue
	
	else :
		sys.stdout.write (str(""+str(help)+" is divisible by 4\n"))
		break
	

sys.stdout.write (str("And we are done!\n"))

