package NIOS::CLI::Commands::ref_update;

use v5.32;
use utf8;
use strict;
use warnings;

use MooseX::App::Command;

use JSON qw(from_json);

extends qw(NIOS::CLI);

use feature qw(signatures);
no warnings qw(experimental::signatures);

command_short_description 'Update an Object reference';

parameter 'ref' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

option 'json' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

sub run ($self) {
    my $response = $self->nios_client->update(
        ref => $self->ref,
        %{ from_json( $self->json ) }
    );

    $response->is_success
      ? print( $response->{'_content'} )
      : die( $response->{'_content'} );
}

1;
