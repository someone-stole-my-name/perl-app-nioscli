package NIOS::CLI::Commands::ref_delete;

use v5.28;
use utf8;
use strict;
use warnings;

use MooseX::App::Command;

use JSON qw(from_json);

extends qw(NIOS::CLI);

use feature qw(signatures);
no warnings qw(experimental::signatures);

command_short_description 'Delete an Object reference';

parameter 'ref' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

sub run ($self) {
    my $response = $self->nios_client->delete( ref => $self->ref );
    die( $response->{'_content'} ) unless $response->is_success;
}

1;
