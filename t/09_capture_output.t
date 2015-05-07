use strict;
use warnings;
use Test::Tester;
use Test::More tests => 3;
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
        name => 'stdout does not match',
      },
    );
    
  };

  subtest 'not unlike' => sub {

    my(undef, $r) = check_test( sub {
        script_stdout_unlike qr{tandard Ou};
      }, {
        ok => 0,
        name => 'stdout does not match',
      },
    );
    
    note $r->{diag};    
  };

};

subtest 'stderr' => sub {
  plan tests => 4;

  subtest 'like' => sub {

    check_test( sub {
        script_stderr_like qr{tandard Er};
      }, {
        ok => 1,
        name => 'stderr matches',
      },
    );
    
  };

  subtest 'not like' => sub {

    my(undef, $r) = check_test( sub {
        script_stderr_like qr{XXXX};
      }, {
        ok => 0,
        name => 'stderr matches',
      },
    );

    note $r->{diag};    
    
  };

  subtest 'unlike' => sub {

    check_test( sub {
        script_stderr_unlike qr{XXXX};
      }, {
        ok => 1,
        name => 'stderr does not match',
      },
    );
    
  };

  subtest 'not unlike' => sub {

    my(undef, $r) = check_test( sub {
        script_stderr_unlike qr{tandard Er};
      }, {
        ok => 0,
        name => 'stderr does not match',
      },
    );
    
    note $r->{diag};    
  };

};
