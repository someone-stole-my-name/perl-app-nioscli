## no critic
package App::nioscli::Commands::list_ptr_records;

# VERSION
# AUTHORITY

## use critic
use strictures 2;
use MooseX::App::Command;

extends qw(App::nioscli);

command_short_description 'List PTR Records';

with 'App::nioscli::Roles::Listable';

has 'default_return_fields' => (
  is      => 'ro',
  isa     => 'Str',
  default => "ptrdname,name,extattrs"
);

has 'exe' => (
  is      => 'ro',
  isa     => 'CodeRef',
  traits  => ['Code'],
  lazy    => 1,
  default => sub {
    sub { shift->nios_client->list_ptr_records(@_); }
  },
  handles => {
    call => 'execute'
  }
);

sub run {
  shift->execute;
}

1;

=head1 OVERVIEW

List PTR Records.

B<Examples>

=over

=item * List all

    nioscli list-ptr-records [long options...]

=item * List filtering by name (exact match)

    nioscli list-ptr-records --filter "name=foo.bar" [long options...]

=item * List filtering by an exact name (regex)

    nioscli list-ptr-records --filter "name~=^foo" [long options...]

=item * List filtering by extattr

    nioscli list-ptr-records --filter "*Tenant ID:=foo" [long options...]

=back
