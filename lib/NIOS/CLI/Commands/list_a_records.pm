package NIOS::CLI::Commands::list_a_records;

use v5.28;
use utf8;
use strict;
use warnings;

use MooseX::App::Command;

extends qw(NIOS::CLI);

with 'NIOS::CLI::Roles::Paginated', 'NIOS::CLI::Roles::Filterable';

use feature qw(signatures);
no warnings qw(experimental::signatures);

command_short_description 'List A Records';

option 'return_fields' => (
    is        => 'ro',
    isa       => 'Str',
    default   => "name,extattrs,ipv4addr"
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
        sub { shift->nios_client->get_a_record(@_); }
    },
    handles => {
        call => 'execute'
    }
);

sub run ($self) {
    $self->execute;
}

1;
