use strict;

sub Handler()
{
  # get user input for board size and days;
  my $height = <STDIN>;
  my $width = <STDIN>;
  chomp($width);
  chomp($height);

  print "Width: $width, height: $height\n";
  my @matrix;
  for(my $i = 0; $i < $height; $i++)
  {
    my @matrix_row;
    for(my $j = 0; $j < $width; $j++)
    {
        push(@matrix_row, 0);
    }
    push(@matrix, \@matrix_row);
  }

  print "Input the number of days you want to see:";
  my $dayZ = <STDIN>;
  chomp($dayZ);

  # Get the two (or one) points
  my $point1 = { x => -1, y=> -1};
  my $point2 = { x => -1, y=> -1};
  my $x;
  my $y;
  print "Input y:";
  $y = <STDIN>;
  print "Input x:";
  $x = <STDIN>;
  chomp($x);
  chomp($y);
  if($x-1 < 0 || $y-1 < 0)
  {
    die " You must input atleast one valid point T__T\n";
  }

  $matrix[($height -1) - ($y -1)][($width - 1) - ($x -1)] = 1;
  print "Input y:";
  $y = <STDIN>;
  print "Input x:";
  $x = <STDIN>;
  chomp($x);
  chomp($y);
  if($x-1 > 0 || $y-1 > 0)
  {
    print "Both coordinates seem ok.\n";
    $matrix[($height - 1) - ($y-1)][($width - 1) - ($x-1)] = 1;

  }
  else
  {
    print "Due to shit input I won't add the second point\n";
  }

  #PrintMatrix(\@matrix);
  my $good_strawberries = DecayStrawberries(\@matrix, $height, $width, $dayZ);
  print "Undefiled strawberries: $good_strawberries \n";
  PrintMatrix(\@matrix);
}

sub PrintMatrix($)
{
  my ($matrix) = @_;

  for my $row (@$matrix)
  {
    for my $column (@$row)
    {
      print $column;
    }
    print "\n";
  }
}

sub DecayStrawberries($$$$)
{
  my ($matrix, $height, $width, $days) = @_;

  for (my $k = 0; $k < $days; $k++)
  {
    #print "Entering day loop\n";
    for (my $i = 0; $i < $height; $i++)
    {
      for (my $j = 0; $j < $width; $j++)
      {
        if($$matrix[$i][$j] == 0)
        {
          next;
        }
        # this asserts that we only decay from strawberries which were decayed yesterday
        # without it we will decay much more strawberries. For example when you decay a berry on the bottom row
        # without this check it will also start decaying berries arround it, thus we decay much more berries than we should
        elsif($$matrix[$i][$j] == 1+ $k)
        {
          if($i != 0 && $$matrix[$i-1][$j] == 0)
          {
            #print "Entering top\n";
            $$matrix[$i-1][$j] = 2+$k;
          }
          # check right
          if($j < $width-1 && $$matrix[$i][$j+1] == 0)
          {
            #print "Entering Right val=$$matrix[$i][$j]\n ";
            $$matrix[$i][$j+1] = 2+$k;
          }
          # check left
          if($j != 0 && $$matrix[$i][$j-1] == 0)
          {
            #print "Entering Right val=$$matrix[$i][$j]\n ";
            $$matrix[$i][$j-1] = 2 +$k;
          }
          # check bottom
          if($i < $height-1 && $$matrix[$i+1][$j] == 0)
          {
            #print "Entering bottom val=$$matrix[$i][$j]\n";
            $$matrix[$i+1][$j] = 2+ $k;
          }
        }
      }
    }
    #PrintMatrix($matrix);
  }

  my $strawberries = 0;
  for (my $i = 0; $i < $height; $i++)
  {
    for (my $j = 0; $j < $width; $j++)
    {
      if($$matrix[$i][$j] == 0)
      {
        $strawberries++;
      }
    }
  }
  return $strawberries;
}

Handler();
