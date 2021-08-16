## no critic
package App::NIOSCLI::Commands::ref_get;

## use critic
use strictures 2;
use JSON qw(to_json from_json);
use MooseX::App::Command;

extends qw(App::NIOSCLI);

command_short_description 'Get an Object reference';

option 'return_fields' => (
  is  => 'ro',
  isa => 'Str'
);

parameter 'ref' => (
  is       => 'ro',
  isa      => 'Str',
  required => 1
);

sub run {
  my $self = shift;
  my $response =
    defined $self->return_fields
    ? $self->nios_client->get(
    path   => $self->ref,
    params => { _return_fields => $self->return_fields }
    )
    : $self->nios_client->get( path => $self->ref );

  $response->is_success
    ? print(
    to_json( from_json( $response->{_content} ), { utf8 => 1, pretty => 1 } ) )
    : die( $response->{'_content'} );
}

1;
