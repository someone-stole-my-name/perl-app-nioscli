package NIOS::CLI::Roles::Filterable;

use v5.32;
use strict;
use warnings;

use MooseX::App::Role;

option 'filter' => (
    is  => 'ro',
    isa => 'HashRef'
);

has '_filter_params' => (
    is      => 'ro',
    isa     => 'HashRef',
    lazy    => 1,
    default => sub {
        my $self = shift;
        return $self->filter ? $self->filter : {};
    }
);

1;
