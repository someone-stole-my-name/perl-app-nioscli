package NIOS::CLI;

# ABSTRACT: CLI for NIOS
# VERSION
# AUTHORITY

use v5.28;
use strict;
use warnings;
use utf8;

use MooseX::App qw(Color Version);
use JSON qw(from_json to_json);
use NIOS;

use feature qw(signatures);
no warnings qw(experimental::signatures);

app_strict(1);
app_namespace 'NIOS::CLI::Commands';
app_command_name {
    my ( $package_short, $package_full ) = @_;
    $package_short =~ tr/_/-/;
    return $package_short;
};

option 'wapi-version' => (
    is            => 'ro',
    isa           => 'Str',
    default       => 'v2.7',
    documentation => 'WAPI version',
    required      => 1,
    cmd_env       => 'WAPI_VERSION'
);

option 'username' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
    cmd_env  => 'WAPI_USERNAME'
);

option 'password' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
    cmd_env  => 'WAPI_PASSWORD'
);

option 'wapi-host' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
    cmd_env  => 'WAPI_HOST'
);

option 'insecure' => (
    is            => 'ro',
    isa           => 'Bool',
    default       => 0,
    cmd_env       => 'WAPI_INSECURE',
    documentation => 'Ignore SSL errors',
);

has 'nios_client' => (
    is      => 'ro',
    isa     => 'Object',
    lazy    => 1,
    default => sub ($self) {
        return NIOS->new(
            username  => $self->{username},
            password  => $self->{password},
            wapi_addr => $self->{'wapi-host'},
            insecure  => $self->{insecure}
        );
    }
);

1;
