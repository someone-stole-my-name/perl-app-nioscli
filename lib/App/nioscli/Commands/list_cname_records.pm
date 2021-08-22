## no critic
package App::nioscli::Commands::list_cname_records;

# VERSION
# AUTHORITY

## use critic
use strictures 2;
use MooseX::App::Command;

extends qw(App::nioscli);

with 'App::nioscli::Roles::Paginated', 'App::nioscli::Roles::Filterable';

option 'return_fields' => (
  is      => 'ro',
  isa     => 'Str',
  default => "name,canonical"
);

has 'params' => (
  is      => 'ro',
  isa     => 'HashRef',
  lazy    => 1,
  default => sub {
    my $self = shift;
    return {
      %{ $self->_pagination_params },
      %{ $self->_filter_params },
      _return_fields => $self->return_fields
    };
  }
);

has 'path' => (
  default => "record:cname",
  is      => 'ro',
  isa     => 'Str'
);

has 'exe' => (
  is      => 'ro',
  isa     => 'CodeRef',
  traits  => ['Code'],
  lazy    => 1,
  default => sub {
    sub { shift->nios_client->get(@_); }
  },
  handles => {
    call => 'execute'
  }
);

sub run {
  shift->execute;
}

1;

=head1 ABSTRACT

List CNAME Records

=head1 OVERVIEW

List CNAME Records.

=over

=item * List all

    nioscli list-cname-records [long options...]

=item * List filtering by name (exact match)

    nioscli list-cname-records --filter "name=foo.bar" [long options...]

=item * List filtering by an exact name (regex)

    nioscli list-cname-records --filter "name~=^foo" [long options...]

=item * List filtering by extattr

    nioscli list-cname-records --filter "*Tenant ID:=foo" [long options...]

=back
