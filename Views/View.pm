package Views::View;

use strict;
use warnings;
use Data::Dumper;


#sdelat proverku na file_exists and is_readable
sub read($)
{
    
	my ($self) = shift;
	my $fileName = $_[0];
	$self->{'html'} = $self->{'fh'}->readFile($fileName);
}


sub parse($)
{
    my($self, $hash) = @_;
    $self->{'html'} =~ s/LANG_(\w)+/$hash->{$&}/gse;
}

sub parseP($$)
{
    my($self, $html ,$hash) = @_;
    $html=~ s/LANG_(\w)+/$hash->{$&}/gse;
	return $html;
}



sub getHtml
{
	my ($self) = shift;
	return $self->{'html'};
	
}


sub makeFormEditArticle
{
	my ($self) = shift;
	my ($hash) = shift;
	my $pattern = $self->{'fh'}->readFile('templates/cabinet/form.html');
	$pattern =~ s/LANG_(\w)+/$hash->{$&}/gse;
	return $pattern;	
}

sub parsePage
{
    my($self, @arr) = @_;
    $self->{'html'} =~ s/LANG_(\w)+/$self->$&(@arr)/gse;
}

sub parseButtons
{
	my ($self) = shift;
	my $btns = $_[0];
	$self->{'html'}=~ s/BUTT_(\w)+/$btns->{$&}/gse;
}

sub parseFormArticle
{
	my ($self) = shift;
	my $hash = $_[0];
	$self->{'html'}=~ s/FORM_(\w)+/$hash->{$&}/gse;
}


sub makeButton
{
	my ($self) = shift;
	my ($hash) = shift;
	my $pattern = $self->{'fh'}->readFile('templates/home/button.html');
	$pattern =~ s/LANG_(\w)+/$hash->{$&}/gse;
	return $pattern;
}


sub LANG_articles
{
	my ($self) = shift;
	my (@arr) = @_;
	my $pattern = $self->read('templates/home/article.html');
	
	my $string;
	my %hash;
	foreach my $value(@arr)
	{
		%hash->{LANG_title} = $value->{'title'};
		%hash->{LANG_date} = $value->{'date'};
		%hash->{LANG_body} = $value->{'body'};
		%hash->{LANG_author} = $value->{'author'};
		$string .= $self->parseP($pattern, \%hash);
	}
	return $string;
}

sub LANG_UserArticles
{
	my ($self) = shift;
	my (@arr) = @_;
	my $pattern = $self->read('templates/cabinet/userArticles.html');
	
	my $string;
	my %hash;
	foreach my $value(@arr)
	{
		%hash->{LANG_title} = $value->{'title'};
		%hash->{LANG_date} = $value->{'date'};
		%hash->{LANG_body} = $value->{'body'};
		%hash->{LANG_id} = $value->{'id'};
		$string .= $self->parseP($pattern, \%hash);
	}
	return $string;
}

sub new
{
    my $class = ref($_[0])||$_[0];
    return bless {'fh' => $_[1], 'html' => ''}; $class;
}
1;
