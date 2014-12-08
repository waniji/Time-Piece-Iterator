package Time::Piece::Iterator;
use 5.008001;
use strict;
use warnings;
use Time::Piece;
use Time::Seconds;

our $VERSION = "0.03";

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

    if(!exists $args{iterating_units}){
        die "'iterating_units' is required.";
    }

    my $next_value_method = $class->can("_next_$args{iterating_units}");
    unless( defined $next_value_method ) {
        die "Specified 'iterating_units' is unusable.";
    }

    bless {
        from => $args{from},
        to => $args{to},
        next => $args{from},
        sign => ( $args{from} > $args{to} ? -1 : 1 ),
        next_value_method => $next_value_method,
    }, $class;
}

sub next {
    my $self = shift;

    return if $self->_iterate_is_finished;

    my $t = $self->{next};
    $self->{next} = $self->_next_value->( $self->{next}, $self->{sign} );

    return $t;
}

sub reset {
    my $self = shift;
    $self->{next} = $self->{from};
}

sub _next_value  { $_[0]->{next_value_method} }
sub _next_second { $_[0] + ( $_[1] * 1          ) }
sub _next_minute { $_[0] + ( $_[1] * ONE_MINUTE ) }
sub _next_hour   { $_[0] + ( $_[1] * ONE_HOUR   ) }
sub _next_day    { $_[0] + ( $_[1] * ONE_DAY    ) }
sub _next_week   { $_[0] + ( $_[1] * ONE_WEEK   ) }
sub _next_month  { $_[0]->add_months( $_[1] * 1 ) }
sub _next_year   { $_[0]->add_years(  $_[1] * 1 ) }

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

Time::Piece::Iterator - Iterate through datetimes in a range.

=head1 SYNOPSIS

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

=head1 METHODS

=head2 new

    my $iterator = Time::Piece::Iterator->new(
        from => localtime->strptime('2014/01/01', '%Y/%m/%d'),
        to   => localtime->strptime('2014/01/05', '%Y/%m/%d'),
        iterating_units => 'day',
    );

Creates a new L<Time::Piece::Iterator> object. C<from> and C<to> must be L<Time::Piece> object. C<iterating_units> can be used second/minute/hour/day/week/month/year.


=head2 next


    while( my $t = $iterator->next ) {
        print $t->ymd, "\n";
    }

Returns a L<Time::Piece> object with the next datetime. If iteration process is finished, it returns C<undef>.

=head2 reset

    $iterator->reset;

Resets the iterator so that the next call to C<next()> returns the first datetime.

=head1 LICENSE

Copyright (C) Makoto Sasaki.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Makoto Sasaki E<lt> wanigoya@gmail.com E<gt>

=cut

