package Devel::Unplug::OO;

use strict;
use warnings;
use Carp;
use Devel::Unplug ();

=head1 NAME

Devel::Unplug::OO - OO interface to L<Devel::Unplug>

=head1 VERSION

This document describes Devel::Unplug::OO version 0.02

=cut

use vars qw($VERSION @ISA);

$VERSION = '0.02';

=head1 SYNOPSIS

    {
        my $unp = Devel::Unplug::OO->new( 'Some::Module' );
        eval "use Some::Module";
        like $@, qr{Some::Module}, "failed OK";
    }
    eval "use Some::Module";
    ok !$@, "loaded OK";

=head1 DESCRIPTION

C<Devel::Unplug::OO> is an object oriented wrapper around L<Devel::Unplug>.

=cut

=head1 INTERFACE 

=head2 C<< new( $module ... ) >>



=cut

sub new {
    
}

1;
__END__

=head1 DEPENDENCIES

L<Devel::Unplug>

=head1 INCOMPATIBILITIES

None reported.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-devel-unplug@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.

=head1 AUTHOR

Andy Armstrong  C<< <andy@hexten.net> >>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2007, Andy Armstrong C<< <andy@hexten.net> >>.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.
