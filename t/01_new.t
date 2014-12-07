use strict;
use Test::More;
use Test::Exception;
use Time::Piece;
use Time::Piece::Iterator;

dies_ok {
    Time::Piece::Iterator->new(
        from => '20140101',
        to   => localtime->strptime('20140105', '%Y%m%d'),
        iterating_units => "day",
    );
} "'from' is not a Time::Piece object";

dies_ok {
    Time::Piece::Iterator->new(
        from => localtime->strptime('20140101', '%Y%m%d'),
        to   => '20140105',
        iterating_units => "day",
    );
} "'to' is not a Time::Piece object";

dies_ok {
    Time::Piece::Iterator->new(
        to   => localtime->strptime('20140105', '%Y%m%d'),
        iterating_units => "day",
    );
} "'from' is required";

dies_ok {
    Time::Piece::Iterator->new(
        from => localtime->strptime('20140101', '%Y%m%d'),
        iterating_units => "day",
    );
} "'to' is required";

lives_ok {
    Time::Piece::Iterator->new(
        from => localtime->strptime('20140105', '%Y%m%d'),
        to   => localtime->strptime('20140101', '%Y%m%d'),
        iterating_units => "day",
    );
} "'from' is a future date than 'to'";

lives_ok {
    Time::Piece::Iterator->new(
        from => localtime->strptime('20140101', '%Y%m%d'),
        to   => localtime->strptime('20140101', '%Y%m%d'),
        iterating_units => "day",
    );
} "'from' and 'to' are the same date";

lives_ok {
    Time::Piece::Iterator->new(
        from => localtime->strptime('20140101', '%Y%m%d'),
        to   => localtime->strptime('20140105', '%Y%m%d'),
        iterating_units => "day",
    );
} "'from' is a past date than 'to'";

done_testing;

