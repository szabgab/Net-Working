package Net::Worker;
use Moo;
use MooX::Options;
use 5.010;

our $VERSION = '0.01';

option verbose => (is => 'ro');
#option file    => (is => 'ro', required => 1);
 
sub run {
    my ($self) = @_;
    if ($self->verbose) {
        say "Networking $VERSION";
    }
}
 


=head NAME

Net::Worker - checking network connectivity

=cut

1;

