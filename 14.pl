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

    install_model auto_increment_test => schema {
        key [qw/ id entry_id /];
        column id
            => int => {
                required => 1,
                unsigned => 1,
            };
        column entry_id
            => int => {
                auto_increment => 1,
                required       => 1,
                unsigned       => 1,
            };
    };
}

print join(";\n", TestTable->as_sqls, '');

my $db = TestTable->new;

$db->set( auto_increment_test => 1 );
$db->set( auto_increment_test => 1 );
$db->set( auto_increment_test => 2 );
$db->set( auto_increment_test => 1 );
$db->set( auto_increment_test => 1 );
$db->set( auto_increment_test => 2 );

my $itr = $db->get('auto_increment_test');
while (<$itr>) {
    printf "id = %d, entry_id = %d\n", $_->id, $_->entry_id;
}


END {
    my $itr = $db->get('auto_increment_test');
    while (<$itr>) { $_->delete }
}

