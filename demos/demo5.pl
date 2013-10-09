#!/usr/bin/perl -w
# demo08.pl
# MANDELBROT VERY USEFUL (algorithm ripped straight from Wikipedia :))
# Written by Vanessa Ung.

$x0 = -2.5;
$y0 = -1;
while ($y0 <= 1) {
    $x0 = -2.5;
    while ($x0 <= 1) {
        $x = 0;
        $y = 0;
        $iteration = 0;
        $maxIteration = 100;

        while ($x*$x + $y*$x < 2*2 and $iteration < $maxIteration) {
            $xTemp = $x*$x - $y*$y + $x0;
            $y = 2*$x*$y + $y0;
            $x = $xTemp;
            $iteration++;
        }
        if ($iteration == $maxIteration) {
            print "*";
        } else {
            print " ";
        }
        $x0 += 0.05;
    }
    print "\n";
    $y0 += 0.1;
}