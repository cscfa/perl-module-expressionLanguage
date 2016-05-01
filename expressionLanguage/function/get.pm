package expressionLanguage::function::get;

use lib '../../';
use parent expressionLanguage::Function;
use Data::Diver qw/Dive/;

sub process
{
	my $self = shift;
	
	my $base = shift;
	my @args = @_;
	
	return Dive($base, @args);
}

1;
__END__
