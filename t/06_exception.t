use strict;
use warnings;
use Test::Tester;
use Test::More tests => 2;
use Test::Script;

subtest script_compiles => sub {

  my(undef, $result) = check_test( sub {
      script_compiles( 't/bin/missing.pl' );
    }, {
      ok   => 0,
      name => 'Script t/bin/missing.pl compiles',
    },
  );

  note $result->{diag};

};

subtest script_runs => sub {

  my(undef, $result) = check_test( sub {
      script_runs( 't/bin/missing.pl' );
    }, {
      ok   => 0,
      name => 'Script t/bin/missing.pl runs',
    },
  );
  
  note $result->{diag};

};
