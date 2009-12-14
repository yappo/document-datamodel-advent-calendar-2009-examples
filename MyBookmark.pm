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

{
    # inflate setup
    use Data::Model::Schema::Inflate;
    use DateTime;

    inflate_type DateTime => {
        inflate => sub {
            DateTime->from_epoch( epoch => $_[0] );
        },
        deflate => sub {
            ref($_[0]) && $_[0]->isa('DateTime') ? $_[0]->epoch : $_[0];
        },
    };
}

install_model user => schema {
    key 'id';
    unique 'nickname';
    column id => int => {};
    columns qw/ nickname /;
};

install_model bookmark => schema {
    key [qw/ url_id user_id /];
    index 'user_id';
    column url_id => int => {};
    column user_id => int => {};

    # create_at を生の値でも使いたい
    column create_at => int => {
        required => 1,
        unsigned => 1,
        default => sub { time() },
    };
    # Inflate するのはエイリアスで
    alias_column create_at => create_dt => {
        inflate => 'DateTime',
    };


    add_method user => sub {
        my $row = shift;
        $row->get_model->lookup( user => $row->user_id );
    };
};

1;
