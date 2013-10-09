#!/usr/bin/perl

print "Please enter your name: ";
$x = <STDIN>;
chomp($x);
if ($x eq "Dave"){
    print "I'm sorry I can't let you do that Dave\n";
} elsif ($x eq "No"){
    print "Smart-ass\n";
} else {
    print "Too bad your name isn't Dave or No\n";
}
