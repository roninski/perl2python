#!/usr/bin/perl

print "Is your name Billy? (Y/N): ";
$billy = <STDIN>;
chomp($billy);
print "Is your best friend's name Mandy? (Y/N): ";
$mandy = <STDIN>;
chomp($mandy);
if ($billy == "Y" && $mandy == "Y"){
	print "It's the Billy and Mandy Show!\n";
} elsif ($billy == "Y" || $mandy == "Y"){
	print "Half the pair is just not good enough\n";
} else {
	print "Obviously I'm wasting my time\n";
}
