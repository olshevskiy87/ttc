#!/usr/bin/perl

use strict;
use warnings;
use Carp;
use Term::ANSIColor;
use English qw(-no_match_vars);

my $ww_file = 'wrong_words';

unless (-e $ww_file) {
    croak "file $ww_file does not exist!\n";
    exit 0;
}

open my $fh, '<', $ww_file or croak $ERRNO;
my @wrong_words = <$fh>;
close $fh;
chomp @wrong_words;
@wrong_words = grep {/\w/x} @wrong_words;

my $chain = join('|', @wrong_words);

my $pattern;
while (<>) {
    chomp;
    if (/\b($chain)\b/x) {
        printf qq{%s: [%s] "%s"\n}
            , colored($ARGV, 'yellow')
            , colored($1, 'red')
            , $_;
    }
}

