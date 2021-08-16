## no critic
package App::nioscli::Commands::create_a_record;

# VERSION
# AUTHORITY

## use critic
use strictures 2;
use JSON qw(from_json);
use MooseX::App::Command;

extends qw(App::nioscli::Commands::create_host_record);

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
      name     => $self->name,
      ipv4addr => $self->address
    };

    $payload->{extattrs} = from_json( $self->extattrs ) if defined $self->extattrs;

    return $payload;
  }
);

has 'path' => (
  default  => "record:a",
  is       => 'ro',
  isa      => 'Str',
  required => 1
);

has 'exe' => (
  is      => 'ro',
  isa     => 'CodeRef',
  traits  => ['Code'],
  lazy    => 1,
  default => sub {
    sub { shift->nios_client->create(@_); }
  },
  handles => {
    call => 'execute'
  }
);

1;

__END__

=head1 OVERVIEW

Create an A record

=over

=item * Create an A record with extattrs:

    nioscli create-a-record \
        --name foo.bar \
        --address 10.0.0.1 \
        --extattrs '{
            "Cloud API Owned" : { "value" : "True" },
            "Tenant ID" : { "value" : "foo" },
            "CMP Type" : { "value" : "bar" }
        }' [long options...]

=back
