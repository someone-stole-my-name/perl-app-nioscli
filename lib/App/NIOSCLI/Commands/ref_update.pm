## no critic
package App::NIOSCLI::Commands::ref_update;

## use critic
use strictures 2;
use JSON qw(from_json);
use MooseX::App::Command;

extends qw(App::NIOSCLI);

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

sub run {
    my $self     = shift;
    my $response = $self->nios_client->update(
        path    => $self->ref,
        payload => from_json( $self->json )
    );

    $response->is_success
      ? print( $response->{'_content'} )
      : die( $response->{'_content'} );
}

1;

__END__

=head1 ABSTRACT

Update an Object reference

=head1 OVERVIEW

Update an Object reference

=head1 EXAMPLES

=over

=item * Update an Object reference

    nioscli ref-update REF \
        --json '{ "name": "foo" }' \
        [long options...]

=back
