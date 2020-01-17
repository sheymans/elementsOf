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

# Figure out the max length of the lines
my $max_line_length = 0;
foreach my $line (@file_content) {
  chomp($line);
  $line =~ tr/,/./;
  $line =~ tr/`/'/;
  my $l = length($line);
  if ($l > $max_line_length) {
    $max_line_length = $l;
  }
}

# surround each line with start and end asterisks forming a box arround it
foreach my $line (@file_content) {
  chomp($line);
  my $l = length($line);
  my $spaces = ' ' x ($max_line_length - $l);
  $line = "* $line $spaces *\n";
}

my $asterisks_line = ('*' x ($max_line_length + 5)) . "\n";
my $file_name_surrounded = $file_name . ".html";
write_file($file_name_surrounded, '<meta charset="utf-8"  "-*-">' . "\n\n");
append_file($file_name_surrounded, $asterisks_line);
append_file($file_name_surrounded, @file_content);
append_file($file_name_surrounded, $asterisks_line);
append_file($file_name_surrounded, ".\n" . '<script src="https://casual-effects.com/markdeep/latest/markdeep.min.js?" charset="utf-8"></script>');


