package NIOS::CLI::Commands::create_a_record;

use v5.32;
use utf8;
use strict;
use warnings;

use MooseX::App::Command;

use JSON qw(from_json);

extends qw(NIOS::CLI::Commands::create_host_record);

use feature qw(signatures);
no warnings qw(experimental::signatures);

command_short_description 'Create an A record';

option 'address' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

has 'payload' => (
    is      => 'ro',
    isa     => 'HashRef',
    lazy    => 1,
    default => sub {
        my $self = shift;

        my $payload = {
            name      => $self->name,
            ipv4addr => $self->address
        };

        $payload->{extattrs} = from_json($self->extattrs) if defined $self->extattrs;

        return $payload;
    }
);

has 'exe' => (
    is      => 'ro',
    isa     => 'CodeRef',
    traits  => ['Code'],
    lazy    => 1,
    default => sub {
        sub { shift->nios_client->create_a_record(@_); }
    },
    handles => {
        call => 'execute'
    }
);

1;
