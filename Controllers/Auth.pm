package Controllers::Auth;

use strict;
use warnings;
use Data::Dumper;

sub run
{
	my $req_meth = %ENV->{'REQUEST_METHOD'};
#	print '<pre>'.Dumper($req_meth).'</pre>';
	if($req_meth eq 'GET')
	{
		print 'Show Form_Auth';
	}
	if($req_meth eq 'POST')
	{
		print 'CheckForm';
		{
			if (1)#esli forma norm
			{
				print 'Avtoriziruem';
			}
			else
			{
				print 'Vivodim Formu s oshibkami';
			}
		}
	}
#	print '<pre>'.Dumper(\%ENV).'</pre>';
}


sub new
{
    my $class = ref($_[0])||$_[0];
	
    return bless {'UModel' => $_[1],'AModel' => $_[2],'View'=> $_[3]}; $class;
}
1;