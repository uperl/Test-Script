#!/usr/bin/perl

# Test a false return from Test::Script

use strict;
BEGIN {
	$|  = 1;
	$^W = 1;
}

# Set up
use Test::Builder::Tester tests => 4;
use Test::More;
use Test::Script;

# Until CPAN #14389 is fixed, create a false HARNESS_ACTIVE value
# if it doesn't exists to prevent a warning in test_test.
$ENV{HARNESS_ACTIVE} ||= 0;





#####################################################################
# Main Testing

SCOPE: {
	# Run a test for a known-bad program
	test_out("not ok 1 - Script t/bin/bad.pl compiles");
	test_fail(+1);
	my $rv = script_compiles_ok('t/bin/bad.pl');
	test_test('Bad script returns false');
	is( $rv, '', 'script_compiles_ok returns false as a convenience' );
}

SCOPE: {
	# Repeat with a custom message
	test_out("not ok 1 - It worked");
	test_fail(+1);
	my $rv = script_compiles_ok('t/bin/bad.pl', 'It worked');
	test_test('Bad script returns false');
	is( $rv, '', 'script_compiles_ok returns false as a convenience' );
}

exit(0);
