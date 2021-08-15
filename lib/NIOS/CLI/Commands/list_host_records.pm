package NIOS::CLI::Commands::list_host_records;

use v5.32;
use utf8;
use strict;
use warnings;

use MooseX::App::Command;

extends qw(NIOS::CLI);

with 'NIOS::CLI::Roles::Paginated', 'NIOS::CLI::Roles::Filterable';

use feature qw(signatures);
no warnings qw(experimental::signatures);

command_short_description 'List HOST Records';

option 'return_fields' => (
    is        => 'ro',
    isa       => 'Str',
    default   => "ipv4addrs,name,extattrs"
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

has 'exe' => (
    is      => 'ro',
    isa     => 'CodeRef',
    traits  => ['Code'],
    lazy    => 1,
    default => sub {
        sub { shift->nios_client->get_host_record(@_); }
    },
    handles => {
        call => 'execute'
    }
);

sub run ($self) {
    $self->execute;
}

1;
