package MyBookmark;
use strict;
use warnings;
use base 'Data::Model';
use Data::Model::Schema sugar => 'mycolumns';
use Data::Model::Mixin modules => ['+MyBookmark::Mixin::Count', 'FindOrCreate'];
use Columns;

{
    # driver setup
    use Data::Model::Driver::DBI;
    my $driver = Data::Model::Driver::DBI->new(
        dsn => 'dbi:SQLite:dbname=mybookmark.db'
    );
    base_driver $driver;
}

install_model user => schema {
    key 'id';
    unique 'nickname';
    column 'user.id' => {
        auto_increment => 1,
    };
    columns qw/ nickname /;
};

install_model bookmark => schema {
    key [qw/ url_id user_id /];
    index 'user_id';
    column url_id => int => {};
    column 'user.id';

    # create_at を生の値でも使いたい
    column 'global.epoch' => 'create_at' => {
        default      => sub { time() },
        alias_rename => {
            epoch_dt     => 'create_dt',
            epoch_dt_utc => 'create_dt_utc',
            epoch_dt_jst => 'create_dt_jst',
        },
    };

    add_method user => sub {
        my $row = shift;
        $row->get_model->lookup( user => $row->user_id );
    };
};

1;
