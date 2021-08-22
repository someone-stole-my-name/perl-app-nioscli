#!/usr/bin/env perl
use File::Slurp qw(read_dir read_file);
$|++;

print("\n=head1 COMMANDS\n\n");
my $dirname = $ARGV[0];
foreach my $command ( sort( read_dir($dirname) ) ) {
  my $command_name = $command;
  $command_name =~ tr/_/-/;
  $command_name =~ s/.pm//;

  print("=head2 $command_name\n\n");

  my $text = read_file("$dirname/$command");
  $text =~ s/head1/head3/g;
  $text =~ /=head3 OVERVIEW\n\n(.*)/gms;

  print("$1\n");
}
