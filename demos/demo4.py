#!/usr/bin/python2.7
import sys
count = 0
while (count <= 9000):
	count = int(count) + 1
	sys.stdout.write (str(""+str(count)+"\n"))

sys.stdout.write (str("It's over 9000!\n"))

