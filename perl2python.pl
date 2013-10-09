#!/usr/bin/perl

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
# this will format into that style.
sub functionFormat{
	# print $_[0];
	my $toCheck = $_[0];
	if ($toCheck =~/(^|\s)[A-Za-z]\w*\s*([^;]*)/){
		# This regex detects most functions, BUT currently does not deal with nested functions
		my $temp = $2;
		if ($temp !~ /(?<=^\()(.*)(?=\))/){
			$temp = "$2";
		}
		#$temp = &functionFormat($temp);
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
		# Removing semicolons could fix this
		# $value = &handleFunctions($value);
		if ($function =~ /print/){
			if (!$imports{"import sys"}){
				$imports{"import sys"} = 1; # Global array imports
			}
			$function = "sys.stdout.write";
			$value =~ s/(?<=["'])\s*\.\s*(?=["'])/\+/g;
			my @array = split(/[.,]/,$value);
			foreach $i (@array){
				$i = "str($i)";
			}
			$value = join('+', @array);
			$toHandle = "$function ($value);";
		} elsif ($function =~ /last/){
			$toHandle = "break;";
		} elsif ($function =~ /next/){
			$toHandle = "continue;"
		} elsif ($function =~ /chop/){
			$toHandle = "$value = str($value)[:-1];"
		} elsif ($function =~ /chomp/){
			$toHandle = "$value = str($value)[:-1] if str($value)[-1] == '\\n' else $value;"
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
	if ($line =~ /^[^#].*;$/){
		$line = &functionFormat($line);
		$line = &handleFunctions($line);

	# Handle elsif -> elif
	} elsif ($line =~ /elsif/){ 
		$line =~ s/elsif/elif/;
	}

	# Handle foreach loops
	if ($line =~ /foreach\s+(\$[A-Za-z]\w*)\s*\(\s*(.*)\s*\)/){
		my $for = $1;
		my $in = $2;
		if ($in =~ /@/){
			$line = "for $for in $in \{";
		} elsif ($in =~ /(\$[A-Za-z]\w*|[0-9]+)\s*\.\.\s*(\$[A-Za-z]\w*|[0-9]+)/) {
			$line = "for $for in xrange(int($1), int($2)+1){";
		}
		# could be a range - specified by a..b
	}

	# Handle <STDIN> or <> outside of loops
	if ($line =~ /<STDIN>/ && $line !~ /while/){
		$line =~ s/<STDIN>/raw_input()/;
	# Handle while loops where a variable is being set to <STDIN> or <>
	# This is bad and you should feel bad
	} elsif ($line =~ /^while\s*\((\s*\$[A-Za-z]\w*)\s*=\s*(<STDIN>|<>)\s*\)/){
		if (!$imports{"import fileinput"}){
			$imports{"import fileinput"} = 1;
		}
		$line = "for $1 in fileinput.input(){";
	}


	# Handle the @ARGV array
	$line =~ s/[\@\$]ARGV/sys\.argv/;

	# Handle eq and ne
	$line =~ s/\seq\s/ == /g;
	$line =~ s/\seq\s/ != /g;

	# Handle int casting
	if ($line =~ /([0-9]+|\$[A-Za-z]\w*)\s*([\+\-\*\/\%]|\*\*)\s*([0-9]+|\$[A-Za-z]\w*)/){
		$line =~ s/([0-9]+|\$[A-Za-z]\w*)\s*([\+\-\*\/\%]|\*\*)\s*([0-9]+|\$[A-Za-z]\w*)/float($1) $2 float($3)/g;
	} 

	# Split variables from single strings. 
	# Only handles single strings
	if ($line =~ /(["'][^"']*['"])/){
		$x = $1;
		$x =~ s/[^\\]\K([\$@%]\w*)(?=\W)/"\+str\($1\)\+"/g;
		$line =~ s/["'][^"']*['"]/$x/;
	}

	# Handle ++ or -- operations (change to +=1 or -=1)
	$line =~ s/(^|[^\\])\K([\$@%]\w+)\+\+/$2 = int($2) + 1/g;
	$line =~ s/(^|[^\\])\K([\$@%]\w+)--/$2 = int($2) - 1/g;

	# Handle ||, && and !
	$line =~ s/&&/ and /g;
	$line =~ s/\|\|/ or /g;
	$line =~ s/[^#]!(?=\s*[\$\@])/ not /g;

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

