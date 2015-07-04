#!/usr/bin/perl

use strict;
use warnings;
use Carp;
use Term::ANSIColor;
use English qw(-no_match_vars);

my $ww_file = 'wrong_words';

unless (-e $ww_file) {
    croak "file $ww_file does not exist!\n";
    exit 1;
}

open my $fh, '<', $ww_file or croak $ERRNO;
my @wrong_words = <$fh>;
close $fh;

chomp @wrong_words;
@wrong_words = grep { ! /^$/ } @wrong_words;
my $chain = join('|', @wrong_words);

my ($pattern, @matches);
while (<>) {
    chomp;
    if (@matches = $_ =~ /\b($chain)\b/g) {
        foreach my $match (@matches) {
            printf qq{%s:%s [%s] "%s"\n}
                , colored($ARGV, 'yellow')
                , $NR
                , colored($match, 'red')
                , $_;
        }
    }
}

