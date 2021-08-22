## no critic
package App::nioscli::Commands::ref_delete;

# VERSION
# AUTHORITY

## use critic
use strictures 2;
use JSON qw(from_json);
use MooseX::App::Command;

extends qw(App::nioscli);

parameter 'ref' => (
  is       => 'ro',
  isa      => 'Str',
  required => 1
);

sub run {
  my $self     = shift;
  my $response = $self->nios_client->delete( path => $self->ref );
  die( $response->{'_content'} ) unless $response->is_success;
}

1;

__END__

=head1 ABSTRACT

Delete an Object reference

=head1 OVERVIEW

Delete an Object reference

=over

=item * Delete an Object reference

    nioscli ref-delete REF [long options...]

=back
