#!/usr/bin/python2.7
import sys
sys.stdout.write (str("I'm out of things\n"))
sys.stdout.write (str("to run for tests\n"))
sys.stdout.write (str("so here's something\n"))
sys.stdout.write (str("I eat with cheese\n"))
# prints first command line argument second command line argument times
count = sys.argv[2]
while (count > 0):
	sys.stdout.write (str(sys.argv[1])+str("\n"))
	count = int(count) - 1

