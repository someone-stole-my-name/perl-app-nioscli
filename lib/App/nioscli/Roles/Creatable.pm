## no critic
package App::nioscli::Roles::Creatable;

## use critic
use strictures 2;
use MooseX::App::Role;

has 'exe' => (
  is       => 'ro',
  isa      => 'CodeRef',
  required => 1
);

has 'payload' => (
  is       => 'ro',
  isa      => 'Str',
  required => 1
);

has 'path' => (
  is       => 'ro',
  isa      => 'Str',
  required => 1
);

sub execute {
  my $self     = shift;
  my $response = $self->exe->(
    $self,
    path    => $self->path,
    payload => $self->payload

  );
  $response->is_success
    ? print( $response->{'_content'} . "\n" )
    : die( $response->{'_content'} );
}

1;
