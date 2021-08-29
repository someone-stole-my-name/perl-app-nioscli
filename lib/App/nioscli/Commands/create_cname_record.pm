## no critic
package App::nioscli::Commands::create_cname_record;

# VERSION
# AUTHORITY

## use critic
use strictures 2;
use JSON qw(from_json);
use MooseX::App::Command;

extends qw(App::nioscli);

command_short_description 'Create a CNAME record';

with 'App::nioscli::Roles::Creatable';

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

    $payload->{extattrs} = from_json( $self->extattrs ) if defined $self->extattrs;

    return $payload;
  }
);

has 'path' => (
  default => "record:cname",
  is      => 'ro',
  isa     => 'Str'
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

sub run {
  shift->execute;
}

1;

__END__

=head1 OVERVIEW

Create an A record

B<Examples>

=over

=item * Create a CNAME record with extattrs:

    nioscli create-cname-record \
        --name foo.bar \
        --canonical foobar.bar \
        --extattrs '{
            "Cloud API Owned" : { "value" : "True" },
            "Tenant ID" : { "value" : "foo" },
            "CMP Type" : { "value" : "bar" }
        }' [long options...]

=back
