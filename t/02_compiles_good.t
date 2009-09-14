#!/usr/bin/perl

# Test a true return from Test::Script

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
	# Run a test for a known-good program
	test_out("ok 1 - Script t/bin/good.pl compiles");
	my $rv = script_compiles_ok('t/bin/good.pl');
	test_test('Bad script returns false');
	is( $rv, 1, 'script_compiles_ok returns true as a convenience' );
}

SCOPE: {	
	# Repeat with a custom message
	test_out("ok 1 - It worked");
	my $rv = script_compiles_ok('t/bin/good.pl', 'It worked');
	test_test('Bad script returns false');
	is( $rv, 1, 'script_compiles_ok returns true as a convenience' );
}
