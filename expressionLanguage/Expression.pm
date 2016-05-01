package expressionLanguage::Expression;

sub new
{
	my $class = shift;
	my ($args) = @_;
	
	my $self = bless {
		function => $args->{function} || undef,
		arguments => @{$args->{arguments}} || undef,
		parentParser => $args->{parser} || die "Parser must be given to create a expressionLanguage::Expression"
	}, $class;
	
	foreach my $argKey (keys(%{$args})) {
		$self->{$argKey} = $args->{$argKey};
	}
	
	return $self;
}

sub getFunction
{
	my $self = shift;
	return $self->{function};
}

sub getArguments
{
	my $self = shift;
	return $self->{arguments};
}

sub setArguments
{
	my $self = shift;
	my ($index, $argument) = @_;
	$self->{arguments}[$index] = $argument;
}

1;
__END__
