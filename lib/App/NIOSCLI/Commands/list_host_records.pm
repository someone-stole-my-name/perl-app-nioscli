## no critic
package App::NIOSCLI::Commands::list_host_records;

## use critic
use strictures 2;
use MooseX::App::Command;

extends qw(App::NIOSCLI);

with 'App::NIOSCLI::Roles::Paginated', 'App::NIOSCLI::Roles::Filterable';

command_short_description 'List HOST Records';

option 'return_fields' => (
    is      => 'ro',
    isa     => 'Str',
    default => "ipv4addrs,name,extattrs"
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
    default => "record:host",
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