package expressionLanguage::Executor;

sub new
{
	my $class = shift;
	my ($args) = @_;
	
	my $self = bless {
		functions => {}
	}, $class;
	
	foreach my $argKey (keys(%{$args})) {
		$self->{$argKey} = $args->{$argKey};
	}
	
	return $self;
}

sub addFunction
{
	my $self = shift;
	my @args = @_;
	
	my $function = $args[0];
	my $alias = $args[1];
	
	if (!$function->can('process')) {
		die "The function $alias must implement the 'process' method";
	}
	
	$self->{functions}->{$alias} = $function;
}

sub execute
{
	my $self = shift;
	my ($expression) = shift;
	
	my $function;
	
	if (!exists($self->{functions}->{$expression->getFunction()})) {
		die "You've requested an unexisting function ".$expression->getFunction();
	} else {
		$function = $self->{functions}->{$expression->getFunction()};
	}
	
	my @arguments = @{$expression->getArguments()};
	foreach my $index (0 .. $#arguments) {
		my $argument = $arguments[$index];
		
		if (ref($argument) eq 'expressionLanguage::Expression') {
			$result = $self->execute($argument);
			
			$expression->setArguments($index, $result)
		}
	}

	return $function->process(@{$expression->getArguments()});
}

1;
__END__
