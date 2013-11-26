package URI::db::teradata;
use base 'URI::db';
our $VERSION = '0.10';

sub default_port { 1025 }
sub dbi_driver   { 'Teradata' }

sub _dbi_param_map {
    return [ DATABASE => scalar shift->dbname ];
}

sub dbi_dsn {
    my $self = shift;
    return join ';' => (
        join (
            ':' => 'dbi', $self->dbi_driver,
            grep { defined } $self->host, $self->_port
        ),
        $self->_dsn_params || ()
    );
}

1;
