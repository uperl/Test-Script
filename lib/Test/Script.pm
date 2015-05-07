package Test::Script;

# ABSTRACT: Basic cross-platform tests for scripts
# VERSION

=head1 SYNOPSIS

 use Test::More tests => 2;
 use Test::Script;
 
 script_compiles('script/awesomescript.pl');
 script_runs(['script/awesomescript.pl', '--awesome-argument']);

=head1 DESCRIPTION

The intent of this module is to provide a series of basic tests for 80%
of the testing you will need to do for scripts in the F<script> (or F<bin>
as is also commonly used) paths of your Perl distribution.

Further, it aims to provide this functionality with perfect
platform-compatibility, and in a way that is as unobtrusive as possible.

That is, if the program works on a platform, then B<Test::Script>
should always work on that platform as well. Anything less than 100% is
considered unacceptable.

In doing so, it is hoped that B<Test::Script> can become a module that
you can safely make a dependency of all your modules, without risking that
your module won't on some platform because of the dependency.

Where a clash exists between wanting more functionality and maintaining
platform safety, this module will err on the side of platform safety.

=head1 FUNCTIONS

=cut

use 5.006;
use strict;
use warnings;
use Carp             ();
use Exporter         ();
use File::Spec       ();
use File::Spec::Unix ();
use Probe::Perl      ();
use IPC::Run3        ();
use Test::Builder    ();

our @ISA     = 'Exporter';
our @EXPORT  = qw{
  script_compiles
  script_compiles_ok
  script_runs
  script_stdout_like
  script_stdout_unlike
};

sub import {
  my $self = shift;
  my $pack = caller;
  my $test = Test::Builder->new;
  $test->exported_to($pack);
  $test->plan(@_);
  foreach ( @EXPORT ) {
    $self->export_to_level(1, $self, $_);
  }
}

my $perl = undef;

sub perl () {
  $perl or
  $perl = Probe::Perl->find_perl_interpreter;
}

sub path ($) {
  my $path = shift;
  unless ( defined $path ) {
    Carp::croak("Did not provide a script name");
  }
  if ( File::Spec::Unix->file_name_is_absolute($path) ) {
    Carp::croak("Script name must be relative");
  }
  File::Spec->catfile(
    File::Spec->curdir,
    split /\//, $path
  );
}

#####################################################################
# Test Functions

=head2 script_compiles

 script_compiles( $script, $test_name );

The L</script_compiles> test calls the script with "perl -c script.pl",
and checks that it returns without error.

The path it should be passed is a relative unix-format script name. This
will be localised when running C<perl -c> and if the test fails the local
name used will be shown in the diagnostic output.

Note also that the test will be run with the same L<perl> interpreter that
is running the test script (and not with the default system perl). This
will also be shown in the diagnostic output on failure.

=cut

sub script_compiles {
  my $args   = _script(shift);
  my $unix   = shift @$args;
  my $path   = path( $unix );
  my @libs   = map { "-I$_" } grep {!ref($_)} @INC;
  my $cmd    = [ perl, @libs, '-c', $path, @$args ];
  my $stdin  = '';
  my $stdout = '';
  my $stderr = '';
  my $rv     = eval { IPC::Run3::run3( $cmd, \$stdin, \$stdout, \$stderr ) };
  my $error  = $@;
  my $exit   = $? ? ($? >> 8) : 0;
  my $signal = $? ? ($? & 127) : 0;
  my $ok     = !! (
    $error eq '' and $rv and $exit == 0 and $signal == 0 and $stderr =~ /syntax OK\s+\z/si
  );

  my $test = Test::Builder->new;
  $test->ok( $ok, $_[0] || "Script $unix compiles" );
  $test->diag( "$exit - $stderr" ) unless $ok;
  $test->diag( "exception: $error" ) if $error;
  $test->diag( "signal: $signal" ) if $signal;

  return $ok;
}

=head2 script_runs

 script_runs( $script, $test_name );
 script_runs( \@script_and_arguments, $test_name );
 script_runs( $script, \%options, $test_name );
 script_runs( \@script_and_arguments, \%options, $test_name );

The L</script_runs> test executes the script with "perl script.pl" and checks
that it returns success.

