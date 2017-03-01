use Test2::Bundle::Extended;
use Test::Script ();

is(
  intercept { Test::Script->import(tests => 42) },
  array {
    event Plan => sub {
      call directive => '';
      call max => 42;
    };
  },
  'with tests',
);

is(
  intercept { Test::Script->import(skip_all => 'foo') },
  array {
    event Plan => sub {
      call directive => 'SKIP';
    };
  },
  'with skip',
);

is(
  # does not appear to emit any events.
  intercept { Test::Script->import('no_plan') },
  array {
  },
  'with no plan',
);

done_testing;
