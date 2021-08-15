package NIOS::CLI::Commands::create_cname_record;

use v5.32;
use utf8;
use strict;
use warnings;

use MooseX::App::Command;

use JSON qw(from_json);

extends qw(NIOS::CLI);

with 'NIOS::CLI::Roles::Creatable';

use feature qw(signatures);
no warnings qw(experimental::signatures);

command_short_description 'Create a CNAME record';

option 'name' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

option 'canonical' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

option 'extattrs' => (
    is  => 'ro',
    isa => 'Str'
);

has 'payload' => (
    is      => 'ro',
    isa     => 'HashRef',
    lazy    => 1,
    default => sub {
        my $self = shift;

        my $payload = {
            name      => $self->name,
            canonical => $self->canonical
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
        sub { shift->nios_client->create_cname_record(@_); }
    },
    handles => {
        call => 'execute'
    }
);

sub run ($self) {
    $self->execute;
}

1;
