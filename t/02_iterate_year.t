use strict;
use Test::More;
use Time::Piece;
use Time::Piece::Iterator;

my $format = '%Y-%m-%dT%H:%M:%S';

subtest "'from' is a past datetime than 'to'" => sub {
    my @expects = qw/
        2011-01-01T00:00:00
        2012-01-01T00:00:00
        2013-01-01T00:00:00
        2014-01-01T00:00:00
    /;

    my $iterator = year_iterator(
        localtime->strptime($expects[0],  $format),
        localtime->strptime($expects[-1], $format),
    );

    while( my $t = $iterator->next ) {
        is( ref $t, "Time::Piece", "Datetime is a Time::Piece object");
        my $expect = shift @expects;
        is( $t->datetime, $expect, "Datetime is $expect");
    }
};

subtest "'from' is a future datetime than 'to'" => sub {
    my @expects = qw/
        2014-01-01T00:00:00
        2013-01-01T00:00:00
        2012-01-01T00:00:00
        2011-01-01T00:00:00
    /;

    my $iterator = year_iterator(
        localtime->strptime($expects[0],  $format),
        localtime->strptime($expects[-1], $format),
    );

    while( my $t = $iterator->next ) {
        is( ref $t, "Time::Piece", "Datetime is a Time::Piece object");
        my $expect = shift @expects;
        is( $t->datetime, $expect, "Datetime is $expect");
    }
};

done_testing;

