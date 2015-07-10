use strict;
use warnings;

use threads;
use threads::shared;

use DBI;
use Try::Tiny;
use Data::Dumper;
use Thread qw(:DEFAULT async yield);
use Time::HiRes qw(usleep);
use Parallel::ForkManager;

my $fail_counter :shared;
$fail_counter = 0;

my $transaction_count :shared;

#my $SLEEP_TIME_MS = 30000;
my $SLEEP_TIME_MS = 5;

my $timeout = 10;

sub DBWork()
{
    print "Thread\n";
    my $dbh = DBI->connect('dbi:Pg:dbname=random;host=localhost','postgres','123',{AutoCommit=>0,RaiseError=>1,PrintError=>0});
    my $time = time;
    while(1)
    {
        if( time - $time > $timeout)
        {
            print "Fail counter: $fail_counter Transaction count $transaction_count";
            last;
        }
        try 
        {   
            
            lock $transaction_count;
            $transaction_count++;
            
            my $sth;
            $dbh->do("begin transaction isolation level serializable") or die;
            #$sth = $dbh->prepare("select pg_sleep(10) from bar;");
            my $rand = int(rand(100)) + 1;
            $sth = $dbh->prepare("select * from bar where a = ? ;");
            #$sth = $dbh->prepare("select * from bar where a = ? FOR UPDATE OF bar;");
            $sth->execute($rand);
            #my $row = $sth->fetchrow_hashref();
            $sth = $dbh->prepare("update bar set b = ? where a = ?");
            $sth->execute(time % 10000, $rand);
            #$sth = $dbh->prepare("select * from bar where a = ? FOR UPDATE OF bar;");
            $sth = $dbh->prepare("select * from bar where a = ? ;");
            $sth->execute($rand);
            #usleep($SLEEP_TIME_MS);
            $dbh->commit();
        }   
        catch
        {   
            my ($err) = @_;
            $dbh->rollback();
            print $err;
            {
                {
                    lock $fail_counter;
                    $fail_counter++;
                }
            }      
        };
    }
    $dbh->disconnect;
}


sub Main()
{

    alarm $timeout;
    my $pm=new Parallel::ForkManager(2);
    for(my $i = 0; $i < 2; $i++)
    {

        #my $thread = Thread->new(sub{DBWork();});
        #my $thread = threads->new(sub{DBWork();});
        
        $pm->start and next;
        DBWork();

    }
        print "11111111111111111Fail counter: $fail_counter \n Transaction count $transaction_count";
}

Main();

=pod
CREATE TABLE bara(a int, b int);
INSERT INTO bar VALUES(1, 1);
INSERT INTO bar VALUES(2, 1);
INSERT INTO bar VALUES(3, 1);
INSERT INTO bar VALUES(4, 1);
INSERT INTO bar VALUES(5, 1);
INSERT INTO bar VALUES(6, 1);
INSERT INTO bar VALUES(7, 1);
INSERT INTO bar VALUES(8, 1);
INSERT INTO bar VALUES(9, 1);
=cut
