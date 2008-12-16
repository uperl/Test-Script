use inc::Module::Install 0.77;

all_from      'lib/Test/Script.pm';
requires      'blib'                  => 0;
requires      'File::Spec'            => '0.80';
requires      'IPC::Run3'             => '0.034';
requires      'Probe::Perl'           => '0.01';
test_requires 'Test::More'            => '0.62';
test_requires 'Test::Builder'         => '0.32';
test_requires 'Test::Builder::Tester' => '1.02';

WriteAll;
