use inc::Module::Install;

name           'Test-Script';
all_from       'lib/Test/Script.pm';
requires       'Exporter'   => 0;
requires       'Carp'       => 0;
requires       'File::Spec' => '0.80';
requires       'Test::More' => '0.47';
requires       'IPC::Run3'  => '0.034';

WriteAll;
