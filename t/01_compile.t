#!/usr/bin/perl

# Compile testing for Test::Script

use strict;
BEGIN {
	$|  = 1;
	$^W = 1;
}

use Test::More tests => 3;

# Check their perl version
ok( $] >= 5.005, "Your perl is new enough" );

# Does the module load
use_ok('Test::Script');
ok(
	defined(&script_compiles_ok),
	'Exports script_compiles_ok by default',
);

exit(0);
