package ExpressionLanguage;
use expressionLanguage::ExpressionParser;
use expressionLanguage::Executor;

$ExpressionLanguage::VERSION = 1.0;

sub new
{
	my $class = shift;
	my ($args) = @_;
	
	my $self = bless {
		parser => expressionLanguage::ExpressionParser->new(),
		executor => expressionLanguage::Executor->new(),
		token => ':='
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
	
	$self->{executor}->addFunction($args[1],$args[0]);
}

sub setToken
{
	my $self = shift;
	my @args = @_;
	
	$self->{token} = $args[0];
}

sub execute
{
	my $self = shift;
	my @args = @_;
	
	my $expression = $self->{parser}->parseString({
		string => $args[0],
		token => $self->{token}
	});
	
	return $self->{executor}->execute($expression);
}

1;
__END__
