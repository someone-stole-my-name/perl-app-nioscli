## no critic
package App::nioscli;

# ABSTRACT: CLI for NIOS
# VERSION
# AUTHORITY

## use critic
use strictures 2;

use MooseX::App qw(Color Version Config);
use JSON qw(from_json to_json);
use DNS::NIOS;

app_strict(1);
app_namespace;
app_command_register
  'create-a-record'     => 'App::nioscli::Commands::create_a_record',
  'create-cname-record' => 'App::nioscli::Commands::create_cname_record',
  'create-host-record'  => 'App::nioscli::Commands::create_host_record',
  'list-a-records'      => 'App::nioscli::Commands::list_a_records',
  'list-aaaa-records'   => 'App::nioscli::Commands::list_aaaa_records',
  'list-cname-records'  => 'App::nioscli::Commands::list_cname_records',
  'list-host-records'   => 'App::nioscli::Commands::list_host_records',
  'list-ptr-records'    => 'App::nioscli::Commands::list_ptr_records',
  'list-txt-records'    => 'App::nioscli::Commands::list_txt_records',
  'ref-delete'          => 'App::nioscli::Commands::ref_delete',
  'ref-get'             => 'App::nioscli::Commands::ref_get',
  'ref-update'          => 'App::nioscli::Commands::ref_update';

option 'wapi-version' => (
  is            => 'ro',
  isa           => 'Str',
  default       => 'v2.7',
  documentation => 'Specifies the version of WAPI to use',
  required      => 1,
  cmd_env       => 'WAPI_VERSION'
);

option 'username' => (
  is            => 'ro',
  isa           => 'Str',
  required      => 1,
  cmd_env       => 'WAPI_USERNAME',
  documentation => 'Username to use to authenticate the connection to NIOS'
);

option 'password' => (
  is            => 'ro',
  isa           => 'Str',
  required      => 1,
  cmd_env       => 'WAPI_PASSWORD',
  documentation => 'Password to use to authenticate the connection to NIOS'
);

option 'wapi-host' => (
  is            => 'ro',
  isa           => 'Str',
  required      => 1,
  cmd_env       => 'WAPI_HOST',
  documentation => 'DNS host name or address of NIOS.'
);

option 'insecure' => (
  is            => 'ro',
  isa           => 'Bool',
  default       => 0,
  cmd_env       => 'WAPI_INSECURE',
  documentation => 'Enable or disable verifying SSL certificates',
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
    return DNS::NIOS->new(
      username  => $self->{username},
      password  => $self->{password},
      wapi_addr => $self->{'wapi-host'},
      insecure  => $self->{insecure},
      scheme    => $self->{scheme}
    );
  }
);

1;

__END__

=head1 DESCRIPTION

This tool aids the management of the BIND-based DNS included in NIOS appliances.
The following types of DNS records are supported:

=over

=item * A

=item * AAAA

=item * CNAME

=item * PTR

=item * TXT

=back

=head1 OPTIONS

The following options are global, they apply to all subcommands:

=head2 C<< config >>

Values for all global and specific options can be read from a YAML config file:

    global:
      username: foo
      password: bar
      wapi-host: 10.0.0.1

=head2 C<< insecure >>

Enable or disable verifying SSL certificates.

B<Default>: false

B<ENV>: WAPI_INSECURE

=head2 C<< password >>

Password to use to authenticate the connection to NIOS.

B<ENV>: WAPI_PASSWORD

=head2 C<< scheme >>

B<Default>: https

=head2 C<< username >>

Username to use to authenticate the connection to NIOS.

B<ENV>: WAPI_USERNAME

=head2 C<< wapi-host >>

DNS host name or address of NIOS.

B<ENV>: WAPI_HOST

=head2 C<< wapi-version >>

Specifies the version of WAPI to use.

B<Default>: v2.7

B<ENV>: WAPI_VERSION
