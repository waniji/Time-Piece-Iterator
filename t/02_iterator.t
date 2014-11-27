use strict;
use Test::More;
use Time::Piece;
use Time::Piece::Iterator;

my @expects = qw/
    20140130
    20140131
    20140201
    20140202
/;

my $iterator = Time::Piece::Iterator->new(
    from => localtime->strptime('20140130', '%Y%m%d'),
    to   => localtime->strptime('20140202', '%Y%m%d'),
);

while( my $date = $iterator->next ) {
    is( ref $date, "Time::Piece", "Time::Pieceオブジェクトである");
    is(  $date->ymd(""), shift @expects, "日付が正しい");
}

$iterator->reset;

@expects = qw/
    20140130
    20140131
    20140201
    20140202
/;

while( my $date = $iterator->next ) {
    is( ref $date, "Time::Piece", "resetしてもTime::Pieceオブジェクトである");
    is( $date->ymd(""), shift @expects, "resetしても日付が正しい");
}

done_testing;

