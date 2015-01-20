#!/usr/bin/perl

use strict;
use warnings;
use List::Util qw/sum/;
use Test::More;
use Test::Warnings;
use Getopt::Alt;

if ( !eval { require YAML } || !eval { require YAML::XS } || !eval { require YAML::Syck } ) {
    plan skip_all => 'Needs YAML, YAML::XS or YAML::Syck to run';
}

build();
get_opt();
done_testing();

sub build {
    my $opt = eval { Getopt::Alt->new({ helper => 0 }, []) };
    ok $opt;

    $opt = eval {
        Getopt::Alt->new(
            {
                helper      => 0,
                conf_prefix => 't/.',
            },
            ['foo|f']
        )
    };
    my $error = $@;
    ok !$error, "No error found"
        or diag "Error : $error";
    ok $opt, "Conf read with out error";
    ok $opt->default->{foo}, "--foo read";
    is $opt->aliases->{bar}[0], 'baz', "bar is baz";

    $opt = eval {
        Getopt::Alt->new(
            {
                helper      => 0,
                conf_prefix => 't/.',
                name        => 'other',
            },
            ['foo|f']
        )
    };
    ok $opt, "Conf read with out error";
    ok !$opt->default->{foo}, "--foo not read";
}

sub get_opt {
    my $opt = eval { get_options('test|t', 'foo|f', 'bar|b') };
    my $error = $@;
    ok !$error, 'no error' or diag $error;
}
