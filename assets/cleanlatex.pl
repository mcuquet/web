#! /usr/bin/perl
# Copyleft 2009 Marti Cuquet
# http://sindominio.net/~nilvar/code/

use strict;
use Getopt::Long;

my $scriptname = "cleanlatex";
my $scriptdescription = "Cleans files generated by LaTeX";
my $scriptusage = "$scriptname [-a] [file]";

my $all = 0;
my $help = 0;

my @BasicExtensions = ('tex~','bib~','aux','log','toc','lof','lot','bbl','blg','out','idx','ind','ilg','nav');
my @ExtraExtensions = ('ps','pdf','dvi');
my @UserExtensions = ();

GetOptions (
    "all|a" => \$all,
    "extension|e=s" => \@UserExtensions,
    "help|h" => \$help
) or die "Usage: $scriptusage\n";
@UserExtensions = split(/,/,join(',',@UserExtensions));

if ($help) {
    print<<"HELP";
$scriptname - $scriptdescription
Usage: $scriptusage

Extensions removed:
@BasicExtensions

With '--all' the following are also removed:
@ExtraExtensions

You can give extra extensions (e.g. ext1, ext2) with either
  '--extension ext1 --extension ext2'
  '-e ext1 -e ext2'
  '--extension ext1,ext2'
  '-e ext1,ext2'
HELP
    exit 0;
}

my @Extensions = ();
my $file = shift;

push @Extensions, @BasicExtensions;
push @Extensions, @ExtraExtensions if ($all);
push @Extensions, @UserExtensions;

if ($file) {
    my $name = ($file =~ /(.+)\.tex$/) ? $1 : $file;
    &CleanExt ($name);
    exit 0;
}

opendir DIR, "." or die "$scriptname: can't open current directory\n";
while ($file = readdir DIR) {
    next unless ($file =~ /(.+)\.tex$/);
    my $name = $1;
    &CleanExt ($name);
}
closedir DIR;

exit 0;

sub CleanExt {
    my $f = shift;
    print "-- $f.tex\n";
    foreach my $ext (@Extensions) {
        if (-e $f . "." . $ext) {
            print " |- $f.$ext\n";
            `rm $f.$ext`;
        }
    }
    print "\n";
}
