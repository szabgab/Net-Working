package Net::Worker;
use Moo;
use MooX::Options;
use 5.010;

use File::HomeDir ();
use YAML qw(LoadFile DumpFile);
#use Path::Tiny qw(path);

our $VERSION = '0.01';

option verbose    => (is => 'ro');
option profiles   => (is => 'ro');
option addprofile => (is => 'ro', format => 's');


#option file    => (is => 'ro', required => 1);
has config => (is => 'rw');

sub config_file {
	return File::Spec->catfile( File::HomeDir->my_home, '.networker' );
}

sub load_config {
	my ($self) = @_;

	my $cfg_file = $self->config_file;
	if (-e $cfg_file) {
		#path($cfg_file)->slurp_utf8;
		$self->config( LoadFile($cfg_file) );
	}

	return;
}

sub save_config {
	my ($self) = @_;

	my $cfg_file = $self->config_file;
	DumpFile($cfg_file, $self->config);

	return;
}
  
sub run {
	my ($self) = @_;

	if ($self->verbose) {
		say "Networking $VERSION";
	}

	$self->load_config;

	if (not $self->config and not $self->addprofile) {
		say "No configuration found\n";
		say "Run $0 --addprofile NAME\n";
		return;
	}

	if ($self->profiles) {
		foreach my $prof (@{ $self->config->{profiles} }) {
			say $prof->{name};
		}
	}

	if ($self->addprofile) {
		say 'adding profile: ' . $self->addprofile;
		my %profile = (
			name => $self->addprofile,
		);
		my $cfg = $self->config;
		if (grep {lc $_->{name} eq lc $profile{name} } @{ $cfg->{profiles} }) {
			say "Profile '$profile{name}' already exists", 
			return;
        } else {
			push @{ $cfg->{profiles} }, \%profile;
			$self->config($cfg);
			$self->save_config;
		}
	}

	return;
}
 


=head NAME

Net::Worker - checking network connectivity

=cut

1;

