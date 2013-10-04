#!/usr/bin/perl -w

# Puts all the code into one line
$code = "";
while ($line = <>){
	$code = $code.$line;
}

# Everything after here will assume a proper split so this needs to be properly handled
# \K disregards everything matched before that point
@array = split(/#.*\K(?=\n)|(?<=[^\\][;{}])/,$code);
# Currently not managed: reserved characters between //s and in strings, hashes.


# Handles converting the flow across (indentation, etc)
# May be best to deal with variables and functions beforehand
# Puts into final output format (without newlines)
$indentation = 0;
foreach $line (@array){
	$line =~ s/^\s*//;
	$line =~ s/\s*$//;
	if ($line =~ /^#!\/usr\/bin\/perl/){
		$line = "#!/usr/bin/python2.7";
	} elsif ($line =~ /^#/){
		$line = "\t"x$indentation . $line;
	} elsif ($line =~ /;$/){
		$line =~ s/;$//;
		$line = "\t"x$indentation . $line;
	} elsif ($line =~ /{$/){
		$line =~ s/{$/:/;
		$line = "\t"x$indentation . $line;
		$indentation++;
	} elsif ($line =~ /}$/){
		$indentation--;
		$line = "\t"x$indentation;
	}
}

foreach $line (@array){
	print $line."\n";
}
