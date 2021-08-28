## no critic
package App::nioscli::Commands::list_txt_records;

# VERSION
# AUTHORITY

## use critic
use strictures 2;
use MooseX::App::Command;

extends qw(App::nioscli);

command_short_description 'List TXT Records';

with 'App::nioscli::Roles::Listable';

has 'exe' => (
  is      => 'ro',
  isa     => 'CodeRef',
  traits  => ['Code'],
  lazy    => 1,
  default => sub {
    sub { shift->nios_client->list_txt_records(@_); }
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

=head1 OVERVIEW

List TXT Records.

B<Examples>

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
