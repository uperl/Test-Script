use strict;
use warnings;
use Test::Tester;
use Test::More tests => 2;
use Test::Script;

script_runs 't/bin/print.pl';

subtest 'stdout' => sub {
  plan tests => 4;

  subtest 'like' => sub {

    check_test( sub {
        script_stdout_like qr{tandard Ou};
      }, {
        ok => 1,
        name => 'stdout matches',
      },
    );
    
  };

  subtest 'not like' => sub {

    my(undef, $r) = check_test( sub {
        script_stdout_like qr{XXXX};
      }, {
        ok => 0,
        name => 'stdout matches',
      },
    );

    note $r->{diag};    
    
  };

  subtest 'unlike' => sub {

    check_test( sub {
        script_stdout_unlike qr{XXXX};
      }, {
        ok => 1,
        name => 'stdout matches',
      },
    );
    
  };

  subtest 'not unlike' => sub {

    my(undef, $r) = check_test( sub {
        script_stdout_unlike qr{tandard Ou};
      }, {
        ok => 0,
        name => 'stdout matches',
      },
    );
    
    note $r->{diag};    
  };

};
