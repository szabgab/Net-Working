use strict;
use warnings;

use Test::More;

plan tests => 1;

use Net::Worker;
my $nw = Net::Worker->new;

isa_ok $nw, 'Net::Worker';
