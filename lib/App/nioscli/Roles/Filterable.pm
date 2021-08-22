## no critic
package App::nioscli::Roles::Filterable;

## use critic
use strictures 2;
use MooseX::App::Role;

option 'filter' => (
  is  => 'ro',
  isa => 'HashRef'
);

has '_filter_params' => (
  is      => 'ro',
  isa     => 'HashRef',
  lazy    => 1,
  default => sub {
    my $self = shift;

    return $self->filter ? $self->filter : {};
  }
);

1;
