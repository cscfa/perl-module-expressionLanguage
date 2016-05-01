package expressionLanguage::function::env;

use lib '../../';
use parent expressionLanguage::Function;

sub process
{
	my $self = shift;
	my @args = @_;

	if ($#args > 0) {
		die "Expression language function 'env' only accept one argument";
	} elsif (!@args) {
		die "Expression language function 'env' need at least one argument";
	}
	
	if (exists($ENV{$args[0]})) {
		return $ENV{$args[0]};
	} else {
		die "you've requested an unexistant environment variable ".$args[0];
	}
}

1;
__END__
