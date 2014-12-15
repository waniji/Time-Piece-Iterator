use strict;
use Test::More;
use Time::Piece;
use Time::Piece::Iterator;
use Time::Seconds;

my $format = '%Y-%m-%dT%H:%M:%S';

subtest "'from' is a past datetime than 'to'" => sub {
    my @expects = qw/
        2014-01-24T00:00:00
        2014-02-07T00:00:00
        2014-02-21T00:00:00
    /;

    my $iterator = custom_iterator(
        localtime->strptime($expects[0],  $format),
        localtime->strptime($expects[-1], $format),
        sub {
            my ($t, $sign) = @_;
            return $t + ( ONE_WEEK * 2 * $sign );
        },
    );

    while( my $t = $iterator->next ) {
        is( ref $t, "Time::Piece", "Datetime is a Time::Piece object");
        my $expect = shift @expects;
        is( $t->datetime, $expect, "Datetime is $expect");
    }
};

subtest "'from' is a future datetime than 'to'" => sub {
    my @expects = qw/
        2014-02-21T00:00:00
        2014-02-07T00:00:00
        2014-01-24T00:00:00
    /;

    my $iterator = custom_iterator(
        localtime->strptime($expects[0],  $format),
        localtime->strptime($expects[-1], $format),
        sub {
            my ($t, $sign) = @_;
            return $t + ( ONE_WEEK * 2 * $sign );
        },
    );

    while( my $t = $iterator->next ) {
        is( ref $t, "Time::Piece", "Datetime is a Time::Piece object");
        my $expect = shift @expects;
        is( $t->datetime, $expect, "Datetime is $expect");
    }
};

done_testing;

