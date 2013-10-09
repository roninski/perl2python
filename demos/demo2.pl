#!/usr/bin/perl

$count = 0;
foreach $arg (@ARGV){
    $count++;
    print "$count: $arg\n";
}

print "There are $count arguments including the file name\n";
