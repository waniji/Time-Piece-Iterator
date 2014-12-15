use strict;
use Test::More;
use Time::Piece;
use Time::Piece::Iterator;

my $format = '%Y-%m-%dT%H:%M:%S';

subtest "'from' is a past datetime than 'to'" => sub {
    my @expects = qw/
        2014-01-31T23:58:00
        2014-01-31T23:59:00
        2014-02-01T00:00:00
        2014-02-01T00:01:00
    /;

    my $iterator = minute_iterator(
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
        2014-02-01T00:01:00
        2014-02-01T00:00:00
        2014-01-31T23:59:00
        2014-01-31T23:58:00
    /;

    my $iterator = minute_iterator(
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

