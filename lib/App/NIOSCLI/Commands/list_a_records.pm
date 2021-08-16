## no critic
package App::NIOSCLI::Commands::list_a_records;

## use critic
use strictures 2;
use MooseX::App::Command;

extends qw(App::NIOSCLI);

with 'App::NIOSCLI::Roles::Paginated', 'App::NIOSCLI::Roles::Filterable';

command_short_description 'List A Records';

option 'return_fields' => (
    is      => 'ro',
    isa     => 'Str',
    default => "name,extattrs,ipv4addr"
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
    default => "record:a",
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
