use strict;
use Data::Dumper;
use Scalar::Util qw(looks_like_number);

my $goat_num = 6;
my $course_num = 2;

=pod
my $goat_num = <STDIN>;
$goat_num = chomp($goat_num);
my $course_num = <STDIN>;
$course_num = chomp($course_num);
if($goat_num < 0  || $course_num < 0)
{
  die "invalid input\n";
}

for(my $i = 0; $i < $goat_num; $i++)
{
  my $goat = <STDIN>;
  $goat = chomp($goat);
  if(!looks_like_number($goat))
  {
    die "Invalid input\n";
  }
  if($goat > 1)
  {
    die "Invalid weight\n";
  }

}
=cut

#my @goats = (26, 7, 10, 30, 5, 4);
=pod
my @goats = (4, 8, 15, 16, 23, 42);
my $goat_total_weight = 0;
my @boat_trips = (0, 0);
@goats = sort {$b <=> $a} @goats;

for my $trip (@boat_trips)
{
  $trip += shift @goats;
}

while(scalar(@goats) > 0)
{
  @boat_trips = sort {$a <=> $b} @boat_trips;
  $boat_trips[0] += shift @goats;
}

print Dumper(@boat_trips);
=cut
