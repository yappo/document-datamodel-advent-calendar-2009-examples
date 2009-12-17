use strict;
use warnings;

{
    package Name;
    sub new {
        my($class, $name) = @_;
        bless \$name, $class;
    }
    sub name { ${ $_[0] } }
}

{
    package TestTable;
    use base 'Data::Model';
    use Data::Model::Schema;
    use Data::Model::Driver::DBI;

    my $driver = Data::Model::Driver::DBI->new(
        dsn => 'dbi:mysql:database=test'
    );
    base_driver $driver;

    install_model utf8_test => schema {
        key 'id';
        column 'id';
        utf8_column name
            => char => {
                required => 1,
                size     => 32,
            };

        alias_column name => obj => {
            inflate => sub { Name->new($_[0]) },
            deflate => sub { $_[0]->name },
        };
    };
}
print join(";\n", TestTable->as_sqls, '');


use utf8;
use Encode;
my $db = TestTable->new;

$db->set( utf8_test => 1 => { name => '大沢和宏' } );
my $row = $db->lookup( utf8_test => 1 );
if (Encode::is_utf8($row->name)) {
    print $row->name . "\n";
}
if (Encode::is_utf8($row->obj->name)) {
    print $row->obj->name . "\n";
}

$row->name('ねこかくたろう');
if (Encode::is_utf8($row->name)) {
    print $row->name . "\n";
}
if (Encode::is_utf8($row->obj->name)) {
    print $row->obj->name . "\n";
}
$row->update;

my $row2 = $db->lookup( utf8_test => 1 );
if (Encode::is_utf8($row->name)) {
    print $row->name . "\n";
}
if (Encode::is_utf8($row->obj->name)) {
    print $row->obj->name . "\n";
}

END {
    my $itr = $db->get('utf8_test');
    while (<$itr>) { $_->delete }
}
