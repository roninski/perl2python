#!/usr/bin/perl

# Perl function handling
# Two methods:
# a) print x, y;
# b) print(x, y)
# Python uses brackets, so if I can get everything in brackets and 
# formatted properly in cases like 'print "hello"' I can change the inside to a python outside




# Puts all the code into one line
$code = "";
while ($line = <>){
	$code = $code.$line;
}

# Everything after here will assume a proper split so this needs to be properly handled
# \K disregards everything matched before that point
@array = split(/#.*\K(?=\n)|(?<=[^\\][;{}])/,$code);
# Currently not managed: reserved characters between //s and in strings, hashes.

%imports = (); # array for imports to access specific python functions

# takes one string, formats it into nested functions e.g. print(print("hello")) from print print "hello"
# this will format
sub functionFormat{
	# print $_[0];
	my $toCheck = $_[0];
	if ($toCheck =~/(^|\s)[A-Za-z]\w*\s*([^;]*)/){
		# regex seems to detect most functions fine
		# this probably should be recursive but that's a pain
		my $temp = $2;
		if ($temp !~ /(?<=^\().*(?=\))/){
			$temp = "($temp)";
		}
		$toCheck =~ s/(^|\s)[A-Za-z]\w*\s*\K([^;]*)/$temp/;

	}
	return $toCheck;
}

sub handleFunctions{
	my $toHandle = $_[0];
	if ($toHandle =~ /(^|\s)([A-Za-z]\w*)\s*\(([^;]*)\)/){
		$function = $2;
		$value = $3;
		if ($function =~ /print\b/){
			if (!$imports{"import sys"}){
				$imports{"import sys"} = 1; # Global array imports
			}
			$function = "sys.stdout.write";
			$value =~ s/(?<=["'])\s*\.\s*(?=["'])/\+/g;
			my @array = split(/,/,$value);
			foreach $i (@array){
				$i = "str($i)";
			}
			$value = join('+', @array);
			$toHandle = "$function ($value);"
			# need to finish this handling
		} elsif ($function =~ /last/){
			$toHandle = "break;";
		} elsif ($function =~ /next/){
			$toHandle = "continue;"
		}
	} 
	return $toHandle;
}


# Main replacements
foreach $line (@array){
	# Strip command of heading and trailing whitespace
	$line =~ s/^\s*//;
	$line =~ s/\s*$//;

	# Handle Functions
	if ($line =~ /;$/){
		$line = &functionFormat($line);
		$line = &handleFunctions($line);
	# Handle elsif -> elif
	} elsif ($line =~ /elsif/){ 
		$line =~ s/elsif/elif/;
	}

	# Split variables from single strings. 
	# Only handles single strings
	if ($line =~ /(["'][^"']*['"])/){
		$x = $1;
		$x =~ s/[^\\]\K([\$@%]\w*)(?=\W)/"\+str\($1\)\+"/g;
		$line =~ s/["'][^"']*['"]/$x/;
	}

	# Handle ++ or -- operations (change to +=1 or -=1)
	$line =~ s/(^|[^\\])\K([\$@%]\w+)\+\+/$2+=1/g;
	$line =~ s/(^|[^\\])\K([\$@%]\w+)--/$2-=1/g;

	# Handle ||, && and !
	$line =~ s/&&/ and /g;
	$line =~ s/\|\|/ or /g;
	$line =~ s/[^#]!/ not /g;

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
	$line =~ s/(^|[^\\])\K[\$@%](?=\w+($|\W))//g;
}

# handles final output, including outputting imports
foreach $line (@array){
	if (!$seenFirst && $line =~ /^\s*#!/){
		print $line."\n";
		foreach $import (keys %imports){
			print $import."\n";
		}
		$seenFirst = 1;
	} elsif (!$seenFirst && $line =~ /^\s*\S/){
		foreach $import (keys %input){
			print $import."\n";
		}
		print $line."\n";
		$seenFirst = 1;
	} else {
		print $line."\n";
	}

}

