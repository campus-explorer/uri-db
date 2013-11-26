#!/usr/bin/perl -w

use strict;
use Test::More;
use utf8;
use URI;

for my $spec (
    {
        uri => 'db:',
        dsn => '',
        dbi => [ [host => undef], ['port' => undef], [dbname => undef] ],
        qry => [],
    },
    {
        uri => 'db:pg:',
        dsn => 'dbi:Pg:',
        dbi => [ [host => undef], [port => undef], [dbname => undef] ],
        qry => [],
    },
    {
        uri => 'db:pg://localhost',
        dsn => 'dbi:Pg:host=localhost',
        dbi => [ [host => 'localhost'], [port => undef], [dbname => undef] ],
        qry => [],
    },
    {
        uri => 'db:pg://localhost:33',
        dsn => 'dbi:Pg:host=localhost;port=33',
        dbi => [ [host => 'localhost'], [port => 33], [dbname => undef] ],
        qry => [],
    },
    {
        uri => 'db:pg://foo:123/try?foo=1&foo=2&lol=yes',
        dsn => 'dbi:Pg:host=foo;port=123;dbname=try;foo=1;foo=2;lol=yes',
        dbi => [ [host => 'foo'], [port => 123], [dbname => 'try'] ],
        qry => [ foo => 1, foo => 2, lol => 'yes' ],
    },
    {
        uri => 'db:sqlite:',
        dsn => 'dbi:SQLite:',
        dbi => [ [dbname => undef] ],
        qry => [],
    },
    {
        uri => 'db:sqlite:foo.db',
        dsn => 'dbi:SQLite:dbname=foo.db',
        dbi => [ [dbname => 'foo.db'] ],
        qry => [],
    },
    {
        uri => 'db:sqlite:/path/foo.db',
        dsn => 'dbi:SQLite:dbname=/path/foo.db',
        dbi => [ [dbname => '/path/foo.db'] ],
        qry => [],
    },
    {
        uri => 'db:sqlite:///path/foo.db',
        dsn => 'dbi:SQLite:dbname=/path/foo.db',
        dbi => [ [dbname => '/path/foo.db'] ],
        qry => [],
    },
    {
        uri => 'db:cubrid://localhost:33/foo',
        dsn => 'dbi:cubrid:host=localhost;port=33;database=foo',
        dbi => [ [host => 'localhost'], [port => 33], [database => 'foo'] ],
        qry => [],
    },
    {
        uri => 'db:db2://localhost:33/foo',
        dsn => 'dbi:DB2:HOSTNAME=localhost;PORT=33;DATABASE=foo',
        dbi => [ [HOSTNAME => 'localhost'], [PORT => 33], [DATABASE => 'foo'] ],
        qry => [],
    },
    {
        uri => 'db:firebird://localhost:33/foo',
        dsn => 'dbi:Firebird:host=localhost;port=33;dbname=foo',
        dbi => [ [host => 'localhost'], [port => 33], [dbname => 'foo'] ],
        qry => [],
    },
    {
        uri => 'db:informix:foo.db',
        dsn => 'dbi:Informix:foo.db',
        dbi => [],
        qry => [],
    },
    {
        uri => 'db:informix:foo.db?foo=1',
        dsn => 'dbi:Informix:foo.db;foo=1',
        dbi => [],
        qry => [foo => 1],
    },
    {
        uri => 'db:ingres:foo.db',
        dsn => 'dbi:Ingres:foo.db',
        dbi => [],
        qry => [],
    },
    {
        uri => 'db:ingres:foo.db?foo=1',
        dsn => 'dbi:Ingres:foo.db;foo=1',
        dbi => [],
        qry => [foo => 1],
    },
    {
        uri => 'db:interbase://localhost:33/foo',
        dsn => 'dbi:InterBase:host=localhost;port=33;dbname=foo',
        dbi => [ [host => 'localhost'], [port => 33], [dbname => 'foo'] ],
        qry => [],
    },
    {
        uri => 'db:maxdb://localhost:33/foo',
        dsn => 'dbi:MaxDB:localhost:33/foo',
        dbi => [],
        qry => [],
    },
    {
        uri => 'db:maxdb://localhost/foo',
        dsn => 'dbi:MaxDB:localhost/foo',
        dbi => [],
        qry => [],
    },
    {
        uri => 'db:monetdb://localhost:1222?foo=1',
        dsn => 'dbi:monetdb:host=localhost;port=1222;foo=1',
        dbi => [ [host => 'localhost'], [port => 1222] ],
        qry => [foo => 1],
    },
    {
        uri => 'db:monetdb://localhost/lolz',
        dsn => 'dbi:monetdb:host=localhost',
        dbi => [ [host => 'localhost'], [port => undef] ],
        qry => [],
    },
    {
        uri => 'db:mysql://localhost:33/foo',
        dsn => 'dbi:mysql:host=localhost;port=33;database=foo',
        dbi => [ [host => 'localhost'], [port => 33], [database => 'foo'] ],
        qry => [],
    },
    {
        uri => 'db:oracle://localhost:33/foo',
        dsn => 'dbi:Oracle:host=localhost;port=33;sid=foo',
        dbi => [ [host => 'localhost'], [port => 33], [sid => 'foo'] ],
        qry => [],
    },
    {
        uri => 'db:sqlserver://localhost:33/foo',
        dsn => 'dbi:ODBC:Driver={SQL Server};Server=localhost,33;Database=foo',
        dbi => [ [ Driver => '{SQL Server}'], [Server => 'localhost,33'], [Database => 'foo'] ],
        qry => [],
    },
    {
        uri => 'db:sybase://localhost:33/foo',
        dsn => 'dbi:Sybase:host=localhost;port=33;dbname=foo',
        dbi => [ [host => 'localhost'], [port => 33], [dbname => 'foo'] ],
        qry => [],
    },
    {
        uri => 'db:teradata://localhost',
        dsn => 'dbi:Teradata:localhost',
        dbi => [ [DATABASE => undef] ],
        qry => [],
    },
    {
        uri => 'db:teradata://localhost:33/foo?hi=1',
        dsn => 'dbi:Teradata:localhost:33;DATABASE=foo;hi=1',
        dbi => [ [DATABASE => 'foo'] ],
        qry => [ hi => 1],
    },
    {
        uri => 'db:unify:foo.db',
        dsn => 'dbi:Unify:foo.db',
        dbi => [],
        qry => [],
    },
    {
        uri => 'db:unify:',
        dsn => 'dbi:Unify:',
        dbi => [],
        qry => [],
    },
    {
        uri => 'db:unify:?foo=1&bar=2',
        dsn => 'dbi:Unify:foo=1;bar=2',
        dbi => [],
        qry => [ foo => 1, bar => 2 ],
    },
    {
        uri => 'db:vertica:',
        dsn => 'dbi:Pg:',
        dbi => [ [host => undef], [port => undef], [dbname => undef] ],
        qry => [],
    },
    {
        uri => 'db:vertica://localhost',
        dsn => 'dbi:Pg:host=localhost',
        dbi => [ [host => 'localhost'], [port => undef], [dbname => undef] ],
        qry => [],
    },
    {
        uri => 'db:vertica://localhost:33',
        dsn => 'dbi:Pg:host=localhost;port=33',
        dbi => [ [host => 'localhost'], [port => 33], [dbname => undef] ],
        qry => [],
    },
    {
        uri => 'db:vertica://foo:123/try?foo=1&foo=2&lol=yes',
        dsn => 'dbi:Pg:host=foo;port=123;dbname=try;foo=1;foo=2;lol=yes',
        dbi => [ [host => 'foo'], [port => 123], [dbname => 'try'] ],
        qry => [ foo => 1, foo => 2, lol => 'yes' ],
    },
) {
    my $uri = $spec->{uri};
    ok my $u = URI->new($uri), "URI $uri";
    is_deeply [ $u->query_params ], $spec->{qry}, "... $uri query params";
    is_deeply [ $u->_dbi_param_map ], $spec->{dbi}, "... $uri DBI param map";
    is_deeply [ $u->dbi_params ], [
        (
            map { @{ $_ } }
            grep { defined $_->[1] && length $_->[1] } @{ $spec->{dbi} }
        ),
        @{ $spec->{qry} },
    ], "... $uri DBI params";
    is $u->dbi_dsn, $spec->{dsn}, "... $uri DSN";
}

done_testing;
