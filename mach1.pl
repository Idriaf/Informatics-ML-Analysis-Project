#!/usr/bin/perl

use strict;
use FileHandle;
my $data_input_fh = new FileHandle "Kennedy1962.txt";
my $sequence;
my %count;
while (<$data_input_fh>) {
    s/[[:punct:]]//g;

    my @words = split;

    my $word;
    FOR1: foreach $word (@words) {
        my $size = length($word);
        if ($size<5) { next FOR1; } 
#       print "$word\n";
        $count{$word}++;
    }
}

my @keyvals = keys %count;
my $key;
my $index=0;
my @unordered_nonzero_count_strings;
foreach $key (@keyvals) {
    if ($count{$key}>10) {
        my $count_string = "$count{$key} count on $key";
     #   print "$count_string\n";
        $unordered_nonzero_count_strings[$index] = $count_string;
        $index++;
    }
}

foreach my $word (sort {$count{$a} <=> $count{$b}} keys %count) {
        print $word . ": " . $count{$word} . "\n";
 }
