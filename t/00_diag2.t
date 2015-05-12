use strict;
use warnings;
use Test::More tests => 1;
use Test::Script;

pass;

diag '';
diag '';
diag '';

diag "probing IPC::Run3 for rt94685 rt46333 rt95308 gh#9";
diag "IPC::Run3 is ", Test::Script::_borked_ipc_run3() ? 'borked' : 'good';

diag '';
diag '';

