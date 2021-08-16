## no critic
package App::NIOSCLI;

# ABSTRACT: CLI for NIOS
# VERSION
# AUTHORITY

## use critic
use strictures 2;

use MooseX::App qw(Color Version Config);
use JSON qw(from_json to_json);
use NIOS;

app_strict(1);
app_namespace 'App::App::NIOSCLI::Commands';
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

option 'scheme' => (
    is      => 'ro',
    isa     => 'Str',
    default => 'https'
);

has 'nios_client' => (
    is      => 'ro',
    isa     => 'Object',
    lazy    => 1,
    default => sub {
        my $self = shift;
        return NIOS->new(
            username  => $self->{username},
            password  => $self->{password},
            wapi_addr => $self->{'wapi-host'},
            insecure  => $self->{insecure},
            scheme    => $self->{scheme}
        );
    }
);

1;
