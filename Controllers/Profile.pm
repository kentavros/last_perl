package Controllers::Profile;

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
    if(!$self->{'UModel'}->is_autorized())
    {
        #redirect index.cgi
    }

    my $req_meth = %ENV->{'REQUEST_METHOD'};
    my %warning;
    #   print '<pre>'.Dumper(\%ENV).'</pre>';
    #   print '<pre>'.Dumper(\%in).'</pre>';

#    if($req_meth eq 'GET')
#    {
#        
#        $self->{'View'}->read('templates/profile/profile.html'); 
#        my %warning->{'LANG_warning'} = '';
#        $self->{'View'}->parse(\%warning);
    #
    # }
    if($req_meth eq 'POST')
    {
        my $postData = \%in;
        if ($self->{'UModel'}->checkUserEditForm($postData))
        {

            print 'Saved';
            #redirect;
        }
        else
        {
        my %warning->{'LANG_warning'} = 'Invalid name or password';
#        $self->{'View'}->read('templates/profile/profile.html'); 
#        $self->{'View'}->parse(\%warning);
     
         }
#        $self->{'View'}->read('templates/profile/profile.html'); 
#        $self->{'View'}->parse(\%warning);
    }
        $self->{'View'}->read('templates/profile/profile.html'); 
        $self->{'View'}->parse(\%warning);


}

sub new
{
    my $class = ref($_[0])||$_[0];

    return bless {'UModel' => $_[1],'AModel' => $_[2],'View'=> $_[3]}; $class;
}
1;
