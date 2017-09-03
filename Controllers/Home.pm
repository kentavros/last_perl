package Controllers::Home;

use strict;
use warnings;
use Data::Dumper;



sub run
{
	my ($self) = shift;
	my $templateName = 'templates/home/home.html';
	$self->{'View'}->read($templateName);
	if($self->{'UModel'}->is_autorized()) #gest ili net true\false
	{
		my %buttons;
		%buttons->{'BUTT_showCabinetButton'} = $self->{'View'}->makeButton({'LANG_destination'=>'index.cgi?page=cabinet',
																				  'LANG_text' => 'Cabinet'});
		%buttons->{'BUTT_showLogOutButton'} = $self->{'View'}->makeButton({'LANG_destination'=>'index.cgi?page=logout',
																				 'LANG_text' => 'Log Out'});
		$self->{'View'}->parseButtons(\%buttons);
	}
	else
	{
		my %buttons;
		%buttons->{'BUTT_showLoginButton'} = $self->{'View'}->makeButton({'LANG_destination'=>'index.cgi?page=login',
																				'LANG_text' => 'Login'});
		%buttons->{'BUTT_showRegButton'} = $self->{'View'}->makeButton({'LANG_destination'=>'index.cgi?page=register',
																			  'LANG_text' => 'Registration'});
		$self->{'View'}->parseButtons(\%buttons);
		
	}
	
	my $data = $self->{'AModel'}->getArticles();
	my @data = @$data;
	$self->{'View'}->parsePage(@data);
}


sub new
{
    my $class = ref($_[0])||$_[0];
    return bless {'UModel' => $_[1],'AModel' => $_[2],'View'=> $_[3]}; $class;
}
1;
