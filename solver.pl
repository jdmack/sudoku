#!/usr/bin/perl

###############################################################################
#
#           Sudoku Solver v1.0
#
#               Author: James Mack
#   Project Start Date: 2008-10-25
#
# This is a perl script that will take in a filename as an argument and input
# a sudoku puzzle from the file, then solves the sudoku puzzle and prints out
# the solution. It will also verify the solution using Sudoku Checker.
#
# Example input file:
# . . . 2 3 . 6 9 .
# 6 . . 5 . . 8 . .
# 9 2 3 8 . . 5 . .
# . . . . . . 4 3 6
# 1 . . . . . . . 2
# 7 4 5 . . . . . .
# . . 4 . . 7 2 6 8
# . . 1 . . 2 . . 4
# . 7 2 . 6 9 . . .
#
###############################################################################

use strict;
use warnings;


if(@ARGV != 1)
{
    &usage;
    exit(1);
}
my $verbose = 1;
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

my @words = (
    [0b111111111, 0b111111111, 0b111111111, 0b111111111, 0b111111111, 0b111111111, 0b111111111, 0b111111111, 0b111111111],
    [0b111111111, 0b111111111, 0b111111111, 0b111111111, 0b111111111, 0b111111111, 0b111111111, 0b111111111, 0b111111111], 
    [0b111111111, 0b111111111, 0b111111111, 0b111111111, 0b111111111, 0b111111111, 0b111111111, 0b111111111, 0b111111111], 
    [0b111111111, 0b111111111, 0b111111111, 0b111111111, 0b111111111, 0b111111111, 0b111111111, 0b111111111, 0b111111111], 
    [0b111111111, 0b111111111, 0b111111111, 0b111111111, 0b111111111, 0b111111111, 0b111111111, 0b111111111, 0b111111111], 
    [0b111111111, 0b111111111, 0b111111111, 0b111111111, 0b111111111, 0b111111111, 0b111111111, 0b111111111, 0b111111111], 
    [0b111111111, 0b111111111, 0b111111111, 0b111111111, 0b111111111, 0b111111111, 0b111111111, 0b111111111, 0b111111111], 
    [0b111111111, 0b111111111, 0b111111111, 0b111111111, 0b111111111, 0b111111111, 0b111111111, 0b111111111, 0b111111111], 
    [0b111111111, 0b111111111, 0b111111111, 0b111111111, 0b111111111, 0b111111111, 0b111111111, 0b111111111, 0b111111111]
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
print "\nUnsolved puzzle:\n";
print_grid();

# SOLVE PUZZLE HERE

while(!is_solved())
{
    for(my $row = 0; $row < 9; $row++)
    {
        for(my $col = 0; $col < 9; $col++)
        {

            my $value = $grid[$row][$col];

            # if($verbose) { print "Visiting ($row, $col)\tContains: $value"; }

            if($value eq ".")
            {
                if(count_ones($words[$row][$col]) == 1)
                {
                    my $number = get_number($words[$row][$col]); 
                    $grid[$row][$col] = $number;
                    # if($verbose) { print "\tSetting to: $number"; }
                }
            }
            
            else
            {
                # Remove number found from current row
                for(my $x = 0; $x < 9; $x++)
                {
                    $words[$row][$x] = remove_number($value, $words[$row][$x]);
                }

                # Remove number found from current column
                for(my $x = 0; $x < 9; $x++)
                {
                    $words[$x][$col] = remove_number($value, $words[$x][$col]);
                }

                # Remove number found from current square
                my $square = get_square($row, $col);
                remove_square($value, $square);
            }
            
            # if($verbose) { print "\n"; }
        }
    }

    if($verbose) 
    {
        print_grid(); 
        print "Numbers solved: $solved_count\n";
    }
}

# Print solved puzzle
print "Solved puzzle:\n";
&print_grid;


###############################################################################
#                                                                             #
#                                  Functions                                  #
#                                                                             #
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

sub count_ones
{
    my $word = shift;
    my $count = 0;

    while($word > 0)
    {
        $count = $count + ($word & 1);
        $word = $word >> 1;
    }
    
    return $count;
}

sub remove_number
{
    my $number = shift;
    my $word = shift;
    my $mask = 0b100000000;

    # Setup the bit mask
    $mask = $mask >> $number - 1;
    $mask = $mask ^ 0b111111111;
    
    # XOR out the bit
    my $new_word = $word & $mask;

    return $new_word;
}

sub remove_square
{
    my $number = shift;
    my $square = shift;
    my $row;
    my $col;

    if($square == 0)
    {
        $row = 0;
        $col = 0;
    }
    elsif($square == 1)
    {
        $row = 0;
        $col = 3;
    }
    elsif($square == 2)
    {
        $row = 0;
        $col = 6;
    }
    elsif($square == 3)
    {
        $row = 3;
        $col = 0;
    }
    elsif($square == 4)
    {
        $row = 3;
        $col = 3;
    }
    elsif($square == 5)
    {
        $row = 3;
        $col = 6;
    }
    elsif($square == 6)
    {
        $row = 6;
        $col = 0;
    }
    elsif($square == 7)
    {
        $row = 6;
        $col = 3;
    }
    elsif($square == 8)
    {
        $row = 6;
        $col = 6;
    }
    
    for(my $x = 0; $x < 3; $x++)
    {
        for(my $y = 0; $y < 3; $y++)
        {
            $words[$row + $x][$col + $y] = 
                remove_number($number, $words[$row + $x][$col + $y]);
        }
    }
    
    return;
}

sub get_number
{
    my $word = shift;
    my $mask = 0b100000000;
    my $number = 1;

    if(count_ones($word) == 1)
    {
        for(my $x = 1; $x <= 9; $x++)
        {
            if($word & $mask)
            {
                return $x;
            }

            $mask = $mask >> 1;
        }
    }

    return 0;
}

sub is_solved
{
    for(my $row = 0; $row < 9; $row++)
    {
        for(my $col = 0; $col < 9; $col++)
        {
            if($grid[$row][$col] eq '.')
            {
                return 0;
            }
        }
    } 
    return 1;
}

sub get_square
{
    my $row = shift;
    my $col = shift;

    if($row <= 2)
    {
        if($col <=2)
        {
            return 0;
        }

        elsif(($col >= 3) && ($col <=5))
        {
            return 1;
        }

        elsif(($col >= 6) && ($col <= 8))
        {
            return 2;
        }
    }
    
    elsif(($row >= 3) && ($row <= 5))
    {
        if($col <=2)
        {
            return 3;
        }

        elsif(($col >= 3) && ($col <=5))
        {
            return 4;
        }

        elsif(($col >= 6) && ($col <= 8))
        {
            return 5;
        }
    }

    elsif(($row >= 6) && ($row <= 8))
    {
        if($col <=2)
        {
            return 6;
        }
        
        elsif(($col >= 3) && ($col <=5))
        {
            return 7;
        }

        elsif(($col >= 6) && ($col <= 8))
        {
            return 8;
        }
    }

    return -1;
}

sub usage
{
    print "Usage: perl solver.pl {filename}\n";
    print "\tfilename - file containing sudoku\n\n";
}

# vim: set shiftwidth=4 tabstop=4 expandtab autoindent:
