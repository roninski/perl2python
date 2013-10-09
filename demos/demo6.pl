#!/usr/bin/perl

print "Please enter a number: ";
$num = <STDIN>;
chomp ($num);
print "\n";
$count = 0;
foreach $i (1..$num){
	print "count + i = ";
	$count = $count + $i;
	print "$count\n";
}

print "$count divided by $num leaves a remainder of " . $count % $num . "\n";
print "$count times $num = " . $count * $num . "\n";
print "$count ^ $num = " . $count ** $num . "\n";
print "$count divided by $num = " . $count / $num . "\n";

foreach $i (1..$num){
	print "count - i = ";
	$count = $count - $i;
	print "$count\n";
}
