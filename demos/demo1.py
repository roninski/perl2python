#!/usr/bin/python2.7
import sys
x = "hello"
y = "world"
z = ""+str(x)+" "+str(y)+"\n \n"
z = str(z)[:-1] if str(z)[-1] == '\n' else z
z = str(z)[:-1]
sys.stdout.write (str(z))

