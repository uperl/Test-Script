#!/usr/bin/perl

# Compile testing for Test::Script

use strict;
BEGIN {
	$|  = 1;
	$^W = 1;
}

use Test::More tests => 3;

use_ok('Test::Script');
ok( defined(&script_compiles), 'Exports script_compiles by default' );
ok( defined(&script_runs),     'Exports script_runs by default'     );
