use strict;
use inc::Module::Install;

name           'Test-Script';
all_from       'lib/Test/Script.pm';
requires       'Carp'                  => 0;
requires       'Exporter'              => 0;
requires       'File::Spec'            => '0.80';
requires       'IPC::Run3'             => '0.034';
test_requires 'Test::More'            => '0.62';
test_requires 'Test::Builder'         => '0.32';
test_requires 'Test::Builder::Tester' => '1.02';

WriteAll;
