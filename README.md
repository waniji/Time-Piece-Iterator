# NAME

Time::Piece::Iterator - Iterate through dates in a range.

# SYNOPSIS

    use Time::Piece;
    use Time::Piece::Iterator;

    my $iterator = Time::Piece::Iterator->new(
        from => localtime->strptime('2014/01/01', '%Y/%m/%d'),
        to   => localtime->strptime('2014/01/05', '%Y/%m/%d'),
    );

    while( my $date = $iterator->next ) {
        print $date->ymd, "\n";
    }

# METHODS

## new

    my $iterator = Time::Piece::Iterator->new(
        from => localtime->strptime('2014/01/01', '%Y/%m/%d'),
        to   => localtime->strptime('2014/01/05', '%Y/%m/%d'),
    );

Creates a new [Time::Piece::Iterator](https://metacpan.org/pod/Time::Piece::Iterator) object. `from` and `to` must be [Time::Piece](https://metacpan.org/pod/Time::Piece) object.

## next

    while( my $date = $iterator->next ) {
        print $date->ymd, "\n";
    }

Returns a [Time::Piece](https://metacpan.org/pod/Time::Piece) object with the next date. If iteration process is finished, it returns `undef`.

## reset

    $iterator->reset;

Resets the iterator so that the next call to `next()` returns the first date.

# LICENSE

Copyright (C) Makoto Sasaki.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Makoto Sasaki < wanigoya@gmail.com >
