use strict;
use Data::Dumper;
use 5.010;

sub Main()
{
  print "Please enter the number of nodes: ";
  my $nodes = <STDIN>;
  if($nodes < 2)
  {
    die "Take the input more seriously.\n";
  }
  chomp($nodes);
  print "Please enter the number of edges: ";
  my $edges = <STDIN>;
  chomp($edges);
  if($edges < ($nodes - 1))
  {
    die "This function works with a tree, not a forest.\n";
  }
  if($edges > ($nodes - 1))
  {
    die "This is not a tree. This is a graph.\n";
  }

  my $tree =  [ map { [ (-1) x 0]  } ((1) x ($nodes+1))];
  while($edges > 0)
  {
    print "Please enter the first node. ";
    my $node_1 = <STDIN>;
    chomp($node_1);
    print "Please enter the second node. ";
    my $node_2 = <STDIN>;
    chomp($node_2);
    push $$tree[$node_1], $node_2;
    push $$tree[$node_2], $node_1;

    if($node_1 > $nodes || $node_2 > $nodes)
    {
      die "I can't let you input non-existant nodes\n";
    }
    if($node_1 < 1 || $node_2 < 1)
    {
      die "I can't let you input negative values\n";
    }
    if($node_1 == $node_2)
    {
      die "I can't let you make cycles\n";
    }
    $edges--;
  }
  #print "Dumping the tree: ", Dumper($tree);

  # Chose which one you want to perform:
  #DepthTraversal($tree, 1);
  #WidthTraversal($tree, 1);
}

sub DepthTraversal($$)
{
  my ($tree, $starting_node) = @_;

  print "Starting from: $starting_node\n";
  DepthTraversalHelper($tree, $starting_node, -1);
}

sub DepthTraversalHelper($$$)
{
  my ($tree, $starting_node, $parent) = @_;

  for my $connected_node (@{$$tree[$starting_node]})
  {
    if($connected_node != $parent)
    {
      print "Passing through: $connected_node\n";
      DepthTraversalHelper($tree, $connected_node, $starting_node);
    }
  }
}

sub WidthTraversal($$)
{
  my ($tree, $starting_node) = @_;

  print "Starting from: $starting_node\n";
  WidthTraversalHelper($tree, $starting_node, -1);

}

sub WidthTraversalHelper($$$)
{
  my ($tree, $starting_node, $parent) = @_;

  my @queue = ();
  my @visited_edges = ();
  push @queue, $starting_node;
  while(scalar(@queue) > 0)
  {
    my $starting_node = shift(@queue);
    push @visited_edges, $starting_node;
    for my $connected_node (@{$$tree[$starting_node]})
    {
        if(!($connected_node ~~ @visited_edges))
        {
          print "Passing through: $connected_node\n";
          push @queue, $connected_node;
        }
    }
  }
}

Main();
