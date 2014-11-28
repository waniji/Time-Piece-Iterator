use strict;
use Test::More;
use Time::Piece;
use Time::Piece::Iterator;

subtest "'from' is a past date than 'to'" => sub {
    my @expect_dates = qw/
        2014-01-30
        2014-01-31
        2014-02-01
        2014-02-02
    /;

    my $iterator = Time::Piece::Iterator->new(
        from => localtime->strptime('20140130', '%Y%m%d'),
        to   => localtime->strptime('20140202', '%Y%m%d'),
    );

    while( my $date = $iterator->next ) {
    }

    $iterator->reset;

    while( my $date = $iterator->next ) {
        is( ref $date, "Time::Piece", "date is a Time::Piece object");
        my $expect_date = shift @expect_dates;
        is(  $date->ymd, $expect_date, "date is $expect_date");
    }
};

subtest "'from' is a future date than 'to'" => sub {
    my @expect_dates = qw/
        2014-02-02
        2014-02-01
        2014-01-31
        2014-01-30
    /;

    my $iterator = Time::Piece::Iterator->new(
        from => localtime->strptime('20140202', '%Y%m%d'),
        to   => localtime->strptime('20140130', '%Y%m%d'),
    );

    while( my $date = $iterator->next ) {
    }

    $iterator->reset;

    while( my $date = $iterator->next ) {
        is( ref $date, "Time::Piece", "date is a Time::Piece object");
        my $expect_date = shift @expect_dates;
        is(  $date->ymd, $expect_date, "date is $expect_date");
    }
};

done_testing;

