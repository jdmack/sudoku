#!/usr/bin/perl

###############################################################################
#
#           Sudoku Checker v1.0
#
# This is a perl script that will take in a filename as an argument and input
# a sudoku puzzle from the file, then checks to see if the its a valid 
# solution.
#
# Example input file:
# 4 7 6 3 1 9 8 5 2
# 5 3 1 2 8 7 4 9 6
# 9 8 2 6 5 4 7 3 1
# 3 1 5 8 9 2 6 7 4
# 8 9 4 5 7 6 1 2 3
# 2 6 7 1 4 3 9 8 5
# 1 4 3 9 2 8 5 6 7
# 7 2 9 4 6 5 3 1 8
# 6 5 8 7 3 1 2 4 9
#
###############################################################################

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

my $sudoku_regex = "([1-9.]) ([1-9.]) ([1-9.]) ([1-9.]) ([1-9.]) ([1-9.]) " 
    .  "([1-9.]) ([1-9.]) ([1-9.])";

# Open puzzle file
open(IN, $filename) || die "Cannot open file $filename: $!";

# Load puzzle from file into memory
my $counter = 0;

while(my $line = <IN>)
{
    if($line =~ /$sudoku_regex/)
    {
        $grid[$counter] = ["$1", "$2", "$3", "$4", "$5", "$6", "$7", 
            "$8", "$9"];
    }
    
    $counter++;
}

# Print imported puzzle
&print_grid;

# Check rows
print "Checking Rows...\n";

for(my $row = 0; $row < 9; $row++)
{
    my @row_values = qw/0 0 0 0 0 0 0 0 0/;

    # Fill in row values and check for collisions
    for(my $col = 0; $col < 9; $col++)
    {
        if($row_values[($grid[$row][$col]) - 1])
        {
            printf("Row %d has multiple %d\n", $row + 1, $grid[$row][$col]);
        }
        else
        {
            $row_values[$grid[$row][$col] - 1] = 1;
        }
    }
    
    # Check that all values exist
    for(my $x = 0; $x < 9; $x++)
    {
        if(!$row_values[$x])
        {
            printf("Row %d is missing a %d\n", $row + 1, $x + 1);

        }
    }
}

print "\n";

# Check columns
print "Checking Columns...\n";

for(my $col = 0; $col < 9; $col++)
{
    my @col_values = qw/0 0 0 0 0 0 0 0 0/;

    # Fill in column values and check for collisions
    for(my $row = 0; $row < 9; $row++)
    {
        if($col_values[($grid[$row][$col]) - 1])
        {
            printf("Column %d has multiple %d\n", $col + 1, $grid[$row][$col]);
        }
        else
        {
            $col_values[$grid[$row][$col] - 1] = 1;
        }
    }
    
    # Check that all values exist
    for(my $x = 0; $x < 9; $x++)
    {
        if(!$col_values[$x])
        {
            printf("Column %d is missing a %d\n", $col + 1, $x + 1);
        }
    }
}

print "\n";

# Check the squares
print "Checking Squares...\n";

for(my $row = 0; $row < 9; $row = $row + 3)
{
    for(my $col = 0; $col < 9; $col = $col + 3)
    {
        my @square_values = qw/0 0 0 0 0 0 0 0 0/;

        for(my $x = 0; $x < 3; $x++)
        {
            for(my $y = 0; $y < 3; $y++)
            {
                if($square_values[($grid[$x + $row][$y + $col]) - 1])
                {
                    printf("Square %d has multiple %d\n", $col + 1, 
                        $grid[$x + $row][$y + $col]);
                }

                else
                {
                    $square_values[$grid[$x + $row][$y + $col] - 1] = 1;
                }
            }
        }

        # Check that all values exist
        for(my $x = 0; $x < 9; $x++)
        {
            if(!$square_values[$x])
            {
                printf("Square is missing a value\n");
            }
        }
    }
}

print "\n";

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
    print "Usage: perl checker.pl {filename}\n";
    print "\tfilename - file containing sudoku\n\n";
}

sub check_line
{
    for(my $row = 0; $row < 9; $row++)
    {
        my @row_values = qw/0 0 0 0 0 0 0 0 0/;

        # Fill in row values and check for collisions
        for(my $col = 0; $col < 9; $col++)
        {
            if($row_values[($grid[$row][$col]) - 1])
            {
                printf("Row %d has multiple %d\n", $row + 1, $grid[$row][$col]);
            }
            else
            {
                $row_values[$grid[$row][$col] - 1] = 1;
            }
        }
        
        # Check that all values exist
        for(my $x = 0; $x < 9; $x++)
        {
            if(!$row_values[$x])
            {
                printf("Row %d is missing a %d\n", $row + 1, $x + 1);

            }
        }
    }


}




# vim: set shiftwidth=4 tabstop=4 expandtab autoindent:
