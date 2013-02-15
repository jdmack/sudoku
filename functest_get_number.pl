#!/usr/bin/perl

use strict;
use warnings;

my $mask = 0b100000000;

my $word = 0b000001000;

my $number = get_number($word);
print "number: $number\n";



# for(my $x = 0; $x < 9; $x++)
# {
#     my $new_mask = $mask >> $x + 1;
#     
#     my $number = get_number($mask);
#     printf("word: %09b\n", $mask);
# 
# }





sub get_number
{
    my $word = shift;
    my $mask = 0b100000000;
    my $number = 1;

    if(count_ones($word) == 1)
    {
        for(my $x = 1; $x <= 9; $x++)
        {
            printf("mask: %09b\tword: %09b\tresult: %d\n", $mask, $word, $word & $mask);
            if($word & $mask)
            {
                return $x;
            }

            $mask = $mask >> 1;
        }
    }

    return 0;
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




# vim: set shiftwidth=4 tabstop=4 expandtab autoindent:
