package expressionLanguage::Function;

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

sub process
{
	die "Function::process is unimplemented";
}

1;
__END__
