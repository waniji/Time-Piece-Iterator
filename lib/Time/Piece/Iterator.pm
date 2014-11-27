package Time::Piece::Iterator;
use 5.008001;
use strict;
use warnings;
use Time::Piece;
use Time::Seconds;

our $VERSION = "0.01";

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

    if ( $args{from} > $args{to} ) {
        die "'from' must be a 'to' the same day or the past.";
    }

    bless {
        from => $args{from},
        to => $args{to},
        now => $args{from},
    }, $class;
}

sub next {
    my $self = shift;

    if( $self->{now} > $self->{to} ) {
        return;
    }

    my $date = $self->{now};
    $self->{now} += ONE_DAY;

    return $date;
}

sub reset {
    my $self = shift;
    $self->{now} = $self->{from};
}

1;
__END__

=encoding utf-8

=head1 NAME

Time::Piece::Iterator - It's new $module

=head1 SYNOPSIS

    use Time::Piece;
    use Time::Piece::Iterator;

    my $iterator = Time::Piece::Iterator->new(
        from => localtime->strptime('20140101', '%Y%m%d'),
        to   => localtime->strptime('20140105', '%Y%m%d'),
    );

    while( my $date = $iterator->next ) {
        print $date->ymd, "\n";
    }

=head1 DESCRIPTION

=head2 new

=head2 next

=head2 reset

=head1 LICENSE

Copyright (C) Makoto Sasaki.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Makoto Sasaki E<lt> wanigoya@gmail.com E<gt>

=cut

