#!/usr/bin/perl

use strict;
use warnings;

if(@ARGV != 1)
{
    &usage;
    exit(1);
}

my $filename = shift;

my @grid = (
            [" ", " ", " ", " ", " ", " ", " ", " ", " "],
            [" ", " ", " ", " ", " ", " ", " ", " ", " "], 
            [" ", " ", " ", " ", " ", " ", " ", " ", " "], 
            [" ", " ", " ", " ", " ", " ", " ", " ", " "], 
            [" ", " ", " ", " ", " ", " ", " ", " ", " "], 
            [" ", " ", " ", " ", " ", " ", " ", " ", " "], 
            [" ", " ", " ", " ", " ", " ", " ", " ", " "], 
            [" ", " ", " ", " ", " ", " ", " ", " ", " "], 
            [" ", " ", " ", " ", " ", " ", " ", " ", " "]
);

open(IN, $filename) || die "Cannot open file $filename: $!";

my $counter = 0;

while(my $line = <IN>)
{
    if($line =~ /([1-9.]) ([1-9.]) ([1-9.]) ([1-9.]) ([1-9.]) ([1-9.]) ([1-9.]) ([1-9.]) ([1-9.])/)
    {
        $grid[$counter] = ["$1", "$2", "$3", "$4", "$5", "$6", "$7", "$8", "$9"];
        
    }
    
    $counter++;

}

&print_grid();



###############################################################################
#
#           Functions
#
###############################################################################

sub print_grid
{
    print "\n";

    for(my $row = 0; $row < 9; $row++)
    {
        for(my $col = 0; $col < 9; $col++)
        {
            print "$grid[$row][$col] ";
        }
        
        print "\n";
    }

    print "\n";

}


sub usage
{
    print "Usage: perl sudoku.pl {filename}\n";
    print "\tfilename - file containing sudoku\n\n";

}

# vim: set shiftwidth=4 tabstop=4 expandtab autoindent:
