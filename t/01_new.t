use strict;
use Test::More;
use Test::Exception;
use Time::Piece;
use Time::Piece::Iterator;

dies_ok {
    Time::Piece::Iterator->new(
        from => '20140101',
        to   => localtime->strptime('20140105', '%Y%m%d'),
    );
}, 'fromがTime::Pieceオブジェクトではない場合は例外を投げる';

dies_ok {
    Time::Piece::Iterator->new(
        from => localtime->strptime('20140101', '%Y%m%d'),
        to   => '20140105',
    );
}, 'toがTime::Pieceオブジェクトではない場合は例外を投げる';

dies_ok {
    Time::Piece::Iterator->new(
        to   => localtime->strptime('20140105', '%Y%m%d'),
    );
}, 'fromが指定されていない場合は例外を投げる';

dies_ok {
    Time::Piece::Iterator->new(
        from => localtime->strptime('20140101', '%Y%m%d'),
    );
}, 'toが指定されていない場合は例外を投げる';

dies_ok {
    Time::Piece::Iterator->new(
        from => localtime->strptime('20140105', '%Y%m%d'),
        to   => localtime->strptime('20140101', '%Y%m%d'),
    );
}, 'fromがtoより未来である場合は例外を投げる';

lives_ok {
    Time::Piece::Iterator->new(
        from => localtime->strptime('20140101', '%Y%m%d'),
        to   => localtime->strptime('20140101', '%Y%m%d'),
    );
}, 'fromとtoが同日';

lives_ok {
    Time::Piece::Iterator->new(
        from => localtime->strptime('20140101', '%Y%m%d'),
        to   => localtime->strptime('20140105', '%Y%m%d'),
    );
}, 'fromとtoが正常値';

done_testing;

