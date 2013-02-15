#!/usr/bin/perl

use strict;
use warnings;

my $mask = 0b111111111;
my $word1;


printf("%b\n", $mask);

for(my $x = 0; $x <= 9; $x++)
{
    my $new_mask = $mask >> $x;
    my $population = count_ones($new_mask);
    printf("shift %d \t%09b\tpop: %d\n", $x, $new_mask, $population);
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




# vim: set shiftwidth=4 tabstop=4 expandtab autoindent : 
