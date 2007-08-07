package Devel::Unplug;

use warnings;
use strict;
use Devel::TraceLoad::Hook qw/register_require_hook/;

use vars qw($VERSION);
$VERSION = '0.0.1';

sub _get_module {
    my $file = shift;
    return $file if $file =~ m{^/};
    $file =~ s{/}{::}g;
    $file =~ s/[.]pm$//;
    return $file;
}

{
    my %unplugged = ();

    sub unplug_module {
        $unplugged{$_}++ for @_;
    }

    sub replug_module {
        for my $mod ( @_ ) {
            delete $unplugged{$mod}
              if $unplugged{$mod} && 0 == --$unplugged{$mod};
        }
    }

    sub get_unplugged {
        return grep { $unplugged{$_} } keys %unplugged;
    }

    sub import {
        unplug_module( @_ );
        
        register_require_hook(
            sub {
                my ( $when, $depth, $arg, $p, $f, $l, $rc, $err ) = @_;

                return unless $when eq 'before';
                my $module = _get_module( $arg );
                return unless $unplugged{$module};

                # Ain't gonna let you load it
                die "Can't locate $arg in \@INC (unplugged by "
                  . __PACKAGE__ . ")";
            }
        );
    }
}

1;
__END__

=head1 NAME

Devel::Unplug - Simulate the non-availability of modules

=head1 VERSION

This document describes Devel::Unplug version 0.0.1

=head1 SYNOPSIS

    use Devel::Unplug;
  
=head1 DESCRIPTION

=head1 INTERFACE 

=over

=item C<< unplug_module >>

=item C<< replug_module >>

=item C<< get_unplugged >>

=back

=head1 DIAGNOSTICS

=over

=item C<< Error message here, perhaps with %s placeholders >>

[Description of error here]

=back

=head1 CONFIGURATION AND ENVIRONMENT
  
Devel::Unplug requires no configuration files or environment variables.

=head1 DEPENDENCIES

None.

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

Copyright (c) 2007, Andy Armstrong C<< <andy@hexten.net> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
