## no critic
package App::NIOSCLI::Commands::ref_delete;

## use critic
use strictures 2;
use JSON qw(from_json);
use MooseX::App::Command;

extends qw(App::NIOSCLI);

command_short_description 'Delete an Object reference';

parameter 'ref' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

sub run {
    my $self     = shift;
    my $response = $self->nios_client->delete( path => $self->ref );
    die( $response->{'_content'} ) unless $response->is_success;
}

1;
