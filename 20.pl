use strict;
use warnings;

{
    package TestTable;
    use base 'Data::Model';
    use Data::Model::Schema;
    use Data::Model::Driver::DBI;

    my $driver = Data::Model::Driver::DBI->new(
        dsn => 'dbi:mysql:database=test'
    );
    base_driver $driver;

    install_model txn_test => schema {
        key 'id';
        columns qw( id name );
        schema_options create_sql_attributes => {
            mysql => 'TYPE=InnoDB',
        };
    };
}
print join(";\n", TestTable->as_sqls, '');

my $db = TestTable->new;

# トランザクションの開始
my $txn = $db->txn_scope;
eval {
    $db->set(
        txn_test => 1 => { name => 'Yappo' }
    );
};
warn $@ if $@;

# INSERT
$txn->set(
    txn_test => 1 => { name => 'Yappo' }
);

# LOOKUP
my $row = $txn->lookup( txn_test => 1 );
warn $row->name;

# UPDATE
$row->name('nekokak');
$txn->update($row);

# GET
my $itr = $txn->get('txn_test');
while (<$itr>) {
    warn $_->name;
}

eval {
    $row->delete;
};
warn $@ if $@;

# delete
$txn->delete($row);

$txn->commit;


END {
    my $itr = $db->get('txn_test');
    while (<$itr>) { $_->delete }
}
