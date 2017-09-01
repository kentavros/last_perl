package Controllers::Register;

use strict;
use warnings;
use Data::Dumper;
use CGI qw(:cgi-lib :escapeHTML :unescapeHTML);
use CGI::Carp qw(fatalsToBrowser); 
use vars qw(%in);
$|=1;
ReadParse();


sub run
{
    my ($self) = shift;
    if($self->{'UModel'}->is_autorized())
	{
		#redirect index.cgi
	}
	my $req_meth = %ENV->{'REQUEST_METHOD'};
	
	if($req_meth eq 'GET')
	{
        $self->{'View'}->read('templates/regpage/regist.html'); 
 	}
	if($req_meth eq 'POST')
	{
        my $postData = \%in;
#       print '<pre>'.Dumper(\%in).'</pre>';
        # print Dumper($postData);

		{
			if ($self->{'UModel'}->checkRegForm($postData))
			{
            
                if(!$self->{'UModel'}->isEmailExists($postData))
                {
					if($self->{'UModel'}->addUser($postData))
                    {
                        print 'Thank You bitch';
                        #redirect logged
                    }
                    print 'Failed registred';
                }
                print 'Email is already exists';
			}
			else
			{
                print 'Proverte pravilnost zapolneniya';
                $self->{'View'}->read('templates/regpage/regist.html'); 
                #parsim placeholder;
#				print 'Vivodim Formu s oshibkami';
			}
		}
	}

}

sub new
{
    my $class = ref($_[0])||$_[0];
	
    return bless {'UModel' => $_[1],'AModel' => $_[2],'View'=> $_[3]}; $class;
}
1;
