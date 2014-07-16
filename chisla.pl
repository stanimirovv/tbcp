my $position = <STDIN>;
chomp($position);
if($position < 1 || $position > 3200000)
{
  die "Wrong input\n";
}

my $row = "";
my $pow;
for(my $i = 1; $i <= $position; $i++)
{
  $pow = $i * $i;
  $row .= $pow;
}
print $row."\n";
print substr($row, $position-1, 1);
