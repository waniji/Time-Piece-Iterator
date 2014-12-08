[![Build Status](https://travis-ci.org/waniji/Time-Piece-Iterator.svg?branch=master)](https://travis-ci.org/waniji/Time-Piece-Iterator) [![Coverage Status](https://img.shields.io/coveralls/waniji/Time-Piece-Iterator/master.svg)](https://coveralls.io/r/waniji/Time-Piece-Iterator?branch=master)
# NAME

Time::Piece::Iterator - Iterate through datetimes in a range.

# SYNOPSIS

    use Time::Piece;
    use Time::Piece::Iterator;

    my $iterator = Time::Piece::Iterator->new(
        from => localtime->strptime('2014/01/01', '%Y/%m/%d'),
        to   => localtime->strptime('2014/01/05', '%Y/%m/%d'),
        iterating_units => 'day',
    );

    while( my $t = $iterator->next ) {
        print $t->ymd, "\n";
    }

# METHODS

## new

    my $iterator = Time::Piece::Iterator->new(
        from => localtime->strptime('2014/01/01', '%Y/%m/%d'),
        to   => localtime->strptime('2014/01/05', '%Y/%m/%d'),
        iterating_units => 'day',
    );

Creates a new [Time::Piece::Iterator](https://metacpan.org/pod/Time::Piece::Iterator) object. `from` and `to` must be [Time::Piece](https://metacpan.org/pod/Time::Piece) object. `iterating_units` can be used second/minute/hour/day/week/month/year.

## next

    while( my $t = $iterator->next ) {
        print $t->ymd, "\n";
    }

Returns a [Time::Piece](https://metacpan.org/pod/Time::Piece) object with the next datetime. If iteration process is finished, it returns `undef`.

## reset

    $iterator->reset;

Resets the iterator so that the next call to `next()` returns the first datetime.

# LICENSE

Copyright (C) Makoto Sasaki.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Makoto Sasaki < wanigoya@gmail.com >
