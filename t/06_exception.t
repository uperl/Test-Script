use strict;
use warnings;
use Test::Tester;
use Test::More tests => 2;
use Test::Script;
use IPC::Run3 ();

do { no warnings; sub IPC::Run3::run3 { die "an exception" } };

my ($res1, $res2);
subtest 'script_compiles' => sub {

  (undef, $res1) = check_test( sub {
      script_compiles( 't/bin/missing.pl' );
    }, {
      ok   => 0,
      name => 'Script t/bin/missing.pl compiles',
    },
  );
  note($res1->{diag});
};

subtest 'script_runs' => sub {

  (undef, $res2) = check_test( sub {
      script_runs( 't/bin/missing.pl' );
    }, {
      ok   => 0,
      name => 'Script t/bin/missing.pl runs',
    },
  );
  note($res2->{diag});
};
