#!/usr/bin/python2.7
import sys
sys.stdout.write (str("Please enter your name: "))
x = raw_input()
x = str(x)[:-1] if str(x)[-1] == '\n' else x
if (x == "Dave"):
	sys.stdout.write (str("I'm sorry I can't let you do that Dave\n"))

elif (x == "No"):
	sys.stdout.write (str("Smart-ass\n"))

else :
	sys.stdout.write (str("Too bad your name isn't Dave or No\n"))


