use Test2::V0;
use Test::Script;

script_compiles('t/bin/taint.pl');
script_runs('t/bin/taint.pl');

done_testing;
