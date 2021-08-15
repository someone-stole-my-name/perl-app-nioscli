package NIOS::CLI::Commands::ref_get;

use v5.28;
use utf8;
use strict;
use warnings;

use MooseX::App::Command;

use JSON qw(to_json from_json);

extends qw(NIOS::CLI);

use feature qw(signatures);
no warnings qw(experimental::signatures);

command_short_description 'Get an Object reference';

option 'return_fields' => (
    is  => 'ro',
    isa => 'Str'
);

parameter 'ref' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

sub run ($self) {
    my $response =
      defined $self->return_fields
      ? $self->nios_client->get(
        ref    => $self->ref,
        params => { _return_fields => $self->return_fields }
      )
      : $self->nios_client->get( ref => $self->ref );

    $response->is_success
      ? print(
        to_json( from_json( $response->{_content} ), { utf8 => 1, pretty => 1 } ) )
      : die( $response->{'_content'} );
}

1;
