use strict;
use Test::More;
use Test::Exception;
use Time::Piece;
use Time::Piece::Iterator;

dies_ok {
    Time::Piece::Iterator->new(
        from => '20140101',
        to   => localtime->strptime('20140105', '%Y%m%d'),
        iterate => "day",
    );
} "'from' is not a Time::Piece object";

dies_ok {
    Time::Piece::Iterator->new(
        from => localtime->strptime('20140101', '%Y%m%d'),
        to   => '20140105',
        iterate => "day",
    );
} "'to' is not a Time::Piece object";

dies_ok {
    Time::Piece::Iterator->new(
        to   => localtime->strptime('20140105', '%Y%m%d'),
        iterate => "day",
    );
} "'from' is required";

dies_ok {
    Time::Piece::Iterator->new(
        from => localtime->strptime('20140101', '%Y%m%d'),
        iterate => "day",
    );
} "'to' is required";

dies_ok {
    Time::Piece::Iterator->new(
        from => localtime->strptime('20140101', '%Y%m%d'),
        to   => localtime->strptime('20140105', '%Y%m%d'),
    );
} "'iterate' is required";

dies_ok {
    Time::Piece::Iterator->new(
        from => localtime->strptime('20140101', '%Y%m%d'),
        to   => localtime->strptime('20140105', '%Y%m%d'),
        iterate => "unknown",
    );
} "Specified 'iterate' is unusable";

lives_ok {
    Time::Piece::Iterator->new(
        from => localtime->strptime('20140105', '%Y%m%d'),
        to   => localtime->strptime('20140101', '%Y%m%d'),
        iterate => "day",
    );
} "'from' is a future date than 'to'";

lives_ok {
    Time::Piece::Iterator->new(
        from => localtime->strptime('20140101', '%Y%m%d'),
        to   => localtime->strptime('20140101', '%Y%m%d'),
        iterate => "day",
    );
} "'from' and 'to' are the same date";

lives_ok {
    Time::Piece::Iterator->new(
        from => localtime->strptime('20140101', '%Y%m%d'),
        to   => localtime->strptime('20140105', '%Y%m%d'),
        iterate => "day",
    );
} "'from' is a past date than 'to'";

done_testing;

