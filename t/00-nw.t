use strict;
use warnings;

use Test::More;
use Capture::Tiny qw(capture);
use File::Temp qw(tempdir);
my $dir = tempdir( CLEANUP => 1 );

plan tests => 6;

use Net::Working;
my $nw = Net::Working->new;

isa_ok $nw, 'Net::Working';

package T;
use parent 'Net::Working';

sub config_file {
	return "$dir/net_working";
}

package main;

my $t = T->new;

diag $t->config_file;
ok ! -e $t->config_file;

{
	my ($stdout, $stderr, $exit) = capture { T->new(addprofile => 'abc')->run; };
	is $stdout, "adding profile: abc\n", 'addprofile';
	is $stderr, '';
}

{
	my ($stdout, $stderr, $exit) = capture { T->new(profiles => 1)->run; };
	is $stdout, "abc\n", 'profiles';
	is $stderr, '';
}
