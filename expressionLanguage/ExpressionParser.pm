package expressionLanguage::ExpressionParser;

use lib '../';
use String::Util qw/trim/;

use expressionLanguage::Expression;

sub new
{
	my $class = shift;
	my ($args) = @_;
	
	my $self = bless {}, $class;
	
	foreach my $argKey (keys(%{$args})) {
		$self->{$argKey} = $args->{$argKey};
	}
	
	return $self;
}

sub parseString
{
	my $self = shift;
	my ($args) = @_;
	
	my $string = $args->{"string"};
	my $token = $args->{"token"};
	
	if ($self->_hasToken({string=>$string, token=>$token})) {
		
		my $function = $self->_getExpressionFunction({
			string => $string,
			token =>$token
		});
		
		my @arguments =  @{$self->_getExpressionArgumentArray({
			string => $string,
			token =>$token
		})};
		
		my @realArguments;
		foreach my $argument (@arguments) {
			if ($self->_hasToken({string=>$argument, token=>$token})) {
				push(@realArguments, $self->parseString({
					string => $argument,
					token => $token,
				}));
			} else {
				push(@realArguments, $argument);
			}
		}
		
		$expression = expressionLanguage::Expression->new({
			function => $function,
			arguments => \@realArguments,
			parser => $self
		});
		
		return $expression;
	} else {
		return undef;
	}
}

sub _hasToken
{
	my $self = shift;
	my ($args) = @_;
	
	my $string = $args->{"string"};
	my $token = $args->{"token"};
	
	return ($string =~ /$token/) ? 1 : 0;
}

sub _getTokenIndex
{
	my $self = shift;
	my ($args) = @_;
	
	my $string = $args->{"string"};
	my $token = $args->{"token"};
	
	return index($string, $token);
}

sub _getExpressionFunction
{
	my $self = shift;
	my ($args) = @_;
	
	my $string = $args->{"string"};
	my $token = $args->{"token"};
	
	my $tokenIndex = $self->_getTokenIndex({string=>$string, token=>$token});
	
	my $tmpString = substr($string, $tokenIndex);
	my $startExpressionIndex = length($token);
	$tmpString =~ /(\()/;

	return substr($tmpString, $startExpressionIndex, $-[0] - $startExpressionIndex);
}

sub _getStartExpressionIndex
{
	my $self = shift;
	my ($args) = @_;
	
	my $string = $args->{"string"};
	my $token = $args->{"token"};
	
	my $tokenIndex = $self->_getTokenIndex({string=>$string, token=>$token});
	my $tmpString = substr($string, $tokenIndex);
	
	return index($tmpString, '(') + $tokenIndex + 1;
}

sub _getEndExpressionIndex
{
	my $self = shift;
	my ($args) = @_;
	
	my $string = $args->{"string"};
	my $token = $args->{"token"};
	
	my $tokenIndex = $self->_getTokenIndex({string=>$string, token=>$token});
	my $tmpString = substr($string, $tokenIndex);
	
	my @openBraceMatch = ($tmpString =~ /\(/g);
	my @closeBraceMatch = ($tmpString =~ /\)/g);
	
	if ($#openBraceMatch == $#closeBraceMatch and $#closeBraceMatch > 0) {
		$tmpString =~ /\)/g;
		
		$index = 0;
		for (0..$#closeBraceMatch) {
			$index = index($tmpString, ')', $index) + 1;
		}
		return $index + $tokenIndex - 1;
	} elsif ($#openBraceMatch == $#closeBraceMatch) {
		return length($tmpString) - 1;
	} else {
		die "Brace error in ".$string;
	}
	
}

sub _getExpressionArgumentString
{
	my $self = shift;
	my ($args) = @_;
	
	my $string = $args->{"string"};
	my $token = $args->{"token"};
	
	my $startIndex = $self->_getStartExpressionIndex({
		string => $string,
		token => $token
	});
	my $endIndex = $self->_getEndExpressionIndex({
		string => $string,
		token => $token
	});
	 
	return substr($string, $startIndex, $endIndex - $startIndex);
}

sub _getExpressionArgumentArray
{
	my $self = shift;
	my ($args) = @_;
	
	my $string = $args->{"string"};
	my $token = $args->{"token"};
	
	my @arguments = split(",", $self->_getExpressionArgumentString({
		string => $string,
		token => $token
	}));
	
	my @result;
	push(@result, trim($_)) foreach (@arguments);
	
	return \@result;
}

1;
__END__
