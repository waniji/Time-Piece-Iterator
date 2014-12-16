package Time::Piece::Iterator;
use 5.008001;
use strict;
use warnings;
use Time::Piece;
use Time::Seconds;
use Exporter 'import';

our $VERSION = "0.03";
our @EXPORT = map { $_.'_iterator' } qw/second minute hour day week month year custom/;

# constructors
sub second_iterator { __PACKAGE__->new( from => $_[0], to => $_[1], iterate => 'second' ) }
sub minute_iterator { __PACKAGE__->new( from => $_[0], to => $_[1], iterate => 'minute' ) }
sub hour_iterator   { __PACKAGE__->new( from => $_[0], to => $_[1], iterate => 'hour'   ) }
sub day_iterator    { __PACKAGE__->new( from => $_[0], to => $_[1], iterate => 'day'    ) }
sub week_iterator   { __PACKAGE__->new( from => $_[0], to => $_[1], iterate => 'week'   ) }
sub month_iterator  { __PACKAGE__->new( from => $_[0], to => $_[1], iterate => 'month'  ) }
sub year_iterator   { __PACKAGE__->new( from => $_[0], to => $_[1], iterate => 'year'   ) }
sub custom_iterator { __PACKAGE__->new( from => $_[0], to => $_[1], iterate => $_[2]    ) }

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

    if(!exists $args{iterate}){
        die "'iterate' is required.";
    }

    my $iterate = $args{iterate};
    if( ref $iterate ne "CODE" ) {
        $iterate = __PACKAGE__->can("_next_$args{iterate}");
        unless( defined $iterate ) {
            die "Specified 'iterate' is unusable.";
        }
    }

    bless {
        from => $args{from},
        to => $args{to},
        next => $args{from},
        sign => ( $args{from} > $args{to} ? -1 : 1 ),
        iterate => $iterate,
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

sub _next_value  { $_[0]->{iterate} }

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

    my $iterator = day_iterator(
        localtime->strptime('2014/01/01', '%Y/%m/%d'),
        localtime->strptime('2014/01/05', '%Y/%m/%d'),
    );

    while( my $t = $iterator->next ) {
        print $t->ymd, "\n";
    }

=head1 CONSTRUCTORS

=head2 new

    my $iterator = Time::Piece::Iterator->new(
        from => localtime->strptime('2014/01/01', '%Y/%m/%d'),
        to   => localtime->strptime('2014/01/05', '%Y/%m/%d'),
        iterate => 'day',
    );

Creates a new L<Time::Piece::Iterator> object. C<from> and C<to> must be L<Time::Piece> object. C<iterate> can be used second/minute/hour/day/week/month/year.

=head2 {second,minute,hour,day,week,month,year}_iterator

    my $iterator = day_iterator(
        localtime->strptime('2014/01/01', '%Y/%m/%d'),
        localtime->strptime('2014/01/05', '%Y/%m/%d'),
    );

These constructors are syntax sugar for C<new()>. Arguments must be L<Time::Piece> object.

=head2 custom_iterator

    my $iterator = custom_iterator(
        localtime->strptime('2014/01/01', '%Y/%m/%d'),
        localtime->strptime('2014/01/05', '%Y/%m/%d'),
        sub {
            my ($t, $sign) = @_;
            return $t + ( ONE_WEEK * 2 * $sign );
        },
    );

If you want to custom iterating unit, you will use this constructor.

=head1 METHODS

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

