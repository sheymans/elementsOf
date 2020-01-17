#!/usr/bin/env perl
#===============================================================================
#
#         FILE: surround_with_stars.pl
#
#        USAGE: ./surround_with_stars.pl  
#
#  DESCRIPTION: Surround ASCII diagrams with a box of asterisks. 
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Stijn Heymans (stijn.heymans@gmail.com), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 01/17/2020 09:11:50
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;

use File::Slurp qw(read_file write_file append_file);

if (scalar @ARGV == 0) {
  print "Needs a file to put asterisks around.\n";
}

my $file_name = $ARGV[0];

my @file_content = read_file($file_name);

my $max_line_length = 0;
foreach my $line (@file_content) {
  $line = shift $line, '*'; 

