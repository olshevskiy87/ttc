#!/usr/bin/perl

use strict;
use warnings;
use Carp;
use Term::ANSIColor;
use English qw(-no_match_vars);
use Getopt::Long;

my $ww_path = 'wrong_words';
unless (GetOptions("ww_path=s" => \$ww_path)) {
    croak("error in command line arguments\n");
    exit 1;
}

unless (-e $ww_path) {
    croak "file $ww_path does not exist!\n";
    exit 1;
}

open my $fh, '<', $ww_path or croak $ERRNO;
my @wrong_words = <$fh>;
close $fh;

chomp @wrong_words;
@wrong_words = grep { ! /^$/ } @wrong_words;
my $chain = join('|', @wrong_words);

my ($pattern, @matches);
while (<>) {
    chomp;
    if (@matches = $_ =~ /\b($chain)\b/gi) {
        foreach my $match (@matches) {
            printf qq{%s:%s [%s] "%s"\n}
                , colored($ARGV, 'yellow')
                , $NR
                , colored($match, 'red')
                , $_;
        }
    }
}

