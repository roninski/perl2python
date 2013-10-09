#!/usr/bin/python2.7
import sys
count = 0
for arg in sys.argv :
	count = int(count) - 1
	sys.stdout.write (str(""+str(count)+": "+str(arg)+"\n"))

sys.stdout.write (str("There are "+str(count)+" arguments including the file name\n"))

