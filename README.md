# Test::Script

Basic cross-platform tests for scripts

# SYNOPSIS

    use Test::More tests => 2;
    use Test::Script;
    
    script_compiles('script/awesomescript.pl');
    script_runs(['script/awesomescript.pl', '--awesome-argument']);

# DESCRIPTION

The intent of this module is to provide a series of basic tests for 80%
of the testing you will need to do for scripts in the `script` (or `bin`
as is also commonly used) paths of your Perl distribution.

Further, it aims to provide this functionality with perfect
platform-compatibility, and in a way that is as unobtrusive as possible.

That is, if the program works on a platform, then **Test::Script**
should always work on that platform as well. Anything less than 100% is
considered unacceptable.

In doing so, it is hoped that **Test::Script** can become a module that
you can safely make a dependency of all your modules, without risking that
your module won't on some platform because of the dependency.

Where a clash exists between wanting more functionality and maintaining
platform safety, this module will err on the side of platform safety.

# FUNCTIONS

## script\_compiles

    script_compiles( $script, $test_name );

The ["script\_compiles"](#script_compiles) test calls the script with "perl -c script.pl",
and checks that it returns without error.

The path it should be passed is a relative unix-format script name. This
will be localised when running `perl -c` and if the test fails the local
name used will be shown in the diagnostic output.

Note also that the test will be run with the same [perl](https://metacpan.org/pod/perl) interpreter that
is running the test script (and not with the default system perl). This
will also be shown in the diagnostic output on failure.

## script\_runs

    script_runs( $script, $test_name );
    script_runs( \@script_and_arguments, $test_name );
    script_runs( $script, \%options, $test_name );
    script_runs( \@script_and_arguments, \%options, $test_name );

The ["script\_runs"](#script_runs) test executes the script with "perl script.pl" and checks
that it returns success.

The path it should be passed is a relative unix-format script name. This
will be localised when running `perl -c` and if the test fails the local
name used will be shown in the diagnostic output.

The test will be run with the same [perl](https://metacpan.org/pod/perl) interpreter that is running the
test script (and not with the default system perl). This will also be shown
in the diagnostic output on failure.

You may pass in options as a hash as the second argument.

- exit

    The expected exit value.  The default is to use whatever indicates success
    on your platform (usually 0).

- signal

    The expected signal.  The default is 0.

- stdin

    The input to be passed into the script via stdin.

## script\_stdout\_is

    script_stdout_is $expected_stdout, $test;

Tests if the output to stdout from the previous ["script\_runs"](#script_runs) matches the 
expected value exactly.

## script\_stdout\_isnt

    script_stdout_is $expected_stdout, $test;

Tests if the output to stdout from the previous ["script\_runs"](#script_runs) does NOT match the 
expected value exactly.

## script\_stdout\_like

    script_stdout_like $regex, $test_name;

Tests if the output to stdout from the previous ["script\_runs"](#script_runs) matches the regular
expression.

## script\_stdout\_unlike

    script_stdout_unlike $regex, $test_name;

Tests if the output to stdout from the previous ["script\_runs"](#script_runs) does NOT match the regular
expression.

## script\_stderr\_is

    script_stderr_is $expected_stderr, $test;

Tests if the output to stderr from the previous ["script\_runs"](#script_runs) matches the 
expected value exactly.

## script\_stderr\_isnt

    script_stderr_is $expected_stderr, $test;

Tests if the output to stderr from the previous ["script\_runs"](#script_runs) does NOT match the 
expected value exactly.

## script\_stderr\_like

    script_stderr_like $regex, $test_name;

Tests if the output to stderr from the previous ["script\_runs"](#script_runs) matches the regular
expression.

## script\_stderr\_unlike

    script_stderr_unlike $regex, $test_name;

Tests if the output to stderr from the previous ["script\_runs"](#script_runs) does NOT match the regular
expression.

# SEE ALSO

[Test::Script::Run](https://metacpan.org/pod/Test::Script::Run), [Test::More](https://metacpan.org/pod/Test::More)

# AUTHOR

Original author: Adam Kennedy

Current maintainer: Graham Ollis <plicease@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2006 by Adam Kennedy.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
