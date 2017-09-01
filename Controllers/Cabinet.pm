package Controllers::Cabinet;

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
    #  print '<pre>'.Dumper(\%in).'</pre>';
		
		my ($self) = shift;
		if($self->{'UModel'}->is_autorized())
		{
			my $templateName = 'templates/cabinet/cabinet.html';
			$self->{'View'}->read($templateName);
			my $req_meth = %ENV->{'REQUEST_METHOD'};

			if($req_meth eq 'POST')
			{
               my $postData = \%in; 
           # print '<pre>'.Dumper($postData).'</pre>';
               if($self->{'AModel'}->editArticle($postData))
               {
                print 'UPDATED';
               } 
				#EditArticleInDb;
				$self->{'View'}->parseFormArticle({FORM_EditArticle => ''});
			}
			
			if($req_meth eq 'GET')
			{
				my $id = %in->{'id'};
				if($id eq undef)
				{
					$self->{'View'}->parseFormArticle({FORM_EditArticle => ''});
				}
				else
				{
					my $formValues = $self->{'AModel'}->getArticleById($id);
					my @formValues = @$formValues;
					my %hash;
					foreach my $val(@formValues)
					{
						%hash->{LANG_title} = $val->{'title'};
						%hash->{LANG_body} = $val->{'body'};
						%hash->{LANG_id} = $val->{'id'};
					}
					$self->{'View'}->parseFormArticle({FORM_EditArticle => $self->{'View'}->makeFormEditArticle(\%hash)});
				}
			}
		my $data = $self->{'AModel'}->getUserArticles(1);
		my @data = @$data;	
		$self->{'View'}->parsePage(@data);
		}
		else
		{
			#redirect home page
		}
}


sub new
{
    my $class = ref($_[0])||$_[0];
    return bless {'UModel' => $_[1],'AModel' => $_[2],'View'=> $_[3]}; $class;
}
1;
