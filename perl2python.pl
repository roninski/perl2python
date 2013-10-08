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

# Main replacements
foreach $line (@array){
	# Strip command of heading and trailing whitespace
	$line =~ s/^\s*//;
	$line =~ s/\s*$//;

	# Split variables from single strings. 
	# Only handles single strings
	if ($line =~ /("[^"]*")/){
		$x = $1;
		$x =~ s/[^\\]\K([\$@%]\w*)(?=\W)/"\+str\($1\)\+"/g;
		$line =~ s/"[^"]*"/$x/;
	}

	# Handle ++ or -- operations (change to +=1 or -=1)
	$line =~ s/(^|[^\\])\K([\$@%]\w+)\+\+/$2+=1/g;
	$line =~ s/(^|[^\\])\K([\$@%]\w+)--/$2-=1/g;
}

# Handles converting the flow across (indentation, etc)
# May be best to deal with variables and functions beforehand
# Puts into final output format (without newlines)
$indentation = 0;
foreach $line (@array){
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

# Remove dollar signs before arrays and variables.
# Note: Could in pre-parsing add special characters after the $ or @ to differentiate 
# from escaped or standard characters
foreach $line (@array){
	$line =~ s/(^|[^\\])\K[\$@](?=\w+($|\W))//g;
}

foreach $line (@array){
	print $line."\n";
}
