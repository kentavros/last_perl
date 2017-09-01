package Utils::Db;

use DBI;
use strict;
use warnings;
use Data::Dumper;

sub select($)
{
	my ($self) = shift;
	my $query = $_[0];
	my $dbh = $self->connect();
	my $sth = $dbh->prepare($query);
	$sth->execute();
	my @res;
	while (my $row = $sth->fetchrow_hashref())
    {
        push(@res, $row);
    }
    $sth->finish();
    $dbh->disconnect();
	return \@res;
}



sub print
{
	my ($self) = shift;
	print 'hello';
}

sub connect
{
	my ($self) = shift;
	my $dbh = DBI->connect($self->{'Driver'},$self->{'user'},$self->{'password'});
	return $dbh;
}

sub new
{
    my $class = ref($_[0])||$_[0];
    return bless {'Driver' => 'DBI:mysql:user9:localhost','user' => 'user9','password' => 'tuser9'}; $class;
}
1;
