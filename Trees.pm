package Trees;

use strict;
use warnings;
use Data::Dumper;

sub CreateTree($)
{
  my ($node_num) = @_;

  #my $tree =  [ map { [ (-1) x $node_num]  } ((1) x $node_num)];
  my $tree =  [ map { [ (-1) x 0]  } ((1) x $node_num)];
  #print Dumper($tree);
  my $self = { nodes => $tree, AddNode => \&AddNode, PrintTree => \&PrintTree };
  bless $self, "Trees";
  return $self;
}

sub AddNode($$)
{
  my $self = shift;
  my ($from, $to) = @_;
  print "Self: ", Dumper($self), "From  ", $from, "  To:  ", $to, "\n";
  push($$self{nodes}[$from], $to);
}

sub PrintTree()
{
  my $self =  shift;

  print Dumper($self);
}

1;
