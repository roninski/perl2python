#!/usr/bin/python2.7
import sys
sys.stdout.write (str("Is your name Billy? (Y/N): "))
billy = raw_input()
billy = str(billy)[:-1] if str(billy)[-1] == '\n' else billy
sys.stdout.write (str("Is your best friend's name Mandy? (Y/N): "))
mandy = raw_input()
mandy = str(mandy)[:-1] if str(mandy)[-1] == '\n' else mandy
if (billy == "Y"  and  mandy == "Y"):
	sys.stdout.write (str("It's the Billy and Mandy Show!\n"))

elif (billy == "Y"  or  mandy == "Y"):
	sys.stdout.write (str("Half the pair is just not good enough\n"))

else :
	sys.stdout.write (str("Obviously I'm wasting my time\n"))


