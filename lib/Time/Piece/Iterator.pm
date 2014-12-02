package Time::Piece::Iterator;
use 5.008001;
use strict;
use warnings;
use Time::Piece;
use Time::Seconds;

our $VERSION = "0.02";

sub new {
    my ($class, %args) = @_;

    for my $key ( qw/from to/ ) {
        if (!exists $args{$key}) {
            die "'$key' is required.";
        }
        if (ref $args{$key} ne "Time::Piece") {
            die "'$key' must be a Time::Piece object.";
        }
    }

    bless {
        from => $args{from},
        to => $args{to},
        next => $args{from},
        sign => ( $args{from} > $args{to} ? -1 : 1 ),
    }, $class;
}

sub next {
    my $self = shift;

    return if $self->_iterate_is_finished;

    my $date = $self->{next};
    $self->{next} += ( $self->{sign} * ONE_DAY );

    return $date;
}

sub reset {
    my $self = shift;
    $self->{next} = $self->{from};
}

sub _iterate_is_finished {
    my $self = shift;

    if( $self->{sign} > 0 ) {
        return $self->{next} > $self->{to};
    } else {
        return $self->{to} > $self->{next};
    }
}

1;
__END__

=encoding utf-8

=head1 NAME

Time::Piece::Iterator - Iterate through dates in a range.

=head1 SYNOPSIS

    use Time::Piece;
    use Time::Piece::Iterator;

    my $iterator = Time::Piece::Iterator->new(
        from => localtime->strptime('2014/01/01', '%Y/%m/%d'),
        to   => localtime->strptime('2014/01/05', '%Y/%m/%d'),
    );

    while( my $date = $iterator->next ) {
        print $date->ymd, "\n";
    }

=head1 METHODS

=head2 new

    my $iterator = Time::Piece::Iterator->new(
        from => localtime->strptime('2014/01/01', '%Y/%m/%d'),
        to   => localtime->strptime('2014/01/05', '%Y/%m/%d'),
    );

Creates a new L<Time::Piece::Iterator> object. C<from> and C<to> must be L<Time::Piece> object.

=head2 next


    while( my $date = $iterator->next ) {
        print $date->ymd, "\n";
    }

Returns a L<Time::Piece> object with the next date. If iteration process is finished, it returns C<undef>.

=head2 reset

    $iterator->reset;

Resets the iterator so that the next call to C<next()> returns the first date.

=head1 LICENSE

Copyright (C) Makoto Sasaki.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Makoto Sasaki E<lt> wanigoya@gmail.com E<gt>

=cut

