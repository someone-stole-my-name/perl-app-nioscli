## no critic
package App::nioscli::Commands::list_txt_records;

# VERSION
# AUTHORITY

## use critic
use strictures 2;
use MooseX::App::Command;

extends qw(App::nioscli);

with 'App::nioscli::Roles::Paginated', 'App::nioscli::Roles::Filterable';

command_short_description 'List TXT Records';

has 'params' => (
  is      => 'ro',
  isa     => 'HashRef',
  lazy    => 1,
  default => sub {
    my $self = shift;
    return { %{ $self->_pagination_params }, %{ $self->_filter_params }, };
  }
);

has 'path' => (
  default => "record:txt",
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

__END__

=head1 ABSTRACT

List TXT Records

=head1 OVERVIEW

List TXT Records.

=over

=item * List all

    nioscli list-txt-records [long options...]

=item * List filtering by name (exact match)

    nioscli list-txt-records --filter "name=foo.bar" [long options...]

=item * List filtering by an exact name (regex)

    nioscli list-txt-records --filter "name~=^foo" [long options...]

=item * List filtering by extattr

    nioscli list-txt-records --filter "*Tenant ID:=foo" [long options...]

=back