The path it should be passed is a relative unix-format script name. This
will be localised when running C<perl -c> and if the test fails the local
name used will be shown in the diagnostic output.

The test will be run with the same L<perl> interpreter that is running the
test script (and not with the default system perl). This will also be shown
in the diagnostic output on failure.

You may pass in options as a hash as the second argument.

=over 4

=item exit

The expected exit value.  The default is to use whatever indicates success
on your platform (usually 0).

=item signal

The expected signal.  The default is 0.

=item stdin

The input to be passed into the script via stdin.

=back

=cut

my $stdout;
my $stderr;

sub script_runs {
  my $args   = _script(shift);
  my $opt    = _options(\@_);
  my $unix   = shift @$args;
  my $path   = path( $unix );
  my @libs   = map { "-I$_" } grep {!ref($_)} @INC;
  my $cmd    = [ perl, @libs, $path, @$args ];
  my $stdin  = $opt->{stdin};
     $stdout = '';
     $stderr = '';
  my $rv     = eval { IPC::Run3::run3( $cmd, \$stdin, \$stdout, \$stderr ) };
  my $error  = $@;
  my $exit   = $? ? ($? >> 8) : 0;
  my $signal = $? ? ($? & 127) : 0;
  my $ok     = !! ( $error eq '' and $rv and $exit == $opt->{exit} and $signal == $opt->{signal} );

  my $test = Test::Builder->new;
  $test->ok( $ok, $_[0] || "Script $unix runs" );
  $test->diag( "$exit - $stderr" ) unless $ok;
  $test->diag( "exception: $error" ) if $error;
  $test->diag( "signal: $signal" ) unless $signal == $opt->{signal};

  return $ok;
}

=head2 script_stdout_like

 script_stdout_like $regex, $test_name;

Tests if the ouput to stdout from the previous L</script_runs> matches the regular
expression.

=cut

sub script_stdout_like
{
  my($pattern, $name) = @_;
  
  my $ok = $stdout =~ $pattern;
  
  my $test = Test::Builder->new;
  $test->ok( $ok, $name || "stdout matches" );
  unless($ok) {
    $test->diag( "The output" );
    $test->diag( "  $_" ) for split /\n/, $stdout;
    $test->diag( "does not match");
    $test->diag( "  $pattern" );
  }
  
  return $ok;
}

=head2 script_stdout_unlike

 script_stdout_unlike $regex, $test_name;

Tests if the ouput to stdout from the previous L</script_runs> does NOT matches the regular
expression.

=cut

sub script_stdout_unlike
{
  my($pattern, $name) = @_;
  
  my $ok = $stdout !~ $pattern;
  
  my $test = Test::Builder->new;
  $test->ok( $ok, $name || "stdout matches" );
  unless($ok) {
    $test->diag( "The output" );
    $test->diag( "  $_" ) for split /\n/, $stdout;
    $test->diag( "does match");
    $test->diag( "  $pattern" );
  }
  
  return $ok;
}

######################################################################
# Support Functions

# Script params must be either a simple non-null string with the script
# name, or an array reference with one or more non-null strings.
sub _script {
  my $in = shift;
  if ( defined _STRING($in) ) {
    return [ $in ];
  }
  if ( _ARRAY($in) ) {
    unless ( scalar grep { not defined _STRING($_) } @$in ) {
      return $in;     
    }
  }
  Carp::croak("Invalid command parameter");
}

# Inline some basic Params::Util functions

sub _options {
  my %options = ref($_[0]->[0]) eq 'HASH' ? %{ shift @{ $_[0] } }: ();
  
  $options{exit}   = 0   unless defined $options{exit};
  $options{signal} = 0   unless defined $options{signal};
  $options{stdin}  = ''  unless defined $options{stdin};

  \%options;
}

sub _ARRAY ($) {
  (ref $_[0] eq 'ARRAY' and @{$_[0]}) ? $_[0] : undef;
}

sub _STRING ($) {
  (defined $_[0] and ! ref $_[0] and length($_[0])) ? $_[0] : undef;
}

BEGIN {
  # Alias to old name
  *script_compiles_ok = *script_compiles;
}

1;

=pod

=head1 SEE ALSO

L<Test::Script::Run>, L<Test::More>

=cut
