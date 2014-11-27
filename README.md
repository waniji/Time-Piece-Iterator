# NAME

Time::Piece::Iterator - It's new $module

# SYNOPSIS

    use Time::Piece;
    use Time::Piece::Iterator;

    my $iterator = Time::Piece::Iterator->new(
        from => localtime->strptime('20140101', '%Y%m%d'),
        to   => localtime->strptime('20140105', '%Y%m%d'),
    );

    while( my $date = $iterator->next ) {
        print $date->ymd, "\n";
    }

# DESCRIPTION

## new

## next

## reset

# LICENSE

Copyright (C) Makoto Sasaki.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Makoto Sasaki < wanigoya@gmail.com >
