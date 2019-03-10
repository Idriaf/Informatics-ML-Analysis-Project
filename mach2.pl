#Ian Riaf 

#!/usr/bin/perl

use strict;
use FileHandle;
my $text_file = "Bush2007.txt";
my $data_input_fh = new FileHandle "$text_file";
my %count;
my $total_count;
my $word_index=0;
my @word_array;

while (<$data_input_fh>) {
    s/[[:punct:]]//g;

    my @words = split;

    my $word;
    FOR1: foreach $word (@words) {
        $word_array[$word_index] = $word;
        $word_index++;

        my $size = length($word);
        if ($size<5) { next FOR1; } 
#       print "$word\n";
        $count{$word}++;
        $total_count++;
    }
}

my $word_count = $word_index;
print "$text_file has $word_count words and $total_count are >=5 chars.\n $word_count/$total_count";

# scan for specified word and get counts in local neighborhood
# my $scan_word = "virtu"; #word from text doesn't have normal 'u'...
my $scan_word = "America";
my $scan_window = 1; # number of words taken before and after scan word

my %oldcount = %count;
my %count;
my $total_count;
my $i;
for $i (0..$word_count-1) {
    my $word = $word_array[$i];
   if ($word ne $scan_word) { next; }
   # if ($word eq 'Alessandro' || $word eq 'nella' || $word eq 'potenti' || $oldcount{$word}!=36) { next; }

    my $left_index=$i-$scan_window;
    if ($left_index<0) {$left_index=0;}
    my $right_index=$i+$scan_window;
    if ($right_index>$word_count-1) {$right_index=$word_count-1;}
    my $j;
    FOR2: for $j ($left_index..$right_index) {
        my $wword = $word_array[$j];
        my $size = length($wword);
        if ($size<3) { next FOR2; } 
        $count{$wword}++;
        $total_count++;
    }
}


my @keyvals = keys %count;
my $key;
my $index=0;
my @unordered_nonzero_count_strings;
foreach $key (@keyvals) {
    if ($count{$key}>0) {
        my $count_string = "$count{$key} count on $key";
#       print "$count_string\n";
        $unordered_nonzero_count_strings[$index] = $count_string;
        $index++;
    }
}

foreach my $word (sort {$count{$a} <=> $count{$b}} keys %count) {
        print $word . ": " . $count{$word} . "\n";
 }

