#!/usr/bin/perl

while (1){
	print "Enter a number: \n";
	$help = <STDIN>;
	chomp($help);
	if ($help % 4 != 0){
		print "$help is not divisible by 4\n";
		next;
	} else {
		print "$help is divisible by 4\n";
		last;
	}
}
print "And we are done!\n";
