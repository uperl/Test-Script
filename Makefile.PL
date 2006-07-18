use inc::Module::Install;

name           'Test-Script';
all_from       'lib/Test/Script.pm';
requires       'Exporter'              => 0;
requires       'Carp'                  => 0;
requires       'File::Spec'            => '0.80';
requires       'Test::More'            => '0.62';
requires       'IPC::Run3'             => '0.034';
build_requires 'Test::More'            => '0.62';
build_requires 'Test::Builder'         => '0.32';
build_requires 'Test::Builder::Tester' => '1.02';

WriteAll;
