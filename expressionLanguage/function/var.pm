package expressionLanguage::function::var;

use lib '../../';
use parent expressionLanguage::Function;

sub process
{
	my $self = shift;
	my @args = @_;

	if ($#args > 0) {
		die "Expression language function 'var' only accept one argument";
	}
	
	my $firstChar = substr($args[0], 0, 1);
	my $var = substr($args[0], 1);
	
	if ($firstChar eq '@') {
		return \@$var;
	} elsif ($firstChar eq '$') {
		return \$$var;
	} elsif ($firstChar eq '%') {
		return \%$var;
	} else {
		die "unrecognized variable type '".$firstChar."' in expression language function 'var'";
	}
}

1;
__END__
