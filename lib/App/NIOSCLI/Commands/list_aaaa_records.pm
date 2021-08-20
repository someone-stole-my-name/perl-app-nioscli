## no critic
package App::NIOSCLI::Commands::list_aaaa_records;

## use critic
use strictures 2;
use MooseX::App::Command;

extends qw(App::NIOSCLI);

with 'App::NIOSCLI::Roles::Paginated', 'App::NIOSCLI::Roles::Filterable';

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
    default => "record:aaaa",
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

List AAAA Records

=head1 OVERVIEW

List AAAA Records.

=head1 EXAMPLES

=over

=item * List all

    nioscli list-aaaa-records [long options...]

=item * List filtering by name (exact match)

    nioscli list-aaaa-records --filter "name=foo.bar" [long options...]

=item * List filtering by an exact name (regex)

    nioscli list-aaaa-records --filter "name~=^foo" [long options...]

=item * List filtering by extattr

    nioscli list-aaaa-records --filter "*Tenant ID:=foo" [long options...]

=back
