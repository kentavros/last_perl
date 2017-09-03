package Controllers::Login;

use strict;
use warnings;
use Data::Dumper;
use CGI qw(:cgi-lib :escapeHTML :unescapeHTML);
use CGI::Carp qw(fatalsToBrowser); 
use vars qw(%in);
$|=1;
ReadParse();

#use File::Basename qw(dirname);
#use lib dirname(__FILE__).'/../Utils/';
#use Utils::CGI::Session;

sub run
{
    my ($self) = shift;
    if($self->{'UModel'}->is_autorized())
	{
		#redirect index.cgi
	}
	
    my %warning;
	my $req_meth = %ENV->{'REQUEST_METHOD'};

	if($req_meth eq 'GET')
	{
        $self->{'View'}->read('templates/login/login.html');
    }
    if($req_meth eq 'POST')
    {
        my $postData = \%in;
    {
        if ($self->{'UModel'}->checkLogForm2($postData))
        {

            if ($self->{'UModel'}->login($postData))
            {
                $self->{'UModel'}->is_autorized();

                print '<a href="index.cgi">Welcome</a><br>';
            }

            #redirect
#            print "Location: index.cgi\n\n";
#            exit();
        }
#			else
#			{
        my %warning->{LANG_warning} = 'Invalid user or password';
#			}
    }
}

$self->{'View'}->parse(\%warning);


}

sub new
{
    my $class = ref($_[0])||$_[0];

    return bless {'UModel' => $_[1],'AModel' => $_[2],'View'=> $_[3]}; $class;
}
1;
