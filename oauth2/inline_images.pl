#!/usr/bin/env perl
#===============================================================================
#
#         FILE: inline_images.pl
#
#        USAGE: ./inline_images.pl  
#
#  DESCRIPTION: Replace all (insert link here) with the content of link.
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Stijn Heymans (stijn.heymans@gmail.com), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 01/30/2020 09:12:50
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;

use File::Slurp qw(read_file write_file append_file);

if (scalar @ARGV == 0) {
  print "Needs a file to inline the images in.\n";
}

my $file_name = $ARGV[0];

my $file_name_inlined = "inline" . $file_name;
my @file_content = read_file($file_name);

foreach my $line (@file_content) {
	if ($line =~ /\(insert ([^\s]*) here\)/) {
		print "inlining: $1\n";
		my @inline = read_file($1);
		# remove first line (meta) and last line (markdeep):
		pop @inline;
		shift @inline;
		# Now append it
		append_file($file_name_inlined, @inline);
	} else {
		append_file($file_name_inlined, $line);
	}
}
