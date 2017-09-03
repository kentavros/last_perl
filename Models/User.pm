package Models::User;

use strict;
use warnings;
use Data::Dumper;
use Digest::MD5 qw(md5 md5_hex md5_base64);

use File::Basename qw(dirname);
use lib dirname(__FILE__).'/../Utils/';
use Utils::CGI::Session;


sub is_autorized
{
    my $self = shift;
    my $sid = $self->{'cgi'}->cookie("SID");
    if ($sid ne '')
    {
        my $sess = new CGI::Session(undef, $sid, {Directory=>'tmp'});
        if ($sess->param('id') != 0)
        {
            return 1;
        }
        else{
            return 0;
        }
    }
    else
    {
        return 0;
    }
}

sub logOut
{
    my $self = shift;
    my $sid = $self->{'cgi'}->cookie("SID");
    my $sess = new CGI::Session(undef, $sid, {Directory=>'tmp'});
    $sess->param('id'=>0);
    $sess->param('name'=>'Guest');

}



sub login
{
    my $self = shift;
    my $postData = shift;
    my $query = 'SELECT id, name FROM users WHERE email=\''.$postData->{'email'}.'\'';
    if ($self->{'Db'}->select($query))
    {
        my $data = $self->{'Db'}->select($query);
        my $uId = $data->[0]->{'id'};
        my $uName = $data->[0]->{'name'};
        my $sid = $self->{'cgi'}->cookie("SID");
        my $sess = new CGI::Session(undef, $sid, {Directory=>'tmp'});
        $sess->param('name' => $uName);
        $sess->param('id' => $uId);
        return 1;
    }
    else
    {
        return 0;
    }
}


sub addUser
{
    my $self = shift;
    my $data = shift;
    my $name = $data->{'name'};
    my $email = $data->{'email'};
    my $pass = md5_hex($data->{'password'});
    my $query = 'INSERT INTO users (name, email, pass) VALUES (\''.$name.'\', \''.$email.'\', \''.$pass.'\')';
    if ($self->{'Db'}->insert($query) == 1)
    {
        return 1;
    }
    return 0;
}

sub checkUserEditForm
{
    my $self=shift;
    my $data=shift;
    if  (($self->{'validator'}->valName($data->{'name'})) && ($self->{'validator'}->valPass($data->{'pass'})))
    {
        my $pass = md5_hex($data->{'pass'});
        my $query = 'UPDATE users SET name=\''.$data->{'name'}.'\', pass=\''.$pass.'\' WHERE id=\''.$data->{'id'}.'\'';
        if ($self->{'Db'}->update($query))
        {
            print 'Update data';
            return 1;
        }
        else {
            #print 'not update';
            return 0;
        }
    }
    else 
    {
        #print 'Not valid';
        return 0;
    }
}


sub isEmailExists
{
    my ($self, $email) = @_;
    my $query = 'SELECT email FROM users WHERE email=\''.$email.'\'';
    #print $query;
    my $resEmail = $self->{'Db'}->select($query);
    if ($resEmail->['email'] ne '')
    {

        return 1;
    }
    else
    {
        # email not exists
        return 0;
    }

}


sub checkRegForm($)
{
    my $self = shift;
    my $data = shift;
#    print Dumper($data);
#    print Dumper($self->{'validator'});
    if ($self->{'validator'}->valName($data->{'name'}) && $self->{'validator'}->valEmail($data->{'email'}) && $self->{'validator'}->valPass($data->{'password'}))
    {
        return 1;
    }
    return 0;
}

sub checkLogForm2
{
    my $self = shift;
    my $data = shift;
    my $email = $data->{'email'};
    my $pass = md5_hex($data->{'password'});
    my $query = 'SELECT email, pass FROM users WHERE email=\''.$email.'\'';
    my $res = $self->{'Db'}->select($query);
    if ($email eq $res->[0]->{'email'} && $pass eq $res->[0]->{'pass'})
    {
        #print 'Loget';
        return 1;
    }
    else
    {
        #print 'Wrong data input!';
        return 0;
    }

}

sub checkLogForm
{
    my $self = shift;
    my $data = shift;
    if (($self->{'validator'}->valEmail($data->{'email'})) && ($self->{'validator'}->valPass($data->{'password'})))
    {
        if ($self->isEmailExists($data->{'email'}))
        {
            my $email = $data->{'email'};
            my $pass = md5_hex($data->{'password'});
            my $query = 'SELECT pass FROM users WHERE email=\''.$email.'\'';
            my $res = $self->{'Db'}->select($query);
            if ($res->[0]->{'pass'} eq $pass)
            {
                print 'LOGET!';
                return 1; 
            }
            else
            {
                print 'Wrong pass!';
                return 0;
            }
        }else
        {
            #print 'net';
            return 0;
        }
    }
    else 
    {   
        return 0;
    } 

}


sub new
{
    my $class = ref($_[0])||$_[0];
    my $cgi = $_[3];
    my $sid = $cgi->cookie("SID");
    if ($sid ne '')
    {
        my $sess = new CGI::Session(undef, $sid, {Directory=>'tmp'});
        print "Content-type: text/html; charset=utf-8\n\n";
    }
    else
    {
        my $sess = CGI::Session->new("driver:file", undef, {Directory=>'tmp'})
            or die CGI::Session->errstr();
        $sess->name('SID');
        my $cookie=$cgi->cookie(SID => $sess->id);
        print $cgi->header( -cookie=>$cookie );
        $sess->param('id' => '0');
        $sess->param('name' => 'Guest');
    }


    return bless {'Db'=> $_[1],'validator'=> $_[2], 'cgi'=>$_[3]}; $class;
}
1;
