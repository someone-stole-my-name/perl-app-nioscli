package NIOS::CLI::Roles::Creatable;

use strict;
use warnings;

use MooseX::App::Role;

use feature qw(signatures);
no warnings qw(experimental::signatures);

has 'exe' => (
    is       => 'ro',
    isa      => 'CodeRef',
    required => 1
);

has 'payload' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

sub execute ($self) {
    my $response = $self->exe->( $self, %{ $self->payload } );
    $response->is_success ? print( $response->{'_content'} . "\n" ) : die($response->{'_content'});
}

1;
