#!/usr/bin/perl

use strict;
use warnings;

my $word = 0b111111111;


for(my $y = 0; $y < 5; $y++)
{
    for(my $x = 1; $x < 10; $x++)
    {
        $word = remove_number($x, $word);
        printf("%d\t%09b\n", $x, $word);
    }
}





sub remove_number
{
    my $number = shift;
    my $word = shift;
    my $mask = 0b100000000;

    # Setup the bit mask
    $mask = $mask >> $number - 1;
    $mask = $mask ^ 0b111111111;

    # AND out the bit
    my $new_word = $word & $mask;

    return $new_word;
}

# vim: set shiftwidth=4 tabstop=4 expandtab autoindent:
