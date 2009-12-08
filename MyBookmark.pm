package MyBookmark;
use strict;
use warnings;
use base 'Data::Model';
use Data::Model::Schema;
use Data::Model::Mixin modules => ['+MyBookmark::Mixin::Count', 'FindOrCreate'];

{
    # driver setup
    use Data::Model::Driver::DBI;
    my $driver = Data::Model::Driver::DBI->new(
        dsn => 'dbi:SQLite:dbname=mybookmark.db', '', ''
    );
    base_driver $driver;
}

install_model user => schema {
    key 'id';
    unique 'nickname';
    columns qw/ id nickname /;
};

install_model bookmark => schema {
    key [qw/ url_id user_id /];
    index 'user_id';
    columns qw/ url_id user_id /;

    add_method user => sub {
        my $row = shift;
        $row->get_model->lookup( user => $row->user_id );
    };
};

1;
