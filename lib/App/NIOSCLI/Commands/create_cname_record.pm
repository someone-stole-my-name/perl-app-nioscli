## no critic
package App::NIOSCLI::Commands::create_cname_record;

## use critic
use strictures 2;
use JSON qw(from_json);
use MooseX::App::Command;

extends qw(App::NIOSCLI);

with 'App::NIOSCLI::Roles::Creatable';

command_short_description 'Create a CNAME record';

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
        sub { shift->nios_client->create(@_); }
    },
    handles => {
        call => 'execute'
    }
);

sub run {
    shift->execute;
}

1;
