#!/usr/bin/perl

print "I'm out of things\n";
print "to run for tests\n";
print "so here's something\n";
print "I eat with cheese\n";

# prints first command line argument second command line argument times
$count = $ARGV[2];
while ($count > 0){
	print $ARGV[1]."\n";
	$count--;
}