#Ian Riaf 

#!/usr/bin/perl

use strict;
use FileHandle;


my $sent_input_fh = new FileHandle "sentiments2.txt";
my %sentiment;

while (<$sent_input_fh>) {
    chomp;
    my ($word,$sentiment_value) = split /\t/;


#   print "$word\t$sentiment_value\n";


    $sentiment{"$word"} = $sentiment_value;
}


my $syll_input_fh = new FileHandle "syllable2.txt";
my %syllables;
while (<$syll_input_fh>) {
    chomp;
    my ($word,$parts,$syllable_count) = split /\t/;


#   print "$word\t$syllable_count\n";


    $syllables{"$word"} = $syllable_count;
}



my $data_input_fh = new FileHandle "Kennedy1962.txt";
my $sequence;
my %count;
my %lineSyl;

my $totalSent=0;



while (<$data_input_fh>) {
    chomp;
    chop;
    tr/[A-Z]/[a-z]/;
#   s/[[:punct:]]//g;

    my @words = split;


    my $syllable_count=0;
    my $sentiment_score=0;

    my $i;
    my $word;

    FOR1: for $i (0..scalar(@words)) {
        my $word=@words[$i];
       #my $size = length($word);
       #if ($size<5) { next FOR1; } 
        $count{@words[$i].@words[$i+1].@words[$i+2]}++;


        if (!$syllables{"$word"}) {
            my @syllables = split /[a,e,i,o,u,y]+/, $word;

       #     print "@syllables\n";

            my $numsyll = scalar(@syllables);
            my $syll_count=0;
            my $syll_index;
            for $syll_index (0..$numsyll-2) {
                if ($syllables[$syll_index] ne "") {
                    $syll_count++;
                }
            }
            if ($syll_count == 0) { $syll_count = 1; }
            
            $syllables{"$word"} = $syll_count;
        }

        $syllable_count += $syllables{"$word"};

        $sentiment_score += $sentiment{"$word"};
     #   print "$word\t$syllables{$word}\n";

    }
    $totalSent+=$sentiment_score;
    $lineSyl{$syllable_count}++;





    #print "$_\t$syllable_count\t$sentiment_score\n";
}


foreach my $word (sort {$count{$a} <=> $count{$b}} keys %count) {
        print $word . ": " . $count{$word} . "\n";


 }

 foreach my $word (sort {$lineSyl{$a} <=> $lineSyl{$b}} keys %lineSyl) {
        print $word . ": " . $lineSyl{$word} . "\n";
 }


print "Total sentiment is $totalSent \n";
