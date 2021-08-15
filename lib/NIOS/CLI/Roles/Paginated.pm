package NIOS::CLI::Roles::Paginated;

use strict;
use warnings;

use MooseX::App::Role;

use JSON qw(from_json to_json);

use feature qw(signatures);
no warnings qw(experimental::signatures);

option 'max-results' => (
    is      => 'ro',
    isa     => 'Int|Str',
    default => "unlimited"
);

has '_pagination_params' => (
    is      => 'ro',
    isa     => 'HashRef',
    lazy    => 1,
    default => sub {
        my $self = shift;
        if ( $self->{'max-results'} ne "unlimited" ) {
            return {
                _return_as_object => 1,
                _max_results      => $self->{'max-results'}
            };
        }
        return {
            _paging           => 1,
            _return_as_object => 1,
            _max_results      => 900
        };

    }
);

has 'results' => (
    is      => 'rw',
    traits  => ['Array'],
    isa     => 'ArrayRef[HashRef]',
    default => sub { return []; },
    handles => {
        add_result => 'push'
    }
);

has 'exe' => (
    is       => 'ro',
    isa      => 'CodeRef',
    required => 1
);

sub add_results ( $self, $results ) {
    foreach ( @{$results} ) {
        if ( ref($_) eq "ARRAY" ) {
            $self->add_results($_);
        }
        else {
            $self->add_result($_);
        }
    }
}

sub execute ($self) {
    my $response = $self->exe->( $self, params => $self->params );

    $self->add_results( from_json( $response->decoded_content )->{result} );

    if ( $self->has_next_page($response) ) {
        while ( $self->has_next_page($response) ) {
            $response = $self->exe->(
                $self,
                params => (
                    {
                        _page_id => $self->has_next_page($response)
                    },
                    %{ $self->params }
                )
            );
            $self->add_results( from_json( $response->decoded_content )->{result} );
        }
    }

    print to_json( $self->results, { utf8 => 1, pretty => 1 } );
}

sub has_next_page ( $self, $response ) {
    return from_json( $response->decoded_content )->{next_page_id}
      ? from_json( $response->decoded_content )->{next_page_id}
      : 0;
}

1;
