#!/usr/bin/perl

use strict;
use warnings;

use Cwd 'abs_path';
use Term::ANSIColor;
use Getopt::Long;
use File::Find;
use File::Basename;
use File::Spec::Functions 'catfile';

my $script_dir = dirname(Cwd::abs_path($0));
my $ww_path = catfile($script_dir, 'wrong_words');
my $path = $script_dir;

unless (
    GetOptions(
        "ww_path=s" => \$ww_path,
        "path=s"    => \$path
    )
) {
    print qq{ttc - tiny typos checker

Usage:
    ttc [options]

Options:
  - ww_path      path to the wrong words file
  - path         folder or file to check
};
    exit 1;
}

my @fnames = ();
sub wanted {
    return if ! -f "$_" or -B "$_";
    return if $File::Find::dir =~ / \/\.git\/? /x;
    return if $_ =~ /\.(po)$/;

    push @fnames, $File::Find::dir.'/'.$_;
};
find(\&wanted, $path);

unless (-e $ww_path) {
    print "file $ww_path does not exist!\n";
    exit 1;
}

open my $fh, '<', $ww_path or print $!;
my @wrong_words = <$fh>;
close $fh;

chomp @wrong_words;
@wrong_words = grep { ! /^$/ } @wrong_words;
my $chain = join('|', @wrong_words);

my ($pattern, @matches);
foreach my $fname (@fnames) {
    open (my $FH, '<', $fname);
    while (<$FH>) {
        chomp;
        if (@matches = $_ =~ /\b($chain)\b/gi) {
            foreach my $match (@matches) {
                printf qq{%s:%s [%s] "%s"\n}
                    , colored($fname, 'yellow')
                    , $.
                    , colored($match, 'red')
                    , $_;
            }
        }
    }
    close $FH;
}
