# Test::Script [![Build Status](https://api.travis-ci.com/plicease/Test-Script.svg?branch=main)](https://travis-ci.com/github/plicease/Test-Script) ![windows](https://github.com/plicease/Test-Script/workflows/windows/badge.svg) ![macos](https://github.com/plicease/Test-Script/workflows/macos/badge.svg)

Basic cross-platform tests for scripts

# SYNOPSIS

```perl
use Test2::V0;
use Test::Script;

script_compiles('script/myscript.pl');
script_runs(['script/myscript.pl', '--my-argument']);

program_runs(['ls', '/dev']);

done_testing;
```

# DESCRIPTION

The intent of this module is to provide a series of basic tests for 80%
of the testing you will need to do for scripts in the `script` (or `bin`
as is also commonly used) paths of your Perl distribution.

It also provides similar functions for testing programs that are not
Perl scripts.

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

```
script_compiles( $script, $test_name );
```

The ["script\_compiles"](#script_compiles) test calls the script with "perl -c script.pl",
and checks that it returns without error.

The path it should be passed is a relative Unix-format script name. This
will be localised when running `perl -c` and if the test fails the local
name used will be shown in the diagnostic output.

Note also that the test will be run with the same [perl](https://metacpan.org/pod/perl) interpreter that
is running the test script (and not with the default system perl). This
will also be shown in the diagnostic output on failure.

## script\_runs

```
script_runs( $script, $test_name );
script_runs( \@script_and_arguments, $test_name );
script_runs( $script, \%options, $test_name );
script_runs( \@script_and_arguments, \%options, $test_name );
```

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

- interpreter\_options

    Array reference of Perl options to be passed to the interpreter.  Things
    like `-w` or `-x` can be passed this way.  This may be either a single
    string or an array reference.

- signal

    The expected signal.  The default is 0.  Use with care!  This may not be
    portable, and is known not to work on Windows.

- stdin

    The input to be passed into the script via stdin.  The value may be one of

    - simple scalar

        Is considered to be a filename.

    - scalar reference

        In which case the input will be drawn from the data contained in the referenced
        scalar.

    The behavior for any other types is undefined (the current implementation uses
    [Capture::Tiny](https://metacpan.org/pod/Capture::Tiny)).  Any already opened stdin will be closed.

- stdout

    Where to send the standard output to.  If you use this option, then the the
    behavior of the `script_stdout_` functions below are undefined.  The value
    may be one of

    - simple scalar

        Is considered to be a filename.

    - scalar reference

    In which case the standard output will be places into the referenced scalar

    The behavior for any other types is undefined (the current implementation uses
    [Capture::Tiny](https://metacpan.org/pod/Capture::Tiny)).

- stderr

    Same as `stdout` above, except for stderr.

## script\_stdout\_is

```
script_stdout_is $expected_stdout, $test_name;
```

Tests if the output to stdout from the previous ["script\_runs"](#script_runs) matches the
expected value exactly.

## script\_stdout\_isnt

```
script_stdout_is $expected_stdout, $test_name;
```

Tests if the output to stdout from the previous ["script\_runs"](#script_runs) does NOT match the
expected value exactly.

## script\_stdout\_like

```
script_stdout_like $regex, $test_name;
```

Tests if the output to stdout from the previous ["script\_runs"](#script_runs) matches the regular
expression.

## script\_stdout\_unlike

```
script_stdout_unlike $regex, $test_name;
```

Tests if the output to stdout from the previous ["script\_runs"](#script_runs) does NOT match the regular
expression.

## script\_stderr\_is

```
script_stderr_is $expected_stderr, $test_name;
```

Tests if the output to stderr from the previous ["script\_runs"](#script_runs) matches the
expected value exactly.

## script\_stderr\_isnt

```
script_stderr_is $expected_stderr, $test_name;
```

Tests if the output to stderr from the previous ["script\_runs"](#script_runs) does NOT match the
expected value exactly.

## script\_stderr\_like

```
script_stderr_like $regex, $test_name;
```

Tests if the output to stderr from the previous ["script\_runs"](#script_runs) matches the regular
expression.

## script\_stderr\_unlike

```
script_stderr_unlike $regex, $test_name;
```

Tests if the output to stderr from the previous ["script\_runs"](#script_runs) does NOT match the regular
expression.

## program\_runs

```
program_runs( $program, $test_name );
program_runs( \@program_and_arguments, $test_name );
program_runs( $program, \%options, $test_name );
program_runs( \@program_and_arguments, \%options, $test_name );
```

The ["program\_runs"](#program_runs) test executes the given program and checks
that it returns success.  This function works like ["script\_runs"](#script_runs) except:

- The path `$program` or `@program_and_arguments` is passed as-is to
[system()](https://perldoc.perl.org/functions/system.html).  This means
`program_runs` can test any program, not just Perl scripts.
- The `%options` do not support the `interpreter_options` key.

See [File::Spec](https://metacpan.org/pod/File::Spec) or [Path::Class](https://metacpan.org/pod/Path::Class) for routines useful in building pathnames
in a cross-platform way.

## program\_stdout\_is

```
program_stdout_is $expected_stdout, $test_name;
```

Tests if the output to stdout from the previous ["program\_runs"](#program_runs) matches the
expected value exactly.

## program\_stdout\_isnt

```
program_stdout_is $expected_stdout, $test_name;
```

Tests if the output to stdout from the previous ["program\_runs"](#program_runs) does NOT match the
expected value exactly.

## program\_stdout\_like

```
program_stdout_like $regex, $test_name;
```

Tests if the output to stdout from the previous ["program\_runs"](#program_runs) matches the regular
expression.

## program\_stdout\_unlike

```
program_stdout_unlike $regex, $test_name;
```

Tests if the output to stdout from the previous ["program\_runs"](#program_runs) does NOT match the regular
expression.

## program\_stderr\_is

```
program_stderr_is $expected_stderr, $test_name;
```

Tests if the output to stderr from the previous ["program\_runs"](#program_runs) matches the
expected value exactly.

## program\_stderr\_isnt

```
program_stderr_is $expected_stderr, $test_name;
```

Tests if the output to stderr from the previous ["program\_runs"](#program_runs) does NOT match the
expected value exactly.

## program\_stderr\_like

```
program_stderr_like $regex, $test_name;
```

Tests if the output to stderr from the previous ["program\_runs"](#program_runs) matches the regular
expression.

## program\_stderr\_unlike

```
program_stderr_unlike $regex, $test_name;
```

Tests if the output to stderr from the previous ["program\_runs"](#program_runs) does NOT match the regular
expression.

# CAVEATS

This module is fully supported back to Perl 5.8.1.

The STDIN handle will be closed when using script\_runs with the stdin option.
An older version used [IPC::Run3](https://metacpan.org/pod/IPC::Run3), which attempted to save STDIN, but
apparently this cannot be done consistently or portably.  We now use
[Capture::Tiny](https://metacpan.org/pod/Capture::Tiny) instead and explicitly do not support saving STDIN handles.

# SEE ALSO

[Test::Script::Run](https://metacpan.org/pod/Test::Script::Run), [Test2::Suite](https://metacpan.org/pod/Test2::Suite)

# AUTHOR

Original author: Adam Kennedy

Current maintainer: Graham Ollis <plicease@cpan.org>

Contributors:

Brendan Byrd

Chris White <cxw@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2019 by Adam Kennedy.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
