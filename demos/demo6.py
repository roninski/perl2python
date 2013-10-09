#!/usr/bin/python2.7
import sys
sys.stdout.write (str("Please enter a number: "))
num = raw_input()
num = str(num)[:-1] if str(num)[-1] == '\n' else num
sys.stdout.write (str("\n"))
count = 0
for i in xrange(int(1), int(num)+1):
	sys.stdout.write (str("count + i = "))
	count = float(count) + float(i)
	sys.stdout.write (str(""+str(count)+"\n"))

sys.stdout.write (str(""+str(count)+" divided by "+str(num)+" leaves a remainder of " )+str( float(count) % float(num) )+str( "\n"))
sys.stdout.write (str(""+str(count)+" times "+str(num)+" = " )+str( float(count) * float(num) )+str( "\n"))
sys.stdout.write (str(""+str(count)+" ^ "+str(num)+" = " )+str( float(count) ** float(num) )+str( "\n"))
sys.stdout.write (str(""+str(count)+" divided by "+str(num)+" = " )+str( float(count) / float(num) )+str( "\n"))
for i in xrange(int(1), int(num)+1):
	sys.stdout.write (str("count - i = "))
	count = float(count) - float(i)
	sys.stdout.write (str(""+str(count)+"\n"))


