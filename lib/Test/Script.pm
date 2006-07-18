package Test::Script;

=pod

=head1 NAME

Test::Script - Highly cross-platform basic tests for script

=head1 DESCRIPTION

B<This module is experimental and may not perform as advertised... yet>

B<API may change in future without notice>

B<YOU HAVE BEEN WARNED>

The intent of this module is to provide a series of basic tests for
scripts in the F<bin> directory of your Perl distribution.

Further, it aims to provide them with perfect platform-compatibility
and in a way that is as unobtrusive as possible.

That is, if the program works on a platform, then B<Test::Script>
should also work on that platform.

In doing so, it is hoped that B<Test::Script> can become a module that
you can safely make a dependency of your module, without risking your
module not working on some platform because of the dependency.

Where a clash exists between wanting more functionality and maintaining
platform safety, this module will err on the side of platform safety.

=head1 FUNCTIONS

=cut

use 5.005;
use strict;
use Carp             ();
use Exporter         ();
use File::Spec       ();
use File::Spec::Unix ();
use IPC::Run3        ();
use Test::More       ();

use vars qw{$VERSION @ISA @EXPORT};
BEGIN {
	$VERSION = '0.01';
	@ISA     = qw( Exporter );
	@EXPORT  = qw( script_compiles_ok );
}





#####################################################################
# Test Functions

=pod

=head2 script_compiles_ok

  script_compiles_ok( 'bin/foo', 'Main script compiles' );

The C<script_compiles_ok> test calls the script with "perl -c scriptname",
and checks that it returns without error.

The path it should be passed is a relative unix-format script name. This
will be localised when running C<perl -c>, and if the test fails, the local
name used will be shown in the diagnostic output.

Note also that the test will be actually done with the same L<perl>
interpreter that is running the test script (and not with the
default system perl). This will also be shown in the diagnostic output
on failure.

=cut

sub script_compiles_ok {
	my $unix    = shift;
	my $message = shift || "Script $unix compiles";
	my $path    = path( $unix );
	my $cmd     = [ $^X, '-c', $path ];
	my $ok      = IPC::Run3::run3( $cmd, \undef, \undef, \undef );
	Test::More::ok( $ok, $message );
	unless ( $ok ) {
		my $cmdstr = join( ' ', @$cmd );
		Test::More::diag( "Call '$cmdstr' returned an error" );
	}
	return $ok;
}

sub path ($) {
	my $path = shift;
	unless ( defined $path ) {
		Carp::croak("Did not provide a script name");
	}
	if ( File::Spec::Unix->file_name_is_absolute($path) ) {
		Carp::croak("Script name must be relative");
	}
	File::Spec->catfile( File::Spec->curdir, split /\//, $path );
}

1;

=pod

=head1 TO DO

- Make this work properly

- This module does not itself have tests

- Test on as many platforms as possible

=head1 SUPPORT

All bugs should be filed via the bug tracker at

L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Test-Script>

For other issues, or commercial enhancement and support, contact the author

=head1 AUTHOR

Adam Kennedy E<lt>adamk@cpan.orgE<gt>

=head1 SEE ALSO

L<prove>, L<http://ali.as/>

=head1 COPYRIGHT

Copyright 2006 Adam Kennedy. All rights reserved.

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=cut
