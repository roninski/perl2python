#!/usr/bin/python2.7
import sys
# demo08.pl
# MANDELBROT VERY USEFUL (algorithm ripped straight from Wikipedia :))
# Written by Vanessa Ung.
x0 = -2.5
y0 = -1
while (y0 <= 1) :
	x0 = -2.5
	while (x0 <= 1) :
		x = 0
		y = 0
		iteration = 0
		maxIteration = 100
		while (float(x) * float(x) + float(y) * float(x) < float(2) * float(2) and iteration < maxIteration) :
			xTemp = float(x) * float(x) - float(y) * float(y) + x0
			y = float(2) * float(x)*float(y) + float(y0)
			x = xTemp
			iteration = int(iteration) + 1
		
		if (iteration == maxIteration) :
			sys.stdout.write (str("*"))
		
		else :
			sys.stdout.write (str(" "))
		
		x0 += 0.05
	
	sys.stdout.write (str("\n"))
	y0 += 0.1

