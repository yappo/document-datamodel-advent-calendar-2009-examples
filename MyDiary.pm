package MyDiary;
use strict;
use warnings;
use base 'Data::Model';
use Data::Model::Schema sugar => 'mycolumns';
use Columns;

{
    # driver setup
    use Data::Model::Driver::DBI;
    my $driver = Data::Model::Driver::DBI->new(
        dsn => 'dbi:SQLite:dbname=mydiary.db', '', ''
    );
    base_driver $driver;
}

install_model diary => schema {
    key 'id';
    index user => [qw/ user_id id /];

    column 'diary.id' => {
        auto_increment => 1,
    };
    column 'user.id';

    column 'global.epoch' => 'create_at' => {
        default      => sub { time() },
        alias_rename => {
            epoch_dt     => 'create_dt',
            epoch_dt_utc => 'create_dt_utc',
            epoch_dt_jst => 'create_dt_jst',
        },
    };
};

1;
